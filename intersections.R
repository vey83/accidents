library(sf)


data  <- read_csv("resources/RoadTrafficAccidentLocations.csv") %>%
  clean_names()

top_intersections <- data %>%
  
  # garder seulement 2024
  filter(accident_year == 2024) %>%
  
  # créer des clusters spatiaux (~50 m)
  mutate(
    cluster_e = round(accident_location_chlv95_e / 50) * 50,
    cluster_n = round(accident_location_chlv95_n / 50) * 50
  ) %>%
  
  # regrouper les accidents par carrefour
  group_by(cluster_e, cluster_n) %>%
  summarise(
    accidents = n(),
    
    graves = sum(accident_severity_category_fr == "accident avec blessés graves"),
    legers = sum(accident_severity_category_fr == "accident avec blessés légers"),
    tues = sum(accident_severity_category_fr == "accident avec tués"),
    
    pietons = sum(accident_involving_pedestrian, na.rm = TRUE),
    velos = sum(accident_involving_bicycle, na.rm = TRUE),
    motos = sum(accident_involving_motorcycle, na.rm = TRUE),
    
    canton = first(canton_code),
    
    .groups = "drop"
  ) %>%
  
  # garder les 20 plus dangereux
  slice_max(accidents, n = 20) %>%
  
  # texte pour tooltip Datawrapper
  mutate(
    tooltip = glue(
      "{accidents} accidents en 2024
{tues} mortels
{graves} blessés graves
{legers} blessés légers

{pietons} impliquant piétons
{velos} impliquant vélos
{motos} impliquant motos"
    )
  ) %>%
  
  # convertir en sf
  st_as_sf(coords = c("cluster_e", "cluster_n"), crs = 2056) %>%
  
  # Datawrapper préfère WGS84
  st_transform(4326)

top_intersections_export <- top_intersections %>%
  mutate(
    lon = st_coordinates(.)[,1],
    lat = st_coordinates(.)[,2]
  ) %>%
  st_drop_geometry()

googlesheets4::write_sheet(
  top_intersections_export,
  ss = link_sheet,
  sheet = "intersections_2024"
)


