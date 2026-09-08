rm(list = ls()) # Remove all stuff in Environment

start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")





# set working dirctory
# setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

source("init_v0.6.R")





# list files in folder
input_path <- paste0(paths$scraper_data,"/2023-02-17_Instaloader_Download_scr - Bilder_Kleiner&weniger")
cat("Take data from: \n", input_path)

files <- list.files(
  input_path,
  pattern = ".jpg",
  full.names = TRUE)


# build jpg_id List
name_files <- data.frame(files) %>% 
  mutate(jpg_id = str_extract(files, "[[:alnum:]_.-]+$")) %>% 
  mutate(image_id = str_extract(jpg_id, "(?<=_)\\d+_\\d+_\\d+"),
         acc = str_extract(jpg_id, "[\\w@\\-\\.+_]+(?=_\\d+_\\d+_\\d+)"),
         post_id = str_extract(jpg_id, "(?<=_n_)[[:graph:]]+(?=.jpg)")) %>% #NOTZE 230217: Changed this from "(?<=_n_)[[:graph:]]+(?=-2.jpg)"
  select(file_path = files,
         jpg_id,
         acc,
         image_id,
         post_id)


# Write csv
output_path <- paste0(paths$data_interim, "/")


write.csv2(name_files,
           file = paste0(output_path,
                         Sys.Date(), 
                         "_bd_filtered_jpg_names_for_sosci_geolocation", 
                         ".csv"), 
           na = "NULL", 
           row.names = FALSE,
           fileEncoding = "UTF-8") 




# last message
cat("Everything Done. Find Data here: \n", output_path)










# end this shit
end_time <- Sys.time()
cat("End Script:", format(Sys.time(), "%H:%M:%S"), "\n", 
    "Differenz: ", difftime(end_time, start_time, units = "min"), "min.", "\n") 
                 