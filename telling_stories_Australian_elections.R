
#Plan
#Simulate
#Acquire
#Explore
#Share

#### Preamble ####
# Purpose: Read in data from the 2022 Australian Election and make
# a graph of the number of seats each party won.
# Author: Bryce Watson
# Date: 8/2/2024
# Prerequisites: Know where to get Australian elections data.

library("janitor")
library("knitr")
library("lubridate")
library("opendatatoronto")
library("tidyverse")

sim_data <- tibble(
  # Use 1 through 151 to represent each division.
  "Division" = 1:151,
  # Randomly pick an option, with replacement, 151 times
  "Party" = sample(
    x = c("Liberal","Labor", "National", "Other"),
    size =151,
    replace = TRUE
  )
)

sim_data

### Read in the data ###
raw_elections_data <- read_csv(
  file = "https://results.aec.gov.au/27966/website/Downloads/HouseMembersElectedDownload-27966.csv",
  show_col_types = FALSE,
  skip = 1
)

# We have read the data from the AEC website. We may like to save
# it in case something happens or they move it.
write_csv(
  x = raw_elections_data,
  file = "australian_voting.csv"
)

#### Basic cleaning ####
raw_elections_data <-
  read_csv(
    file = "australian_voting.csv",
    show_col_types = FALSE
  )
# Make the names easier to type
cleaned_elections_data <-
  clean_names(raw_elections_data)

# Have a look at the first six rows
head(cleaned_elections_data)

# Select division and party name
cleaned_elections_data <-
  cleaned_elections_data |>
  select(
    division_nm,
    party_nm
  )

head(cleaned_elections_data)

# Rename variables
cleaned_elections_data <-
  cleaned_elections_data |>
  rename(
    division = division_nm,
    elected_party = party_nm
  )

# Simplify names
cleaned_elections_data <-
  cleaned_elections_data |>
  mutate(
    elected_party =
      case_match(
        elected_party,
        "Australian Labor Party" ~ "Labor",
        "Liberal National Party of Queensland" ~ "Liberal",
        "Liberal" ~ "Liberal",
        "The Nationals" ~ "Nationals",
        "The Greens" ~ "Greens",
        "Independent" ~ "Other",
        "Katter's Australian Party (KAP)" ~ "Other",
        "Centre Alliance" ~ "Other"
      )
  )

head(cleaned_elections_data)

# Write cleaned dataset
write_csv(
  x = cleaned_elections_data,
  file = "cleaned_elections_data.csv"
)

#### Read in the data ####
cleaned_elections_data <-
  read_csv(
    file = "cleaned_elections_data.csv",
    show_col_types = FALSE
  )

cleaned_elections_data |>
  count(elected_party)

# Build graph
cleaned_elections_data |>
  ggplot(aes(x = elected_party)) + # aes abbreviates "aesthetics" 
  geom_bar()

cleaned_elections_data |>
  ggplot(aes(x = elected_party)) +
  geom_bar() +
  theme_minimal() + # Make the theme neater
  labs(x = "Party", y = "Number of seats") # Make labels more meaningful
