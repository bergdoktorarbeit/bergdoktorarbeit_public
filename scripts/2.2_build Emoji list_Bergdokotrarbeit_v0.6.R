rm(list = ls()) # Remove all stuff in Environment

start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")

# set working dirctory
setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

source("scripts/init_v0.6.R")




#Emoji Data

  #get data
    csv_desc_raw <- read.csv(paste0(paths$ctdata, 
                                    "/Ouput/WK BD Data/", 
                                    "bd_combined_meta_interim.csv"), 
                             stringsAsFactors = FALSE,
                             sep = ";") %>% 
                    select(c("post_index",
                             "acc",
                             "user_name",
                             "post_descr")) 
    

    csv_emoji_dictionary_raw <- read.csv(paste0(paths$data_raw, 
                                                "/supplementary_data/Smileys/More Emojis/emojidictionary-master/", 
                                                "emoji_dictionary.csv"), 
                                         stringsAsFactors = FALSE, #NOTE: The dictionary comes from https://lyons7.github.io/portfolio/2017-10-04-emoji-dictionary/
                                         encoding="UTF-8") %>%
                                select(index = Number,
                                       emoji_name = Name,
                                       r_encoding = R_Encoding,
                                       codepoint = Codepoint)
    
    csv_emoji_unicode_raw <- read.xlsx(paste0(paths$data_raw, 
                                              "/supplementary_data/Smileys/More Emojis/", 
                                              "Emojidata from Unicode.org.xlsx"), 
                                       startRow = 1, #NOTE: This is selfmade from the Unicode.org!
                                       check.names = FALSE)
  
    
  
  
  #post_descr Emojis extraction
    emoji_vector <- str_extract_all(csv_desc_raw$post_descr, "<[<\\w\\+>]+>") %>% 
      as.list()
    
    emoji_vector_num <- as.numeric(do.call(rbind, lapply(emoji_vector, function(x) length(x))))
    
    emoji_character <- as.character()
    for (i in seq_along(emoji_vector)) {
      emoji_character[i] <- paste(emoji_vector[[i]], collapse = " ")
      #print(i)
    }
    
  
  #build table
    df_bd_posts_emojis <- csv_desc_raw %>% #build standart table
      mutate(post_descr_length = str_length(post_descr), 
             post_descr_word_count = sapply(strsplit(post_descr, " "), length),
             post_emoji_num = emoji_vector_num,
             post_emoji_list = emoji_vector,
             post_emoji_string = emoji_character,
             post_emoji_length = str_length(post_emoji_string), #TODO: THis makes no sense!
             post_emoji_word_rate = round(post_emoji_num / post_descr_word_count * 100, 2),
             post_emoji_descr_rate = round(post_emoji_length / post_descr_length * 100, 2)  ) %>% 
      select(all_of(select_colum_emoji) ) 
    
    
    df_bd_posts_emojis_unpiv <- df_bd_posts_emojis %>% #buil unpivot table #NOTE: Use this table to translate to emojis
      select(post_index,
             user_name) %>% 
      bind_cols(
        as.data.frame(
          str_split_fixed(
            as.character(df_bd_posts_emojis$post_emoji_string),
            " ",
            df_bd_posts_emojis$post_emoji_num
          )
        )
      ) %>%
      pivot_longer(!post_index & !user_name,
                   names_to = "emoji_order",
                   values_to = "emoji_code") %>% 
      apply(2, function(x) gsub("^$|^ $", NA, x)) %>% 
      na.omit(emoji_code) %>% 
      as.data.frame() %>% 
      mutate (
        emoji_order = gsub("V", "", emoji_order),
        emoji_code = gsub("><", " ", emoji_code),
        emoji_code = gsub("<", "", emoji_code),
        emoji_code = gsub(">", "", emoji_code))
    
    
    df_bd_emoji_list <- data.frame(matrix(unlist(emoji_vector), #build hashtag list
                                                    nrow=length(unlist(emoji_vector)), 
                                                    byrow=TRUE)) %>%
      select(emoji = matrix.unlist.emoji_vector...nrow...length.unlist.emoji_vector....) %>%
      mutate(emoji = tolower(as.character(emoji))) %>% 
      count(emoji) %>% # neue Spalte mit dem Namen n entsteht
      arrange(desc(n)) %>% 
      select(emoji,
             hash_num = n)
    
    rm(emoji_vector)
    
      
      
  #Build table for emoji_dictionary
    meta_unicode_emoji_dictionary <- csv_emoji_unicode_raw %>%
      left_join(csv_emoji_dictionary_raw, by = "codepoint") %>% 
      select(unicode_index = index.x,
             dictionary_index = index.y,
             everything(),
             unicode_encoding = codepoint,
             -emoji_name) 

    
    cat("I am working and doing shit \n")


#Save the data
  output_path <- paste0(paths$ctdata, "/Ouput/WK BD Data/")    
  
  
  write.csv2(df_bd_posts_emojis,
             file = paste0(output_path, "bd_combined_emojis_interim_", Sys.Date(), ".csv"), 
             na = "NULL", 
             row.names = FALSE,
             fileEncoding = "UTF-8")
  
  write.csv2(df_bd_posts_emojis_unpiv,
             file = paste0(output_path, "bd_combined_emojis_unpiv_interim_", Sys.Date(), ".csv"), 
             na = "NULL", 
             row.names = FALSE,
             fileEncoding = "UTF-8")
  
  write.csv2(df_bd_emoji_list,
             file = paste0(output_path, "bd_combined_emojis_list_interim_", Sys.Date(), ".csv"), 
             na = "NULL", 
             row.names = FALSE,
             fileEncoding = "UTF-8")
  
  write.xlsx(meta_unicode_emoji_dictionary, #NOTE : Save as xlsx to keep the emojis visible
             file = paste0(output_path, "meta_unicode_emoji_dictionary_", Sys.Date(), ".xlsx"), 
             na = "NULL", 
             rowNames = FALSE,
             fileEncoding = "UTF-8")




#FOR LATER
#    library(emo)
#    tweets %>%
#        mutate(emoji = ji_extract_all(text)) %>%
#        unnest(cols = c(emoji)) %>%
#        count(emoji, sort = TRUE) %>%
#        top_n(10)
  
  
  
  
  
# save message  
cat("Data saved in: ", output_path,  "\n")


# end this shit
end_time <- Sys.time()
cat("End Script:", format(Sys.time(), "%H:%M:%S"), "\n", 
    "Differenz: ", difftime(end_time, start_time, units = "min"), "min.", "\n") 



