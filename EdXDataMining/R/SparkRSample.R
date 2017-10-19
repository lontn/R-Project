#Spark2.2.0
#library(rJava)
# Set the system environment variables
#Sys.setenv(HADOOP_HOME = "D:\\hadoop\\hadoop-2.7.1\\bin")
#Sys.setenv(SPARK_HOME = "D:\\spark-2.2.0-bin-hadoop2.7")
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
 Sys.setenv(SPARK_HOME = "D:\\spark-2.2.0-bin-hadoop2.7")
}
#Sys.getenv("SPARK_HOME")
#為了使用Spark所提供的SparkR的package
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
# Create a spark context and a SQL context
library(SparkR)
#sc <- sparkR.session(master = "local[*]")

sc <- sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "2g"), enableHiveSupport = FALSE)
#sqlContext <- sparkRSQL.init(sc)


df <- as.DataFrame(faithful)

# Displays the first part of the SparkDataFrame
head(df)

printSchema(df)

# Register this SparkDataFrame as a temporary view.
createOrReplaceTempView(df, "faith")

# SQL statements can be run by using the sql method
teenagers <- sql("SELECT * FROM faith WHERE waiting >= 70 ")
head(teenagers)

