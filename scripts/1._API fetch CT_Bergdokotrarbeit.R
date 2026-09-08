#### Librarys
library(httr)
library(jsonlite)
library(dplyr)


# remove everything from loval environment
rm(list = ls())

#### Definitions
GET <- httr::GET
from_json <- jsonlite::fromJSON

# source(init.R) #TODO DB: Work with inti and source.


# Components querry URL
base_url <- paste0("https://api.crowdtangle.com")
endpoint <- paste0("/posts?")
my_token <- paste0("token=", "5H5SGOLeMYbDPsI3UQJA90hBLihqshdm2ZzPXyzu") # Stand: 2019-12-19 #Bergdoktorarbeit
#my_list_id <- paste0("&listIds=1417560") # Saved Search "Wilder Kaiser - Touristen"
my_list_id <- paste0("&listIds=1256313") # Saved Search "Bergdoktor, Wilderkaiser - Screentourismus"
sort_by <- paste0("&sortBy=date")
# date_range <- paste0("&startDate=2019-12-15", "&endDate=2019-12-31")
# histroy <- paste0("&includeHistory=TRUE") # Include timeseries history to posts
count_posts <- paste0("&count=100")
offset_posts <- paste0("&offset=0")




# test list
# date_range_list_test <- c( paste0("&startDate=2021-05-15", "&endDate=2021-05-31"),
#                       paste0("&startDate=2021-06-01", "&endDate=2021-06-15"),
#                       paste0("&startDate=2021-06-15", "&endDate=2021-06-30"))


# editied
date_range_list_bd <- c( paste0("&startDate=2017-01-01", "&endDate=2017-08-31"),
                            paste0("&startDate=2017-09-01", "&endDate=2017-12-31"),
                            paste0("&startDate=2018-01-01", "&endDate=2018-05-31"),
                            paste0("&startDate=2018-06-01", "&endDate=2018-06-30"),
                            paste0("&startDate=2018-07-01", "&endDate=2018-07-31"),
                            paste0("&startDate=2018-08-01", "&endDate=2018-08-31"),
                            paste0("&startDate=2018-09-01", "&endDate=2018-09-30"),
                            paste0("&startDate=2018-10-01", "&endDate=2018-10-31"),
                            paste0("&startDate=2018-11-01", "&endDate=2018-11-30"),
                            paste0("&startDate=2018-12-01", "&endDate=2018-12-31"),
                            paste0("&startDate=2019-01-01", "&endDate=2019-01-15"),
                            paste0("&startDate=2019-01-16", "&endDate=2019-01-31"),
                            paste0("&startDate=2019-02-01", "&endDate=2019-02-28"),
                            paste0("&startDate=2019-03-01", "&endDate=2019-03-15"),
                            paste0("&startDate=2019-03-15", "&endDate=2019-03-31"),
                            paste0("&startDate=2019-04-01", "&endDate=2019-04-15"),
                            paste0("&startDate=2019-04-16", "&endDate=2019-04-30"),
                            paste0("&startDate=2019-05-01", "&endDate=2019-05-15"),
                            paste0("&startDate=2019-05-16", "&endDate=2019-05-31"),
                            paste0("&startDate=2019-06-01", "&endDate=2019-06-10"),
                            paste0("&startDate=2019-06-11", "&endDate=2019-06-20"),
                            paste0("&startDate=2019-06-21", "&endDate=2019-06-30"),
                            paste0("&startDate=2019-07-01", "&endDate=2019-07-10"),
                            paste0("&startDate=2019-07-11", "&endDate=2019-07-20"),
                            paste0("&startDate=2019-07-21", "&endDate=2019-07-31"),
                            paste0("&startDate=2019-08-01", "&endDate=2019-08-15"),
                            paste0("&startDate=2019-08-16", "&endDate=2019-08-31"),
                            paste0("&startDate=2019-09-01", "&endDate=2019-09-30"),
                            paste0("&startDate=2019-10-01", "&endDate=2019-10-31"),
                            paste0("&startDate=2019-11-01", "&endDate=2019-11-30"),
                            paste0("&startDate=2019-12-01", "&endDate=2019-12-15"),
                            paste0("&startDate=2019-12-16", "&endDate=2019-12-31"),
                            paste0("&startDate=2020-01-01", "&endDate=2020-01-15"),
                            paste0("&startDate=2020-01-16", "&endDate=2020-01-31"),
                            paste0("&startDate=2020-02-01", "&endDate=2020-02-15"),
                            paste0("&startDate=2020-02-16", "&endDate=2020-02-29"),
                            paste0("&startDate=2020-03-01", "&endDate=2020-03-15"),
                            paste0("&startDate=2020-03-16", "&endDate=2020-03-31"),
                            paste0("&startDate=2020-04-01", "&endDate=2020-04-15"),
                            paste0("&startDate=2020-04-16", "&endDate=2020-04-30"),
                            paste0("&startDate=2020-05-01", "&endDate=2020-05-10"),
                            paste0("&startDate=2020-05-11", "&endDate=2020-05-20"),
                            paste0("&startDate=2020-05-21", "&endDate=2020-05-31"),
                            paste0("&startDate=2020-06-01", "&endDate=2020-06-15"),
                            paste0("&startDate=2020-06-16", "&endDate=2020-06-30"),
                            paste0("&startDate=2020-07-01", "&endDate=2020-07-10"),
                            paste0("&startDate=2020-07-11", "&endDate=2020-07-20"),
                            paste0("&startDate=2020-07-21", "&endDate=2020-07-31"),
                            paste0("&startDate=2020-08-01", "&endDate=2020-08-10"),
                            paste0("&startDate=2020-08-11", "&endDate=2020-08-20"),
                            paste0("&startDate=2020-08-21", "&endDate=2020-08-31"),
                            paste0("&startDate=2020-09-01", "&endDate=2020-09-10"),
                            paste0("&startDate=2020-09-11", "&endDate=2020-09-20"),
                            paste0("&startDate=2020-09-21", "&endDate=2020-09-30"),
                            paste0("&startDate=2020-10-01", "&endDate=2020-10-10"),
                            paste0("&startDate=2020-10-11", "&endDate=2020-10-20"),
                            paste0("&startDate=2020-10-21", "&endDate=2020-10-31"),
                            paste0("&startDate=2020-11-01", "&endDate=2020-11-10"),
                            paste0("&startDate=2020-11-11", "&endDate=2020-11-20"),
                            paste0("&startDate=2020-11-21", "&endDate=2020-11-30"),
                            paste0("&startDate=2020-12-01", "&endDate=2020-12-10"),
                            paste0("&startDate=2020-12-11", "&endDate=2020-12-20"),
                            paste0("&startDate=2020-12-21", "&endDate=2020-12-31"),
                            paste0("&startDate=2021-01-01", "&endDate=2021-01-15"),
                            paste0("&startDate=2021-01-16", "&endDate=2021-01-31"),
                            paste0("&startDate=2021-02-01", "&endDate=2021-02-15"),
                            paste0("&startDate=2021-02-16", "&endDate=2021-02-28"),
                            paste0("&startDate=2021-03-01", "&endDate=2021-03-10"),
                            paste0("&startDate=2021-03-11", "&endDate=2021-03-20"),
                            paste0("&startDate=2021-03-21", "&endDate=2021-03-31"),
                            paste0("&startDate=2021-04-01", "&endDate=2021-04-15"),
                            paste0("&startDate=2021-04-16", "&endDate=2021-04-30"),
                            paste0("&startDate=2021-05-01", "&endDate=2021-05-10"), 
                            paste0("&startDate=2021-05-11", "&endDate=2021-05-20"), 
                            paste0("&startDate=2021-05-21", "&endDate=2021-05-31"), 
                            paste0("&startDate=2021-06-01", "&endDate=2021-06-10"),
                            paste0("&startDate=2021-06-11", "&endDate=2021-06-20"),
                            paste0("&startDate=2021-06-21", "&endDate=2021-06-30"))

date_range_list_wk <- c( paste0("&startDate=2015-01-01", "&endDate=2015-12-31"), # Edited
                      paste0("&startDate=2016-01-01", "&endDate=2016-06-30"), # Edited
                      paste0("&startDate=2016-07-01", "&endDate=2016-12-31"), # Edited
                      paste0("&startDate=2017-01-01", "&endDate=2017-03-31"), # Edited
                      paste0("&startDate=2017-04-01", "&endDate=2017-06-30"), # Edited
                      paste0("&startDate=2017-07-01", "&endDate=2017-09-30"), # Edited
                      paste0("&startDate=2017-10-01", "&endDate=2017-12-31"), # Edited
                      paste0("&startDate=2018-01-01", "&endDate=2018-03-31"), # Edited
                      paste0("&startDate=2018-04-01", "&endDate=2018-05-31"), # Edited
                      paste0("&startDate=2018-06-01", "&endDate=2018-07-31"), # Edited
                      paste0("&startDate=2018-08-01", "&endDate=2018-09-30"), # Edited
                      paste0("&startDate=2018-10-01", "&endDate=2018-10-31"), # Edited
                      paste0("&startDate=2018-11-01", "&endDate=2018-11-30"), # Edited
                      paste0("&startDate=2018-12-01", "&endDate=2018-12-31"), # Edited
                      paste0("&startDate=2019-01-01", "&endDate=2019-01-31"), # Edited
                      paste0("&startDate=2019-02-01", "&endDate=2019-02-28"), # Edited
                      paste0("&startDate=2019-03-01", "&endDate=2019-04-30"), # Edited
                      paste0("&startDate=2019-05-01", "&endDate=2019-06-30"), # Edited
                      paste0("&startDate=2019-07-01", "&endDate=2019-07-31"), # Edited
                      paste0("&startDate=2019-08-01", "&endDate=2019-08-31"), # Edited
                      paste0("&startDate=2019-09-01", "&endDate=2019-09-30"), # Edited
                      paste0("&startDate=2019-10-01", "&endDate=2019-12-31"), # Edited
                      paste0("&startDate=2020-01-01", "&endDate=2020-03-31"), # Edited
                      paste0("&startDate=2020-04-01", "&endDate=2020-06-30"), # Edited
                      paste0("&startDate=2020-07-01", "&endDate=2020-08-31"), # edited
                      paste0("&startDate=2020-09-01", "&endDate=2020-09-30"), # edited
                      paste0("&startDate=2020-10-01", "&endDate=2020-10-31"), # edited
                      paste0("&startDate=2020-11-01", "&endDate=2020-12-31"), # Edited
                      paste0("&startDate=2021-01-01", "&endDate=2021-01-31"), # Edited
                      paste0("&startDate=2021-02-01", "&endDate=2021-02-28"), # Edited
                      paste0("&startDate=2021-03-01", "&endDate=2021-03-15"),
                      paste0("&startDate=2021-03-15", "&endDate=2021-03-31"),
                      paste0("&startDate=2021-04-01", "&endDate=2021-04-15"),
                      paste0("&startDate=2021-04-15", "&endDate=2021-04-30"),
                      paste0("&startDate=2021-05-01", "&endDate=2021-05-10"), # Edited
                      paste0("&startDate=2021-05-11", "&endDate=2021-05-20"), # Edited
                      paste0("&startDate=2021-05-21", "&endDate=2021-05-31"), # Edited
                      paste0("&startDate=2021-06-01", "&endDate=2021-06-15"),
                      paste0("&startDate=2021-06-15", "&endDate=2021-06-30"))

date_range_list <- date_range_list_bd # entweder "date_range_list_wk" oder "date_range_list_bd"


delay_time <- 11




# Download Loop
df_raw_download <- tibble()

for (dates in 1:length(date_range_list)) {
    
    #dates <- 1 #NOTE: Test without loop
    bergdoktor_url <- paste0(base_url, endpoint, my_token, my_list_id, sort_by, date_range_list[dates], count_posts, offset_posts)
    download_url <- bergdoktor_url
    
    data_tmp <- from_json(download_url)
    data_tmp <- data_tmp$result$posts
    
    print(date_range_list[dates])
    print(min(data_tmp$date))
    print(max(data_tmp$date))
    
    Sys.sleep(delay_time) #Delay the time for API restrictions
    
    df_raw <- tibble()
    
    data_tmp_nrow <- if_else(is.null(nrow(data_tmp)) == TRUE, 
                             as.integer(1), 
                             nrow(data_tmp) ) #Protects befor tables with 0 rows
    # the protector is not working!
    
    
    for (row_num in 1:data_tmp_nrow) {
        
        #row_num <- 3 #NOTE: Test without loop
        
        #print(row_num) 
        
        data_raw_account <- data_tmp$account$name[row_num]
        data_raw_userName <- data_tmp$account$handle[row_num]
        data_raw_FollowersAtPosting <- data_tmp$account$subscriberCount[row_num]
        data_raw_created <- data_tmp$date[row_num]
        data_raw_type <- data_tmp$type[row_num]
        data_raw_url <- data_tmp$postUrl[row_num]
        data_raw_photoUrl <- data_tmp$account$profileImage[row_num]
        data_raw_description <- data_tmp$description[row_num]
        data_raw_image_text <- data_tmp$imageText[row_num] #NOTE: not available anymore
        data_raw_score <- data_tmp$score[row_num]
        data_raw_language <- data_tmp$languageCode[row_num]
        data_raw_verified <- data_tmp$account$verified[row_num]
        data_raw_likes <- data_tmp$statistics$actual$favoriteCount[row_num]
        data_raw_comments <- data_tmp$statistics$actual$commentCount[row_num]
        data_raw_expectedLikes <- data_tmp$statistics$expected$favoriteCount[row_num]
        data_raw_expectedComments <- data_tmp$statistics$expected$commentCount[row_num]
        
        df_temp <- tibble(data_raw_account,
                          data_raw_userName,
                          data_raw_FollowersAtPosting,
                          data_raw_created,
                          data_raw_type,
                          data_raw_url,
                          data_raw_photoUrl,
                          data_raw_description,
                          #data_raw_image_text,  #NOTE: not available anymore
                          data_raw_score,
                          data_raw_language,
                          data_raw_verified,
                          data_raw_likes,
                          data_raw_comments,
                          data_raw_expectedLikes,
                          data_raw_expectedComments)
        
        df_raw <- bind_rows(df_raw, df_temp)
        
        
        rm(df_temp)
    }
    
    
# Print Infos about Post treshold
    cat(if_else(nrow(df_raw) == 100,
                "Postanzahl: WARNING! Download Treshhold 100 reached",
                paste0(nrow(df_raw), " Posts"),
                "Missing"), 
        "\n", 
        paste(length(unique(df_raw$data_raw_userName)), " Accounts"))
    
# bind rows
    df_raw_download <- bind_rows(df_raw_download, df_raw)
    
    
    rm(data_tmp, df_raw)
    
    
}


# clean up table and ad aditional coloumn

df_data_download <- df_raw_download %>% 
    mutate( differenz_likes = data_raw_expectedLikes - data_raw_likes,
            differenz_comments = data_raw_expectedComments - data_raw_comments, 
            int_num = data_raw_likes + data_raw_comments) %>% 
    select(acc = data_raw_account,
           user_name = data_raw_userName,
           user_verified = data_raw_verified,
           post_creat_full = data_raw_created,
           post_type = data_raw_type,
           post_url = data_raw_url,
           image_url = data_raw_photoUrl,
           post_descr = data_raw_description,
           #image_text = data_raw_image_text,
           post_lang = data_raw_language,
           foll_at_post = data_raw_FollowersAtPosting,
           int_num,
           like_num = data_raw_likes,
           com_num = data_raw_comments,
           dif_like_num = differenz_likes,
           dif_com_num = differenz_comments,
           expected_like_num = data_raw_expectedLikes,
           expected_com_num = data_raw_expectedComments,
           #View_num = ?, 
           #QUEST: Where is the views? Apparently not available via API: https://github.com/CrowdTangle/API/wiki/Post
           score_num = data_raw_score)

rm(df_raw_download, values)


# write csv #NOTE: Use it when necessary
save_path <- c("C:/Users/boecher.d/ZDF/TechnologyZDFD - Documents/04_analytics/git-repos-data-mirror/bergdoktorarbeit/1_RAW/data/CT Data/Input/WK BD Data", 
               "C:/Users/boecher.d/ZDF/TechnologyZDFD - Documents/04_analytics/git-repos-data-mirror/bergdoktorarbeit/1_RAW/data/CT Data/Input/WK Tourist Data")

# Save BD Data
write.csv2(df_data_download,
           file = paste0(save_path[1], "/bd_wk_data_api_input_", Sys.Date(), ".csv"),
           na = "NULL",
           row.names = FALSE,
           fileEncoding = "utf-8")


# # Save WK Data
# write.csv2(df_data_download,
#            file = paste0(save_path[2], "/t_wk_data_api_input.csv"),
#            na = "NULL",
#            row.names = FALSE,
#            fileEncoding = "utf-8")
