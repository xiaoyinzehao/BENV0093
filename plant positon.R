# 读取 GeoJSON 文件
indonesia_map <- st_read("D:/spatial/geoBoundaries-IDN-ADM2_simplified.geojson")


# 如果电厂数据在 Excel 文件中，使用 readxl 包读取
power_plants <- read_excel("D:/spatial/power plant Indonesia.xlsx")



# 确保坐标数据是数值类型
power_plants$Longitude <- as.numeric(power_plants$longitude)
power_plants$Latitude <- as.numeric(power_plants$latitude)

# 将数据框转换为 sf 对象
power_plants_sf <- st_as_sf(power_plants, coords = c("Longitude", "Latitude"), crs = 4326, agr = "constant")
tmap_mode("plot")
# 使用 tmap 绘制地图
tm_pec<-tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(power_plants_sf) +
  tm_symbols(size = 0.4, col = "red") +
  tm_layout(main.title = "planned,exsiting and construction") +
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

print(tm_pec)














# 加载必要的库
library(tmap)
library(sf)
library(readxl)

# 读取电厂地址数据

data1 <- read_excel("D:/spatial/Modified_SEELECTED_POSITION.xlsx")

# 创建sf对象
sf_selection <- st_as_sf(data1, coords = c("longitude", "latitude"), crs = 4326)
# 读取地图数据

tm_selection<-tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(sf_selection) +
  tm_symbols(size = 0.3, col = "blue") +
  tm_layout(main.title = "Selected position") +
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

print(tm_selection)




