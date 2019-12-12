library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(tidyverse)
library(cowplot)
library(ggplot2)
library(dashTable)
library(plotly)
library(albersusa)
library(lattice)
library(usmap)

app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")

df <- read_csv("../data/barley.csv")

yearMarks <- map(unique(df$year), as.character)
names(yearMarks) <- unique(df$year)
yearSlider <- dccRangeSlider(
  id = "year",
  marks = yearMarks,
  min = 1931,
  max = 1932,
  step = 1,
  value = list(1931, 1932)
)

siteDropdown <- dccDropdown(
  id = "site",
  # map/lapply can be used as a shortcut instead of writing the whole list
  # especially useful if you wanted to filter by country!
  options = map(
    unique(df$site), function(x){
      list(label=x, value=x)
    }),
  value = levels(as.factor(df$site)), #Selects all by default
  multi = TRUE
)

varietyDropdown <- dccDropdown(
  id = "variety",
  # map/lapply can be used as a shortcut instead of writing the whole list
  # especially useful if you wanted to filter by country!
  options = map(
    unique(df$variety), function(x){
      list(label=x, value=x)
    }),
  value = levels(as.factor(df$variety)), #Selects all by default
  multi = TRUE
)


all_sites <- unique(df$site)
all_varieties <- unique(df$variety)
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
    ylab("Yield(kg/hectar)") +
    ggtitle("Yield per variety") +
    theme(axis.line = element_line(colour = "gray"),
          panel.border = element_blank(),
          text = element_text(size=20),
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
    ylab("Yield(kg/hectar)") +
    ggtitle("Yield per site") +
    theme(axis.line = element_line(colour = "gray"),
          panel.border = element_blank(),
          text = element_text(size=20),
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
    ylab("Site") +
    ggtitle("Heatmap showing the yield per variety and per site")
  
  
  # passing c("text") into tooltip only shows the contents of 
  ggplotly(p, tooltip = c("text"))
}

make_map <- function(sites = all_sites){
  
  data <- df %>% 
    select(2:ncol(.)) %>%
    filter(site %in% sites)
  
  layer_points <- tibble(
    lon = c(-93.2277, -93.5084, -95.9189, -96.6094, -93.5302, -92.1005),
    lat = c(44.9740, 44.0070, 45.5919, 47.7746, 47.2372, 46.7867),
    site = unique(df$site)
  ) %>%
    filter(site %in% sites)
  
  layer_points_t <- usmap_transform((as.data.frame(layer_points))) 
  
  p <- plot_usmap(include = "MN", "counties", color = "blue", size = 0.2) +
    labs(title = "Barley Sites in Minnesota, USA") +
    geom_point(data = layer_points_t, aes(x = lon.1, y = lat.1), color = "red") +
    geom_text(data = layer_points_t, aes(x = lon.1, y = lat.1, label = site), hjust = -100, vjust = 4000)
  
    
  # displays meaningless latitude and longitude. But at least it shows something other than type=0,
  ggplotly(p, layer = 2)
}

variety_graph <- dccGraph(
  id = 'variety-graph',
  figure=make_graph_variety() # gets initial data using argument defaults
)

site_graph <- dccGraph(
  id = 'site-graph',
  figure=make_graph_site() # gets initial data using argument defaults
)

heat_map_graph <- dccGraph(
  id = 'heat-map-graph',
  figure=make_heat_map() # gets initial data using argument defaults
)

map_graph <- dccGraph(
  id = 'map-graph',
  figure=make_map() # gets initial data using argument defaults
)


app$layout(
  htmlDiv(
    className = "test",
    list(
      htmlH1('BaRley app'),
      htmlH2('Have some information about the barley yield in an interactive way!'),
      htmlP('Barley is part of the major cereal grains used worldwide. Understanding how the annual yield of barley is impacted by the variety or site on which it grows is very important. This dashboard has been created to allow you to explore a dataset containing the annual yield for selected varieties of barley and particular sites, for the years 1931, 1932, or both. It should help you better understand what variety or what site is the most suitable to your situation. If you are wondering:'),
      htmlP('-Given some sites and some varieties, what variety of barley had the highest yield during a specific year?'),
      htmlP('-Given some sites and some varieties, what site had the highest yield during a specific year?'),
      htmlP('-Given some sites and some varieties, what is the variety of barley with the highest yield for each of the sites?'),
      htmlP('then this app is exactly what you need! Now, you have no excuse to increase your productivity and have the highest yield as possible! '),
      htmlP('Trick : Place your mouse above the different bars to display more information!'),
      dccMarkdown('*More information about the dataset : *'),
      dccMarkdown('*We chose the barley dataset from the vega-datasets python package. This dataset shows the yields of 10 different varieties of barley at 6 different sites in Minnesota during the years 1931 and 1932. It first appeared in the 1934 paper "Statistical Determination of Barley Varietal Adaption" by the three agronomists who led this experiment: F.R. Immer, H.K. Hayes, and L. Powers.*'),
      dccMarkdown('*The 10 varieties studied are : Velvet, Trebi, No. 457, No. 462, Peatland, No. 475, Manchuria, Glabron, Svansota, and Wisconsin No 38.*'),
      dccMarkdown('*The 6 sites studied are : University Farm, Waseca, Morris, Crookston, Grand Rapids, and Duluth.*'),
      htmlBr(),
      #selection components
      htmlLabel('Select a year range:'),
      yearSlider,
      htmlBr(),
      htmlLabel('Select a site:'),
      siteDropdown,
      htmlLabel('Select a variety:'),
      varietyDropdown,
      #graph and table
      map_graph, htmlIframe(height=20, width=10, style=list(borderWidth = 3)), #space
      variety_graph, 
      htmlIframe(height=20, width=10, style=list(borderWidth = 2)), #space
      site_graph,
      htmlIframe(height=20, width=10, style=list(borderWidth = 2)), #space
      heat_map_graph,
      htmlIframe(height=20, width=10, style=list(borderWidth = 3)) #space
    )
  )
)


app$callback(
  #update figure of variety-graph
  output=list(id = 'variety-graph', property='figure'),
  params=list(input(id = 'year', property='value'),
              input(id = 'site', property='value'),
              input(id = 'variety', property='value')),
  #this translates your list of params into function arguments
  function(year_value, site_value, variety_value) {
    make_graph_variety(year_value, site_value, variety_value)
  })

app$callback(
  #update figure of variety-graph
  output=list(id = 'site-graph', property='figure'),
  params=list(input(id = 'year', property='value'),
              input(id = 'site', property='value'),
              input(id = 'variety', property='value')),
  #this translates your list of params into function arguments
  function(year_value, site_value, variety_value) {
    make_graph_site(year_value, site_value, variety_value)
  })

app$callback(
  #update figure of variety-graph
  output=list(id = 'heat-map-graph', property='figure'),
  params=list(input(id = 'year', property='value'),
              input(id = 'site', property='value'),
              input(id = 'variety', property='value')),
  #this translates your list of params into function arguments
  function(year_value, site_value, variety_value) {
    make_heat_map(year_value, site_value, variety_value)
  })

app$callback(
  output=list(id = 'map-graph', property='figure'),
  params=list(input(id = 'site', property='value')),
  #this translates your list of params into function arguments
  function(site_value) {
    make_map(site_value)
  })

app$run_server()




