elevation_1 <- raster("D:/spatial/新建文件夹/IDN_alt.vrt")
slope_data <- terrain(elevation_1, opt = "slope", unit = "degrees")
tm_slope <- tm_shape(slope_data) +
  tm_raster(style = "cont", palette = "-RdYlBu", title = "slope") +
  tm_layout(main.title = "slpoe")+
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))
print(tm_slope)

class(slope_data)

unique_sp_slope <- as(data_exclude_protected_areas, "Spatial")
slope_values <- extract(slope_data, unique_sp_slope)
data_exclude_protected_areas$slope <- slope_values 

class(slope_data)
