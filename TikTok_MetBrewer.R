library("MetBrewer")
library(glue)
library(dplyr)
library(ggplot2)
library(readxl)
library(stringr)
library(colorspace)
library(sf)

# Code based on https://www.modeldifferently.com/2020/10/como-dibujar-mapas-en-r/
base_dir <- "SIGLIM_Publico_INSPIRE/SHP_ETRS89"

peninbal_shp_filename <- glue("{base_dir}/recintos_provinciales_inspire_peninbal_etrs89/recintos_provinciales_inspire_peninbal_etrs89.shp")
peninbal_shp <- read_sf(peninbal_shp_filename, quiet = TRUE)

peninbal_simpl_shp <- 
  peninbal_shp %>% 
  st_simplify(dTolerance = 1000)

png("bw.png")
peninbal_simpl_shp %>% 
  ggplot() +
  geom_sf() +
  theme_bw()
dev.off()

# Create random data
data <- data.frame(COD_PROV=seq(1,50,1), 
                   YEAR=seq(from = 2013, to = 2016),
                   NAME_PROV="Unknown",
                   PIB=rep(c(10000,20000,50000,200,3000), 200))

economical_data <- data %>% 
  mutate(COD_PROV = stringr::str_pad(as.character(COD_PROV), width = 2, pad = "0"))

drawing_data <- 
  peninbal_simpl_shp %>% 
  mutate(COD_PROV = substr(NATCODE, 5, 6)) %>%
  left_join(economical_data, by = 'COD_PROV')

theme_custom_map <- function(base_size = 11,
                             base_family = "",
                             base_line_size = base_size / 22,
                             base_rect_size = base_size / 22) {
  theme_bw(base_size = base_size, 
           base_family = base_family,
           base_line_size = base_line_size) %+replace%
    theme(
      axis.title = element_blank(), 
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      legend.position = 'none',
      complete = TRUE
    )
}

png("color1.png")
drawing_data %>% 
  ggplot() +
  aes(fill = PIB) +
  geom_sf() +
  theme_custom_map()
dev.off()

png("color2.png")
drawing_data %>% 
  ggplot() +
  aes(fill = factor(PIB)) +
  geom_sf() +
  scale_fill_manual(values = met.brewer("Degas", 5)) +
  theme_custom_map()
dev.off()

png("color3.png")
drawing_data %>% 
  ggplot() +
  aes(fill = factor(PIB)) +
  geom_sf() +
  scale_fill_manual(values = met.brewer("Gauguin", 5)) +
  theme_custom_map()
dev.off()

png("color4.png")
drawing_data %>% 
  ggplot() +
  aes(fill = factor(PIB)) +
  geom_sf() +
  scale_fill_manual(values = met.brewer("Klimt", 5)) +
  theme_custom_map()
dev.off()
