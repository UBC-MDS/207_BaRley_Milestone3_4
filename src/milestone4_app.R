library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(tidyverse)
library(cowplot)
library(ggplot2)
library(dashTable)
library(plotly)


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
  value = levels(df$site), #Selects all by default
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
  value = levels(df$variety), #Selects all by default
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


app$layout(
  htmlDiv(
    list(
      htmlH1('My app'),
      htmlH2('Looking at yield data interactively'),
      #selection components
      htmlLabel('Select a year range:'),
      yearSlider,
      htmlIframe(height=10, width=10, style=list(borderWidth = 2)), #space
      htmlLabel('Select a site:'),
      siteDropdown,
      htmlLabel('Select a variety:'),
      varietyDropdown,
      #graph and table
      variety_graph, 
      htmlIframe(height=20, width=10, style=list(borderWidth = 2)), #space
      site_graph,
      htmlIframe(height=20, width=10, style=list(borderWidth = 2)), #space
      heat_map_graph,
      htmlIframe(height=20, width=10, style=list(borderWidth = 3)), #space
      dccMarkdown("[Data Source](https://cran.r-project.org/web/packages/gapminder/README.html)")
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

app$run_server()




