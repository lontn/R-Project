#Spark1.6.3

# Set the system environment variables
Sys.setenv(SPARK_HOME = "D:\\spark-1.6.3-bin-hadoop2.6")
#為了使用Spark所提供的SparkR的package
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# Create a spark context and a SQL context
sc <- sparkR.init(master = "local[*]", appName = "SparkR2")
sqlContext <- sparkRSQL.init(sc)

#### Create a sparkR DataFrame from a R DataFrame ####
exercise.df <- data.frame(name=c("John", "Smith", "Sarah"), age=c(19, 23, 18)) # a R_dataFrame
exercise.df

##然後利用createDataFrame() ，把R的DataFrame，轉變成spark的DataFrame形式。
# convert R_dataFrame to spark_sql_dataFrame
spark.df <- createDataFrame(sqlContext, exercise.df) 
head(spark.df)

# print out the spark_sql_dataFrame's schema
printSchema(spark.df) 

class(spark.df)

#當然，我們也可以把spark的DataFrame，變回R的DataFrame
r.df <- collect(spark.df)
class(r.df)

##此外，我們可以利用sql的語法，對Spark內的資料進行查詢。
##這裡要注意的是，使用sql語法查詢之前，必須先用registerTempTable()，在spark裡建立一個可查詢的table：
# Running SQL Queries from SparkR
registerTempTable(spark.df, "test")
sql_result <- sql(sqlContext, "SELECT name FROM test WHERE age > 19 AND age < 24")
head(sql_result)
