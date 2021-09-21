####--- Priority Rules ---####

# 0 = FIFO   (first in first out)
# 1 = EDD    (earliest due date)
# 2 = SPT    (shortest processing time)
# 3 = SL     (slack remaining time)
# 4 = CR     (critical ratio)
# 5 = SL/OPN (slack per remaining operation)

select_priority_rule <- function(priority_rule, env = env) {
  
  priority_rule <- priority_rule %>% round(0) %>% as.character
  
  values <- 
    switch(priority_rule,
      '0' = function() {c(0, NA, T)},
      '1' = function() {c(10^6 - get_attribute(env, 'due_date'), NA, T)},
      '2' = function() {c(10^6 - get_attribute(env, 'lot_size'), NA, T)},
      '3' = function() {c(10^6 - get_attribute(env, 'due_date') - now(env) - get_attribute(env, 'remaining_time'), NA, T)},
      '4' = function() {c(10^6 - 100*((get_attribute(env, 'due_date') - now(env))/get_attribute(env, 'remaining_time')), NA, T)},
      '5' = function() {c(10^6 - (get_attribute(env, 'due_date') - now(env) - get_attribute(env, 'remaining_time'))/get_attribute(env, 'remaining_opn'), NA, T)}
    )
  
  values
  
}
