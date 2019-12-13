source("wrangle.R")

make_graph_variety <- function(years = c(1931, 1932), 
                       sites = all_sites,
                       varieties = all_varieties){
  
  #filter our data based on the year/continent selections
  
  data <- df %>%
    filter(year >= years[1] & year <= years[length(years)]) %>%
    filter(site %in% sites) %>% 
    filter(variety %in% varieties) %>% 
    group_by(variety, year) %>% 
    summarise(yield = sum(yield))
  
  p <- ggplot(data, aes(x=reorder(as.factor(variety), -yield), y = yield, fill = as.factor(year),
                        text = paste('variety: ', variety,
                                     '</br></br></br> Year:', year,
                                     '</br></br></br> Yield:', yield))) +
    geom_bar(stat = 'identity', position = "stack") +
    theme_bw() + 
    scale_fill_discrete(name = "years") +
    xlab("Variety") +
    ylab("Yield(kg/hectare)") +
    # ggtitle("Yield per variety") +
    theme(axis.line = element_line(colour = "gray"),
          panel.border = element_blank(),
          text = element_text(size=10),
          axis.text.x = element_text(angle = 35, hjust = 1)
    )
  
  
  # passing c("text") into tooltip only shows the contents of 
  ggplotly(p, tooltip = c("text"))
}


make_graph_site <- function(years = c(1931, 1932), 
                               sites = all_sites,
                               varieties = all_varieties){
  
  #filter our data based on the year/continent selections
  data <- df %>%
    filter(year >= years[1] & year <= years[length(years)]) %>%
    filter(site %in% sites) %>% 
    filter(variety %in% varieties) %>% 
    group_by(site, year) %>% 
    summarise(yield = sum(yield))
  
  p <- ggplot(data, aes(x=reorder(as.factor(site), -yield), y = yield, fill = as.factor(year),
                        text = paste('site: ', site,
                                     '</br></br></br> Year:', year,
                                     '</br></br></br> Yield:', yield))) +
    geom_bar(stat = 'identity', position = "stack") +
    theme_bw() + 
    scale_fill_discrete(name = "years") +
    xlab("Site") +
    ylab("Yield(kg/hectare)") +
    # ggtitle("Yield per site") +
    theme(axis.line = element_line(colour = "gray"),
          panel.border = element_blank(),
          text = element_text(size=10),
          axis.text.x = element_text(angle = 35, hjust = 1)
    )
  
  
  # passing c("text") into tooltip only shows the contents of 
  ggplotly(p, tooltip = c("text"))
}


make_heat_map <- function(years = c(1931, 1932), 
                          sites = all_sites,
                          varieties = all_varieties){
  
  #filter our data based on the year/continent selections
  data <- df %>%
    filter(year >= years[1] & year <= years[length(years)]) %>%
    filter(site %in% sites) %>% 
    filter(variety %in% varieties) %>% 
    group_by(variety, site) %>% 
    summarise(yield = sum(yield))
  
  p <- ggplot(data, aes(variety, site, fill= yield, text = paste('site: ', site,
                                                                 '</br></br></br> Variety:', variety,
                                                                 '</br></br></br> Yield:', yield))) + 
    geom_tile() +
    scale_fill_gradient(low="white", high="blue") +
    xlab("Variety") +
    ylab("Site") # +
    # ggtitle("Heatmap showing the yield per variety and per site")
  
  
  # passing c("text") into tooltip only shows the contents of 
  ggplotly(p, tooltip = c("text"))
}

make_map <- function(sites = all_sites){
  
  data <- df %>% 
    select(2:ncol(.)) %>%
    filter(site %in% sites)

  layer_text <- tibble(
    lon = c(-93.2277, -93.5084, -95.9189, -96.6094, -93.5302, -92.1005),
    lat = c(44.9740, 44.0070, 45.5919, 47.7746, 47.2372, 46.7867),
    site = unique(df$site)
  ) %>%
    filter(site %in% sites)

  layer_points <- tibble(
    lon = c(-93.2277, -93.5084, -95.9189, -96.6094, -93.5302, -92.1005),
    lat = c(44.9740, 44.0070, 45.5919, 47.7746, 47.2372, 46.7867),
    site = unique(df$site)
  ) %>%
    filter(site %in% sites)
  
  layer_points_t <- usmap_transform((as.data.frame(layer_points))) 
  layer_text_t <- usmap_transform((as.data.frame(layer_text))) 

  p <- plot_usmap(include = "MN", "counties", color = "blue", size = 0.2) +
    labs(title = "Barley Sites in Minnesota, USA") +
    geom_point(data = layer_points_t, aes(x = lon.1, y = lat.1), color = "red") +
    geom_text(data = layer_text_t, aes(x = lon.1, y = lat.1, label = site))
  
    
  # displays meaningless latitude and longitude. But at least it shows something other than type=0,
  ggplotly(p, layer = 2)
}
