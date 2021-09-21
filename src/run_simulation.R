# function to run simulation

run_simulation <- function(PR, kpi_sim = 'tardy_jobs', repli = 1) {
  
  kpi_sim <- kpi_sim
  
  machines <- c('SF_005', 'TC_005', 'TC_006', 'TC_007',
                'TC_008', 'TM_006', 'IM_011', 'FB_018',
                'FR_001', 'FB_017', 'FB_024', 'FR_005')
  
  result <- source('src/simulation_env.R', local = TRUE)
  
  result$value
  
}
