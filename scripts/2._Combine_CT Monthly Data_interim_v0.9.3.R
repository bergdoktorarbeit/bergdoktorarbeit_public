rm(list = ls()) # Remove all stuff in Environment

start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")





# set working dirctory
#setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

source("init_v0.6.R")

# SET WD 
#NOTE DB: WD Works not with Uni Mainz Webdav!
    # setwd("C:/Users/boecher.d/ZDF/TechnologyZDFD - Documents/04_analytics/git-repos-data-mirror/bergdoktorarbeit/1_RAW/data/CT Data/Input/WK BD Data")
    # getwd()
    

#Get files names in Folder

    files <- list.files(
        paste0(paths$ctdata, "/Input/WK BD Data"),
        pattern = ".csv",
        full.names = TRUE)
    
    
    bd_monthly_files <- files[grepl("feed-download", files)]
    bd_api_file <- files[grepl("bd_wk_data_api", files)]
    
    
# get Data
    
    # Get Metadata
    
    metadata_path <- paste0(paths$ctdata, "/Input/")
    file <- "Accounts - Art.xlsx"
    
    csv_meta_raw <- read.xlsx(paste0(metadata_path, file), 
                                startRow = 1,
                                check.names = FALSE)
    
    #rename stuff
        names(csv_meta_raw) [names(csv_meta_raw) == "Account"] <- "acc"
        names(csv_meta_raw) [names(csv_meta_raw) == "User.Name"] <- "user_name"
        names(csv_meta_raw) [names(csv_meta_raw) == "Art"] <- "art"
        names(csv_meta_raw) [names(csv_meta_raw) == "Sub_Art"] <- "sub_art"
        names(csv_meta_raw) [names(csv_meta_raw) == "Profil_link"] <- "profil_link"
        names(csv_meta_raw) [names(csv_meta_raw) == "Profilbild_link"] <- "profilbild_link"
        names(csv_meta_raw) [names(csv_meta_raw) == "Beispiel_posts"] <- "bsp_post"
        names(csv_meta_raw) [names(csv_meta_raw) == "Bemerkung"] <- "bemerkung"
    
    

# Get Quantitative Data (Monthy CT Data Loop)

# initiate tibble
df_bd_posts <- tibble()

for (csv_temp_file in bd_monthly_files) {

    #csv_temp_file <- bd_monthly_files[1] #Note: Deine input CSV without loop when testing    
    csv_raw <- read.csv(csv_temp_file, 
                         stringsAsFactors = FALSE, 
                         encoding="UTF-8")
    
    #Get Download date
        downloaded_temp <- gsub(".*/","", csv_temp_file) 
        downloaded_temp <- gsub("-CEST.*","", downloaded_temp)
        downloaded_temp <- gsub("-CET.*","", downloaded_temp)
        csv_raw$downloaded <- downloaded_temp
        
        print(downloaded_temp)
    
 
    #rename stuff
        names(csv_raw) [names(csv_raw) == "X.U.FEFF.Account"] <- "acc" #artefact???
        names(csv_raw) [names(csv_raw) == "Account"] <- "acc"
        names(csv_raw) [names(csv_raw) == "User.Name"] <- "user_name"
        names(csv_raw) [names(csv_raw) == "Followers.at.Posting"] <- "foll_at_post"
        names(csv_raw) [names(csv_raw) == "Created"] <- "post_creat_full" #NOTE DB: two different names of coloumns (Post.Created or Created)
        names(csv_raw) [names(csv_raw) == "Post.Created"] <- "post_creat_full"
        names(csv_raw) [names(csv_raw) == "Post.Created.Date"] <- "post_creat_date"
        names(csv_raw) [names(csv_raw) == "Post.Created.Time"] <- "post_creat_time"
        names(csv_raw) [names(csv_raw) == "Type"] <- "post_type"
        names(csv_raw) [names(csv_raw) == "Total.Interactions"] <- "total_int_num"
        names(csv_raw) [names(csv_raw) == "Likes"] <- "like_num"
        names(csv_raw) [names(csv_raw) == "Comments"] <- "com_num"
        names(csv_raw) [names(csv_raw) == "Views"] <- "view_num"
        names(csv_raw) [names(csv_raw) == "URL"] <- "post_url"
        names(csv_raw) [names(csv_raw) == "Link"] <- "post_link"
        names(csv_raw) [names(csv_raw) == "Photo"] <- "image_url"
        names(csv_raw) [names(csv_raw) == "Title"] <- "post_titel"
        names(csv_raw) [names(csv_raw) == "Description"] <- "post_descr"
        names(csv_raw) [names(csv_raw) == "Image.Text"] <- "image_text"
        names(csv_raw) [names(csv_raw) == "Sponsor.Id"] <- "post_sponsor_id"
        names(csv_raw) [names(csv_raw) == "Sponsor.Name"] <- "post_sponsor_name"
        names(csv_raw) [names(csv_raw) == "Overperforming.Score..weighted.....Likes.1x.Comments.1x.."] <- "score_num"
        names(csv_raw) [names(csv_raw) == "Overperforming.Score"] <- "score_num" #NOTE DB: Two different names of colums for the Ovp. Score
        
        #print(colnames(csv_raw))
    
    
    #Build table
        df_bd_temp <- csv_raw  %>% 
            mutate(score_num = gsub("\\.", ",", score_num),
                   post_creat_full = gsub("CEST.*","", post_creat_full),
                   post_creat_full = gsub("CET.*","", post_creat_full),
                   int_num = like_num + com_num,
                   image_id = str_extract(image_url, "5/\\s*(.*?)\\s*n.jpg"),
                   image_id = gsub(".*/", "" , image_id),
                   image_text = if_else(("image_text" %in% names(csv_raw)) == TRUE, "!FAIL!No Image Text!FAIL!", "N/A")
                   ) %>% 
            mutate(image_id = gsub("_n_.jpg|_n.jpg", "", image_id)) %>% 
            select(downloaded,
                 acc,
                 user_name,
                 foll_at_post,
                 post_creat_full,
                 post_type,
                 like_num,
                 com_num,
                 int_num,
                 view_num,
                 post_url,
                 image_url,
                 image_id,
                 image_text,
                 post_descr,
                 score_num) 
                     
    df_bd_posts <- bind_rows(df_bd_posts, df_bd_temp)
}

#remove temp table from loop
    rm(df_bd_temp, csv_raw)
    
  
#delete double posts
    df_bd_posts <- df_bd_posts %>% 
        arrange(downloaded) %>% 
        distinct(post_url, .keep_all = TRUE)
    

#Add api data
    api_posts <- read.csv(bd_api_file, 
                        sep =";",
                        stringsAsFactors = FALSE, 
                        encoding="UTF-8") 
    
    api_posts_join <- api_posts %>% 
      select(user_verified,
             post_lang,
             dif_like_num,
             dif_com_num,
             expected_like_num,
             expected_com_num,
             post_url)

    #Join and bind API Data    

      df_bd_posts <- df_bd_posts %>% 
          left_join(api_posts_join, 
                    by = "post_url") %>% 
        mutate( foll_at_post = na_if(foll_at_post, "N/A"),
                view_num = na_if(view_num, 0)) %>% 
        mutate(foll_at_post = as.integer(foll_at_post))
        
      df_bd_posts <- df_bd_posts %>%   
          bind_rows(api_posts) %>% 
          distinct(post_url, .keep_all = TRUE)
    
    

#Data wrangeling with combined data
        
        #build table    
            
            df_bd_posts <- df_bd_posts %>% 
                mutate (post_index = row_number() + 99) %>% #Start Index with 100
                add_column(post_descr_short = paste0(str_sub(df_bd_posts$post_descr, 0, 50), " [...]"),
                           post_id = str_replace_all(str_sub(df_bd_posts$post_url, -13), "/", "")) %>% 
                #mutate(view_num = if_else(str_detect(df_bd_posts$post_type, "Photo"), "NA", view_num))
                #mutate(view_num = if_else(post_type == "Photo", view_num - 99, as.double(view_num)))
                #mutate(view_num = if_else(post_type == "Photo", NA, view_num))
                mutate(view_num = if_else(post_type == "Photo", "N/A", as.character(view_num))) %>%  #NOTE DB: Convert back to number #mutate(as.numeric(view_num))
                select(all_of(select_colum_all)) %>% 
                left_join(csv_meta_raw %>% select(user_name, art), by = "user_name") %>% # join art
                filter(art %in% c("Screentourist", "Destination", "Produktion")) %>% # filter art
                select(-art) # get rid of art to not destry the later pipes
                
                
                
                
    
    #Hashtag Data
    df_bd_posts_hashtag <- df_bd_posts %>% 
        select(c("post_index",
                 "user_name",
                 "image_text",
                 "post_descr"))
    
         #post_descr hashtags          
         hashtag_vector <- str_extract_all(df_bd_posts_hashtag$post_descr, "#\\w+")
             
         hashtag_vector_num <- as.numeric(do.call(rbind, lapply(hashtag_vector, function(x) length(x)))) 
         
         hashtag_character <- as.character()
         for (i in seq_along(hashtag_vector)) {
             hashtag_character[i] <- paste(hashtag_vector[[i]], collapse = " ")
             #print(i)
         }
         
         
         #build table
         df_bd_posts_hashtag <- df_bd_posts_hashtag %>% #build standart table
             mutate(post_descr_length = str_length(post_descr),
                    post_hash_num = hashtag_vector_num,
                    post_hash_list = hashtag_vector,
                    post_hash_string = hashtag_character,
                    post_hash_length = str_length(post_hash_string),
                    post_hash_descr_rate = round(post_hash_length / post_descr_length * 100, 2) ) %>% 
             select(all_of(select_colum_hashtag) )
         
         df_bd_posts_hashtag_unpiv <- df_bd_posts_hashtag %>% #build unpivot table
             select(post_index,
                    user_name) %>% 
             bind_cols(
                 as.data.frame(
                     str_split_fixed(
                         as.character(df_bd_posts_hashtag$post_hash_string),
                         " ",
                         max(df_bd_posts_hashtag$post_hash_num)
                     )
                 )
             ) %>%
             pivot_longer(!post_index & !user_name,
                          names_to = "hash_order",
                          values_to = "hashtags") %>% 
             apply(2, function(x) gsub("^$|^ $", NA, x)) %>% 
             na.omit(hashtags) %>% 
             as.data.frame() %>% 
             mutate (
                 hash_order = gsub("V", "", hash_order) )
         
         
         df_bd_hashtag_list <- data.frame(matrix(unlist(hashtag_vector), #build hashtag list
                                                 nrow=length(unlist(hashtag_vector)), 
                                                 byrow=TRUE)) %>%
           select(hashtags = matrix.unlist.hashtag_vector...nrow...length.unlist.hashtag_vector....) %>%
           mutate(hashtags = tolower(as.character(hashtags))) %>% 
           count(hashtags) %>% # neue Spalte mit dem Namen n entsteht
           arrange(desc(n)) %>% 
           select(hashtags,
                  hash_num = n)
             
        rm(hashtag_vector)
     

    #Mention Data
        df_bd_posts_mention <- df_bd_posts %>% 
            select(c("post_index",
                     "user_name",
                     "image_text",
                     "post_descr"))
        
        #post_descr mentions          
        mention_vector  <- str_extract_all(df_bd_posts_mention$post_descr, "@[\\w@\\-\\.+_]+")
        
        mention_vector_num <- as.numeric(do.call(rbind, lapply(mention_vector, function(x) length(x)))) 
        
        mention_character <- as.character()
        for (i in seq_along(mention_vector)) {
            mention_character[i] <- paste(mention_vector[[i]], collapse = " ")
            #print(i)
        }
        
        
        #build table
        df_bd_posts_mention <- df_bd_posts_mention %>% #build standart table
            mutate(post_descr_length = str_length(post_descr),
                   post_ment_num = mention_vector_num,
                   post_ment_list = mention_vector,
                   post_ment_string = mention_character,
                   post_ment_length = str_length(post_ment_string),
                   post_ment_descr_rate = round(post_ment_length / post_descr_length * 100, 2) ) %>% 
            select(all_of(select_colum_mention) )
        
        
        df_bd_posts_mention_unpiv <- df_bd_posts_mention %>% #buil unpivot table
            select(post_index,
                   user_name) %>% 
            bind_cols(
                as.data.frame(
                    str_split_fixed(
                        as.character(df_bd_posts_mention$post_ment_string),
                        " ",
                        max(df_bd_posts_mention$post_ment_num)
                    )
                )
            ) %>%
            pivot_longer(!post_index & !user_name,
                         names_to = "ment_order",
                         values_to = "mentions") %>% 
            apply(2, function(x) gsub("^$|^ $", NA, x)) %>% 
            na.omit(mentions) %>% 
            as.data.frame() %>% 
            mutate (
                ment_order = gsub("V", "", ment_order) )
        
        df_bd_mention_list <- data.frame(matrix(unlist(mention_vector), #buil mention list
                                                nrow=length(unlist(mention_vector)), 
                                                byrow=TRUE)) %>% 
            select(mentions = matrix.unlist.mention_vector...nrow...length.unlist.mention_vector....) %>% 
            count(mentions) %>% 
            arrange(desc(n)) %>% 
            select(mentions,
                 ment_num = n)

        
        rm(mention_vector, mention_vector_num, mention_character)
        
        

        
    #combine hashtag + mention tables
        df_bd_posts_hash_ment <- bind_cols(df_bd_posts_hashtag, (df_bd_posts_mention %>% select(contains("ment"))) )
  

        
    
# build table to safe
    #A ll Infos
    df_bd_posts_all <- df_bd_posts %>% 
      mutate(view_num = as.numeric(if_else(view_num == "N/A", "", view_num) ),
             score_num = as.numeric(gsub("\\,", ".", score_num) )
             )
    
    # Meta Data
    df_bd_posts_meta <- df_bd_posts_all %>% 
      select(all_of(select_colum_meta) )
    
    # Post Data
    df_bd_posts_data <- df_bd_posts_all %>% 
      select(all_of(select_colum_data) )
    
    # combine hashtag + mention tables
    df_bd_posts_hash_ment <- bind_cols(df_bd_posts_hashtag, (df_bd_posts_mention %>% select(contains("ment"))) )
    
    # Hashtag data
    df_bd_posts_hashtag_unpiv <- df_bd_posts_hashtag_unpiv %>% 
      mutate(hash_order = as.numeric(hash_order) )
    
    # Mention data
    df_bd_posts_mention_unpiv <- df_bd_posts_mention_unpiv %>% 
      mutate(ment_order = as.numeric(ment_order) )
    
    # Find missing meta data
    df_bd_posts_missing_art <- full_join(csv_meta_raw, 
                                         (df_bd_posts_meta %>% 
                                            select(user_name, acc, post_url) %>% 
                                            distinct() ),
                                         by = "user_name") %>% 
      distinct(user_name, .keep_all = TRUE) %>%
      filter(is.na(art)) %>% 
      select(acc = acc.y,
             user_name,
             art,
             profil_link,
             profilbild_link,
             beispiel_post = post_url)
    
    
# Erase df
    #data
    rm(api_posts, 
       api_posts_join 
       #,csv_meta_raw
       ) 
    #values
    rm(select_colum_all, 
        select_colum_data, 
        select_colum_hashtag, 
        select_colum_mention, 
        downloaded_temp, 
        file, 
        files,
        hashtag_character,
        hashtag_vector_num,
        i,
        metadata_path,
        select_colum_meta,
        bd_api_file, 
        bd_monthly_files, 
        csv_temp_file)
        

#save as csv
    output_path <- paste0(paths$data_processed, "/")    
    
    write.csv2(df_bd_posts_all,
               file = paste0(output_path, Sys.Date(), "_bd_ct-some_all", ".csv"), 
               na = "NULL", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_bd_posts_meta,
               file = paste0(output_path, Sys.Date(), "_bd_ct-some_meta", ".csv"), 
               na = "NULL", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_bd_posts_data,
               file = paste0(output_path, Sys.Date(), "_bd_ct-some_data", ".csv"), 
               na = "NULL", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_bd_posts_hash_ment,
               file = paste0(output_path, Sys.Date(), "_bd_ct-some_hash-ment_all", ".csv"), 
               na = "NULL", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_bd_posts_hashtag_unpiv,
               file = paste0(output_path, Sys.Date(), "_bd_ct-some_hash", ".csv"), 
               na = "NULL", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_bd_posts_mention_unpiv,
               file = paste0(output_path, Sys.Date(), "_bd_ct-some_ment", ".csv"), 
               na = "NULL", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_bd_mention_list,
               file = paste0(output_path, Sys.Date(), "_bd_ct-some_ment_list", ".csv"), 
               na = "NULL", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_bd_hashtag_list,
               file = paste0(output_path, Sys.Date(), "_bd_ct-some_hash_list", ".csv"), 
               na = "NULL", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_bd_posts_missing_art,
               file = paste0(paths$data_interim, "/", Sys.Date(), "_missing-art", ".csv"), 
               na = "NULL", 
               row.names = FALSE,
               fileEncoding = "UTF-8")


    
    
    
    # End message    
    print(paste0("Everything done. Data saved at ", output_path))
    
    
    
    
    
    # end this shit
    end_time <- Sys.time()
    cat("End Script:", format(Sys.time(), "%H:%M:%S"), "\n", 
        "Differenz: ", difftime(end_time, start_time, units = "min"), "min.", "\n") 
    
    
    