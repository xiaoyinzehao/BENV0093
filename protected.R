protected_sf_0 <- st_read("D:/spatial/新建文件夹/protected/WDPA_WDOECM_Jan2024_Public_IDN_shp_0/WDPA_WDOECM_Jan2024_Public_IDN_shp-polygons.shp")

tm_protected0 <- tm_shape(indonesia_map) +
    tm_borders() +
    tm_shape(protected_sf_0) +
    tm_polygons(col = "green", border.col = "black") +
    tm_layout(main.title = "印度尼西亚保护区0")
  
print(tm_protected0)


class(protected_sf_0)




protected_sf_1 <- st_read("D:/spatial/新建文件夹/protected/WDPA_WDOECM_Jan2024_Public_IDN_shp_1/WDPA_WDOECM_Jan2024_Public_IDN_shp-polygons.shp")

tm_protected1 <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(protected_sf_1) +
  tm_polygons(col = "blue", border.col = "black") +
  tm_layout(main.title = "印度尼西亚保护区1")

print(tm_protected1)






protected_sf_2 <- st_read("D:/spatial/新建文件夹/protected/WDPA_WDOECM_Jan2024_Public_IDN_shp_2/WDPA_WDOECM_Jan2024_Public_IDN_shp-polygons.shp")

tm_protected2 <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(protected_sf_2) +
  tm_polygons(col = "yellow", border.col = "black") +
  tm_layout(main.title = "印度尼西亚保护区2")

print(tm_protected2)








tmap_mode("plot")

tm_protected_all <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(protected_sf_0) +
  tm_polygons(col = "green", border.col = "black")+
  tm_shape(protected_sf_1) +
  tm_polygons(col = "green", border.col = "black")+
  tm_shape(protected_sf_2) +
  tm_polygons(col = "green", border.col = "black") +
  tm_layout(main.title = "Protected areas of Indonesia")+
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

print(tm_protected_all)














joined_data0 <- st_join(clipped_radiation_idw_clean, protected_sf_0, join = st_within)
filtered_data0 <- filter(joined_data, is.na(WDPAID))
joined_data1 <- st_join(filtered_data0, protected_sf_1, join = st_within)
filtered_data1 <- filter(joined_data1, is.na(WDPAID.y))
joined_data2 <- st_join(filtered_data1, protected_sf_2, join = st_within)
filtered_data2 <- filter(joined_data2, is.na(WDPAID))


data_exclude_protected_areas <- filtered_data2 %>%
  select(where(~ !all(is.na(.))))

tm_landcover_include <- tm_shape(indonesia_map) +
  tm_borders() +
  tm_shape(data_includ_landcover) +
  tm_dots(size = 0.0005, col = "blue", palette = "magma", style = "quantile")+
  tm_layout(main.title = "area exclude protected area")+
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

print(tm_landcover_include)

data_exclude_protected_areas <- data_exclude_protected_areas %>%
  rename(ssrd = var1.pred)

