
clipped_radiation_idw <- clipped_radiation_idw %>% select(-var1.var)

clipped_radiation_idw_clean <- na.omit(clipped_radiation_idw)

st_crs(clipped_radiation_idw_clean)

clipped_radiation_idw_clean <- st_transform(clipped_radiation_idw_clean, st_crs(clipped_radiation))

# 缩短字段名
data_exclude_protected_areas <- data_exclude_protected_areas %>%
  rename(
    d_n_r = distance_to_nearest_road,
    d_n_g = distance_to_nearest_grid
    # 继续重命名其他需要缩短的字段名
  )

# 将 sf 对象保存为 Shapefile
st_write(data_exclude_protected_areas, "D:/spatial/代码/data_exclude_protected_areas.shp")


data_try <- st_read("D:/spatial/代码/data_exclude_protected_areas.shp")

data_try_1 <- na.omit(data_try)

data_filtered <- data_try_1 %>%
  filter(!landcover %in% c(1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 15, 20, 21, 22))

tm_can_build_solar_power_station <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(data_filtered) +
  tm_dots(size = 0.001, col = "blue")+
  tm_layout(main.title = "Place can build solar power station")+
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

print(tm_can_build_solar_power_station)












# 假设data_filtered是您的sf文件对象

# 选择需要归一化的数值型列
cols_to_normalize <- c("ssrd", "elevation", "population", "slope", "d_n_r", "d_n_g")
numeric_cols <- data_filtered %>%
  select(all_of(cols_to_normalize)) %>%
  st_drop_geometry()  # 去除空间数据

# 计算最小值和最大值
min_values <- apply(numeric_cols, 2, min, na.rm = TRUE)
max_values <- apply(numeric_cols, 2, max, na.rm = TRUE)

# 对数值型列进行归一化
data_filtered_normalized <- data_filtered %>%
  mutate(across(all_of(cols_to_normalize), ~ (.-min_values[cur_column()]) / (max_values[cur_column()] - min_values[cur_column()])))

# 打印归一化后的数据
print(data_filtered_normalized)








# 假设data_filtered是您的sf文件对象

# 选择需要进行一减操作的列
cols_to_modify <- c("elevation", "population", "slope", "d_n_r", "d_n_g")

# 进行一减操作
data_filtered_modified <- data_filtered_normalized %>%
  mutate(across(all_of(cols_to_modify), ~ 1 - .))

# 打印修改后的数据
print(data_filtered_modified)

class(data_filtered_modified)


data_filtered_modified_wkt <- data_filtered_modified %>%
  mutate(geometry_wkt = st_as_text(geometry)) %>%
  select(-geometry)

# 保存CSV文件
write.csv(data_filtered_modified_wkt, "D:/spatial/data_filtered_modified.csv", row.names = FALSE)






data_filtered_wkt <- data_filtered %>%
  mutate(geometry_wkt = st_as_text(geometry)) %>%
  select(-geometry)

write.csv(data_filtered_wkt, "D:/spatial/data_filtered.csv", row.names = FALSE)
