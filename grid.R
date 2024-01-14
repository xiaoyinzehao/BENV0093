grid_sf <- st_read("D:/spatial/grid.geojson")


# 读取地图
indonesia_map <- st_read("D:/spatial/geoBoundaries-IDN-ADM2_simplified.geojson")


tm_grid <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(grid_sf) +
  tm_lines(col = "blue", lwd = 1) +
  tm_layout(main.title = "印度尼西亚道路地图")

print(tm_grid)

st_crs(clipped_radiation_idw)
st_crs(grid_sf)

# 假设我们需要将 clipped_radiation_idw 转换为与 grid_sf 相同的 CRS
clipped_radiation_idw <- st_transform(clipped_radiation_idw, st_crs(grid_sf))



grid_distances <- st_distance(clipped_radiation_idw,grid_sf)

min_distances_grid <- apply(grid_distances, 1, min)
clipped_radiation_idw$distance_to_nearest_grid <- min_distances_grid


tm_griddistance <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(clipped_radiation_idw) +
  tm_dots(size = 0.05,col = "distance_to_nearest_grid", palette = "Set3",style = "quantile") +
  tm_layout(main.title = "distance to nearest grid")+
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

print(tm_griddistance)
