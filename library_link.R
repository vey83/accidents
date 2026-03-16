#library

library(tidyverse)
library(janitor)
library(glue)
library(googlesheets4)
library(sf)

##links
communes <- read_csv("https://raw.githubusercontent.com/awp-finanznachrichten/lena_maerz2026/refs/heads/main/Output_Switzerland/CH_Bargeld_Gegenvorschlag_all_data.csv") %>%
  select(Gemeinde_Nr,Gemeinde_f,Gemeinde_d) %>%
  clean_names()

link_sheet = "1O7sN4MPLZkpsz9BbXUrFLHMNRiJuCwY9Y4W8syoP7z8"

##data
data  <- read_csv("resources/RoadTrafficAccidentLocations.csv") %>%
  clean_names() %>%
  mutate(municipality_code = as.numeric(municipality_code)) %>%
  left_join(communes, by=c("municipality_code" = "gemeinde_nr"))

mapping_com <- data %>% 
  group_by(accident_year,municipality_code) %>%
  slice(1) %>%
  ungroup() %>%
  select(municipality_code,gemeinde_f,gemeinde_d)
