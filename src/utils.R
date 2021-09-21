# Useful auxiliary functions

####--- read input data ---####

read_input <- function(demand_path, maintenance_path, failure_path, inventory_path) {
  
  if (!exists('demand')) {
    demand <<- openxlsx::read.xlsx(demand_path)
    demand <<- demand[demand$lot_size > 0,]
  }
  
  if (!exists('maintenance_data')) {
    maintenance_data <<- openxlsx::read.xlsx(maintenance_path)
  }
  
  if (!exists('failure')) {
    failure <<- openxlsx::read.xlsx(failure_path)
  }
  
  if (!exists('inventory')) {
    inventory <<- openxlsx::read.xlsx(inventory_path)
  }
  
}

####--- main operation function ---####

source('src/logs.R')
source('src/select_priority_rule.R')

visit_op <- function(traj,
                     resource,
                     op_time,
                     PR = 0,
                     log = FALSE,
                     msg = '',
                     sim_env = env,
                     sim_machines = machines) {
  
  if (length(PR) > 1) PR <- PR[[which(resource == sim_machines)]]
  
  traj %>% 
    
    log_attributes(log , msg) %>%
    
    set_prioritization(select_priority_rule(PR, env = sim_env)) %>% 
    
    visit(resource = resource,
          task = function() {
            get_attribute(sim_env, 'lot_size')*op_time*extraDistr::rtriang(1, 0.9, 1.1)
          }) %>%
    
    set_attribute(keys   = 'remaining_time',
                  values = function() -get_attribute(sim_env, 'lot_size')*op_time,
                  mod    = "+") %>%
    
    set_attribute(keys   = 'remaining_opn',
                  values = -1L,
                  mod    = "+")
  
}

####--- add_demand ---####

add_demand <- function(env, traj) {
  
  add_dataframe(.env           = env,
                name_prefix    = traj,
                trajectory     = get(traj),
                data           = demand[demand$prod_type == traj,],
                mon            = 2,
                col_time       = 'start_time',
                time           = 'absolute',
                col_attributes = c('due_date', 'lot_size', 'remaining_time', 'remaining_opn'))
  
}

####--- add_maintenance ---####

add_predictive_maintenance <- function(env, machine) {
  
  input_data <- maintenance_data[maintenance_data$machine == machine,]
  maint_jobs <- c()
  
  for (i in seq_len(nrow(input_data))) {
    
    release_time <- 
      
      switch(input_data$frequency[i],
              
              'daily'      = seq(1, 209088, by = 528),
              'weekly'     = seq(1, 209088, by = 2640),
              'monthly'    = seq(1, 209088, by = 11616),
              'quarterly'  = seq(1, 209088, by = 34848),
              'semiannual' = seq(1, 209088, by = 69696),
              'yearly'     = seq(1, 209088, by = 139392)
      )
    
    jobs <- cbind(input_data[i,], release_time, row.names = NULL)
    maint_jobs <- rbind(maint_jobs, jobs)
    
  }
  
  maint_jobs <- dplyr::arrange(maint_jobs, release_time)
  
  add_dataframe(.env           = env,
                name_prefix    = machine,
                trajectory     = get(paste0(machine, '_pm')),
                data           = maint_jobs,
                mon            = 2,
                col_time       = 'release_time',
                time           = 'absolute',
                col_attributes = c('resource_code', 'time'))
  
}

####--- dynamic predicitive maintenance trajectories ---####

pred_maint <- function(machine, sim_env = env) {
  
  trajectory(paste0(machine, '_pm')) %>% 
    
    select(
      function() {
        resource <- get_attribute(sim_env, 'resource_code')
        
        suppressMessages(
          plyr::mapvalues(resource,
                          c(1, 2, 3), 
                          c('operator','mechanic', 'electric')))
      }
      
    ) %>% 
    seize_selected(1) %>% 
    seize(machine, 1) %>% 
    timeout(function() get_attribute(sim_env, 'time')) %>%
    release(machine, 1) %>% 
    release_selected(1)
  
}

####--- add failure events ---####

add_failure <- function(env, machine_to_failure) {
  
  # machine_to_failure <- 'FB_017'
  
  data <- dplyr::filter(failure, machine == machine_to_failure)
  
  add_generator(.env         = env,
                name_prefix  = paste0(machine_to_failure, '_failure'),
                trajectory   = get(paste0(machine_to_failure, '_failure')),
                distribution = function() rexp(1, 1/data[['MTBF']]),
                mon          = 2,
                priority     = 9999999,
                preemptible  = 9999999,
                restart      = TRUE)
}

####--- dynamic failure event trajectories ---####

failure_event <- function(machine_to_failure, sim_env = env) {
  
  data <- dplyr::filter(failure, machine == machine_to_failure)
  
  trajectory(paste0(machine_to_failure, '_failure')) %>%
    seize(machine_to_failure, 1) %>% 
    timeout(function() rnorm(1, data[['MTTR']], data[['SDTR']])) %>% 
    release(machine_to_failure, 1)
  
}

####--- add inventory ---####

add_inventory <- function(env, raw) {

  data <- inventory[inventory$raw_material == raw,]
  
  data <- data.frame(raw_material = as.numeric(stringr::str_sub(raw, -2)),
                     delivery_time = seq(0, 209088, by = data$delivery_freq[1]))
  
  add_dataframe(.env           = env,
                name_prefix    = paste0('inventory_', raw, '_'),
                trajectory     = get(paste0('inventory_', raw)),
                data           = data,
                mon            = 2,
                col_time       = 'delivery_time',
                time           = 'absolute',
                col_attributes = 'raw_material')
  
}

####--- inventory control ---####

initial_raw_material <- function(env, raw, quantity) {
  
  if (is.numeric(raw)) {
    if (raw > 9) { 
      raw <- paste0('RM', raw) 
    } else { 
      raw <- paste0('RM0', raw) 
    }
  }
  
  if (missing(quantity)) {
    
    quantity <- 
      inventory %>%
      dplyr::filter(raw_material == raw) %>%
      dplyr::select(delivery_quantity)
    
  }
  
  add_global(.env  = env,
             key   = raw,
             value = quantity[[1,1]]*2)
  
}

control_raw_mat <- function(name, raw, quantity, log = FALSE) {
  
  convert <- function(input) {
    if (is.numeric(input)) {
      if (input > 9) {
        input <- paste0('RM', input)
      } else {
        input <- paste0('RM0', input)
      }
    }
    input
  }
  
  log_raw <- function(.trj) {
    if (isTRUE(log)) {
      .trj %>% 
        log_(function() {
          get_global(env, convert(raw)) %>% as.character()
          # convert(raw) %>% as.character()
        })
      
    } else {.trj}
  }
  
  if (missing(quantity)) quantity <- 0
  
  trajectory(paste0('inventory_', name)) %>% 

    set_global(
      
      key = function() convert(raw),
      value = function() {
        
        if (quantity == 0) {

            quantity <-
              inventory %>%
              dplyr::filter(raw_material == convert(raw)) %>%
              dplyr::select(delivery_quantity)
            
            return(quantity[[1,1]])
            
        } else { return(quantity) }
      },
      mod = '+') %>% 
    log_raw() %>% 
    send(name)
}

raw_material_consumption <- function(traj,
                                     raw,
                                     quantity, 
                                     sim_env = env) {
  
  traj %>%
    
    branch(function() quantity*get_attribute(sim_env, 'lot_size') > get_global(sim_env, raw),
           continue = TRUE,
           trajectory() %>%
             trap(raw) %>%
             wait() %>%
             untrap(raw) %>%
             rollback(5)) %>%
    
    set_global(key = raw,
               value = function() -quantity*get_attribute(sim_env, 'lot_size'),
               mod = '+') 
}
