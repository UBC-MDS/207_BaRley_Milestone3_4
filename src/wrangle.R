
library(readr)
library(tibble)
library(purrr)

df <- read_csv("../data/barley.csv")

all_sites <- unique(df$site)
all_varieties <- unique(df$variety)
