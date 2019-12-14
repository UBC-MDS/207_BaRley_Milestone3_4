# source("wrangle.R")
# yearMarks <- map(unique(df$year), as.character)
# names(yearMarks) <- unique(df$year)
# yearSlider <- dccRangeSlider(
#   id = "year",
#   marks = yearMarks,
#   min = 1931,
#   max = 1932,
#   step = 1,
#   value = list(1931, 1932)
# )

# siteDropdown <- dccDropdown(
#   id = "site",
#   # map/lapply can be used as a shortcut instead of writing the whole list
#   # especially useful if you wanted to filter by country!
#   options = map(
#     unique(df$site), function(x){
#       list(label=x, value=x)
#     }),
#   value = levels(as.factor(df$site)), #Selects all by default
#   multi = TRUE
# )

# varietyDropdown <- dccDropdown(
#   id = "variety",
#   # map/lapply can be used as a shortcut instead of writing the whole list
#   # especially useful if you wanted to filter by country!
#   options = map(
#     unique(df$variety), function(x){
#       list(label=x, value=x)
#     }),
#   value = levels(as.factor(df$variety)), #Selects all by default
#   multi = TRUE
# )

