


####################################
### Loading librarys for scripts ###
####################################

#tidyverse
library(tidyverse)
library(dplyr)
library(tibble)
library(stringr)
library(tidyr)

#others
library(httr)
library(jsonlite)
library(rjson)
library(reshape)
library(openxlsx)
library(stringi)
library(lubridate) #QUEST: Do I need this?
library(utils)
# Script 2.4
library(textclean) # https://cran.r-project.org/web/packages/textclean/readme/README.htmlcollap
library(janitor)
# Script 5.1
library(tidycomm) # http://127.0.0.1:26402/session/Rvig.1f586b0c5085.html
# script 5.2
library(quanteda) # http://127.0.0.1:31088/library/quanteda/doc/quickstart.html 
                  # Alternativ (oder ergänzend) zur manuellen Inhaltsanalyse lassen sich einige Aspekte auch automatisieren.
                  # Dafür nutzen wir das großartige quanteda-Package (das für QUantitative ANalysis of TExtual DAta steht).
library(quanteda.textplots) # https://github.com/quanteda/quanteda.textplots
#library(quanteda.textstats) # Do I need this (Its recomended!)?
#library(quanteda.textmodels) # Do I need this (Its recomended!)?
# for vector stuff
library(pracma)
# plots
library(ggplot2)
library(plotly)
# clean Text function
library(tm)




########################################
### source function in extra scripts ###
########################################


# source functions
source("vector_functions.R")
source("col_name_function.R")
source("clean_text_function.R")
source("sheet_col_function.R")




########################################
### Define arguments ambigious names ###
########################################

GET <- httr::GET
from_json <- jsonlite::fromJSON
rename <- dplyr::rename





#################################
### Get the paths to the data ###
#################################

# define path segments
hard_drive <- "C:"
windows_user <- paste0("/Users/", Sys.getenv("USERNAME"))
git_mirror_path <- "/ZDF/TechnologyZDFD - Dokumente/04_analytics/git-repos-data-mirror"
git_repo_path <- "/git_repos/bergdoktorarbeit/scripts"
repository <- "/bergdoktorarbeit"
paths <- list()

# build paths
paths$data <- paste0(hard_drive,
                         windows_user,
                         git_mirror_path,
                         repository)

paths$data_raw <- paste0(hard_drive,
                         windows_user,
                         git_mirror_path,
                         repository,
                         "/1_RAW")

paths$data_interim <- paste0(hard_drive,
                         windows_user,
                         git_mirror_path,
                         repository,
                         "/2_INTERIM")

paths$data_processed <- paste0(hard_drive,
                         windows_user,
                         git_mirror_path,
                         repository,
                         "/3_PROCESSED")

paths$scripts <- paste0(hard_drive,
                         git_repo_path)

paths$ctdata <- paste0(hard_drive,
                       windows_user,
                       git_mirror_path,
                       repository,
                       "/1_RAW/data/CT Data")

paths$scraper_data <- paste0(hard_drive,
                       windows_user,
                       git_mirror_path,
                       repository,
                       "/1_RAW/data/Scraper 2 Datas")

paths$interview_data <- paste0(hard_drive,
                             windows_user,
                             git_mirror_path,
                             repository,
                             "/1_RAW/data/Trace Interviews Save Data")

paths$filmgeo_data <- paste0(hard_drive,
                               windows_user,
                               git_mirror_path,
                               repository,
                               "/1_RAW/data/Filmgeographie Daten")






#################################
### Save the Names of folders ###
#################################
#QUEST do I use this?

# Get folder Names
folders <- list()

data_folders <- list.dirs(paths$data, recursive = FALSE)
folders$data <- gsub(paste0(paths$data, "/"), "", data_folders, fixed = TRUE)

raw_folders <- list.dirs(paths$data_raw, recursive = FALSE)
folders$raw <- gsub(paste0(paths$data_raw, "/"), "", raw_folders, fixed = TRUE)

interim_folders <- list.dirs(paths$data_interim, recursive = FALSE)
folders$interim <- gsub(paste0(paths$data_interim, "/"), "", interim_folders, fixed = TRUE)

processed_folders <- list.dirs(paths$data_processed, recursive = FALSE)
folders$processed <- gsub(paste0(paths$data_processed, "/"), "", processed_folders, fixed = TRUE)

scripts_folders <- list.dirs(paths$scripts, recursive = FALSE)
folders$scripts <- gsub(paste0(paths$scripts, "/"), "", scripts_folders, fixed = TRUE)





########################
### Column selection ###
########################

#Important columns (select) for script 2.
select_colum_all <- c("post_index",
                      "downloaded",
                      "acc",
                      "user_name",
                      "user_verified",
                      "post_lang",
                      "foll_at_post",
                      "post_creat_full",
                      "post_type",
                      "post_id",
                      "post_url",
                      "image_url",
                      "image_id",
                      "image_text",
                      "post_descr",
                      "post_descr_short",
                      "like_num",
                      "com_num",
                      "int_num",
                      "view_num",
                      "dif_like_num",
                      "dif_com_num",
                      "expected_like_num",
                      "expected_com_num",
                      "score_num")

select_colum_meta <- c("post_index", 
                       "downloaded",
                       "acc",
                       "user_name",
                       "user_verified",
                       "post_lang",
                       "foll_at_post",
                       "post_creat_full",
                       "post_type",
                       "post_id",
                       "post_url",
                       "image_url",
                       "image_id",
                       "image_text",
                       "post_descr",
                       "post_descr_short")

select_colum_data <- c("post_index",
                       "like_num",
                       "com_num",
                       "int_num",
                       "view_num",
                       "dif_like_num",
                       "dif_com_num",
                       "expected_like_num",
                       "expected_com_num",
                       "score_num")

select_colum_hashtag <- c("post_index",
                          "user_name",
                          "post_descr",
                          #"post_hash_list",
                          "post_hash_string",
                          "post_hash_num",
                          "post_hash_length",                                  
                          "post_descr_length",
                          "post_hash_descr_rate")

select_colum_mention <- c("post_index",
                          "user_name",
                          "post_descr",
                          #"post_ment_list",
                          "post_ment_string",
                          "post_ment_num",
                          "post_ment_length",                                  
                          "post_descr_length",
                          "post_ment_descr_rate")

#select Columns for script 2.2
select_colum_emoji <- c("post_index",
                        "user_name",
                        "post_descr",
                        #"post_emoji_list",
                        "post_emoji_string",
                        "post_emoji_num",
                        "post_emoji_length",                                  
                        "post_descr_length",
                        "post_descr_word_count",
                        #"post_emoji_descr_rate"
                        "post_emoji_word_rate")



select_colum_traceinterview <- c(
  # Demographic questions (DE):
    "DE02_01", "DE03_01", "DE03_02", "DE03_03", "DE03_04", "DE03_05", "DE03_06", "DE03_07", "DE03_08", 
    "DE04_01", "DE05", "DE06", "DE07_01", "DE08", "DE09", "DE12_01", "DE13_01", 
    "DE14", "DE14_01", "DE14_02", "DE14_03", "DE14_04", "DE14_05", 
    "DE14_06", "DE14_07", "DE14_08", "DE14_09a", 
    "DE15_01", "DE15_02", "DE15_03", 
    "DE16", "DE16_01", "DE16_02", "DE16_03", "DE16_04", "DE16_05", "DE16_06", "DE16_07", "DE16_08a", 
    "DE17", "DE21_01", "DE22", "DE23_01", 
  # Basic Questions (EI): 
    "EI01", "EI01_01", "EI01_02", "EI01_03", "EI01_04", "EI01_05", "EI01_06", "EI01_07", 
    "EI01_08", "EI01_09", "EI01_10", "EI01_11", "EI01_12", "EI01_13", "EI01_14", "EI01_15", "EI01_16", 
    "EI02_01", "EI03_01", 
    "EI04_EI09",
    "EI05_01", "EI05_02", "EI05_03", "EI05_04", "EI05_05", "EI05_06", "EI05_07", 
    "EI05_08", "EI05_09", "EI05_10",
    "EI06_EI07",
    "EI08_01_EI10_01", "EI08_02_EI10_02", "EI08_03_EI10_03", "EI08_04_EI10_04",  
    "EI08_05_EI10_05", "EI08_06_EI10_06",
  # Content of the posting questions (IP): 
    "IP01_IP21_IP39", "IP04_IP23_IP40", "IP05_IP24_IP41", "IP06_IP25_IP42", "IP07_IP26_IP43", 
    "IP08_IP45", 
    "IP11_IP30_IP47", "IP12_IP31_IP48", 
    "IP13_IP49", 
    "IP14_52_54_56_58", #filter: insta linked watch?
    "IP17_IP20_IP38", # filter: my posting?
    "IP27_IP44", "IP32_IP50", 
    "IP35_IP59_m", "IP35_IP59_m_pts", "IP35_IP59_m_rgs", # Geoloc motive 
    "IP35_IP59_f", "IP35_IP59_f_pts", "IP35_IP59_f_rgs", # Geoloc photographer 
  # Questions to tourismm(IT): 
    "IT01_01", "IT01_02", "IT01_03", "IT01_04", "IT01_05", "IT01_06", 
    "IT02_01", "IT02_02", "IT02_03", 
    "IT03_01", "IT03_02", "IT03_03", "IT03_04", 
    "IT04", "IT05_01", "IT05_02", "IT06_01", "IT07", 
    "IT08_01", "IT08_02", "IT08_03", "IT08_04", "IT08_05", "IT08_06", "IT08_07", "IT08_08", 
    "IT08_09", "IT08_10", "IT08_11",
    "IT09",
    "IT10_01", "IT10_02", "IT10_03", "IT10_04", "IT10_05", "IT10_06", "IT10_07", 
    "IT15_01", "IT15_02", "IT15_03", "IT15_04", "IT15_05", "IT15_06", "IT15_07", 
    "IT13", "IT14", "IT16", "IT17", "IT18_01",
    "IT19_01", "IT19_02", "IT19_03", "IT19_04", "IT19_05", "IT19_06", 
    "IT20", "IT20_01", "IT20_02", "IT20_03", "IT20_04", 
    "IT21_01", "IT21_02", "IT22_01", 
    "IT24_01_IT33_01", "IT24_02_IT33_02", "IT24_03_IT33_03",  
    "IT24_04_IT33_04", "IT24_05_IT33_05", "IT24_06_IT33_06", "IT24_07_IT33_07",
    "IT25_01", "IT25_02", "IT25_03", "IT25_04", "IT25_05", "IT25_06", "IT25_07",
    "IT26_IT31",
    "IT27_01", "IT27_02", "IT27_03", "IT27_04", 
    "IT28_01", "IT29_01", 
    "IT30_01", "IT30_02", "IT30_03", "IT30_04", "IT30_05", "IT30_06", "IT30_07",
  # interview meta: 
    "QUESTNNR", "STARTED" , "TIME_SUM", "MAILSENT", "LASTDATA", "FINISHED", "Q_VIEWER", 
    "LASTPAGE", "MAXPAGE", "MISSING", "MISSREL", "TIME_RSI", "DEG_TIME"
)



# define delet coloumns
delet_traceinterview_standart_rows <- c("CASE", "MODE", "SERIAL", "REF", "QUESTNNR", "STARTED",
                                         "TIME_SUM", "MAILSENT", "LASTDATA", "FINISHED", "Q_VIEWER", 
                                         "LASTPAGE", "MAXPAGE", "MISSING", "MISSREL", "TIME_RSI", "DEG_TIME")
delet_traceinterview_ip_rows <- c("IP35_01x01", "IP35_01x02", "IP35_01x03", "IP35_01x04", "IP35_01x05", "IP35_01x06", "IP35_01x07", "IP35_01x08", "IP35_01x09", "IP35_01x10", 
                               "IP35_01x11", "IP35_01x12", "IP35_01x13", "IP35_01x14", "IP35_01x15", "IP35_01x16", "IP35_01x17", "IP35_01x18", "IP35_01x19", "IP35_01x20", 
                               "IP35_01x21", "IP35_01x22", "IP35_01x23", "IP35_01x24", "IP35_01x25", "IP35_01x26", "IP35_01x27", "IP35_01x28", "IP35_01x29", "IP35_01x30", 
                               "IP35_02x01", "IP35_02x02", "IP35_02x03", "IP35_02x04", "IP35_02x05", "IP35_02x06", "IP35_02x07", "IP35_02x08", "IP35_02x09", "IP35_02x10", 
                               "IP35_02x11", "IP35_02x12", "IP35_02x13", "IP35_02x14", "IP35_02x15", "IP35_02x16", "IP35_02x17", "IP35_02x18", "IP35_02x19", "IP35_02x20", 
                               "IP35_02x21", "IP35_02x22", "IP35_02x23", "IP35_02x24", "IP35_02x25", "IP35_02x26", "IP35_02x27", "IP35_02x28", "IP35_02x29", "IP35_02x30", 
                               "IP59_01x01", "IP59_01x02", "IP59_01x03", "IP59_01x04", "IP59_01x05", "IP59_01x06", "IP59_01x07", "IP59_01x08", "IP59_01x09", "IP59_01x10", 
                               "IP59_01x11", "IP59_01x12", "IP59_01x13", "IP59_01x14", "IP59_01x15", "IP59_01x16", "IP59_01x17", "IP59_01x18", "IP59_01x19", "IP59_01x20", 
                               "IP59_01x21", "IP59_01x22", "IP59_01x23", "IP59_01x24", "IP59_01x25", "IP59_01x26", "IP59_01x27", "IP59_01x28", "IP59_01x29", 
                               "IP59_02x01", "IP59_02x02", "IP59_02x03", "IP59_02x04", "IP59_02x05", "IP59_02x06", "IP59_02x07", "IP59_02x08", "IP59_02x09", "IP59_02x10", 
                               "IP59_02x11", "IP59_02x12", "IP59_02x13", "IP59_02x14", "IP59_02x15", "IP59_02x16", "IP59_02x17", "IP59_02x18", "IP59_02x19", "IP59_02x20", 
                               "IP59_02x21", "IP59_02x22", "IP59_02x23", "IP59_02x24", "IP59_02x25", "IP59_02x26", "IP59_02x27", "IP59_02x28", "IP59_02x29")


delet_traceinterview_rows <- c(delet_traceinterview_standart_rows, delet_traceinterview_ip_rows)

delet_traceinterview_values_rows <- c("DE03_01", "DE03_02", "DE03_03", "DE03_04",  "DE03_05", "DE03_06", "DE03_07", "DE03_08", 
                                      "DE14_01", "DE14_02", "DE14_03", "DE14_04", "DE14_05", "DE14_06", "DE14_07", "DE14_08", "DE14_09", 
                                      "DE16_01", "DE16_02", "DE16_03", "DE16_04", "DE16_05", "DE16_06", "DE16_07", "DE16_08", 
                                      "EI01_01", "EI01_02", "EI01_03", "EI01_04", "EI01_05", "EI01_06", "EI01_07", "EI01_08", 
                                      "EI01_09", "EI01_10", "EI01_11", "EI01_12", "EI01_13", "EI01_14", "EI01_15", "EI01_16", 
                                      "IT10_01", "IT10_02", "IT10_03", "IT10_04", "IT10_05", "IT10_06", "IT10_07", 
                                      "IT24_01", "IT24_02", "IT24_03", "IT24_04", "IT24_05", "IT24_06", "IT24_07", 
                                      "IT25_01", "IT25_02", "IT25_03", "IT25_04", "IT25_05", "IT25_06", "IT25_07", 
                                      "IT33_01", "IT33_02", "IT33_03", "IT33_04", "IT33_05", "IT33_06", "IT33_07", 
                                      "IT30_01", "IT30_02", "IT30_03", "IT30_04", "IT30_05", "IT30_06", "IT30_07")

delet_geoloc_rows_small <- delet_traceinterview_standart_rows
delet_geoloc_rows <- c(delet_traceinterview_standart_rows, "RA01_CP", "RA02_CP", "RA03_CP", "RA04_CP", "RA05_CP", 
                       "RA07_01x01", "RA07_01x02", "RA07_01x03", "RA07_01x04", "RA07_01x05", "RA07_01x06", "RA07_01x07", "RA07_01x08", "RA07_01x09", "RA07_01x10", 
                       "RA07_01x11", "RA07_01x12", "RA07_01x13", "RA07_01x14", "RA07_01x15", "RA07_01x16", "RA07_01x17", "RA07_01x18", "RA07_01x19", "RA07_01x20", 
                       "RA07_01x21", "RA07_01x22", "RA07_01x23", "RA07_01x24", "RA07_01x25", "RA07_01x26", "RA07_01x27", "RA07_01x28", "RA07_01x29", "RA07_01x30",
                       "RA07_02x01", "RA07_02x02", "RA07_02x03", "RA07_02x04", "RA07_02x05", "RA07_02x06", "RA07_02x07", "RA07_02x08", "RA07_02x09", "RA07_02x10", 
                       "RA07_02x11", "RA07_02x12", "RA07_02x13", "RA07_02x14", "RA07_02x15", "RA07_02x16", "RA07_02x17", "RA07_02x18", "RA07_02x19", "RA07_02x20", 
                       "RA07_02x21", "RA07_02x22", "RA07_02x23", "RA07_02x24", "RA07_02x25", "RA07_02x26", "RA07_02x27", "RA07_02x28", "RA07_02x29", "RA07_02x30", 
                       "RA09_01x01", "RA09_01x02", "RA09_01x03", "RA09_01x04", "RA09_01x05", "RA09_01x06", "RA09_01x07", "RA09_01x08", "RA09_01x09", "RA09_01x10", 
                       "RA09_01x11", "RA09_01x12", "RA09_01x13", "RA09_01x14", "RA09_01x15", "RA09_01x16", "RA09_01x17", "RA09_01x18", "RA09_01x19", "RA09_01x20", 
                       "RA09_01x21", "RA09_01x22", "RA09_01x23", "RA09_01x24", "RA09_01x25", "RA09_01x26", "RA09_01x27", "RA09_01x28", "RA09_01x29", "RA09_01x30", 
                       "RA09_02x01", "RA09_02x02", "RA09_02x03", "RA09_02x04", "RA09_02x05", "RA09_02x06", "RA09_02x07", "RA09_02x08", "RA09_02x09", "RA09_02x10", 
                       "RA09_02x11", "RA09_02x12", "RA09_02x13", "RA09_02x14", "RA09_02x15", "RA09_02x16", "RA09_02x17", "RA09_02x18", "RA09_02x19", "RA09_02x20", 
                       "RA09_02x21", "RA09_02x22", "RA09_02x23", "RA09_02x24", "RA09_02x25", "RA09_02x26", "RA09_02x27", "RA09_02x28", "RA09_02x29", "RA09_02x30", 
                       "RA10_01x01", "RA10_01x02", "RA10_01x03", "RA10_01x04", "RA10_01x05", "RA10_01x06", "RA10_01x07", "RA10_01x08", "RA10_01x09", "RA10_01x10", 
                       "RA10_01x11", "RA10_01x12", "RA10_01x13", "RA10_01x14", "RA10_01x15", "RA10_01x16", "RA10_01x17", "RA10_01x18", "RA10_01x19", "RA10_01x20", 
                       "RA10_01x21", "RA10_01x22", "RA10_01x23", "RA10_01x24", "RA10_01x25", "RA10_01x26", "RA10_01x27", "RA10_01x28", "RA10_01x29", "RA10_01x30", 
                       "RA10_02x01", "RA10_02x02", "RA10_02x03", "RA10_02x04", "RA10_02x05", "RA10_02x06", "RA10_02x07", "RA10_02x08", "RA10_02x09", "RA10_02x10", 
                       "RA10_02x11", "RA10_02x12", "RA10_02x13", "RA10_02x14", "RA10_02x15", "RA10_02x16", "RA10_02x17", "RA10_02x18", "RA10_02x19", "RA10_02x20", 
                       "RA10_02x21", "RA10_02x22", "RA10_02x23", "RA10_02x24", "RA10_02x25", "RA10_02x26", "RA10_02x27", "RA10_02x28", "RA10_02x29", "RA10_02x30", 
                       "RA11_01x01", "RA11_01x02", "RA11_01x03", "RA11_01x04", "RA11_01x05", "RA11_01x06", "RA11_01x07", "RA11_01x08", "RA11_01x09", "RA11_01x10", 
                       "RA11_01x11", "RA11_01x12", "RA11_01x13", "RA11_01x14", "RA11_01x15", "RA11_01x16", "RA11_01x17", "RA11_01x18", "RA11_01x19", "RA11_01x20", 
                       "RA11_01x21", "RA11_01x22", "RA11_01x23", "RA11_01x24", "RA11_01x25", "RA11_01x26", "RA11_01x27", "RA11_01x28", "RA11_01x29", "RA11_01x30", 
                       "RA11_02x01", "RA11_02x02", "RA11_02x03", "RA11_02x04", "RA11_02x05", "RA11_02x06", "RA11_02x07", "RA11_02x08", "RA11_02x09", "RA11_02x10", 
                       "RA11_02x11", "RA11_02x12", "RA11_02x13", "RA11_02x14", "RA11_02x15", "RA11_02x16", "RA11_02x17", "RA11_02x18", "RA11_02x19", "RA11_02x20", 
                       "RA11_02x21", "RA11_02x22", "RA11_02x23", "RA11_02x24", "RA11_02x25", "RA11_02x26", "RA11_02x27", "RA11_02x28", "RA11_02x29", "RA11_02x30", 
                       "RA12_01x01", "RA12_01x02", "RA12_01x03", "RA12_01x04", "RA12_01x05", "RA12_01x06", "RA12_01x07", "RA12_01x08", "RA12_01x09", "RA12_01x10", 
                       "RA12_01x11", "RA12_01x12", "RA12_01x13", "RA12_01x14", "RA12_01x15", "RA12_01x16", "RA12_01x17", "RA12_01x18", "RA12_01x19", "RA12_01x20", 
                       "RA12_01x21", "RA12_01x22", "RA12_01x23", "RA12_01x24", "RA12_01x25", "RA12_01x26", "RA12_01x27", "RA12_01x28", "RA12_01x29", "RA12_01x30", 
                       "RA12_02x01", "RA12_02x02", "RA12_02x03", "RA12_02x04", "RA12_02x05", "RA12_02x06", "RA12_02x07", "RA12_02x08", "RA12_02x09", "RA12_02x10", 
                       "RA12_02x11", "RA12_02x12", "RA12_02x13", "RA12_02x14", "RA12_02x15", "RA12_02x16", "RA12_02x17", "RA12_02x18", "RA12_02x19", "RA12_02x20", 
                       "RA12_02x21", "RA12_02x22", "RA12_02x23", "RA12_02x24", "RA12_02x25", "RA12_02x26", "RA12_02x27", "RA12_02x28", "RA12_02x29", "RA12_02x30")

delet_geoloc_map_rows <- c("RA01_CP", "RA02_CP", "RA03_CP", "RA04_CP", "RA05_CP", 
                       "RA07_01x01", "RA07_01x02", "RA07_01x03", "RA07_01x04", "RA07_01x05", "RA07_01x06", "RA07_01x07", "RA07_01x08", "RA07_01x09", "RA07_01x10", 
                       "RA07_01x11", "RA07_01x12", "RA07_01x13", "RA07_01x14", "RA07_01x15", "RA07_01x16", "RA07_01x17", "RA07_01x18", "RA07_01x19", "RA07_01x20", 
                       "RA07_01x21", "RA07_01x22", "RA07_01x23", "RA07_01x24", "RA07_01x25", "RA07_01x26", "RA07_01x27", "RA07_01x28", "RA07_01x29", "RA07_01x30",
                       "RA07_02x01", "RA07_02x02", "RA07_02x03", "RA07_02x04", "RA07_02x05", "RA07_02x06", "RA07_02x07", "RA07_02x08", "RA07_02x09", "RA07_02x10", 
                       "RA07_02x11", "RA07_02x12", "RA07_02x13", "RA07_02x14", "RA07_02x15", "RA07_02x16", "RA07_02x17", "RA07_02x18", "RA07_02x19", "RA07_02x20", 
                       "RA07_02x21", "RA07_02x22", "RA07_02x23", "RA07_02x24", "RA07_02x25", "RA07_02x26", "RA07_02x27", "RA07_02x28", "RA07_02x29", "RA07_02x30", 
                       "RA09_01x01", "RA09_01x02", "RA09_01x03", "RA09_01x04", "RA09_01x05", "RA09_01x06", "RA09_01x07", "RA09_01x08", "RA09_01x09", "RA09_01x10", 
                       "RA09_01x11", "RA09_01x12", "RA09_01x13", "RA09_01x14", "RA09_01x15", "RA09_01x16", "RA09_01x17", "RA09_01x18", "RA09_01x19", "RA09_01x20", 
                       "RA09_01x21", "RA09_01x22", "RA09_01x23", "RA09_01x24", "RA09_01x25", "RA09_01x26", "RA09_01x27", "RA09_01x28", "RA09_01x29", "RA09_01x30", 
                       "RA09_02x01", "RA09_02x02", "RA09_02x03", "RA09_02x04", "RA09_02x05", "RA09_02x06", "RA09_02x07", "RA09_02x08", "RA09_02x09", "RA09_02x10", 
                       "RA09_02x11", "RA09_02x12", "RA09_02x13", "RA09_02x14", "RA09_02x15", "RA09_02x16", "RA09_02x17", "RA09_02x18", "RA09_02x19", "RA09_02x20", 
                       "RA09_02x21", "RA09_02x22", "RA09_02x23", "RA09_02x24", "RA09_02x25", "RA09_02x26", "RA09_02x27", "RA09_02x28", "RA09_02x29", "RA09_02x30", 
                       "RA10_01x01", "RA10_01x02", "RA10_01x03", "RA10_01x04", "RA10_01x05", "RA10_01x06", "RA10_01x07", "RA10_01x08", "RA10_01x09", "RA10_01x10", 
                       "RA10_01x11", "RA10_01x12", "RA10_01x13", "RA10_01x14", "RA10_01x15", "RA10_01x16", "RA10_01x17", "RA10_01x18", "RA10_01x19", "RA10_01x20", 
                       "RA10_01x21", "RA10_01x22", "RA10_01x23", "RA10_01x24", "RA10_01x25", "RA10_01x26", "RA10_01x27", "RA10_01x28", "RA10_01x29", "RA10_01x30", 
                       "RA10_02x01", "RA10_02x02", "RA10_02x03", "RA10_02x04", "RA10_02x05", "RA10_02x06", "RA10_02x07", "RA10_02x08", "RA10_02x09", "RA10_02x10", 
                       "RA10_02x11", "RA10_02x12", "RA10_02x13", "RA10_02x14", "RA10_02x15", "RA10_02x16", "RA10_02x17", "RA10_02x18", "RA10_02x19", "RA10_02x20", 
                       "RA10_02x21", "RA10_02x22", "RA10_02x23", "RA10_02x24", "RA10_02x25", "RA10_02x26", "RA10_02x27", "RA10_02x28", "RA10_02x29", "RA10_02x30", 
                       "RA11_01x01", "RA11_01x02", "RA11_01x03", "RA11_01x04", "RA11_01x05", "RA11_01x06", "RA11_01x07", "RA11_01x08", "RA11_01x09", "RA11_01x10", 
                       "RA11_01x11", "RA11_01x12", "RA11_01x13", "RA11_01x14", "RA11_01x15", "RA11_01x16", "RA11_01x17", "RA11_01x18", "RA11_01x19", "RA11_01x20", 
                       "RA11_01x21", "RA11_01x22", "RA11_01x23", "RA11_01x24", "RA11_01x25", "RA11_01x26", "RA11_01x27", "RA11_01x28", "RA11_01x29", "RA11_01x30", 
                       "RA11_02x01", "RA11_02x02", "RA11_02x03", "RA11_02x04", "RA11_02x05", "RA11_02x06", "RA11_02x07", "RA11_02x08", "RA11_02x09", "RA11_02x10", 
                       "RA11_02x11", "RA11_02x12", "RA11_02x13", "RA11_02x14", "RA11_02x15", "RA11_02x16", "RA11_02x17", "RA11_02x18", "RA11_02x19", "RA11_02x20", 
                       "RA11_02x21", "RA11_02x22", "RA11_02x23", "RA11_02x24", "RA11_02x25", "RA11_02x26", "RA11_02x27", "RA11_02x28", "RA11_02x29", "RA11_02x30", 
                       "RA12_01x01", "RA12_01x02", "RA12_01x03", "RA12_01x04", "RA12_01x05", "RA12_01x06", "RA12_01x07", "RA12_01x08", "RA12_01x09", "RA12_01x10", 
                       "RA12_01x11", "RA12_01x12", "RA12_01x13", "RA12_01x14", "RA12_01x15", "RA12_01x16", "RA12_01x17", "RA12_01x18", "RA12_01x19", "RA12_01x20", 
                       "RA12_01x21", "RA12_01x22", "RA12_01x23", "RA12_01x24", "RA12_01x25", "RA12_01x26", "RA12_01x27", "RA12_01x28", "RA12_01x29", "RA12_01x30", 
                       "RA12_02x01", "RA12_02x02", "RA12_02x03", "RA12_02x04", "RA12_02x05", "RA12_02x06", "RA12_02x07", "RA12_02x08", "RA12_02x09", "RA12_02x10", 
                       "RA12_02x11", "RA12_02x12", "RA12_02x13", "RA12_02x14", "RA12_02x15", "RA12_02x16", "RA12_02x17", "RA12_02x18", "RA12_02x19", "RA12_02x20", 
                       "RA12_02x21", "RA12_02x22", "RA12_02x23", "RA12_02x24", "RA12_02x25", "RA12_02x26", "RA12_02x27", "RA12_02x28", "RA12_02x29", "RA12_02x30")



# define question with unique identifiers
unique_username_cols <- c("SO02", "SO06", "SO06s", "SO09", "SO10", 
                          "SO11", "SO12", "SO12s", "SO13")

unique_url_cols <- c("IP02", "IP18", "IP36", "IP51", "IP53", "IP55", "IP57")

unique_random_post_cols <- c("RA01", "RA02", "RA03", "RA04", "RA05")



##############################################
### Mapping for Answers of Traceinterviews ###
##############################################

# define values for numeric answers
values_1to5_approval <- tibble(values = as.numeric(c("1", "2", "3", "4", "5")), 
                      meaning= c("1: trifft nicht zu",
                                 "2: trifft eher nicht zu",
                                 "3: trifft weder noch zu",
                                 "4: trifft eher zu",
                                 "5: trifft vollständig zu") ) 

values_1to5_amount <- tibble(values = as.numeric(c("1", "2", "3", "4", "5")), 
                      meaning= c("1: gar nicht",
                                 "2: eher nicht",
                                 "3: weder noch",
                                 "4: eher mehr",
                                 "5: sehr viel") ) 

values_1to5_influence <- tibble(values = as.numeric(c("1", "2", "3", "4", "5")), 
                             meaning= c("1: gar nicht beeinflusst",
                                        "2: eher nicht beeinflusst",
                                        "3: weder noch beeinflusst",
                                        "4: eher beeinflusst",
                                        "5: sehr stark beeinflusst") ) 

values_1to8 <- tibble(values = as.numeric(c("1", "2", "3", "4", "5", "6", "7", "8")), 
                      meaning= c("Rank 1",
                                 "Rank 2",
                                 "Rank 3",
                                 "Rank 4",
                                 "Rank 5",
                                 "Rank 6",
                                 "Rank 7",
                                 "Rank 8") ) 

values_1to7 <- tibble(values = as.numeric(c("1", "2", "3", "4", "5", "6", "7")), 
                      meaning= c("1: Am meisten Zeit",
                                 "2: Mehr Zeit",
                                 "3 ",
                                 "4: Durchschnittlich viel Zeit",
                                 "5 ",
                                 "6: weniger Zeit",
                                 "7: Am wenigsten Zeit") ) 

values_to_regions <- tibble(
      values = as.numeric(c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", 
                           "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", 
                           "21", "22", "23", "24", "25", "26", "27", "28", "29") ),
      meaning = c("A1", "B1", "C1 - WK", "D1 - WK", "E1 - WK", "A2", 
                  "B2 - See", "C2 - WK", "D2 - WK", "E2 - WK", 
                  "A3", "B3", "C3", 
                  "D3 - Praxis & Dorf", 
                  "E3", "A4", 
                  "B4 - Gruberhof", 
                  "C4", "D4", "E4", "F1", "F2", "F3", "F4",
                  "Gruberhof", "Praxis", "Dorfplatz", "Hintersteiner See",
                  "Wilder Kaiser Gebirge", "Ich kenne den Ort nicht"),
      polygon_koordinates = c("11,53 232,42 239,221 19,231", 
                              "232,42 237,220 461,211 454,35", 
                              "453,36 461,212 683,203 674,30", 
                              "675,28 682,202 904,194 896,21", 
                              "1126,187 1118,10 896,21 905,197", 
                              "18,230 239,224 247,402 26,410", 
                              "239,223 462,213 469,389 247,400", 
                              "459,212 683,204 689,384 469,394", 
                              "682,205 904,195 911,375 689,386", 
                              "904,198 1125,189 1132,368 912,377", 
                              "26,406 246,401 253,579 32,586", 
                              "246,401 468,392 476,571 253,579", 
                              "467,390 688,382 695,558 474,569", 
                              "691,380 910,372 919,552 698,562", 
                              "912,376 1134,367 1138,543 920,552", 
                              "31,585 253,575 260,753 39,753", 
                              "253,575 471,565 481,741 260,756", 
                              "475,569 695,556 704,740 482,748", 
                              "696,562 917,550 924,727 704,737", 
                              "918,551 1138,543 1147,717 923,726", 
                              "1120,8 1125,184 1347,175 1333,3", 
                              "1128,186 1347,177 1355,354 1135,365", 
                              "1133,363 1355,355 1361,532 1140,540", 
                              "1139,541 1361,533 1361,606 1228,606 1227,714 1148,717", 
                              "324,596 373,594 370,642 322,642", 
                              "697,455 752,456 750,514 695,515", 
                              "858,455 919,450 917,495 860,500", 
                              "428,270 312,273 312,345 431,342", 
                              "321,194 469,125 592,88 669,68 734,76 817,49 906,41 987,30 1048,28 1123,32 1130,52 1172,26 1225,72 1236,126 1222,161 1280,177 1326,247 1302,282 1187,288 1088,294 1026,302 967,316 910,302 842,297 815,305 752,305 689,310 613,303 546,294 467,262 406,262 371,278 340,269 327,242 320,218", 
                              "1345,609 1231,608 1230,709 1345,709")
      )




#######################
### Colors & shapes ###
#######################

#colors for groups

group_labels <- c("Destination", 
                  "Produktion", 
                  "Screentourist")

group_color <- c("#E69F00", # Desti
                 "#56B4E9", # Prod
                 "#66bf52")  # Scre

motiv_photo_corner_labels <- c("Corner 1", 
                               "Corner 2", 
                               "Photografer", 
                               "Motiv")

motiv_photo_corner_color <- c("#c7c6c1", # Corner 1
                              "#c7c6c1", # Corner 2
                              "#7d1e20", # Photo
                              "#c7aa04") # Motiv

motiv_photo_corner_shapes <- c(2, # Corner 1
                               6, # Corner 2
                               4, # Photo
                               1) # Motiv

motiv_photo_labels <- c("Photographer",
                        "Motive")

motiv_photo_color <- c("#7d1e20", # Photo # I dont use the color, just the shapes
                       "#c7aa04") # Motiv

motiv_photo_shapes <- c(4, # Photo - Cross
                        1) # Motiv - Circle




####################################################
### Define Multiword expressions for diktionarys ###
####################################################

list_multiword_saveds <- c("der Bergdoktor",
                           "ZDF Bergdoktor",
                           "orf Bergdoktor",
                           "Martin Gruber",
                           "Hans Gruber",
                           "Lilli Gruber",
                           "Elisabeth Gruber",
                           "Susanne Dreiseitl",
                           "Roman Melchinger",
                           "Alexander Kahnweiler",
                           "Linn Kemper",
                           "Franziska Hochstetter",
                           "Rebecca Imanuel",
                           "Andrea Gerhard",
                           "Simone Hanselmann",
                           "Mark Keller",
                           "Monika Baumgartner",
                           "Natalie O'Hara",
                           "Ronja Forcher",
                           "Heiko Ruprecht",
                           "Hans Sigl",
                           "Wilder Kaiser",
                           "visit austria",
                           "in echt noch schöner",
                           "film tourismus")

list_multiword_all <- c(list_multiword_saveds,
                        "Dr Martin Gruber",
                        "Dr Gruber",
                        "Dr Roman Melchinger",
                        "Dr Melchinger",
                        "Dr Alexander Kahnweiler",
                        "Dr Kahnweiler",
                        "Vera Fendrich",
                        "Dr Vera Fendrich",
                        "Dr Fendrich",
                        "Wilden Kaiser",
                        "mehr Reith",
                        "Hohe Salve",
                        "Rübezahl Alm",
                        "Wilder Kaiser Gasthof") # add more to this list and use it analysis





#TODO DB: 
#    1. Extract Smileys, #NOTE: Not perfect but DONE 
#    2. Add qualitative Meta table, 
#    3. Missing meta Data table, #NOTE: DONE
#    4. hook up to API, #NOTE: Done
#    5. Add Leaderboard Data
#    6. Make init
#    7. Add Screentourism Lvl: 
#        - Calculate the lvl on how many times the post connects to screentourism
#          in Hashtags, Mentions, Geotag, Text and Picture
#        - Build hashtag and mentions lists to find the connecting
#        - Build aditional lists with geotags and text
#        - Do the points for pictures manually or leave it out.
#    8. Combine Monthly CSV Data with API #NOTE: DONE
#    9. Build missing Profilart table to check. #NOTE: DONE
#   10. Add Scraper Data with Geotags to the data set #NOTE: DONE