rm(list = ls()) # Remove all stuff in Environment

start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")




# set working dirctory
# setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

source("init_v0.6.R")


# Set Winput path
download_ordner <- "2023-02-17_Instaloader_Download_scr"

input_path <- paste0(paths$data_raw, 
             "/data/Scraper 2 Datas/", 
             download_ordner)



# Get Data
files_all <- list.files(
  input_path,
  full.names = TRUE)


json_files <- files_all[grepl(".json", files_all)]

jpg_files <- files_all[grepl(".jpg", files_all)]



# Build Jpg File Table
df_jpg_files_raw <- as.data.frame(jpg_files) %>% 
  select(jpg_filepath = jpg_files) %>%  
  mutate(jpg_id = str_extract(jpg_filepath, "(?<=Download_scr/).+")) %>%
  mutate(jpg_id = gsub(".jpg", "", jpg_id)) %>% 
  mutate(image_id = str_extract(jpg_id, "(?<=_)\\d+_\\d+_\\d+"),
         acc = str_extract(jpg_id, "[\\w@\\-\\.+_]+(?=_\\d+_\\d+_\\d+)"),
         post_id = str_extract(jpg_id, "(?<=_n_)[[:graph:]]+$")) %>%
  select(jpg_filepath,
         jpg_id,
         image_id,
         post_id,
         acc)



# Build Json File Table
df_json_files_raw <- as.data.frame(json_files) %>% 
  select(json_filepath = json_files) %>%  
  mutate(json_id = str_extract(json_filepath, "(?<=Download_scr/).+")) %>%
  mutate(json_id = gsub(".json", "", json_id)) %>% 
  mutate(image_id = str_extract(json_id, "(?<=_)\\d+_\\d+_\\d+"),
         acc = str_extract(json_id, "[\\w@\\-\\.+_]+(?=_\\d+_\\d+_\\d+)"),
         post_id = str_extract(json_id, "(?<=_n_)[[:graph:]]+$")) %>%
  select(json_filepath,
         json_id,
         image_id,
         post_id,
         acc)



# LOOP: Extract Data from Json and build table
  df_json_post_raw <- tibble()
  
  for (json_files_temp in json_files) {
    #json_files_temp <- json_files[1] #to test it without loop
    
    
    # Extract from JSON
    json_raw <- fromJSON(file=json_files_temp)
  
    # Post
      accessibility_caption <- json_raw[["node"]][["accessibility_caption"]]
      img_url <- json_raw[["node"]][["display_url"]]
      post_id<- json_raw[["node"]][["shortcode"]]
      post_id2 <- json_raw[["node"]][["id"]]
      post_id3 <- json_raw[["node"]][["iphone_struct"]][["id"]]
      
    # Location
      loc_lat <- json_raw[["node"]][["iphone_struct"]][["location"]][["lat"]]
      loc_lng <- json_raw[["node"]][["iphone_struct"]][["location"]][["lng"]]
      loc_name_long <- json_raw[["node"]][["iphone_struct"]][["location"]][["name"]]
      loc_name_short <- json_raw[["node"]][["iphone_struct"]][["location"]][["short_name"]]
  
    # Owner
      owner_id <- json_raw[["node"]][["owner"]][["id"]]
      owner_username <- json_raw[["node"]][["owner"]][["username"]]
      owner_fullname <- json_raw[["node"]][["owner"]][["full_name"]]
      owner_location <- json_raw[["node"]][["location"]][["address_json"]]
        
      
      
      
    # Build Table    
        
    #df_post <- tibble()
    
    
      df_post_temp <- tibble(accessibility_caption,
                             img_url,
                             post_id,
                             post_id2,
                             post_id3,
                             loc_lat,
                             loc_lng,
                             loc_name_long,
                             loc_name_short,
                             owner_id,
                             owner_username,
                             owner_fullname,
                             owner_location)
      
      
      df_json_post_raw <- bind_rows(df_json_post_raw, df_post_temp)
  
  }
  
  
  
rm(json_raw,
   df_post_temp)


# clean table
df_json_post <- df_json_post_raw %>% 
  select(user_name = owner_username,
         post_id,
         loc_owner = owner_location,
         loc_lat,
         loc_lng,
         loc_name_long,
         loc_name_short,
         img_url,
         accessibility_caption) %>% 
  mutate(loc_owner = str_replace_all(loc_owner, c("\\\\u00fc" = "ü", "\\\\u00E4" = "ä","\\\\u00f6" = "ö"))) %>% 
  mutate(loc_owner_address = str_extract(loc_owner, "(?<=street_address[[:punct:][:blank:]]{4})[\\w[:blank:]]+(?=[[:punct:][:blank:]]{4}zip)"),
         loc_owner_zip = str_extract(loc_owner, "(?<=zip_code[[:punct:][:blank:]]{4})[:digit:]+"),
         loc_owner_city = str_extract(loc_owner, "(?<=city_name[[:punct:][:blank:]]{4})[\\w[:blank:]]+(?=[[:punct:][:blank:]]{4}reg)"),
         loc_owner_region = str_extract(loc_owner, "(?<=region_name[[:punct:][:blank:]]{4})[\\w[:blank:]]+(?=[[:punct:][:blank:]]{4}cou)"),
         loc_owner_country_code = str_extract(loc_owner, "(?<=country_code[[:punct:][:blank:]]{4})\\w+"),
         loc_owner_ex_city = str_extract(loc_owner, "(?<=exact_city_match[[:punct:][:blank:]]{4})\\w+"),
         loc_owner_ex_region = str_extract(loc_owner, "(?<=xact_region_match[[:punct:][:blank:]]{4})\\w+"),
         loc_owner_ex_country = str_extract(loc_owner, "(?<=exact_country_match[[:punct:][:blank:]]{4})\\w+"),
         image_id = str_extract(img_url, "\\d+_\\d+_\\d+(?=_n.jpg)")) %>% 
  left_join(df_json_files_raw %>% select(post_id, json_filepath), by = "post_id") %>% 
  left_join(df_jpg_files_raw %>% select(post_id, jpg_filepath), by = "post_id") %>% 
  select(user_name,
         post_id,
         image_id,
         image_url = img_url,
         json_filepath,
         jpg_filepath,
         image_access_text = accessibility_caption,
         loc_name_long,
         loc_name_short,
         loc_name_adress = loc_owner_address,
         loc_zip = loc_owner_zip,
         loc_city = loc_owner_city,
         loc_region = loc_owner_region,
         loc_country_code = loc_owner_country_code,
         #loc_owner_ex_city,
         #loc_owner_ex_region, #NOTE DB: Alles leere Spalten
         #loc_owner_ex_country,
         loc_lat,
         loc_lng) %>% 
  arrange(post_id)

# rename dataframes because of binding with other dfs
  df_jpg_files_raw_scr <- df_jpg_files_raw
  df_json_files_raw_scr <- df_json_files_raw
  df_json_post_scr <- df_json_post
  
  
  rm(df_json_post_raw,
     df_jpg_files_raw,
     df_json_files_raw,
     df_json_post)



# bind data from desti and production

  # source 2.3.2 Script
  source("2.3.2_Extract JSON_des+pro.R")
  
  
  # bind rows
  df_jpg_files_raw <- df_jpg_files_raw_scr %>% 
    bind_rows(df_jpg_files_raw_des_pro)
  
  df_json_post <- df_json_post_scr %>% 
    bind_rows(df_json_post_des_pro)
  
  

#save as csv
  output_path <- paste0(paths$data_processed, "/")    
  
  write.csv2(df_jpg_files_raw,
             file = paste0(output_path, Sys.Date(),"_bd_scraper-some_jpg_files", ".csv"), 
             na = "NULL", 
             row.names = FALSE,
             fileEncoding = "UTF-8")
  
  # write.csv2(df_json_files_raw,
  #            file = paste0(output_path, "bd_filtered_json_files.csv"), 
  #            na = "NULL", 
  #            row.names = FALSE,
  #            fileEncoding = "UTF-8")
  
  write.csv2(df_json_post,
             file = paste0(output_path, Sys.Date(), "_bd_scraper-some_json_geotag", ".csv"), 
             na = "NULL", 
             row.names = FALSE,
             fileEncoding = "UTF-8") 
  
  
  
  
  
print(paste0("Everything Done. Find Data here: ", output_path))









# end this shit
end_time <- Sys.time()
cat("End Script:", format(Sys.time(), "%H:%M:%S"), "\n", 
    "Differenz: ", difftime(end_time, start_time, units = "min"), "min.", "\n") 






