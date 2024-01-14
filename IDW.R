library(sf)
library(tmap)
library(readxl)
library(gstat)
library(sp)
library(raster)
library(dplyr)

# 读取 GeoJSON 文件
indonesia_map <- st_read("D:/spatial/geoBoundaries-IDN-ADM2_simplified.geojson")

# 读取阳光辐射数据的 Excel 文件
radiation_data <- read_excel("D:/spatial/average_ssrd_values.xlsx")

# 转换为 sf 对象，替换 longitude 和 latitude 为您的数据列名
radiation_sf <- st_as_sf(radiation_data, coords = c("lon", "lat"), crs = st_crs(indonesia_map))

clipped_radiation <- st_intersection(radiation_sf, st_union(indonesia_map))
# 创建地图
tmap_mode("plot")

tm_map <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(clipped_radiation) +
  tm_dots(size = 0.05, col = "ssrd", palette = "viridis", style = "quantile") +
  tm_layout(main.title = "indonesia ssrd")+
  tm_compass(type = "arrow", position = c("left", "top")) +
  tm_scale_bar(position = c("left", "bottom"))


# 打印地图
print(tm_map)


library(fields)


library(akima)



# 提取辐射数据坐标和值
coords_radiation <- as.data.frame(st_coordinates(radiation_sf))
radiation_values_df <- data.frame(ANN = radiation_sf$ssrd)

# 创建 SpatialPointsDataFrame
radiation_sp <- SpatialPointsDataFrame(coords = coords_radiation, 
                                       data = radiation_values_df)

# 获取 CRS 作为 PROJ4 字符串并设置 CRS
crs_proj4 <- st_crs(indonesia_map)$proj4string
proj4string(radiation_sp) <- CRS(as.character(crs_proj4))















# 定义网格的范围
x_min <- min(90)
x_max <- max(145)
y_min <- min(-14)
y_max <- max(12)

# 设置较小的网格步长（例如，增加网格密度）
step_size <- 0.05  # 调整此值以更改网格密度

# 创建网格
grid_data <- expand.grid(x = seq(from = x_min, to = x_max, by = step_size),
                         y = seq(from = y_min, to = y_max, by = step_size))

# 将网格数据转换为 SpatialPointsDataFrame
coordinates(grid_data) <- ~x+y
grid_sp <- SpatialPointsDataFrame(grid_data, data.frame(id = row.names(grid_data)))












# 检查 CRS
crs_radiation_sp <- proj4string(radiation_sp)
crs_grid_sp <- proj4string(grid_sp)


if (is.na(crs_radiation_sp)) {
  proj4string(radiation_sp) <- CRS("+proj=longlat +datum=WGS84 +no_defs")
}
if (is.na(crs_grid_sp)) {
  proj4string(grid_sp) <- CRS("+proj=longlat +datum=WGS84 +no_defs")
}#先用这个

# 检查 CRS
crs_radiation_sp <- proj4string(radiation_sp)
crs_grid_sp <- proj4string(grid_sp)


# 如果 CRS 不匹配，则转换 CRS
if (crs_radiation_sp != crs_grid_sp) {
  radiation_sp <- spTransform(radiation_sp, CRS(crs_grid_sp))
}

# 再次尝试 IDW 插值
idw_result <- idw(formula = ANN ~ 1, locations = radiation_sp, newdata = grid_sp, idp = 2.0)


# 首先确保 CRS 信息不是空值
if (!is.na(crs_radiation_sp) && !is.na(crs_grid_sp)) {
  # 如果 CRS 不匹配，则转换 CRS
  if (crs_radiation_sp != crs_grid_sp) {
    radiation_sp <- spTransform(radiation_sp, CRS(crs_grid_sp))
  }
} else {
  stop("CRS information is missing in one of the objects.")
}



if (is.na(crs_radiation_sp)) {
  proj4string(radiation_sp) <- CRS("+proj=longlat +datum=WGS84 +no_defs")
}
if (is.na(crs_grid_sp)) {
  proj4string(grid_sp) <- CRS("+proj=longlat +datum=WGS84 +no_defs")
}#先用这个















# 执行 IDW 插值
idw_result <- idw(formula = ANN ~ 1, locations = radiation_sp, newdata = grid_sp, idp = 2.0)

# 转换为 sf 对象
idw_sf <- st_as_sf(idw_result)

clipped_radiation_idw <- st_intersection(idw_sf, st_union(indonesia_map))

unique_sf_no_duplicates <- clipped_radiation_idw %>% distinct(st_geometry(.), .keep_all = TRUE)

quantiles <- quantile(unique_sf_no_duplicates$var1.pred, probs = c(0, 0.25, 0.5, 0.75, 1))
tmap_mode("plot")
tmap_mode("view")


# 绘制插值结果
tm_map_idw <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(clipped_radiation_idw) +
  tm_dots(size = 0.05, col = "ssrd", palette = "viridis", style = "quantile")+
  tm_layout(main.title = "indonesia ssrd after IDW")+
  tm_compass(type = "arrow", position = c("left", "top")) +
  tm_scale_bar(position = c("left", "bottom"))


print(tm_map_idw)

write.csv(clipped_radiation_idw, "D:/spatial/新建文件夹/idw_sr.csv", row.names = FALSE)


clipped_radiation_idw <- clipped_radiation_idw %>% rename(ssrd = var1.pred)




