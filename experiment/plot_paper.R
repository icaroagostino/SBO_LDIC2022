library(ggplot2)
library(openxlsx)
library(dplyr)

load('final_results/lead_time_sbo.Rda')
load('final_results/tardy_jobs_sbo.Rda')

results <- rbind(read.xlsx('final_results/results.xlsx'),
                 data.frame(PR = 'SBO', 
                            lead_time = lead_time@fitnessValue*(-1),
                            tardy_jobs = tardy_jobs@fitnessValue*(-1)))

ggplot(results, aes(x = reorder(PR, lead_time),
                    y = lead_time,
                    fill = as.factor(lead_time))) +
  
  geom_bar(position = "dodge", stat = "identity", show.legend = F) +
  geom_text(aes(label = round(lead_time, 2)), nudge_y = 120) +
  ylab('Lead Time') +
  xlab('Scheduling approach') +
  theme(text = element_text(size = 13)) +
  scale_fill_manual(
    values = c('dodgerblue3', rep('#999999', 6)))

ggplot(results, aes(x = reorder(PR, tardy_jobs),
                    y = tardy_jobs,
                    fill = as.factor(tardy_jobs))) +
  
  geom_bar(position = "dodge", stat = "identity", show.legend = F) +
  geom_text(aes(label = tardy_jobs), nudge_y = 8) +
  ylab('Tardy Jobs') +
  xlab('Scheduling approach') +
  theme(text = element_text(size = 13)) +
  scale_fill_manual(
    values = c('dodgerblue3', rep('#999999', 6)))

source('final_results/plot_custumized.R')

plot_customized(lead_time,
                ylim = c(1550, 2000),
                ylab_kpi = 'Lead Time')

plot_customized(tardy_jobs,
                ylim = c(122, 128),
                ylab_kpi = 'Tardy Jobs')

demand <- read.xlsx('input_data/demand.xlsx')

demand %>% 
  group_by(month) %>% 
  summarise(demand = sum(lot_size)) %>% 
  
  ggplot(aes(x = month, y = demand, group = 1)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = demand), nudge_y = 750) +

  ylab('Demand') +
  xlab('Months')
