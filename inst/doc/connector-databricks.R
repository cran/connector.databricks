## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
# library(connector.databricks)
# 
# # Connect to databricks tables using DBI
# con <- connector_databricks_table(
#   http_path = "path-to-cluster",
#   catalog = "my_catalog",
#   schema = "my_schema"
# )
# 
# # Connect to databricks volume
# con <- connector_databricks_volume(
#   catalog = "my_catalog",
#   schema = "my_schema",
#   path = "path-to-file-storage"
# )

## ----eval=FALSE---------------------------------------------------------------
# library(connector)
# 
# # Create connector object
# db <- connect()

## ----eval=FALSE---------------------------------------------------------------
# # Connection to Databricks cluster. This will print object details
# db$tables
# 
# # Connection to Databricks cluster. This will print object details
# db$volume

## ----eval=FALSE---------------------------------------------------------------
# # Create a directory
# db$volume |>
#   create_directory_cnt("new_directory")
# 
# # Remove a directory
# db$volume |>
#   remove_directory_cnt("new_directory")
# 
# # List content inside volume directory
# db$volume |>
#   list_content_cnt()
# 
# # List tables inside database
# db$tables |>
#   list_content_cnt()

## ----eval=FALSE---------------------------------------------------------------
# library(dplyr)
# 
# # Manipulate data
# 
# ## Iris data
# setosa <- iris |>
#   filter(Species == "setosa")
# 
# mean_for_all_iris <- iris |>
#   group_by(Species) |>
#   summarise_all(list(mean, median, sd, min, max))
# 
# ## mtcars data
# cars <- mtcars |>
#   filter(mpg > 22)
# 
# mean_for_all_mtcars <- mtcars |>
#   group_by(gear) |>
#   summarise(across(
#     everything(),
#     list(
#       "mean" = mean,
#       "median" = median,
#       "sd" = sd,
#       "min" = min,
#       "max" = max
#     ),
#     .names = "{.col}_{.fn}"
#   )) |>
#   tidyr::pivot_longer(
#     cols = -gear,
#     names_to = c(".value", "stat"),
#     names_sep = "_"
#   )
# 
# ## Store data
# db$tables |>
#   write_cnt(setosa, "setosa", overwrite = TRUE)
# 
# db$tables |>
#   write_cnt(mean_for_all_iris, "mean_iris", overwrite = TRUE)
# 
# db$tables |>
#   write_cnt(cars, "cars_mpg", overwrite = TRUE)
# 
# db$tables |>
#   write_cnt(mean_for_all_mtcars, "mean_mtcars", overwrite = TRUE)

## ----eval=FALSE---------------------------------------------------------------
# library(gt)
# library(tidyr)
# library(ggplot2)
# 
# # List and load data from cluster
# db$tables |>
#   list_content_cnt()
# 
# table <- db$tables |>
#   read_cnt("mean_mtcars")
# 
# gttable <- table |>
#   gt(groupname_col = "gear")
# 
# # Save non-tabular data to databricks volume
# tmp_file <- tempfile(fileext = ".docx")
# gtsave(gttable, tmp_file)
# db$volume |>
#   upload_cnt(tmp_file, "tmeanallmtcars.docx")
# 
# # Manipulate data
# setosa_fsetosa <- db$tables |>
#   read_cnt("setosa") |>
#   filter(Sepal.Length > 5)
# 
# fsetosa <- ggplot(setosa) +
#   aes(x = Sepal.Length, y = Sepal.Width) +
#   geom_point()
# 
# ## Store data into output location
# db$volume |>
#   write_cnt(fsetosa$data, "fsetosa.csv")
# db$volume |>
#   write_cnt(fsetosa, "fsetosa.rds")
# 
# tmp_file <- tempfile(fileext = ".png")
# ggsave(tmp_file, fsetosa)
# db$volume |>
#   upload_cnt(tmp_file, "fsetosa.png")

