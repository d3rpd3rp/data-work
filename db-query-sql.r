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
print(topdeltas, row.names = FALSE)
dbDisconnect(con)


SELECT date,symbol,ABS(open - close) AS 'change' FROM (SELECT date,open,close,symbol FROM aonetable ORDER BY ABS(open - close) DESC) AS sorted GROUP BY MAX('change');

SELECT date,symbol,ABS(open - close) AS 'change' FROM (SELECT date,open,close,symbol FROM aonetable WHERE MAX(ABS(open-close)) AS sorted 
GROUP BY 'change' ORDER BY date DESC;

SELECT date,symbol,ABS(open-close) AS change FROM aonetable ORDER BY change DESC 1;

SELECT DISTINCT date,symbol,ABS(open-close) AS `change` FROM aonetable GROUP BY MAX(change) ORDER BY date DESC;

#WORKS
SELECT DISTINCT date,symbol,ABS(open-close) AS `change` FROM aonetable ORDER BY `change` DESC; 

SELECT DISTINCT date,symbol,ABS(open-close) AS `change` FROM aonetable GROUP BY date; 


SELECT date, symbol, ABS(open - close) AS `change` FROM aonetable
FROM (
   SELECT TYPE, MIN(date) as mindate, 
   FROM aonetable group by type
) AS Q INNER JOIN anonetable as at ON at.type = Q.type and Q.date = x.mindate;


SELECT date, symbol, ABS(open - close) AS `change` FROM ((SELECT ABS(open - close) AS `absallrows` FROM aonetable WHERE MAX(`absallrows`)) AS Q INNER JOIN aonetable AS at ON at.type = Q.type and Q.date = at.`absallrows`);

(SELECT ABS(open - close) AS `absallrows` FROM aonetable GROUP BY `absallrows`) AS Q INNER JOIN aonetable AS at ON at.type = Q.type and Q.date = at.absallrows);

(SELECT ABS(open - close) AS `absallrows` FROM aonetable GROUP BY `absallrows`) AS Q INNER JOIN aonetable AS at ON at.type = Q.type and Q.date = at.absallrows;