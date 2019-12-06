  library(ggplot2)
  library(albersusa)
  library(tidyverse)
  library(lattice)
  
  # Read in the data from the repository
  
  df <- read_csv("data/barley.csv") %>% 
    select(2:ncol(.))
  
  # Defines the sites by actual latitude and longitude
  
  layer_points <- tibble(
    lon = c(-93.2277, -93.5084, -95.9189, -96.6094, -93.5302, -92.1005),
    lat = c(44.9740, 44.0070, 45.5919, 47.7746, 47.2372, 46.7867),
    location = unique(df$site)
  )
  
  # Transforms these points to the basis used by the map
  
  layer_points_t <- usmap_transform((as.data.frame(layer_points)))
  
  # Plot the map
  
  plot_usmap(include = "MN", "counties", color = "blue", size = 0.2) +
    labs(title = "Barley Sites in Minnesota, USA") +
    geom_point(data = layer_points_t, aes(x = lon.1, y = lat.1), color = "red") +
    geom_text(data = layer_points_t, aes(x = lon.1, y = lat.1, label = location), hjust = -0.2, vjust = 0)
  
