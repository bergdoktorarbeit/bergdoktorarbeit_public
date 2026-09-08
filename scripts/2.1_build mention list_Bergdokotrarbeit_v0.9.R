rm(list = ls()) # Remove all stuff in Environment

start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")

# set working dirctory
setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

source("scripts/init_v0.6.R")





# Get data
xlsx_meta_raw <- read.xlsx(paste0(paths$ctdata, "/Input/Accounts - Art.xlsx"), 
                          startRow = 1,
                          check.names = FALSE)

csv_ment_raw <- read.csv(paste0(paths$ctdata,"/Ouput/WK BD Data/bd_combined_ment_list_interim.csv"), 
                    stringsAsFactors = FALSE,
                    sep = ";",
                    encoding="UTF-8")


#build tables
meta_raw <- xlsx_meta_raw %>% 
  select(user_name = User.Name, Art)

ment_raw <- csv_ment_raw %>% 
  select(user_name = mentions, ment_num) %>% 
  mutate(user_name = str_sub(user_name, 2))


#combine art and mention
df_bd_ment_art <- ment_raw %>% 
  left_join(meta_raw, by = "user_name") %>% 
  distinct(user_name, .keep_all = TRUE)


output_path <- paste0(paths$ctdata, "/Input/")

#save data
write.xlsx(df_bd_ment_art,
           file = paste0(output_path, Sys.Date(),"_Mentions - Art.xlsx"),
           keepNA = TRUE)

# End message    
cat(paste0("Everything done. \nData saved at ", output_path))




# end this shit
end_time <- Sys.time()
cat("End Script:", format(Sys.time(), "%H:%M:%S"), "\n", 
    "Differenz: ", difftime(end_time, start_time, units = "min"), "min.", "\n") 



