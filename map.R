accidents_2024_map <- data %>%
  filter(accident_year == 2024,
         accident_severity_category != "as3") %>%
  
  st_as_sf(
    coords = c("accident_location_chlv95_e", "accident_location_chlv95_n"),
    crs = 2056
  ) %>%
  
  st_transform(4326) %>%
  
  mutate(
    lon = st_coordinates(.)[,1],
    lat = st_coordinates(.)[,2]
  ) %>%
  
  st_drop_geometry()



googlesheets4::write_sheet(accidents_2024_map,
                           ss = link_sheet,
                           sheet = "carte_accidents_2024_2")




# On filtre 2024 et on crée un sf object
#flourish_accidents_2024_map <- data %>%
#  filter(accident_year == 2024) %>%
#  st_as_sf(coords = c("accident_location_chlv95_e", "accident_location_chlv95_n"),
#           crs = 2056) %>%   # CHLV95
#  st_transform(crs = 4326)  %>%# WGS84 pour Flourish / GeoJSON

#mutate(
#  lon = st_coordinates(.)[,1],
#  lat = st_coordinates(.)[,2]
#) %>%
  
#  st_drop_geometry()

#googlesheets4::write_sheet(flourish_accidents_2024_map,
#                           ss = link_sheet,
#                           sheet = "flourish_carte_accidents_2024")
