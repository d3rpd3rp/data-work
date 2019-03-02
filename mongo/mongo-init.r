
library(mongolite)

args<-commandArgs(TRUE)
path<-args[1]
file.names <- dir(path, pattern ="*.csv")

m <- mongo(url = "mongodb://localhost:27017")

for (i in 1:length(file.names))
        filepath <- paste(path, file.names[i], sep="/")
        samplerows <- read.csv(filepath, header=FALSE, sep=",", row.names=NULL)
        samplerows["V2"] <- NULL
        symbolname <- strsplit(file.names[i], "\\.")[[1]][1]
        symbolname <- strsplit(symbolname, "_")[[1]][2]
        samplerows$symbol <- rep(symbolname, nrow(samplerows))
        names(samplerows) <- c("date", "open", "high", "low", "close", "volume", "symbol")
        m$insert(samplerows)
#find largest difference
maxs <- m$aggregate('[{"$group":{"_id":"$date", "sym": {"$addToSet": "$symbol"}, "maxchange":{ "$max": {"$abs": { "$subtract": ["$open", "$close"]}}}}}]')
names(maxs) <- c("date", "symbol", "change")
print(maxs[order(maxs$date),])