source('src/packages.R')

# load auxiliary functions
source('src/utils.R', local = TRUE)
source('src/kpi.R', local = TRUE)

# read data
read_input(demand_path      = 'input_data/demand.xlsx',
           maintenance_path = 'input_data/maintenance_schedule.xlsx',
           failure_path     = 'input_data/failure_data.xlsx',
           inventory_path   = 'input_data/inventory_data.xlsx')

# Define rules, kpi and replications
if (!exists('PR'))      PR      <- 0
if (!exists('kpi_sim')) kpi_sim <- 'tardy_jobs'
if (!exists('repli'))   repli   <- 1

# Simulation environment
env <- simmer('olsen', verbose = FALSE)

# Production trajectories
{
  P01 <- trajectory('P01') %>%
    
    raw_material_consumption(raw = 'RM01', quantity = 0.0890) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_006', op_time = 1.0300, PR = PR)

  P02 <- trajectory('P02') %>%
    
    raw_material_consumption(raw = 'RM02', quantity = 0.0700) %>%

    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_008', op_time = 2.0000, PR = PR) %>%
    visit_op('IM_011', op_time = 0.2002, PR = PR) 
  
  P03 <- trajectory('P03') %>% 
    
    raw_material_consumption(raw = 'RM03', quantity = 0.0175) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_008', op_time = 1.5300, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) 
  
  P04 <- trajectory('P04') %>% 
    
    raw_material_consumption(raw = 'RM04', quantity = 0.0500) %>%
    
    visit_op('SF_005', op_time = 0.2001, PR = PR) %>%
    visit_op('TC_006', op_time = 4.0000, PR = PR) %>%
    visit_op('IM_011', op_time = 0.0501, PR = PR) 
  
  P05 <- trajectory('P05') %>% 
    
    raw_material_consumption(raw = 'RM05', quantity = 0.0500) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_007', op_time = 3.0300, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) 
  
  P06 <- trajectory('P06') %>% 
    
    raw_material_consumption(raw = 'RM06', quantity = 0.0550) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_007', op_time = 2.2700, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) 
  
  P07 <- trajectory('P07') %>% 
    
    raw_material_consumption(raw = 'RM07', quantity = 0.0175) %>%
    
    visit_op('SF_005', op_time = 0.2000, PR = PR) %>%
    visit_op('TC_005', op_time = 1.0000, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1000, PR = PR) %>%
    visit_op('FB_018', op_time = 1.0000, PR = PR)
  
  P08 <- trajectory('P08') %>% 
    
    raw_material_consumption(raw = 'RM08', quantity = 0.0119) %>%
    
    visit_op('SF_005', op_time = 8.0000, PR = PR) %>%
    visit_op('TC_008', op_time = 1.4700, PR = PR) %>%
    visit_op('IM_011', op_time = 0.0001, PR = PR) %>%
    visit_op('TM_006', op_time = 8.0000, PR = PR) %>% 
    visit_op('FR_001', op_time = 6.0000, PR = PR)
  
  P09 <- trajectory('P09') %>% 
    
    raw_material_consumption(raw = 'RM09', quantity = 0.0480) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_008', op_time = 1.4600, PR = PR) %>%
    visit_op('IM_011', op_time = 0.0001, PR = PR) %>%
    visit_op('TM_006', op_time = 1.0001, PR = PR) %>% 
    visit_op('IM_011', op_time = 0.0001, PR = PR)
  
  P10 <- trajectory('P10') %>%
    
    raw_material_consumption(raw = 'RM10', quantity = 0.0137) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_007', op_time = 3.0001, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) %>%
    visit_op('TC_008', op_time = 2.0001, PR = PR) %>% 
    visit_op('IM_011', op_time = 0.1001, PR = PR) %>% 
    visit_op('TM_006', op_time = 0.5001, PR = PR)
  
  P11 <- trajectory('P11') %>% 
    
    raw_material_consumption(raw = 'RM11', quantity = 0.0381) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_005', op_time = 1.2500, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) %>% 
    visit_op('FB_017', op_time = 1.0001, PR = PR) %>%
    visit_op('FR_001', op_time = 1.0001, PR = PR) %>% 
    visit_op('IM_011', op_time = 0.2002, PR = PR)
  
  P12 <- trajectory('P12') %>% 
    
    raw_material_consumption(raw = 'RM12', quantity = 0.1100) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_008', op_time = 2.1000, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) %>% 
    visit_op('TM_006', op_time = 0.1000, PR = PR) %>%
    visit_op('IM_011', op_time = 0.2001, PR = PR)
  
  P13 <- trajectory('P13') %>% 
    
    raw_material_consumption(raw = 'RM13', quantity = 0.0554) %>%
    
    visit_op('TC_008', op_time = 1.5000, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) %>% 
    visit_op('FB_017', op_time = 1.0001, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR)
  
  P14 <- trajectory('P14') %>% 
    
    raw_material_consumption(raw = 'RM14', quantity = 0.0371) %>%
    
    visit_op('TC_007', op_time = 2.4000, PR = PR) %>%
    visit_op('TC_005', op_time = 10.000, PR = PR) %>% 
    visit_op('FB_017', op_time = 1.0001, PR = PR) %>%
    visit_op('IM_011', op_time = 0.2002, PR = PR)
  
  P15 <- trajectory('P15') %>%
    
    raw_material_consumption(raw = 'RM15', quantity = 0.0195) %>%
    
    visit_op('TC_008', op_time = 1.1800, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR)
  
  P16 <- trajectory('P16') %>% 
    
    raw_material_consumption(raw = 'RM16', quantity = 0.0520) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_006', op_time = 0.3300, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) %>% 
    visit_op('FB_024', op_time = 0.1001, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR)
  
  P17 <- trajectory('P17') %>% 
    
    raw_material_consumption(raw = 'RM16', quantity = 0.0640) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_006', op_time = 0.3300, PR = PR) %>% 
    visit_op('IM_011', op_time = 0.1001, PR = PR)
  
  P18 <- trajectory('P18') %>% 
    
    raw_material_consumption(raw = 'RM16', quantity = 0.0382) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_006', op_time = 0.4000, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) %>% 
    visit_op('TM_006', op_time = 2.0001, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) %>% 
    visit_op('FB_017', op_time = 2.0002, PR = PR)
  
  P19 <- trajectory('P19') %>% 
    
    raw_material_consumption(raw = 'RM16', quantity = 0.0382) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_006', op_time = 0.3500, PR = PR) %>% 
    visit_op('IM_011', op_time = 0.3003, PR = PR)
  
  P20 <- trajectory('P20') %>% 
    
    raw_material_consumption(raw = 'RM17', quantity = 0.0381) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_005', op_time = 2.5400, PR = PR) %>% 
    visit_op('IM_011', op_time = 0.1001, PR = PR)
  
  P21 <- trajectory('P21') %>% 
    
    raw_material_consumption(raw = 'RM18', quantity = 0.0081) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_007', op_time = 2.1200, PR = PR) %>% 
    visit_op('IM_011', op_time = 0.3003, PR = PR)
  
  P22 <- trajectory('P22') %>% 
    
    raw_material_consumption(raw = 'RM19', quantity = 0.0694) %>%
    
    visit_op('SF_005', op_time = 1.0001, PR = PR) %>%
    visit_op('TC_007', op_time = 1.5300, PR = PR) %>% 
    visit_op('IM_011', op_time = 0.4004, PR = PR)
  
  P23 <- trajectory('P23') %>% 
    
    raw_material_consumption(raw = 'RM20', quantity = 0.0721) %>%
    
    visit_op('TC_005', op_time = 0.5700, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) %>%
    visit_op('FR_005', op_time = 1.0001, PR = PR) %>% 
    visit_op('FB_018', op_time = 1.0001, PR = PR) %>%
    visit_op('IM_011', op_time = 0.1001, PR = PR) %>% 
    visit_op('FR_001', op_time = 2.0002, PR = PR) %>% 
    visit_op('IM_011', op_time = 0.1001, PR = PR) %>% 
    visit_op('FR_001', op_time = 1.0001, PR = PR) %>%
    visit_op('IM_011', op_time = 0.2002, PR = PR) 
}


inventory_RM01 <- control_raw_mat('RM01', get_attribute(env, 'raw_material'))
inventory_RM02 <- control_raw_mat('RM02', get_attribute(env, 'raw_material'))
inventory_RM03 <- control_raw_mat('RM03', get_attribute(env, 'raw_material'))
inventory_RM04 <- control_raw_mat('RM04', get_attribute(env, 'raw_material'))
inventory_RM05 <- control_raw_mat('RM05', get_attribute(env, 'raw_material'))
inventory_RM06 <- control_raw_mat('RM06', get_attribute(env, 'raw_material'))
inventory_RM07 <- control_raw_mat('RM07', get_attribute(env, 'raw_material'))
inventory_RM08 <- control_raw_mat('RM08', get_attribute(env, 'raw_material'))
inventory_RM09 <- control_raw_mat('RM07', get_attribute(env, 'raw_material'))
inventory_RM10 <- control_raw_mat('RM10', get_attribute(env, 'raw_material'))
inventory_RM11 <- control_raw_mat('RM11', get_attribute(env, 'raw_material'))
inventory_RM12 <- control_raw_mat('RM12', get_attribute(env, 'raw_material'))
inventory_RM13 <- control_raw_mat('RM13', get_attribute(env, 'raw_material'))
inventory_RM14 <- control_raw_mat('RM14', get_attribute(env, 'raw_material'))
inventory_RM15 <- control_raw_mat('RM15', get_attribute(env, 'raw_material')) 
inventory_RM16 <- control_raw_mat('RM16', get_attribute(env, 'raw_material')) 
inventory_RM17 <- control_raw_mat('RM17', get_attribute(env, 'raw_material'))
inventory_RM18 <- control_raw_mat('RM18', get_attribute(env, 'raw_material'))
inventory_RM19 <- control_raw_mat('RM19', get_attribute(env, 'raw_material'))
inventory_RM20 <- control_raw_mat('RM20', get_attribute(env, 'raw_material'))

# Maintenance trajectories

{ 
  SF_005_pm <- pred_maint(machine = 'SF_005')
  TC_005_pm <- pred_maint(machine = 'TC_005')
  TC_006_pm <- pred_maint(machine = 'TC_006')
  TC_007_pm <- pred_maint(machine = 'TC_007')
  TC_008_pm <- pred_maint(machine = 'TC_008')
  TM_006_pm <- pred_maint(machine = 'TM_006')
  FB_018_pm <- pred_maint(machine = 'FB_018')
  FR_001_pm <- pred_maint(machine = 'FR_001')
  FB_017_pm <- pred_maint(machine = 'FB_017')
  FB_024_pm <- pred_maint(machine = 'FB_024')
  FR_005_pm <- pred_maint(machine = 'FR_005')
}

# Failure events

{
  SF_005_failure <- failure_event(machine_to_failure = 'SF_005')
  TC_005_failure <- failure_event(machine_to_failure = 'TC_005')
  TC_006_failure <- failure_event(machine_to_failure = 'TC_006')
  TC_007_failure <- failure_event(machine_to_failure = 'TC_007')
  TC_008_failure <- failure_event(machine_to_failure = 'TC_008')
  TM_006_failure <- failure_event(machine_to_failure = 'TM_006')
  FB_018_failure <- failure_event(machine_to_failure = 'FB_018')
  FR_001_failure <- failure_event(machine_to_failure = 'FR_001')
  FB_017_failure <- failure_event(machine_to_failure = 'FB_017')
  FB_024_failure <- failure_event(machine_to_failure = 'FB_024')
  FR_005_failure <- failure_event(machine_to_failure = 'FR_005')
}

# Resources
{
  env %>% 
    add_resource('SF_005', 1) %>%
    add_resource('TC_005', 1) %>%
    add_resource('TC_006', 1) %>%
    add_resource('TC_007', 1) %>%
    add_resource('TC_008', 1) %>%
    add_resource('TM_006', 1) %>%
    add_resource('IM_011', 1) %>%
    add_resource('FB_018', 1) %>%
    add_resource('FR_001', 1) %>%
    add_resource('FB_017', 1) %>%
    add_resource('FB_024', 1) %>%
    add_resource('FR_005', 1) %>%
    add_resource('operator', 12) %>%
    add_resource('mechanic', 2) %>%
    add_resource('electric', 2)
  
}

env %>%
  add_inventory(raw = 'RM01') %>%
  add_inventory(raw = 'RM02') %>%
  add_inventory(raw = 'RM03') %>%
  add_inventory(raw = 'RM04') %>%
  add_inventory(raw = 'RM05') %>%
  add_inventory(raw = 'RM06') %>%
  add_inventory(raw = 'RM07') %>%
  add_inventory(raw = 'RM08') %>%
  add_inventory(raw = 'RM09') %>%
  add_inventory(raw = 'RM10') %>%
  add_inventory(raw = 'RM11') %>%
  add_inventory(raw = 'RM12') %>%
  add_inventory(raw = 'RM13') %>%
  add_inventory(raw = 'RM14') %>%
  add_inventory(raw = 'RM15') %>%
  add_inventory(raw = 'RM16') %>%
  add_inventory(raw = 'RM17') %>%
  add_inventory(raw = 'RM18') %>%
  add_inventory(raw = 'RM19') %>%
  add_inventory(raw = 'RM20')

# Add generators
{
  env %>% 
    add_demand('P01') %>% 
    add_demand('P02') %>% 
    add_demand('P03') %>% 
    add_demand('P04') %>% 
    add_demand('P05') %>% 
    add_demand('P06') %>% 
    add_demand('P07') %>% 
    add_demand('P08') %>% 
    add_demand('P09') %>% 
    add_demand('P10') %>% 
    add_demand('P11') %>% 
    add_demand('P12') %>% 
    add_demand('P13') %>% 
    add_demand('P14') %>% 
    add_demand('P15') %>% 
    add_demand('P16') %>% 
    add_demand('P17') %>% 
    add_demand('P18') %>% 
    add_demand('P19') %>% 
    add_demand('P20') %>% 
    add_demand('P21') %>% 
    add_demand('P22') %>% 
    add_demand('P23') 
  
}


# Add maintenance generators

env %>% 
  add_predictive_maintenance('SF_005') %>% 
  add_predictive_maintenance('TC_005') %>% 
  add_predictive_maintenance('TC_006') %>% 
  add_predictive_maintenance('TC_007') %>% 
  add_predictive_maintenance('TC_008') %>%
  add_predictive_maintenance('TM_006') %>%
  add_predictive_maintenance('FB_018') %>%
  add_predictive_maintenance('FR_001') %>%
  add_predictive_maintenance('FB_017') %>%
  add_predictive_maintenance('FB_024') %>%
  add_predictive_maintenance('FR_005')

# Add failure generators

env %>% 
  add_failure('SF_005') %>% 
  add_failure('TC_005') %>% 
  add_failure('TC_006') %>% 
  add_failure('TC_007') %>% 
  add_failure('TC_008') %>%
  add_failure('TM_006') %>%
  add_failure('FB_018') %>%
  add_failure('FR_001') %>%
  add_failure('FB_017') %>%
  add_failure('FB_024') %>%
  add_failure('FR_005')

env %>% 
  initial_raw_material('RM01') %>%
  initial_raw_material('RM02') %>%
  initial_raw_material('RM03') %>%
  initial_raw_material('RM04') %>%
  initial_raw_material('RM05') %>%
  initial_raw_material('RM06') %>%
  initial_raw_material('RM07') %>%
  initial_raw_material('RM08') %>%
  initial_raw_material('RM09') %>%
  initial_raw_material('RM10') %>%
  initial_raw_material('RM11') %>%
  initial_raw_material('RM12') %>%
  initial_raw_material('RM13') %>%
  initial_raw_material('RM14') %>%
  initial_raw_material('RM15') %>%
  initial_raw_material('RM16') %>%
  initial_raw_material('RM17') %>%
  initial_raw_material('RM18') %>%
  initial_raw_material('RM19') %>%
  initial_raw_material('RM20')

envs <<- lapply(1:repli, function(i) {
  reset(env); run(env, 209088)
})

kpi(envs, kpi = kpi_sim)
