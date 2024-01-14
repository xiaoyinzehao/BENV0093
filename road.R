library(sf)
library(sp)
library(dplyr)
library(tmap)

class(clipped_radiation_idw)
# 假设 your_sf 是您的 sf 点数据集
# 假设 unique_sf 是您的 sf 点数据集
unique_sf_no_duplicates <- clipped_radiation_idw %>% distinct(st_geometry(.), .keep_all = TRUE)



road_sf <- st_read("D:/spatial/新建文件夹/IDN_roads.shp")




# 读取地图
indonesia_map <- st_read("D:/spatial/geoBoundaries-IDN-ADM2_simplified.geojson")


tm_road <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(road_sf) +
  tm_lines(col = "blue", lwd = 1) +
  tm_layout(main.title = "印度尼西亚道路地图")

print(tm_road)

# 计算距离
distances <- st_distance(clipped_radiation_idw,roads_sf)

class(clipped_radiation_idw)

class(distances)

min_distances <- apply(distances, 1, min)
clipped_radiation_idw$distance_to_nearest_road <- min_distances


# 设置 tmap 模式为绘图
tmap_mode("plot")


# 绘制地图
tm_roaddistance <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(clipped_radiation_idw) +
  tm_dots(size = 0.05,col = "distance_to_nearest_road", palette = "Set3",style = "quantile") +
  tm_layout(main.title = "distance to nearest road")+
  tm_compass(type = "arrow", position = c("left", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

print(tm_roaddistance)

