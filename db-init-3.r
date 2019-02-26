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

  args<-commandArgs(TRUE)
  path<-args[1]

  con <- dbConnect(RMySQL::MySQL(), user='root', password='Spring2019!!', host='127.0.0.1')
  dbSendQuery(con, "CREATE DATABASE AONEDB;")
  dbSendQuery(con, "USE AONEDB;")
  #credit for the id generation https://programminghistorian.org/en/lessons/getting-started-with-mysql-using-r#create-database
  dbSendQuery(con, "CREATE TABLE aonetable (id INT NOT NULL AUTO_INCREMENT, date DATE, open FLOAT, \
                                            high FLOAT, low FLOAT, close FLOAT, symbol VARCHAR(20), PRIMARY KEY (id));")
  dbSendQuery(con, "GRANT ALL PRIVILEGES ON AONEDB.* TO 'mysqladmin'@'127.0.0.1' IDENTIFIED BY 'mysqladmin';")
  dbDisconnect(con)

  file.names <- dir(path, pattern ="*.csv")

  con <- dbConnect(RMySQL::MySQL(), user='mysqladmin', password='mysqladmin', dbname='AONEDB', host='127.0.0.1')
  dbSendQuery(con, "USE AONEDB;")

  for(i in 1:length(file.names)){
              #idea from https://stackoverflow.com/questions/44288358/is-there-a-faster-way-to-upload-data-from-r-to-mysql
              dbSendQuery(con, "LOAD DATA LOCAL INFILE '", file.names[i], "' INTO TABLE aonetable FIELDS TERMINATED by ',' ENCLOSED BY '"' \
                                LINES TERMINATED BY '\r\n';")
  }
  dbDisconnect(con)