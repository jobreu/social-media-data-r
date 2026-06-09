# Setup ####

## Load packages ####
library(tidyverse)
library(atrrr)
library(vosonSML)

## Authentication ####

### Bluesky ####
auth("your_user_name") # eigenen User Name hier einfügen (z.B., tmueller.bsky.social)
# weitere Infos: https://jobreu.github.io/social-media-data-r/10-bluesky-collection.html#authentifizierung
# und: https://jbgruber.github.io/atrrr/articles/Basic_Usage.html#authentication


### YouTube ####
auth_yt <- Authenticate("youtube",
                        apiKey = "your_api_key_here") # eigenen API Key hier einfügen

# weitere Infos: https://jobreu.github.io/social-media-data-r/12-youtube-collection.html#authentifizierung
# und: https://vosonlab.github.io/vosonSML/articles/Intro-to-vosonSML.html#authenticating-with-the-youtube-api

## Accounts & videos ###
# Bluesky: siehe https://jobreu.github.io/social-media-data-r/10-bluesky-collection.html#daten-sammeln
# Beispiel-Skript: get_accounts-R im scripts-Ordner
# YouTube: siehe https://jobreu.github.io/social-media-data-r/12-youtube-collection.html#kommentare-zu-videos

### Bluesky-Accounts ####
# Quelle: https://doi.org/10.4232/1.14773

bs_accounts <- c("serapgueler.bsky.social", "nroettgen.bsky.social",
                 "larsklingbeil.bsky.social", "svenjaschulze.bsky.social",
                 "katharinadroege.bsky.social", "nouripour.bsky.social",
                 "heidireichinnek.dielinkebt.de", "janvanaken.dielinkebt.de",
                 "christianduerr.bsky.social")

### YouTube Video URLs ####

# Bluesky-Posts ####
# siehe https://jobreu.github.io/social-media-data-r/10-bluesky-collection.html#posts

bs_posts <- map_df(bs_accounts,
                   ~get_skeets_authored_by(actor = .x,
                                           limit = 1000, 
                                           parse = TRUE))

## Daten speichern ####
write_csv(bs_posts, "./data/bluesky_data.csv") # ggf. Dateipfad anpassen

# YouTube-Kommentare ####
# siehe https://jobreu.github.io/social-media-data-r/12-youtube-collection.html#kommentare-zu-videos

# Quelle: Websuche auf YouTube zum Thema "Bundestagswahl 2025" + manueller Check: Kommentare vorhanden
video_urls <- c("https://www.youtube.com/watch?v=5A-ggbcnwcg",
                "https://www.youtube.com/watch?v=a6ZaJ38cy7U",
                "https://www.youtube.com/watch?v=Mp5sWuWQlM0")

comments_yt <- auth_yt %>%
  Collect(videoIDs = video_urls,
          maxComments = 2000)

## Daten speichern ####
write_csv(comments_yt, "./data/youtube_data.csv") # ggf. Dateipfad anpassen