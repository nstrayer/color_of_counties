#Let's scrape some photos for the counties using the google places api
library(jsonlite)
library(nmisc)
library(dplyr)
library(readr)

get_place_id <- function(county, state){
  #construct api query
  base_url <- "https://maps.googleapis.com/maps/api/place/textsearch/json?query="
  search   <- gsub(" ", "+", paste(county, "county", state, sep = "+"))
  end_url  <- "&key=AIzaSyBg7LRVJCeoh-vWSPZFDiOJppxzGA7njYA"
  query    <- paste0(base_url, search, end_url)
  res      <- fromJSON(query)
  place_id <- res$results$place_id[1] #sometimes returns more than one. 
  return(place_id)
}

get_photos_list <- function(place_id){
  base_url <- "https://maps.googleapis.com/maps/api/place/details/json?placeid="
  end_url  <- "&key=AIzaSyBg7LRVJCeoh-vWSPZFDiOJppxzGA7njYA"
  query    <- paste0(base_url, place_id, end_url)
  res      <- fromJSON(query)
  photo_references <- res$result$photos$photo_reference
  return(photo_references)
}

references <- photo_references
get_photo <- function(reference, destination){
  base_url <- "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference="
  end_url  <- "&key=AIzaSyBg7LRVJCeoh-vWSPZFDiOJppxzGA7njYA"
  query    <- paste0(base_url, reference, end_url)
  
  download.file(query, destination)
}

download_photos <- function(photo_references, directory){

    for(i in 1:length(photo_references)){
      destination <- paste0(directory, "/", "photo", i, ".jpeg") #figure out where we're putting photo
      print(destination)
      
      tryCatch(get_photo(photo_references[i], destination), #download photo,
               warning = function(w) {print(directory)},
               error = function(e) {print(directory)})
    }
  
}

setwd("/Users/Nick/dev/us-of-color")
all_counties <- read_csv("united-states-counties.csv", col_names = F) %>% 
  rename(county = X1, state = X2)

setwd("photos")
for (i in 318:dim(all_counties)[1]){ #died at dc once. let's not repeat ourselves. 
  county <- all_counties[i, "county"]
  state  <- all_counties[i, "state"]
  print(paste(county, state))

  #get place id
  place_id <- get_place_id(county, state)
  
  #get list of photos
  photo_list <- get_photos_list(place_id)
  
  #make a directory for this county's photos
  directory_name <- paste(gsub(" ", "-", county), gsub(" ", "-", state), sep = "_") #state is seperate from county with "_"
  dir.create(directory_name)
  
  #download all the photos into this directory
  download_photos(photo_list, directory_name)
}

convert out.jpeg  -format %c -depth 8  histogram:info:histogram_image.txt
sort -n histogram_image.txt | tail -1wa