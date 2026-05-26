# Setup ####

## load packages ####
library(tidyverse)

## import data ####

# data source: https://doi.org/10.4232/1.14773
# you need create a GESIS account and download the data
accounts <- read_csv("./data/ZA9076_v1-1-0.csv") # you probably have to adjust the path here

## check data ####

names(accounts)

glimpse(accounts)

table(accounts$party)

# create vector with names of parties to include in the account selection
parties <- c("CDU", "SPD", "GRÜNE", "FDP", "DIE LINKE")

# Bluesky ####

bluesky_accounts <- accounts %>%
  filter(party %in% parties) %>% # only include candidates from the selected parties
  filter(!is.na(BS_url_1)) # only include candidates with a Bluesky account

nrow(bluesky_accounts)

bluesky_accounts %>% 
  select(party, state,
         first_name, last_name,
         BS_url_1) %>% 
  arrange(party, last_name) %>%
  View()

# if we look at the data, we can manually select a subset of accounts to collect data from

# if you want to sample a subset of accounts from the selected parties, you can do so as follows:
sampled_bluesky_accounts <- bluesky_accounts %>%
  group_by(party) %>% 
  sample_n(5) %>% # sample 5 accounts per party
  ungroup() %>% 
  mutate(BS_handle =  str_extract(BS_url_1,
                                  "(?<=profile/)[^/]+$")) %>% # extract the Bluesky handle from the URL
  pull(BS_handle) # extract the Bluesky handles into a vector


# TikTok ####

tiktok_accounts <- accounts %>%
  filter(party %in% parties) %>% # only include candidates from the selected parties
  filter(!is.na(TT_url_1)) # only include candidates with a TikTok account

nrow(tiktok_accounts)

tiktok_accounts %>% 
  select(party, state,
         first_name, last_name,
         TT_url_1) %>% 
  arrange(party, last_name) %>%
  View()

# if we look at the data, we can manually select a subset of accounts to collect data from

# if you want to sample a subset of accounts from the selected parties, you can do so as follows:
sampled_tiktok_accounts <- tiktok_accounts %>%
  group_by(party) %>%
  sample_n(5) %>% # sample 5 accounts per party
  ungroup() %>%
  mutate(TT_handle =  str_extract(TT_url_1,
                                  "(?<=@)[^/]+$")) %>% # extract the TikTok handle from the URL
  pull(TT_handle) # extract the TikTok handles into a vector

sampled_tiktok_accounts
