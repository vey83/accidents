heatmap_2024 <- data %>%
  filter(accident_year == 2024) %>%
  count(accident_week_day_fr, accident_hour, name = "accidents") %>%
  mutate(
    accident_hour = as.integer(accident_hour))

my_days_fr <- c("lundi","mardi","mercredi","jeudi","vendredi","samedi","dimanche")

heatmap_2024_reord <- heatmap_2024 %>%
  mutate(accident_week_day_fr = factor(accident_week_day_fr, levels = my_days_fr)) %>%
  arrange(accident_week_day_fr, accident_hour)


googlesheets4::write_sheet(heatmap_2024_reord,
                           ss = link_sheet,
                           sheet = "heatmap")
