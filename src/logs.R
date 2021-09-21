# Some useful log functions

log_attributes <- function(traj, log = FALSE, msg, env = get('env', envir = .GlobalEnv)) {
  
  if (isTRUE(log)) {
    
    traj %>% 
      log_(paste('--- Atributos', msg, '---')) %>%
      log_(function() paste('remaining time:', get_attribute(env, 'remaining_time'))) %>%
      log_(function() paste('remaining opn:', get_attribute(env, 'remaining_opn')))
    
  } else {
    
    traj
  }
  
}

log_priorization <- function(traj, assign_pr = FALSE, env = get('env', envir = .GlobalEnv)) {
  
  traj %>% 
    
    log_(function() {
      
      if (isTRUE(assign_pr)) {
        assign(paste0('pr_at_', round(now(env), 1)), get_prioritization(env), envir = .GlobalEnv)
      }
      
      paste(get_prioritization(env)[1])
      
    }
    )
}
