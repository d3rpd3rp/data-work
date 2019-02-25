library(DBI)

args<-commandArgs(TRUE)
path<-args[1]
 
file.names <- dir(path, pattern ="*.csv")

con <- dbConnect(RMySQL::MySQL(), user='mysqladmin', password='mysqladmin', dbname='AONEDB', host='127.0.0.1')
dbSendQuery(con, "USE AONEDB;")

for(i in 1:length(file.names)){
  filepath <- paste(path, file.names[i], sep="/")
  samplerows <- read.csv(filepath, header=FALSE, sep=",")
  print(typeof(samplerows))
  print(typeof(str(samplerows))
  #idea from https://stackoverflow.com/questions/44288358/is-there-a-faster-way-to-upload-data-from-r-to-mysql
  dbWriteTable(con, name="aonetable", samplerows, append=TRUE )
}
dbDisconnect(con)

