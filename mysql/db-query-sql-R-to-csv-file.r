#!/usr/bin/Rscript
#r routine to init the db based on set of csv files
#ex. Rscript foo.R arg1 arg2
#provide only one cmd line arg "path": location of csv files
#ex. Rscript db-init.r /home/ubuntu/
#credit to the following blog for some conceptual ideas on working with R dataframes 
#https://nsaunders.wordpress.com/2013/02/13/basic-r-rows-that-contain-the-maximum-value-of-a-variable/

library(DBI)
library(dplyr)

con <- dbConnect(RMySQL::MySQL(), user='mysqladmin', password='mysqladmin', dbname='AONEDB', host='127.0.0.1')
dbSendQuery(con, "USE AONEDB;")
res <- dbSendQuery(con, "SELECT date,symbol,ABS(open - close) AS `change` FROM aonetable ORDER BY date")
fetchedres <- fetch(res, n = -1)
aggres <- aggregate(change ~ date, fetchedres, max)
maxres <- merge(aggres, fetchedres)
print(maxres, row.names = FALSE)
write.csv(maxres, file = "assignment1-jbl-output.csv", row.names = FALSE)
dbDisconnect(con)

quit()