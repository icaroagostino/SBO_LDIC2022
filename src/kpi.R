# kpi function

kpi <- function(env,
                kpi = c('lead_time', 'utilization', 'tardy_jobs'),
                n_jobs = nrow(demand),
                warmUp = 0) {
  
  kpi_results <- c()
  n_replications <- max(get_mon_arrivals(env)$replication)
  
  if ('lead_time' %in% kpi) {
    lead_time <-
      get_mon_arrivals(env) %>%
      dplyr::slice_tail(prop = 1 - warmUp) %>%
      dplyr::mutate(leadTime = (end_time - start_time)) %>%
      dplyr::select(leadTime) %>%
      unlist %>%
      mean()
    
    kpi_results<- c(kpi_results, lead_time = lead_time)
  }
  if ('utilization' %in% kpi) {
    utilization <-
      get_mon_resources(env) %>%
      dplyr::slice_tail(prop = 1 - warmUp) %>%
      dplyr::group_by(.data$resource, .data$replication) %>%
      dplyr::mutate(dt = .data$time - dplyr::lag(.data$time)) %>%
      dplyr::mutate(in_use = .data$dt * dplyr::lag(.data$server / .data$capacity)) %>%
      dplyr::summarise(utilization = sum(.data$in_use, na.rm = TRUE) / sum(.data$dt, na.rm=TRUE), .groups = 'keep') %>%
      dplyr::summarise(utilization = mean(.data$utilization), .groups = 'drop') %>%
      .$utilization %>%
      mean
    
    kpi_results <- c(kpi_results, utilization = utilization)
  }
  if ('tardy_jobs' %in% kpi) {
    tardy_jobs <- 
      merge(get_mon_arrivals(env),
            get_mon_attributes(env) %>% dplyr::filter(key == 'due_date'),
            by = c('name', 'replication')) %>% 
      dplyr::slice_tail(prop = 1 - warmUp) %>%
      dplyr::mutate(tardy = (value - end_time)) %>%
      dplyr::mutate(dplyr::across(tardy, ~ 1 * (. < 0))) %>% 
      dplyr::select(tardy)
    
    n_replication <- max(get_mon_arrivals(env)$replication)
    not_started_jobs <- n_jobs*n_replication - nrow(tardy_jobs)
    
    tardy_jobs <- (sum(tardy_jobs) + not_started_jobs)/n_replication
    
    kpi_results <- c(kpi_results, tardy_jobs = tardy_jobs)
    
  }

    kpi_results
  
}
