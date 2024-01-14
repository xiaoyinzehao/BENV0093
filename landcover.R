landcover_raster <- raster("D:/spatial/新建文件夹/wwwww/IDN_cov/IDN_cov.vrt")

tm_landcover <- tm_shape(landcover_raster) +
  tm_raster(style = "cont", palette = "magma", title = "landcover") +
  tm_layout(main.title = "landcover")+
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))
print(tm_landcover)
landcover_data <- raster("D:/spatial/新建文件夹/wwwww/IDN_cov/IDN_cov.vrt")
unique_sp_landcover <- as(data_exclude_protected_areas, "Spatial")
landcover_values <- extract(landcover_data, unique_sp_landcover)
data_exclude_protected_areas$landcover<- landcover_values


tm_landcover_clipped <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(data_exclude_protected_areas) +
  tm_dots(size = 0.001, col = "landcover", palette = "magma", style = "quantile")+
  tm_layout(main.title = "landcover")+
  tm_compass(type = "arrow", position = c("left", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

print(tm_landcover_clipped)

