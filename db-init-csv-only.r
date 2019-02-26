library(DBI)
  
args<-commandArgs(TRUE)
path<-args[1]

file.names <- dir(path, pattern ="*.csv")

con <- dbConnect(RMySQL::MySQL(), user='mysqladmin', password='mysqladmin', dbname='AONEDB', host='127.0.0.1')
dbSendQuery(con, "USE AONEDB;")

for(i in 1:length(file.names)){
  filepath <- paste(path, file.names[i], sep="/")
  samplerows <- read.csv(filepath, header=FALSE, sep=",", row.names=NULL)
  samplerows["V2"] <- NULL
  symbolname <- strsplit(file.names[i], "\\.")[[1]][1]
  #symbolname <- strsplit(symbolname, "\\_")
  print(symbolname)
  samplerows$symbol <- rep(symbolname, nrow(samplerows))
  names(samplerows) <- c("date", "open", "high", "low", "close", "volume", "symbol")
  dbWriteTable(con, name="aonetable", samplerows, row.names=FALSE, field.types = NULL, append=TRUE )
}
dbDisconnect(con)