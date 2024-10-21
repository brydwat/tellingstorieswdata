#### Preamble ####
# Purpose: Get data on 2021 shelter usage and make table
# Author: Rohan Alexander
# Email: rohan.alexander@utoronto.ca
# Date: 1 July 2022
# Prerequisites: -

#### Workspace setup ####
install.packages("opendatatoronto")
install.packages("knitr")

library(knitr)
library(janitor)
library(lubridate)
library(opendatatoronto)
library(tidyverse)

set.seed(853)

simulated_occupancy_data <-
  tibble(
    date = rep(x = as.Date("2021-01-01") + c(0:364), times=3),
    # Based on Eddelbuettel:https://stackoverflow.com/a/21502386
    shelter = c(
      rep(x = "Shelter 1", times = 365),
      rep(x = "Shelter 2", times = 365),
      rep(x = "Shelter 3", times = 365)
    ),
    number_occupied =
      rpois(
        n = 365 * 3,
        lambda = 30
      ) # Draw 1095 times from the Poisson distribution
  )

head(simulated_occupancy_data)

#### Acquire ####
toronto_shelters <-
  # Each package is associated with a unique id  found in the "For 
  # Developers" tab of the relevant page from Open Data Toronto
  # https://open.toronto.ca/dataset/daily-shelter-overnight-service-occupancy-capacity/
  list_package_resources("21c83b32-d5a8-4106-a54f-010dbe49f6f2") |>
  # Within that package, we are interested in the 2021 dataset
  filter(name == 
           "daily-shelter-overnight-service-occupancy-capacity-2021.csv") |>
  # Having reduced the dataset to one row we can get the resource
  get_resource()

write_csv(
  x = toronto_shelters,
  file = "toronto_shelters.csv"
)

head(toronto_shelters)

toronto_shelters_clean <- 
  clean_names(toronto_shelters) |>
  mutate(occupancy_date = ymd(occupancy_date)) |>
  select(occupancy_date, occupied_beds)

head(toronto_shelters_clean)

write_csv(
  x = toronto_shelters_clean,
  file = "cleaned_toronto_shelters.csv"
)

#### Explore ####
toronto_shelters_clean <-
  read_csv(
    "cleaned_toronto_shelters.csv",
    show_col_types = FALSE
  )
