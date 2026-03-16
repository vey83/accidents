data_com <- data %>%
  filter(accident_year == 2024) %>%
  group_by(municipality_code) %>%
  mutate(tot_accident_municipality = n()) %>%
  ungroup() %>%
  group_by(municipality_code,accident_severity_category) %>%
  mutate(tot_accident_severity_category = n()) %>%
  slice(1) %>%
  ungroup() %>%
  select(municipality_codeaccident_severity_category_fr,tot_accident_municipality,tot_accident_severity_category)


data_com_wide <- data_com %>%
  select(municipality_code,
         accident_severity_category_fr,
         tot_accident_severity_category) %>%
  pivot_wider(
    names_from = accident_severity_category_fr,
    values_from = tot_accident_severity_category,
    values_fill = 0
  ) %>%
  mutate(
    total_accidents = rowSums(
      across(starts_with("accident")),
      na.rm = TRUE
    )
  ) %>%
  clean_names() %>%
  left_join(mapping_com)



data_com_tooltips <- data_com_wide %>%
  mutate(tooltip_text = paste(glue("Blessés légers: {accident_avec_blesses_legers} <br> Blessés graves: {accident_avec_blesses_graves} <br> Morts: {accident_avec_tues}")),
         tooltip_text_de = paste(glue("Unfall mit Getöteten: {accident_avec_blesses_legers} <br> Unfall mit Schwerverletzten: {accident_avec_blesses_graves} <br> Unfall mit Getöteten: {accident_avec_tues}")))
 

link_sheet = "1O7sN4MPLZkpsz9BbXUrFLHMNRiJuCwY9Y4W8syoP7z8"

googlesheets4::write_sheet(data_com_tooltips,
                           ss = link_sheet,
                           sheet = "carte_accidents_2024")
