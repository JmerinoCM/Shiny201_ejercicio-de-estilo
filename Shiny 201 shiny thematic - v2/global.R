# global

# Librerías

library(shiny) 
library(shinydashboard) 
library(tidyverse) 
library(viridis)
library(shinyWidgets)
library(sf)
library(leaflet)
library(readxl)
library(ggplot2)
library(ggthemes)
library(plotly)
# library(shinythemes)
library(bslib)
library(thematic)
thematic_shiny(font = "auto")
library(showtext)

my_theme <- bs_theme(bootswatch = "minty",
                     base_font = font_google("Righteous")) 
# Warning: Error in match.arg: 'arg' should be one of “cerulean”, “cosmo”, “cyborg”, “darkly”, “flatly”, “journal”, “litera”, “lumen”, “lux”, “materia”, “minty”, “morph”, “pulse”, “quartz”, “sandstone”, “simplex”, “sketchy”, “slate”, “solar”, “spacelab”, “superhero”, “united”, “vapor”, “yeti”, “zephyr”
# Cargar datos

df <- read_excel('www/tasa_prevalencia.xlsx')

shape <- st_read("www/sin_islas.shp") 
shape$ENTIDAD <- gsub("DISTRITO FEDERAL", "CIUDAD DE MÉXICO", shape$ENTIDAD) 
shape$ENTIDAD <- gsub("MEXICO", "ESTADO DE MÉXICO", shape$ENTIDAD) 
shape$ENTIDAD <- gsub("VERACRUZ DE IGNACIO DE LA LLAVE", "VERACRUZ", shape$ENTIDAD) 
shape$ENTIDAD <- gsub("MICHOACAN DE OCAMPO", "MICHOACÁN", shape$ENTIDAD) 
shape$ENTIDAD <- gsub("COAHUILA DE ZARAGOZA", "COAHUILA", shape$ENTIDAD) 
shape$ENTIDAD <- gsub("QUERETARO DE ARTEAGA", "QUERÉTARO", shape$ENTIDAD) 
shape$CVE_EDO <- as.numeric(shape$CVE_EDO) 

# Transformaciones
df$CVE_EDO <- shape$CVE_EDO

df <- df %>% 
  pivot_longer(cols=c('2015','2016','2017','2018','2019','2020'), names_to = "years", values_to = "value")

df_shape <- shape %>%
  left_join(df, by="CVE_EDO")





