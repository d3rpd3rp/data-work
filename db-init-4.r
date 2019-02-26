#!/usr/bin/Rscript
#r routine to init the db based on set of csv files
#ex. Rscript foo.R arg1 arg2
#provide only one cmd line arg "path": location of csv files
#ex. Rscript db-init.r /home/ubuntu/

library(DBI)

args<-commandArgs(TRUE)
path<-args[1]

con <- dbConnect(RMySQL::MySQL(), user='root', password='Spring2019!!', host='127.0.0.1')
dbSendQuery(con, "CREATE DATABASE AONEDB;")
dbSendQuery(con, "USE AONEDB;")
#credit for the id generation https://programminghistorian.org/en/lessons/getting-started-with-mysql-using-r#create-database
dbSendQuery(con, "CREATE TABLE aonetable (id INT NOT NULL AUTO_INCREMENT, date DATE, open FLOAT, \
                                        high FLOAT, low FLOAT, close FLOAT, volume FLOAT, symbol VARCHAR(20), PRIMARY KEY (id));")
dbSendQuery(con, "GRANT ALL PRIVILEGES ON AONEDB.* TO 'mysqladmin'@'127.0.0.1' IDENTIFIED BY 'mysqladmin';")
dbDisconnect(con)

file.names <- dir(path, pattern ="*.csv")

con <- dbConnect(RMySQL::MySQL(), user='mysqladmin', password='mysqladmin', dbname='AONEDB', host='127.0.0.1')
dbSendQuery(con, "USE AONEDB;")

for(i in 1:length(file.names)){
  filepath <- paste(path, file.names[i], sep="/")
  samplerows <- read.csv(filepath, header=FALSE, sep=",", row.names=NULL)
  samplerows["V2"] <- NULL
  symbolname <- strsplit(file.names[i], "\\.")[[1]][1]
  symbolname <- strsplit(symbolname, "_")[[1]][2]
  print(symbolname)
  samplerows$symbol <- rep(symbolname, nrow(samplerows))
  names(samplerows) <- c("date", "open", "high", "low", "close", "volume", "symbol")
  dbWriteTable(con, name="aonetable", samplerows, row.names=FALSE, field.types = NULL, append=TRUE )
}
dbDisconnect(con)

quit()