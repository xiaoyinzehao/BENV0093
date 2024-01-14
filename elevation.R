
elevation_raster <- raster("D:/spatial/新建文件夹/IDN_alt.vrt")
tm_elevation <- tm_shape(elevation_raster) +
  tm_raster(style = "cont", palette = "-RdYlBu", title = "elevation") +
  tm_layout(main.title = "indonesia elevation")+
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

print(tm_elevation)
elevation_data <- raster("D:/spatial/新建文件夹/IDN_alt.vrt")
unique_sp <- as(data_exclude_protected_areas, "Spatial")
elevation_values <- extract(elevation_data, unique_sp)
data_exclude_protected_areas$elevation <- elevation_values


tm_elevations <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(data_includ_landcover) +
  tm_dots(size = 0.0005, col = "elevation", palette = "magma", style = "quantile")+
  tm_layout(main.title = "elevation")+
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

print(tm_elevations)
