#devtools::install_github("rstudio/sparklyr")
library(sparklyr)
spark_install(version = "2.0.1")

sc <- spark_connect(master = "spark://iwannab1-XPS-15-9550:7077", spark_home="/home/iwannab1/tools/spark-2.0.1-bin-hadoop2.7", app_name = "sparklr")

library(dplyr)
library(nycflights13)
library(ggplot2)

flights <- copy_to(sc, flights, "flights")
airlines <- copy_to(sc, airlines, "airlines")
src_tbls(sc)

flights %>% select(year:day, arr_delay, dep_delay) %>% filter(dep_delay > 1000)


# lazy 
c1 = flights %>% filter(day == 17, month == 5, carrier %in% c('UA', 'WN', 'AA', 'DL'))
c2 = c1 %>% select(year, month, day, carrier, dep_delay, air_time, distance)
c3 = c2 %>% arrange(year, month, day, carrier)
c4 = c3 %>% mutate(air_time_hours = air_time / 60)

c1
c4

# convert to R dataframe
carrierhours = collect(c4)
ggplot(carrierhours, aes(carrier, air_time_hours)) + geom_boxplot()

# register temp table
compute(c4, 'carrierhours')
src_tbls(sc)

# sql rendering
bestworst = flights %>%
  group_by(year, month, day) %>%
  select(dep_delay) %>% 
  filter(dep_delay == min(dep_delay) || dep_delay == max(dep_delay))

sql_render(bestworst)
bestworst

# parquet file handle
spark_write_parquet(tbl, "hdfs://hdfs.company.org:9000/hdfs-path/data")
tbl = spark_read_parquet(sc, "data", "hdfs://hdfs.company.org:9000/hdfs-path/data")

# MLlib
iris_tbl <- copy_to(sc, iris, "iris", overwrite = TRUE)
rf_model <- iris_tbl %>%  ml_random_forest(Species ~ Petal_Length + Petal_Width, type = "classification")

rf_predict <- sdf_predict(rf_model, iris_tbl) %>%  ft_string_indexer("Species", "Species_idx") %>%  collect

table(rf_predict$Species_idx, rf_predict$prediction)
