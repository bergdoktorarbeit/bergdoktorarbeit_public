rm(list = ls()) # Remove all stuff in Environment

start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")






# set working dirctory
# setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

source("init_v0.6.R")



# Get data
csv_meta_raw <- read.csv(paste0(paths$ctdata, 
                                "/Ouput/WK BD Data",
                                "/bd_combined_meta_interim.csv"), 
                    stringsAsFactors = FALSE,
                    sep = ";",
                    encoding="UTF-8")

xlsx_art_raw <- read.xlsx(paste0(paths$ctdata, 
                                 "/Input/", 
                                 "Accounts - Art.xlsx"), 
                           startRow = 1,
                           check.names = FALSE)


#build art_raw table
# art_raw <- xlsx_art_raw %>% #NOTE 230217: old code 
#   select(user_name = User.Name, 
#          Art) %>% 
#   filter(Art %in% c("Produktion", "Screentourist", "Destination")) %>% 
#   select(user_name)

art_scr_raw <- xlsx_art_raw %>% #NOTE 230217: New code because I forgot the screentourists
  select(user_name = User.Name, 
         Art) %>% 
  filter(Art == "Screentourist") %>% 
  select(user_name)


#filter meta_raw with art_raw table
# csv_meta_raw <- art_raw %>% #NOTE 230217: old code
#   left_join(csv_meta_raw, by = "user_name")

csv_meta_raw <- art_scr_raw %>% #NOTE 230217: New code because I forgot the screentourists
  left_join(csv_meta_raw, by = "user_name")


#build post_code list
post_code_list <- csv_meta_raw %>% 
  select(post_id) %>%
  mutate(post_id = paste0(" -", post_id)) %>% 
  summarise(post_id = paste(post_id, collapse = ""))

  
#make instaloader start_code
instaloader <- "instaloader"
login <- " --login=bocher_daniel"
save_pattern <- paste0(" --dirname-pattern=", Sys.Date(), "_Instaloader_Download --filename-pattern={profile}_{filename}_{shortcode}")
filter <- "--post-filter=\"not is_video\"" #NOTE: Not used at the moment 
format <- " --no-compress-json --no-captions --"
instaloader_start_code <- paste0(instaloader, login, save_pattern, format)


#Combine instaloader code for download
instaloader_code <- paste0(instaloader_start_code, post_code_list)


output_path <- paste0(paths$data_interim)

#save data as csv
write.csv(instaloader_code, file = paste0(output_path, 
                                          Sys.Date(),
                                          "_Instaloader_Code.csv"))




# save message
cat("Data saved in: ", output_path,  "\n")








# end this shit
end_time <- Sys.time()
cat("End Script:", format(Sys.time(), "%H:%M:%S"), "\n", 
    "Differenz: ", difftime(end_time, start_time, units = "min"), "min.", "\n") 



