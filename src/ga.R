# ga engine for simulation-based optimization method

sbo <- function(kpi) {
   
   source('src/packages.R')
   source('src/utils.R')
   source('src/run_simulation.R')
   
   read_input(demand_path      = 'demand/demand.xlsx',
              maintenance_path = 'maintenance/maintenance_schedule.xlsx',
              failure_path     = 'maintenance/failure_data.xlsx')
   
   result <- 
      ga(type = 'real-valued',
         fitness = function(genes){-run_simulation(PR = genes, kpi_sim = kpi, repli = 10)},
         lower = rep(0, 12),
         upper = rep(5, 12),
         popSize = 30,
         maxiter = 100,
         run = 30,
         pcrossover = 0.8,
         pmutation = 0.4,
         parallel = detectCores() - 1,
         monitor = TRUE)
   
   result
   
}
