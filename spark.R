if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  Sys.setenv(SPARK_HOME = "/home/iwannab1/tools/spark-2.0.1-bin-hadoop2.7")
}
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(master = "spark://iwannab1-XPS-15-9550:7077", sparkConfig = list(spark.driver.memory = "2g"))