# routine to check and install packages

libsCheck <- c('simmer',
               'simmer.bricks',
               'simmer.plot',
               'GA',
               'parallel',
               'doParallel',
               'dplyr',
               'plyr',
               'openxlsx',
               'extraDistr')

libsLoad <- libsCheck[1:5]

for (i in seq_along(libsCheck)) {
  
  if(libsCheck[i] %in% rownames(installed.packages()) == F) {
    install.packages(libsCheck[i])
  }
  
}

if (all(libsCheck %in% rownames(installed.packages()))) {
  
  print('All required packages are installed!')
  
} else {
  
  print('Manually check the installation of packages')
  
}

for (j in seq_along(libsLoad)) {
  
  suppressMessages(library(libsLoad[j], character.only = TRUE, quietly = TRUE))
  
}

if (all(libsLoad %in% (.packages()))){
  
  print('All required packages are loaded!')
  
} else {
  
  print('Manually check the installation of packages')
  
}

rm(libsCheck, libsLoad, i, j)
