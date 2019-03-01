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

#SELECT date,ABS(open - close) AS `change` FROM aonetable ORDER BY ABS(open - close) DESC;
#SELECT date,ABS(open - close) AS `change` FROM aonetable ORDER BY date,ABS(open - close) DESC;


SELECT date,ABS(open - close) AS `change` FROM aonetable ORDER BY date,ABS(open - close) DESC
WHERE MAX(ABS(open - close)) AS `maximal_changed` IN (SELECT DISTNCT date FROM aonetable ORDER BY DESC LIMIT 1);



SELECT date,symbol,change GROUP BY (date)
FROM (
        SELECT date,ABS(open - close) AS change FROM aonetable ORDER BY date,ABS(open - close) DESC
     );


SELECT date,symbol,change FROM (SELECT date,open,close,symbol FROM aonetable ORDER BY date,ABS(open - close) DESC) GROUP BY date;

SELECT date,symbol,close,open 
FROM (SELECT date,open,close,symbol FROM aonetable ORDER BY ABS(open - close) DESC) AS sorted GROUP BY date AS maxs;


SELECT date,symbol,close,open FROM (SELECT date,symbol,close,open FROM aonetable ORDER BY ABS(open - close) DESC) AS sorted GROUP BY date AS maxs;


SELECT symbol, close, open, DISTINCT date FROM (SELECT symbol,close,open,date FROM aonetable ORDER BY ABS(open - close) DESC) AS sorted;

SELECT ANY_VALUE(symbol), ABS(open - close), DATE(date) FROM (SELECT DISTINCT(symbol),close,open,date FROM aonetable ORDER BY ABS(open - close) DESC) AS sorted GROUP BY DATE(date);


SELECT ANY_VALUE(symbol), ABS(ANY_VALUE(open) - ANY_VALUE(close)), DATE(date) FROM (SELECT symbol,close,open,date FROM aonetable ORDER BY ABS(open - close) DESC) AS sorted GROUP BY DATE(date);

SELECT ABS(open - close),symbol,date FROM (SELECT open,close,symbol,date FROM aonetable ORDER BY ABS(open - close) DESC) AS sorted GROUP BY date;

SELECT DISTINCT date, ABS(open - close),symbol FROM (SELECT date,open,close,symbol FROM aonetable ORDER BY ABS(open - close) DESC) AS sorted;


#(ABS(1-CLOSE/OPEN)))
#OUTPUT: DATE SYMBOL MAXIMUM_CHANGE

#SELECT * FROM {DBNAME}
#	WHERE * IN ( 
#		#adapted from: https://stackoverflow.com/questions/592209/find-closest-numeric-value-in-database
#		#replaced any parameters with vars anototated by {} and caps
#		SELECT TOP {k} * FROM {DBNAME}
#		WHERE Name = '{FEATURE}' and Size = 2 and PType = 'p'
#		#take the difference betwenn the area of the table and the give size of {FEATURE}
#		#this is clever ^^^
#		#take the absolute value so remains positive
#		ORDER BY ABS( Area - @input ) 
#		)
#don't know how to nest another iteration for all {FEATURES}

#res <- dbSendQuery(con, statement = paste("SELECT w.laser_id, w.wavelength, p.cut_off","FROM WL w, PURGE P","WHERE w.laser_id = p.laser_id","ORDER BY w.laser_id"))