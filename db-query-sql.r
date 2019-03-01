#!/usr/bin/Rscript
#r routine to init the db based on set of csv files
#ex. Rscript foo.R arg1 arg2
#provide only one cmd line arg "path": location of csv files
#ex. Rscript db-init.r /home/ubuntu/

library(DBI)

con <- dbConnect(RMySQL::MySQL(), user='mysqladmin', password='mysqladmin', dbname='AONEDB', host='127.0.0.1')
dbSendQuery(con, "USE AONEDB;")
res <- dbSendQuery(con, statement = paste("SELECT DISTINCT date, ABS(open - close),symbol", "FROM (SELECT date,open,close,symbol FROM aonetable ORDER BY ABS(open - close) DESC)", "AS sorted"))
topdeltas <- fetch(res, n = -1)
print(topdeltas)
dbDisconnect(con)