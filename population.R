
population_raster <- raster("D:/spatial/新建文件夹/idn_pop.vrt")
tm_population <- tm_shape(population_raster) +
  tm_raster(style = "cont", palette = "plasma", title = "population") +
  tm_layout(main.title = "population map")+
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))
print(tm_population)
population_data <- raster("D:/spatial/新建文件夹/idn_pop.vrt")
unique_sp_population <- as(data_exclude_protected_areas, "Spatial")
population_values <- extract(population_data, unique_sp_population)
data_exclude_protected_areas$population <- population_values

tm_people <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(data_exclude_protected_areas) +
  tm_dots(size = 0.05,col = "population", palette = "plasma",style="quantile") +
  tm_layout(main.title = "population")+
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

print(tm_people)
