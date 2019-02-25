#!/usr/bin/Rscript
#r routine to init the db based on set of csv files
#ex. Rscript foo.R arg1 arg2
#! /path/to/Rscript
#args <- commandArgs(TRUE)
#...
#q(status=<exit status code>)
#
#provide only one cmd line arg "path": location of csv files
#ex. Rscript db-init.r /home/ubuntu/

library(DBI)

#path<-arg1 

con <- dbConnect(RMySQL::MySQL(), user='root', password='Spring2019!!', host='127.0.0.1')
dbSendQuery(con, "CREATE DATABASE AONEDB;")
dbSendQuery(con, "USE AONEDB;")
#credit for the id generation https://programminghistorian.org/en/lessons/getting-started-with-mysql-using-r#create-database
dbSendQuery(con, "CREATE TABLE aonetable (id INT NOT NULL AUTO_INCREMENT, date DATE, symbol VARCHAR(20), \
                                          open FLOAT, high FLOAT, low FLOAT, close FLOAT, PRIMARY KEY (id));")
dbSendQuery(con, "GRANT ALL PRIVILEGES ON AONEDB.* TO 'mysqladmin'@'127.0.0.1' IDENTIFIED BY 'mysqladmin';")
dbDisconnect(con)


"""
file.names <- dir(path, pattern =".csv")
for(i in 1:length(file.names)){
  samplerows <- read.csv(file.names[i], header=FALSE, sep=",")
  str(samplerows)
}

file.names <- dir(path, pattern =".csv")
for(i in 1:length(file.names)){
    #idea from https://stackoverflow.com/questions/44288358/is-there-a-faster-way-to-upload-data-from-r-to-mysql
    dbSendQuery(con, "LOAD DATA LOCAL INFILE file.names[i]
                  INTO TABLE AONETABLE
                  FIELDS TERMINATED by ','
                  ENCLOSED BY '"'
                  LINES TERMINATED BY '\\n'")

library(RMySql)
library(RODBC)

con <- dbConnect(MySQL(),
  user = 'user',
  password = 'pw',
  host = 'amazonaws.com',
  dbname = 'db_name')
"""