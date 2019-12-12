library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(tidyverse)
library(cowplot)
library(ggplot2)
# library(dashTable)
library(plotly)
# library(albersusa)
# library(lattice)
library(usmap)

source("charts.R")
source("components.R")

app <- Dash$new(external_stylesheets = "https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css",
                external_scripts="https://code.jquery.com/jquery-3.4.1.slim.min.js")

jumbotron <- htmlDiv(
                htmlCenter(htmlH1("BaRley App"))
            )

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

content <- htmlDiv(
    list(
        htmlH5("Have some information about the barley yield in an interactive way!", class="card-header"),
        htmlDiv(
            list(
                htmlH5("Description", class="card-title"),
                htmlDiv(
                    list(
                        htmlP("Barley is part of the major cereal grains used worldwide. Understanding how the annual yield of barley is impacted by the variety or site on which it grows is very important. This dashboard has been created to allow you to explore a dataset containing the annual yield for selected varieties of barley and particular sites, for the years 1931, 1932, or both. It should help you better understand what variety or what site is the most suitable to your situation. If you are wondering:"),
                        htmlP('-Given some sites and some varieties, what variety of barley had the highest yield during a specific year?'),
                        htmlP('-Given some sites and some varieties, what site had the highest yield during a specific year?'),
                        htmlP('-Given some sites and some varieties, what is the variety of barley with the highest yield for each of the sites?'),
                        htmlP('Then this app is exactly what you need! Now, you have no excuse to increase your productivity and have the highest yield as possible! '),
                        htmlP('Trick : Place your mouse above the different bars to display more information!')
                    ),
                    class="card-text"
                )
            ),
            class="card-body"
        )
    ),
    class="card"
)

app$layout(
        htmlDiv(
            jumbotron,
            class="jumbotron"
        ),
        htmlDiv(
            list(
                # Row 0
                content,
                htmlBr(),
                htmlBr(),

                # Row 1
                htmlDiv(                    
                    list(
                        htmlDiv(
                            list(
                                htmlLabel("Year:"),
                                yearSlider,
                                htmlBr(),
                                htmlLabel('Site:'),
                                siteDropdown,
                                htmlBr(),
                                htmlLabel("Variety:"),
                                varietyDropdown
                            ),
                        class="col"
                        ),
                        htmlDiv(
                            list(
                                htmlP("")
                            ),
                            class="col"
                        ),
                        htmlDiv(
                            list(
                                map_graph
                            ),
                            class="col"
                        )
                    ),
                    class="row"
                ),
                htmlBr(),
                htmlBr(),

                # Row 2
                htmlDiv(
                    list(
                        htmlDiv(
                        list(
                            #htmlLabel('Site:'),
                            #siteDropdown
                        ),
                        class="col"
                        ),
                        htmlDiv(
                            list(
                                # htmlLabel("Variety:"),
                                # varietyDropdown
                            ),
                            class="col"
                        )
                    ),
                    class="row"
                ),
                htmlBr(),
                htmlHr(),
                htmlBr(),
                # Row 3
                htmlDiv(
                    list(
                        htmlDiv(
                            list(
                                htmlDiv(
                                    htmlCenter(htmlH3("Yield per Variety"))
                                ),
                                variety_graph
                            ),
                            class="col"
                        ),
                        htmlDiv(
                            list(
                                htmlDiv(
                                    htmlCenter(htmlH3("Yield per Site"))
                                ),
                                site_graph
                            ),
                            class="col"
                        )
                    ),
                    class="row"
                ),
                htmlBr(),
                htmlBr(),
                # Row 4
                htmlDiv(
                    list(
                        htmlDiv(
                            list(
                                htmlDiv(
                                    htmlCenter(htmlH3("Heatmap showing the yield per variety and per site"))
                                ),                                             
                                heat_map_graph
                            ),              
                            class="col"
                        )
                    ),
                    class="row"
                ),

                # Row 4
                htmlDiv(
                    list(
                        # map_graph
                    ),
                    class="row"
                )

            ),
            class="container"
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
