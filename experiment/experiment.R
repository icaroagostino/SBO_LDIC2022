# Experiment with fixed priority rules and optimization

repli <- 10

PR <- 0 # FIFO
source('src/simulation_env.R')
FIFO <- kpi(envs, kpi = c('lead_time', 'tardy_jobs'))

PR <- 1 # EDD
source('src/simulation_env.R')
EDD <- kpi(envs, kpi = c('lead_time', 'tardy_jobs'))

PR <- 2 # SPT
source('src/simulation_env.R')
SPT <- kpi(envs, kpi = c('lead_time', 'tardy_jobs'))

PR <- 3 # SL
source('src/simulation_env.R')
SL <- kpi(envs, kpi = c('lead_time', 'tardy_jobs'))

PR <- 4 # CR
source('src/simulation_env.R')
CR <- kpi(envs, kpi = c('lead_time', 'tardy_jobs'))

PR <- 5 # SL/OPN
source('src/simulation_env.R')
SL_OPN <- kpi(envs, kpi = c('lead_time', 'tardy_jobs'))

source('src/ga.R')
start_time <- Sys.time(); tardy_jobs  <- sbo(kpi = 'tardy_jobs')  ; Sys.time() - start_time
start_time <- Sys.time(); lead_time   <- sbo(kpi = 'lead_time')   ; Sys.time() - start_time

lead_time@summary <- lead_time@summary*(-1)
tardy_jobs@summary <- tardy_jobs@summary*(-1)

# to save the optimizationresults use the code above
# save('experiment/lead_time_sbo.Rda')
# save('experiment/tardy_jobs_sbo.Rda')

results <- rbind(FIFO, EDD, SPT, SL, CR, SL_OPN)
results <- tibble::rownames_to_column(as.data.frame(results), var = 'PR')
results$PR[1] <- 'Fixed schedule'

results

# to write the DR results use the code above
# library(openxlsx)
# write.xlsx(results, 'experiment/results.xlsx')

# to generate the plots used in the paper run 'experiment/plot_paper.R'
