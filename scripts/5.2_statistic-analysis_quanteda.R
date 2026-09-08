# Remove all stuff in Environment
rm(list = ls()) 

# start timer
start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")






# set working dirctory
#setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

source("init_v0.6.R")



######################
#### Prepare Data ####
######################


# get data
cat("Data load from:\n", paths$data_processed, "and \n",
    paths$data_raw, "\n")


# get bd_ct-some_all.csv
  files <- list.files(
    paths$data_processed,
    pattern = ".csv",
    full.names = TRUE)
  
  file_ct_names <- files[grepl("bd_ct-some_all", files)] 


# get Accounts - Art.xlsx
  files <- list.files(
    paste0(paths$ctdata, "/Input"),
    pattern = ".xlsx",
    full.names = TRUE)
  
  file_acc_names <- files[grepl("Accounts - Art", files)] 
  
# get dictionary Data
  files <- list.files(
    paste0(paths$data_raw, "/supplementary_data/Sonstiges"),
    pattern = ".txt",
    full.names = TRUE)
  
  file_senti_names <- files[grepl("SentiWS", files)] 
  file_savedsearch_names <- files[grepl("savedsearch", files)] 
  


# Inbound file data
  df_ct_all_raw <- read.csv(file_ct_names, 
                            stringsAsFactors = FALSE,
                            sep = ";",
                            encoding="UTF-8") #todo: Maybe add select to filter everything but the text and 1 unique identifier.
  
  
  df_acc_all_raw <- read.xlsx(file_acc_names,
                              sheet = 1,
                              startRow = 1,
                              detectDates = TRUE) %>% 
    select(1:3,
           -Account)
  
  # Sentiment Dikt data
  dikt_pos_raw <- read_lines(file_senti_names, # postitive
                             skip = 42) %>% 
    as.data.frame()
  
  dikt_neg_raw <- read_lines(file_senti_names[1], # negative
                             skip = 42) %>%
    as.data.frame()
  
  # Keywords Dikt data
  dikt_saveds_all_raw <- read_lines(file_savedsearch_names, # all words
                                    skip = 16)
  
  dikt_saveds_bd_raw <- read_lines(file_savedsearch_names, # bergdoktor series words
                                   skip = 16,
                                   n_max = 6)
  
  dikt_saveds_roles_raw <- read_lines(file_savedsearch_names, # bergdoktor roles words
                                   skip = 22,
                                   n_max = 14)
  
  dikt_saveds_actors_raw <- read_lines(file_savedsearch_names, # bergdoktor actor words
                                      skip = 36,
                                      n_max = 16)
  
  dikt_saveds_screenl_raw <- read_lines(file_savedsearch_names, # bergdoktor screenlocations words
                                       skip = 52,
                                       n_max = 2)
  
  dikt_saveds_spaces_raw <- read_lines(file_savedsearch_names, # Wilderkaiser spaces words
                                        skip = 54,
                                        n_max = 16)
  
  dikt_saveds_dmo_raw <- read_lines(file_savedsearch_names, # Wilderkaiser Destination marketing hashtags & words
                                       skip = 70,
                                       n_max = 7)
  
  dikt_saveds_misc_raw <- read_lines(file_savedsearch_names, # Miscellaneous words
                                    skip = 77,
                                    n_max = 5)


# build first table
  df_raw <- df_ct_all_raw %>% 
    left_join(df_acc_all_raw,
              by = join_by(user_name == User.Name) ) %>% 
    filter(Art %in% c("Screentourist", "Destination", "Produktion")) %>% 
    mutate(post_descr = clean_text(post_descr)) %>%
    mutate(score_num_group = if_else(score_num >= 1, 1, 
                                     if_else(score_num >= 0, 0,
                                             if_else(score_num < 0, -1, NA)
                                             )
                                     )
           )
  
  
##############################
#### Prepare Corpus & DFM ####
##############################


# build corpus
corpus_1 <- corpus(df_raw, text_field = 'post_descr')
    # Types sind in unserem Fall einzigartige Begriffe (zB 1x "well" in "well earned & well deserved")
    # Tokens sind Wörter (oder: Begriffe im Kontext, zB 2x "well" in "well earned & well deserved")


# Analize Tokens
corpus_2 <- tokens(corpus_1,
                   what = "word", # Word boundaries. This is the default.
                   remove_punct = TRUE, # remove all characters in the Unicode "Punctuation" [P] class, 
                                        # with exceptions for those used as prefixes for valid social media tags if preserve_tags = TRUE
                   #preserve_tags = TRUE, # works with remove_punct
                   remove_symbols = TRUE, # no symbols: all characters in the Unicode "Symbol" ⁠[S]⁠ class
                   remove_numbers = TRUE, # no numbers: tokens that consist only of numbers, but not words that start with digits, e.g. ⁠2day⁠
                   remove_url = TRUE, # no URLS bgeinning with http(S)
                   remove_separators = TRUE, # no seperator: (Unicode "Separator" ⁠[Z]⁠ and "Control" ⁠[C]⁠ categories
                   split_hyphens = FALSE, # do not split words that are connected by hyphenation characters in between words, e.g. "self-aware"
                   include_docvars = TRUE
                   )



# Remove Stop Words and work just with word stems
  # Add multiphrase words to corpus
  corpus_2 <- corpus_2 %>% 
    tokens_compound(pattern = phrase(list_multiword_all), # OR use: list_multiword_saved
                    concatenator = "_")
    
  # Corpus with stemming
  corpus_3 <- corpus_2 %>%
    tokens_remove(stopwords("de")) %>% # no stopwords de
    tokens_remove(stopwords("en")) %>% # no stopwords eng
    tokens_remove("dass") %>% 
    tokens_wordstem(language = "de") %>% # only word stems. Problem: it makes "Kaiser" into "Kais". Use Corpus_3.1 without stemming
    tokens_tolower() 
  
  
  # Corpus without stemming
  corpus_3.1 <- corpus_2 %>% 
    tokens_remove(stopwords("de")) %>% # no stopwords de
    tokens_remove(stopwords("en")) %>%  # no stopwords eng
    tokens_remove("dass") %>% 
    tokens_tolower() 
  
  
# Building dictionary
  #clean dictionry
  dikt_pos <- dikt_pos_raw%>% 
    select(pos = 1) %>% 
    mutate(pos = str_remove(pos, "\\|.+"))
  
  dikt_neg <- dikt_neg_raw%>% 
    select(neg = 1) %>% 
    mutate(neg = str_remove(neg, "\\|.+"))

  # making dikt
  dikt <- dictionary(list(positiv = as.list(dikt_pos),
                        negativ = as.list(dikt_neg) ) )
  
  dikt_saveds <- dictionary(list(BERGDOKTOR = as.list(dikt_saveds_bd_raw),
                                 ROLES = as.list(dikt_saveds_roles_raw),
                                 ACTORS = as.list(dikt_saveds_actors_raw),
                                 SCREENLOCATIONS = as.list(dikt_saveds_screenl_raw),
                                 SPACES = as.list(dikt_saveds_spaces_raw),
                                 DMO = as.list(dikt_saveds_dmo_raw),
                                 MISC = as.list(dikt_saveds_misc_raw)),                                
                            tolower = TRUE#,
                            #separator = "_"
                            )
  
  dikt_keyw <- dictionary(list(BERGDOKTOR = as.list(dikt_saveds_bd_raw,
                                                    "Bergdoktors"),
                               ROLES = as.list(dikt_saveds_roles_raw, 
                                               "Dr Martin Gruber",
                                               "Dr Gruber",
                                               "Dr Roman Melchinger",
                                               "Dr Melchinger",
                                               "Dr Alexander Kahnweiler",
                                               "Dr Kahnweiler",
                                               "Vera Fendrich",
                                               "Dr Vera Fendrich",
                                               "Dr Fendrich",
                                               "Linn Kemper",
                                               "Linn",
                                               "Kemper",
                                               "Martin"),
                               ACTORS = as.list(dikt_saveds_actors_raw,
                                                "Andrea Gerhard",
                                                "Ronja",
                                                "Hans"),
                               SCREENLOCATIONS = as.list(dikt_saveds_screenl_raw,
                                                         "Praxis",
                                                         "Arztpraxis",
                                                         "Bergdokorpraxis",
                                                         "Krankenhaus",
                                                         "Wilder Kaiser Gasthof",
                                                         "Dorfplatz",
                                                         "Bergdoktorhaus",
                                                         "Drehorten"),
                               DESTINATION = as.list(dikt_saveds_spaces_raw,
                                                     "Reith",
                                                     "Reither",
                                                     "Kitzbühl",
                                                     "Kitzbühel",
                                                     "Kitzbüheler",
                                                     "Rübezahl Alm",
                                                     "Scheffau",
                                                     "Kaiser",
                                                     "Kaisers",
                                                     "Wilde Kaiser",
                                                     "Wilden Kaiser",
                                                     "Tiroler",
                                                     "Aurach",
                                                     "Hintersteiner",
                                                     "Hartkaiser",
                                                     "Astberg",
                                                     "Alm",
                                                     "Hohe Salve",
                                                     "Salve"),
                               DMO = as.list(dikt_saveds_dmo_raw,
                                             "mehr reith"),
                               PRODUCTION = as.list("ZDF",
                                                    "ORF",
                                                    "Staffel",
                                                    "Season",
                                                    "Episode",
                                                    "TV",
                                                    "Dreharbeiten",
                                                    "Drehtag",
                                                    "Serie",
                                                    "Series",
                                                    "Casting",
                                                    "Regie",
                                                    "Dreh",
                                                    "Gedreht",
                                                    "Schauspieler",
                                                    "Film",
                                                    "Winterspecial"),
                               SCREENTOURISMUS = as.list(dikt_saveds_misc_raw,
                                                         "Fantag")
                               ),                                
                          tolower = TRUE
    )
  
  


# Building a document feature Matrix
    # Eine DFM enthält alle Types (einzigartige Begriffe) als Spalten und alle Dokumente (Texte) als Zeilen.
    # In den Zellen steht die jeweilige Zahl, wie oft ein Type im jeweiligen Dokument vorkommt.
  
  choosen_corpus <- c(#corpus_3 
                      corpus_3.1
                      )
  
  dfm_4 <- dfm(choosen_corpus)

  dfm_4_senti <- dfm_lookup(dfm_4, 
                            dictionary = dikt,
                            capkeys = TRUE)
  
  # making the dfm for the multiword analysis with tokens() instead of corpus() 
  tokens_1 <-  tokens(df_raw$post_descr,
           what = "word", # Word boundaries. This is the default.
           remove_punct = TRUE, # remove all characters in the Unicode "Punctuation" [P] class,
           # with exceptions for those used as prefixes for valid social media tags if preserve_tags = TRUE
           #preserve_tags = TRUE, # works with remove_punct
           remove_symbols = TRUE, # no symbols: all characters in the Unicode "Symbol" ⁠[S]⁠ class
           remove_numbers = TRUE, # no numbers: tokens that consist only of numbers, but not words that start with digits, e.g. ⁠2day⁠
           remove_url = TRUE, # no URLS bgeinning with http(S)
           remove_separators = TRUE, # no seperator: (Unicode "Separator" ⁠[Z]⁠ and "Control" ⁠[C]⁠ categories
           split_hyphens = FALSE, # do not split words that are connected by hyphenation characters in between words, e.g. "self-aware"
           include_docvars = TRUE) %>%
    tokens_remove(stopwords("de")) %>% # no stopwords de
    tokens_remove(stopwords("en")) %>%  # no stopwords eng
    tokens_tolower() 
  
  
  dfm_4_saveds <- tokens_1 %>%
    tokens_lookup(dictionary = dikt_saveds, 
                  exclusive = TRUE, # turn off if you want all the words not just the dikt
                  capkeys = TRUE) %>%
    dfm()  
  
  dfm_4_keywords <- tokens_1 %>%
    tokens_lookup(dictionary = dikt_keyw, 
                  exclusive = TRUE, # turn off if you want all the words not just the dikt
                  capkeys = FALSE) %>%
    dfm()
  
  
# use dictionary to put together words
  dfm_4.1 <- dfm_4 %>% 
    dfm_replace(pattern = c("Wilden Kaiser", "Wilder Kaiser", "Wilde Kaiser", "wilden_kaiser"),
                replacement = c("wilder_kaiser", "wilder_kaiser", "wilder_kaiser", "wilder_kaiser") ) %>% 
    dfm_replace(pattern = c("hintersteiner", "hintersteinersee", "hintersteinerseev"),
                replacement = c("hintersteiner_see", "hintersteiner_see", "hintersteiner_see") ) %>%
    dfm_replace(pattern = c("winterspecial", "winter special"),
                replacement = c("winterspecial", "winterspecial") )


# weighted texts after text length
  dfm_5 <- dfm_weight(dfm_4.1,
                     scheme = c("count" # integer feature count (default when a dfm is created)
                       #"prop" # Between 0 and 1: the proportion of the feature counts of total feature counts (aka relative frequency),
                     ) )
  
  dfm_5_senti <- dfm_weight(dfm_4_senti,
                            scheme = c("count") )
  
  dfm_5_saveds <- dfm_weight(dfm_4_saveds,
                            scheme = c("count") )
  
  dfm_5_keywords <- dfm_weight(dfm_4_keywords,
                             scheme = c("count") )
  




##################  
#### Analysis ####
##################


# Find the most common word of all the text
  top_num <- 20
  
  vec_5.1_top_doc <- topfeatures(dfm_5,
                                n = top_num,
                                scheme = c("docfreq") )
  vec_5.1_top_doc
  
  vec_5.2_top_count <- topfeatures(dfm_5,
                                   n = top_num,
                                   scheme = c("count") )
  vec_5.2_top_count

# find the top negative and postive of all the text
  vec_5.1_senti_top_doc <- topfeatures(dfm_5_senti,
                                       n = top_num,
                                       scheme = c("docfreq") )
  vec_5.1_senti_top_doc
  
  vec_5.2_senti_top_count <- topfeatures(dfm_5_senti,
                                         n = top_num,
                                         scheme = c("count") )
  vec_5.2_senti_top_count


# find the top saved search of all the text
  vec_5.1_saveds_top_doc <- topfeatures(dfm_5_saveds,
                                       n = top_num,
                                       scheme = c("docfreq") )
  vec_5.1_saveds_top_doc
  
  vec_5.2_saveds_top_count <- topfeatures(dfm_5_saveds,
                                         n = top_num,
                                         scheme = c("count") )
  vec_5.2_saveds_top_count

    
# find the top saved search of all the text
  vec_5.1_keywords_top_doc <- topfeatures(dfm_5_keywords,
                                        n = top_num,
                                        scheme = c("docfreq") )
  vec_5.1_keywords_top_doc
  
  vec_5.2_keywords_top_count <- topfeatures(dfm_5_keywords,
                                          n = top_num,
                                          scheme = c("count") )
  vec_5.2_keywords_top_count
  

# Filter for columns and words

  # Top features for different groups?
  filter_art <- c("Screentourist"
                  ,"Destination"
                  ,"Produktion")
  
  
  for (i in 1:length(filter_art) ){ # normal words in groups
  dfm_name <- paste0("dfm_5.3_", filter_art[i])
  
  assign(dfm_name, 
         dfm_subset(dfm_5, Art == filter_art[i]) 
         )
  
  vec_name <- paste0("vec_5.3_", filter_art[i], "_top_count")
  
  assign(vec_name,
         topfeatures(dfm_subset(dfm_5, Art == filter_art[i]),
                     n = top_num,
                     scheme = c("count")
                     )
         )
  }
  
  for (i in 1:length(filter_art) ){ # Sentiments in groups
    dfm_name <- paste0("dfm_5.4_senti_", filter_art[i])
    
    assign(dfm_name, 
           dfm_subset(dfm_5_senti, Art == filter_art[i])
           )
    
    # vec_name <- paste0("vec_5.4_senti_", filter_art[i], "_top_count")
    # 
    # assign(vec_name,
    #        topfeatures(dfm_subset(dfm_5, Art == filter_art[i]),
    #                    n = top_num,
    #                    scheme = c("count")
    #                    )
    #      )
  }
  
  # find the top sentiments of the different groups
    # Screentouristen
      vec_5.1_senti_scr_top_doc <- topfeatures(dfm_5.4_senti_Screentourist,
                                            n = top_num,
                                            scheme = c("docfreq") )
      vec_5.1_senti_scr_top_doc
      
      vec_5.2_senti_scr_top_count <- topfeatures(dfm_5.4_senti_Screentourist,
                                              n = top_num,
                                              scheme = c("count") )
      vec_5.2_senti_scr_top_count
  
    # Destination
      vec_5.1_senti_des_top_doc <- topfeatures(dfm_5.4_senti_Destination,
                                               n = top_num,
                                               scheme = c("docfreq") )
      vec_5.1_senti_des_top_doc
      
      vec_5.2_senti_des_top_count <- topfeatures(dfm_5.4_senti_Destination,
                                                 n = top_num,
                                                 scheme = c("count") )
      vec_5.2_senti_des_top_count
      
    # Produktion
      vec_5.1_senti_pro_top_doc <- topfeatures(dfm_5.4_senti_Produktion,
                                               n = top_num,
                                               scheme = c("docfreq") )
      vec_5.1_senti_pro_top_doc
      
      vec_5.2_senti_pro_top_count <- topfeatures(dfm_5.4_senti_Produktion,
                                                 n = top_num,
                                                 scheme = c("count") )
      vec_5.2_senti_pro_top_count
  
  
  
    # Gruppieren
    dfm_7_groupart_all <- dfm_group(dfm_5, groups = Art)
    
    dfm_7_groupscore_all <- dfm_group(dfm_5, groups = score_num_group)
    
    
    
    
    
    
    
    # Oder für Begriffe wie Bergdoktor
    search_pattern <- "zdf*"
    
    dfm_6_pattern <- dfm_select(#dfm_5,  
      dfm_7_groupart_all, 
      selection = "keep", 
      pattern = search_pattern)
    
    vec_6_pattern_top_count <- topfeatures(dfm_6_pattern,
                                           n = top_num,
                                           scheme = c(#"doc"
                                             "count"
                                           )
    )
    vec_6_pattern_top_count
    
    # Optional analysis  
    # sum(featfreq(dfm_6_pattern)) # calculate the number of occurrences of the words
    # 
    # 
    # df_8_pattern_final <- dfm_6_pattern %>% # make it into a df
    #   convert(to = 'data.frame') %>%
    #   as_tibble()
    # df_8_pattern_final

    
    
    
    
    
    
  
# Making a wordcloud
      #TODO: Change the number of min_size and max_size to create
      # Number of entries changes with the resolution of the monitor!!! WTF!
      # Has to be saved MANUALLY!
  word_num = 100
    
  textplot_wordcloud(dfm_5, # all
                     max_words = word_num,
                     random_order = FALSE,
                     min_size = 1,#0.5,
                     max_size = 10,#6,
                     min_count = 4,
                     rotation = 0,
                     color = rev(RColorBrewer::brewer.pal(10, "Spectral"))
                     )
  
  textplot_wordcloud(dfm_5.3_Screentourist, # scr
                     max_words = word_num,
                     random_order = FALSE,
                     min_size = 1,#0.5,
                     max_size = 10,#6,
                     min_count = 2,
                     rotation = 0,
                     color = rev(RColorBrewer::brewer.pal(10, "Spectral"))
                     )
  
  textplot_wordcloud(dfm_5.3_Destination, # des
                     max_words = word_num,
                     random_order = FALSE,
                     min_size = 1,#0.5,
                     max_size = 10,#6,
                     min_count = 2,
                     rotation = 0,
                     color = rev(RColorBrewer::brewer.pal(10, "Spectral"))
                     )
  
  textplot_wordcloud(dfm_5.3_Produktion, # pro
                     max_words = word_num,
                     random_order = FALSE,
                     min_size = 1,#0.5,
                     max_size = 10,#6, 
                     min_count = 2,
                     rotation = 0,
                     color = rev(RColorBrewer::brewer.pal(10, "Spectral"))
                     )
  
  
  textplot_wordcloud(dfm_7_groupart_all, # all
                     max_words = word_num,
                     random_order = FALSE,
                     min_size = 1,#0.5,
                     max_size = 8,#6,
                     min_count = 2,
                     rotation = 0,
                     color = group_color,
                     comparison = TRUE
                     )
  
  textplot_wordcloud(dfm_7_groupscore_all, # all
                     max_words = word_num,
                     random_order = FALSE,
                     min_size = 1, #0.1, 
                     max_size = 6, #3,
                     min_count = 4,
                     rotation = 0,
                     color = group_color,
                     comparison = TRUE)
  
  
  
  
  
  ######################################  
  #### Preparing tables to be saved ####
  ######################################


# Convert back to data frame
  # normal all table
    df_8_final <- dfm_5 %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      bind_cols(docvars(dfm_5)) %>% 
      bind_cols(df_raw$post_descr) %>% 
      mutate(post_descr = ...6221,
             .keep = c("unused") ) %>%
      select(1,
             6219,
             all_of(select_colum_all),
             6220,
             order(colnames(.))) %>% 
      rename(post_descr_cleaned = post_descr) %>%
      pivot_longer(cols = 29:6221) %>% 
      mutate(token = name,
             token_num = value,
             .keep = c("unused")) %>%
      filter(token_num != 0)
      
    
  # Sentiment Table
    df_8.1_senti_final <- dfm_5_senti %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      bind_cols(docvars(dfm_5)) %>% 
      bind_cols(df_raw$post_descr) %>% 
      mutate(post_descr = ...30,
             .keep = c("unused") ) %>% 
      select(1,
           28,
           all_of(select_colum_all),
           29,
           everything()
           ) %>% 
      rename(post_descr_cleaned = post_descr)
  
  # Saved Search Table
    df_8.2_saveds_final <- dfm_5_saveds %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      bind_cols(docvars(dfm_5)) %>% 
      bind_cols(df_raw$post_descr) %>% 
      mutate(post_descr = ...35,
             .keep = c("unused") ) %>% 
      select(1,
             33,
             all_of(select_colum_all),
             34,
             order(colnames(.))
             ) %>% 
      rename(post_descr_cleaned = post_descr)
    
  # Normal Table by group
    df_8_scr_final <- dfm_5.3_Screentourist %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      bind_cols(docvars(dfm_5.3_Screentourist)) %>% 
      bind_cols(df_raw %>% filter(Art == "Screentourist") %>% select(post_descr)) %>% 
      select(1,
             6219,
             all_of(select_colum_all),
             6220,
             order(colnames(.))) %>% 
      rename(post_descr_cleaned = post_descr) %>%
      pivot_longer(cols = 29:6221) %>% 
      mutate(token = name,
             token_num = value,
             .keep = c("unused")) %>%
      filter(token_num != 0)
    
    
    df_8_des_final <- dfm_5.3_Destination %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      bind_cols(docvars(dfm_5.3_Destination)) %>% 
      bind_cols(df_raw %>% filter(Art == "Destination") %>% select(post_descr)) %>% 
      select(1,
             6219,
             all_of(select_colum_all),
             6220,
             order(colnames(.))) %>% 
      rename(post_descr_cleaned = post_descr) %>%
      pivot_longer(cols = 29:6221) %>% 
      mutate(token = name,
             token_num = value,
             .keep = c("unused")) %>%
      filter(token_num != 0)
    
      
    df_8_pro_final <- dfm_5.3_Produktion %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      bind_cols(docvars(dfm_5.3_Produktion)) %>% 
      bind_cols(df_raw %>% filter(Art == "Produktion") %>% select(post_descr)) %>% 
      select(1,
             6219,
             all_of(select_colum_all),
             6220,
             order(colnames(.))) %>% 
      rename(post_descr_cleaned = post_descr) %>%
      pivot_longer(cols = 29:6221) %>% 
      mutate(token = name,
             token_num = value,
             .keep = c("unused")) %>%
      filter(token_num != 0)
    
    
  # Sentiment Tables by group
    df_8.1_senti_scr_final <- dfm_5.4_senti_Screentourist %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      bind_cols(docvars(dfm_5.4_senti_Screentourist)) %>% 
      bind_cols(df_raw %>% filter(Art == "Screentourist") %>% select(post_descr)) %>% 
      select(1,
             28,
             all_of(select_colum_all),
             29,
             order(colnames(.)))
    
    df_8.1_senti_des_final <- dfm_5.4_senti_Destination %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      bind_cols(docvars(dfm_5.4_senti_Destination)) %>% 
      bind_cols(df_raw %>% filter(Art == "Destination") %>% select(post_descr)) %>% 
      select(1,
             28,
             all_of(select_colum_all),
             29,
             order(colnames(.)))
    
    df_8.1_senti_pro_final <- dfm_5.4_senti_Produktion %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      bind_cols(docvars(dfm_5.4_senti_Produktion)) %>% 
      bind_cols(df_raw %>% filter(Art == "Produktion") %>% select(post_descr)) %>% 
      select(1,
             28,
             all_of(select_colum_all),
             29,
             order(colnames(.)))
    
  # Keyword tables
    df_8.1_keyword_final <- dfm_5_keywords %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      bind_cols(docvars(dfm_5)) %>% 
      bind_cols(df_raw$post_descr) %>% 
      mutate(post_descr = ...36,
             .keep = c("unused") ) %>% 
      select(1,
             34,
             all_of(select_colum_all),
             35,
             order(colnames(.))
             ) %>% 
      rename(post_descr_cleaned = post_descr)
  
  
  # grouped tables
    df_8.2_groupart_all_final <- dfm_7_groupart_all %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      select(art_group = doc_id,
             order(colnames(.)))
    
    
    df_8.2_groupscore_all_final <- dfm_7_groupscore_all %>%
      convert(to = 'data.frame') %>% 
      as_tibble() %>% 
      select(score_grouped = doc_id,
             order(colnames(.)))
  
    
  # Top docs table
    df_8.3_top_doc_final <- vec_5.1_top_doc %>% 
      as.data.frame() %>% 
      rename(doc_count = '.') %>% 
      rownames_to_column(var = "Words")
    
    df_8.3_top_count_final <- vec_5.2_top_count %>% 
      as.data.frame() %>% 
      rename(word_count = '.') %>% 
      rownames_to_column(var = "Words")
    
    df_8.3_senti_top_doc_final <- vec_5.1_senti_top_doc %>% 
      as.data.frame() %>% 
      rename(doc_count = '.') %>% 
      rownames_to_column(var = "Sentiments")
    
    df_8.3_senti_top_count_final <- vec_5.2_senti_top_count %>% 
      as.data.frame() %>% 
      rename(word_count = '.') %>%  
      rownames_to_column(var = "Sentiments")
    
    df_8.3_saveds_top_doc_final <- vec_5.1_saveds_top_doc %>% 
      as.data.frame() %>% 
      rename(doc_count = '.') %>% 
      rownames_to_column(var = "Saved Search")
    
    df_8.3_saveds_top_count_final <- vec_5.2_saveds_top_count %>% 
      as.data.frame() %>% 
      rename(word_count = '.') %>% 
      rownames_to_column(var = "Saved Search")
 
  # Top docs in groups table
    df_8.4_top_count_scr_final <- vec_5.3_Screentourist_top_count %>% 
      as.data.frame() %>% 
      rename(word_count = '.') %>%  
      rownames_to_column(var = "Scr Words")
    
    df_8.4_top_count_des_final <- vec_5.3_Destination_top_count %>% 
      as.data.frame() %>% 
      rename(word_count = '.') %>%
      rownames_to_column(var = "Des Words")
    
    df_8.4_top_count_pro_final <- vec_5.3_Produktion_top_count %>% 
      as.data.frame() %>% 
      rename(word_count = '.') %>%
      rownames_to_column(var = "Pro Words")
    
    # Top docs & count sentiments in groups table
      # Screentouristen
      df_8.5_top_count_scr_final <- vec_5.2_senti_scr_top_count %>% 
        as.data.frame() %>% 
        rename(word_count = '.') %>%  
        rownames_to_column(var = "Scr Words")
      
      df_8.5_top_doc_scr_final <- vec_5.1_senti_scr_top_doc %>% 
        as.data.frame() %>% 
        rename(doc_count = '.') %>%  
        rownames_to_column(var = "Scr Words")
      
      # Destination
      df_8.5_top_count_des_final <- vec_5.2_senti_des_top_count %>% 
        as.data.frame() %>% 
        rename(word_count = '.') %>%
        rownames_to_column(var = "Des Words")
      
      df_8.5_top_doc_des_final <- vec_5.1_senti_des_top_doc %>% 
        as.data.frame() %>% 
        rename(doc_count = '.') %>%
        rownames_to_column(var = "Des Words")
      
      # Produktion
      df_8.5_top_count_pro_final <- vec_5.2_senti_pro_top_count %>% 
        as.data.frame() %>% 
        rename(word_count = '.') %>%
        rownames_to_column(var = "Pro Words")
      
      df_8.5_top_doc_pro_final <- vec_5.1_senti_pro_top_doc %>% 
        as.data.frame() %>% 
        rename(doc_count = '.') %>%
        rownames_to_column(var = "Pro Words")
      
      
    # Top docs & count keywords
      df_8.5_top_count_keyw_final <- vec_5.2_keywords_top_count %>% 
        as.data.frame() %>% 
        rename(word_count = '.') %>%
        rownames_to_column(var = "Words")
      
      df_8.5_top_doc_keyw_final <- vec_5.1_keywords_top_doc %>% 
        as.data.frame() %>% 
        rename(doc_count = '.') %>%
        rownames_to_column(var = "Words")
  
  
  
  # Erase stuff
    rm(files,
         file_acc_names, 
         file_ct_names, 
         file_savedsearch_names, 
         file_senti_names)
    rm(df_acc_all_raw, df_ct_all_raw)
    rm(dikt_neg_raw, 
       dikt_pos_raw,
       dikt_saveds_actors_raw,
       dikt_saveds_bd_raw,
       dikt_saveds_dmo_raw,
       dikt_saveds_roles_raw,
       dikt_saveds_screenl_raw,
       dikt_saveds_spaces_raw,
       dikt_saveds_misc_raw,
       dikt_saveds_all_raw)
    rm(corpus_1, 
       corpus_2,
       corpus_3,
       corpus_3.1)
    rm(dikt, dikt_neg, dikt_pos, dikt_saveds, dikt_keyw)
    rm(tokens_1)
    rm(dfm_4, dfm_4_senti, dfm_4_saveds, dfm_4_keywords, dfm_4.1)
    rm(dfm_5, dfm_5_senti, dfm_5_saveds, dfm_5_keywords, 
       dfm_5.3_Screentourist, dfm_5.3_Destination, dfm_5.3_Produktion,
       dfm_5.4_senti_Screentourist, dfm_5.4_senti_Destination, dfm_5.4_senti_Produktion)
    rm(dfm_6_pattern, 
       dfm_7_groupart_all, dfm_7_groupscore_all)
    rm(vec_6_pattern_top_count,
       vec_5.1_keywords_top_doc,
       vec_5.2_keywords_top_count,
       vec_5.1_top_doc,
       vec_5.2_top_count,
       vec_5.1_senti_top_doc,
       vec_5.2_senti_top_count,
       vec_5.2_senti_scr_top_count,
       vec_5.2_senti_des_top_count,
       vec_5.2_senti_pro_top_count,
       vec_5.1_senti_scr_top_doc,
       vec_5.1_senti_des_top_doc,
       vec_5.1_senti_pro_top_doc,
       vec_5.1_saveds_top_doc,
       vec_5.2_saveds_top_count,
       vec_5.3_Screentourist_top_count,
       vec_5.3_Destination_top_count,
       vec_5.3_Produktion_top_count)
    rm(dfm_name, vec_name, i, top_num, word_num, filter_art, search_pattern, choosen_corpus)

    
    
    
  ##################################  
  #### Save table to hard drive ####
  ##################################
    
  output_path <- paths$data_processed
  
  cat("Save data in \n", output_path)
    
    
  # Save cvs
    # dfm standart table
    write.csv2(df_8_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_dfm_all", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    
    # dfm standart table in groups
    write.csv2(df_8_scr_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_dfm_scr", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_8_des_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_dfm_des", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_8_pro_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_dfm_pro", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    
    # dfm sentiment table all
    write.csv2(df_8.1_senti_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_senti_all", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    
    # dfm sentiment table in groups
    write.csv2(df_8.1_senti_scr_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_senti_scr", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_8.1_senti_des_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_senti_des", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    write.csv2(df_8.1_senti_pro_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_senti_pro", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    
    # dfm keywords all
    write.csv2(df_8.1_keyword_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_keywords_all", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    
    # dfm saved search all
    write.csv2(df_8.2_saveds_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_saveds_all", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    
    # dfm grouped Art all
    write.csv2(df_8.2_groupart_all_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_groupart_all", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    
    
    # dfm grouped crowd Tangle score all
    write.csv2(df_8.2_saveds_final, 
               file = paste0(output_path, "/", Sys.Date(),  "_ct_quanteda_groupscore_all", ".csv"), 
               na = "", 
               row.names = FALSE,
               fileEncoding = "UTF-8")
    

    
    
    
  
  ## Saving top words into one excel sheet
  
  # define excel options
  options("openxlsx.borderStyle" = "thin")
  options("openxlsx.numFmt" = "0")
  
  # define headerStyle
  hs1 <- createStyle(
    fgFill = "#748498",
    halign = "CENTER",
    textDecoration = "Bold",
    border = "bottom",
    fontColour = "white"
  )
  
  # create a workbook and add a worksheet
  wb <- createWorkbook()
  addWorksheet(wb, "1 Top docs")
  addWorksheet(wb, "2 Top docs groups")
  addWorksheet(wb, "3 Top docs senti")
  addWorksheet(wb, "4 Top docs senti groups")
  addWorksheet(wb, "5 Top docs saveds")
  addWorksheet(wb, "6 Top docs keywords")

  
  # define Ttables
  table_names <- c("df_8.3_top_doc_final",
                   "df_8.3_top_count_final")
  
  # sheet_col_function(table_names, 1) #NOTE: NOT Working
  
  # Loop through each cross table and add it to the worksheet
  col_start <- 1
  for (table_name in table_names) {
    # Load the cross table
    table_data <- get(table_name)

    # Determine the number of rows and columns in the cross table
    n_rows <- nrow(table_data)
    n_cols <- ncol(table_data)

    # Write the cross table to the worksheet
    writeData(
      wb,
      sheet = 1,
      x = table_data,
      startRow = 1,
      startCol = col_start,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )

    # Increment the col_start variable so that the next table is written to the next column
    col_start <- col_start + n_cols + 2 # Add 2 for the blank column between tables
  }
  
  
  # define Ttables
  table_names <- c("df_8.4_top_count_scr_final",
                   "df_8.4_top_count_des_final",
                   "df_8.4_top_count_pro_final")
  
  # sheet_col_function(table_names, 2) #NOTE: NOT Working
  
  # Loop through each cross table and add it to the worksheet
  col_start <- 1
  for (table_name in table_names) {
    # Load the cross table
    table_data <- get(table_name)

    # Determine the number of rows and columns in the cross table
    n_rows <- nrow(table_data)
    n_cols <- ncol(table_data)

    # Write the cross table to the worksheet
    writeData(
      wb,
      sheet = 2,
      x = table_data,
      startRow = 1,
      startCol = col_start,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )

    # Increment the col_start variable so that the next table is written to the next column
    col_start <- col_start + n_cols + 2 # Add 2 for the blank column between tables
  }
  
  # define Ttables
  table_names <- c("df_8.3_senti_top_doc_final",
                   "df_8.3_senti_top_count_final")
  
  # sheet_col_function(table_names, 3) #NOTE: NOT Working
  
  # Loop through each cross table and add it to the worksheet
  col_start <- 1
  for (table_name in table_names) {
    # Load the cross table
    table_data <- get(table_name)

    # Determine the number of rows and columns in the cross table
    n_rows <- nrow(table_data)
    n_cols <- ncol(table_data)

    # Write the cross table to the worksheet
    writeData(
      wb,
      sheet = 3,
      x = table_data,
      startRow = 1,
      startCol = col_start,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )

    # Increment the col_start variable so that the next table is written to the next column
    col_start <- col_start + n_cols + 2 # Add 2 for the blank column between tables
  }
  
  
  # define Ttables
  table_names <- c("df_8.5_top_doc_scr_final",
                   "df_8.5_top_count_scr_final")
  
  # sheet_col_function(table_names, 4) #NOTE: NOT Working
  
  # Loop through each cross table and add it to the worksheet
  col_start <- 1
  for (table_name in table_names) {
    # Load the cross table
    table_data <- get(table_name)
    
    # Determine the number of rows and columns in the cross table
    n_rows <- nrow(table_data)
    n_cols <- ncol(table_data)
    
    # Write the cross table to the worksheet
    writeData(
      wb,
      sheet = 4,
      x = table_data,
      startRow = 1,
      startCol = col_start,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    # Increment the col_start variable so that the next table is written to the next column
    col_start <- col_start + n_cols + 2 # Add 2 for the blank column between tables
  }
  
  
  # define Ttables
  table_names <- c("df_8.5_top_doc_des_final",
                   "df_8.5_top_count_des_final")
  
  # sheet_col_function(table_names, 4) #NOTE: NOT Working
  
  # Loop through each cross table and add it to the worksheet
  col_start <- 1
  for (table_name in table_names) {
    # Load the cross table
    table_data <- get(table_name)
    
    # Determine the number of rows and columns in the cross table
    n_rows <- nrow(table_data)
    n_cols <- ncol(table_data)
    
    # Write the cross table to the worksheet
    writeData(
      wb,
      sheet = 4,
      x = table_data,
      startRow = n_rows + 4,
      startCol = col_start,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    # Increment the col_start variable so that the next table is written to the next column
    col_start <- col_start + n_cols + 2 # Add 2 for the blank column between tables
  }
  
  
  # define Ttables
  table_names <- c("df_8.5_top_doc_pro_final",
                   "df_8.5_top_count_pro_final")
  
  # sheet_col_function(table_names, 4) #NOTE: NOT Working
  
  # Loop through each cross table and add it to the worksheet
  col_start <- 1
  for (table_name in table_names) {
    # Load the cross table
    table_data <- get(table_name)
    
    # Determine the number of rows and columns in the cross table
    n_rows <- nrow(table_data)
    n_cols <- ncol(table_data)
    
    # Write the cross table to the worksheet
    writeData(
      wb,
      sheet = 4,
      x = table_data,
      startRow = n_rows*2 + 7,
      startCol = col_start,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    # Increment the col_start variable so that the next table is written to the next column
    col_start <- col_start + n_cols + 2 # Add 2 for the blank column between tables
  }
  
  
  # define Ttables
  table_names <- c("df_8.3_saveds_top_doc_final",
                   "df_8.3_saveds_top_count_final")
  
  # sheet_col_function(table_names, 5) #NOTE: NOT Working
  
  # Loop through each cross table and add it to the worksheet
  col_start <- 1
  for (table_name in table_names) {
    # Load the cross table
    table_data <- get(table_name)

    # Determine the number of rows and columns in the cross table
    n_rows <- nrow(table_data)
    n_cols <- ncol(table_data)

    # Write the cross table to the worksheet
    writeData(
      wb,
      sheet = 5,
      x = table_data,
      startRow = 1,
      startCol = col_start,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )

    # Increment the col_start variable so that the next table is written to the next column
    col_start <- col_start + n_cols + 2 # Add 2 for the blank column between tables
  }
  
  
  # define Ttables
  table_names <- c("df_8.5_top_doc_keyw_final",
                   "df_8.5_top_count_keyw_final")
  
  # sheet_col_function(table_names, 1) #NOTE: NOT Working
  
  # Loop through each cross table and add it to the worksheet
  col_start <- 1
  for (table_name in table_names) {
    # Load the cross table
    table_data <- get(table_name)
    
    # Determine the number of rows and columns in the cross table
    n_rows <- nrow(table_data)
    n_cols <- ncol(table_data)
    
    
    # Write the cross table to the worksheet
    writeData(
      wb,
      sheet = 6,
      x = table_data,
      startRow = 1,
      startCol = col_start,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    # Increment the col_start variable so that the next table is written to the next column
    col_start <- col_start + n_cols + 2 # Add 2 for the blank column between tables
  }
  

  # make it pretty
  setColWidths(wb, sheet = 1, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 2, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 3, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 4, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 5, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 6, cols = 1:15, widths = "auto")
  
  # save workbook
  output_path <- paste0(paths$data_processed)
  
  saveWorkbook(wb,
               paste0(output_path, "/", Sys.Date(),"_ct_quanteda_top_words" , ".xlsx"),
               overwrite = TRUE)
  

  
  
  


  
  

############ >>>>> COntinue here <<<<<<<<<<<<< ###############
  # clean up script - DONE
  # work with sentiements - DONE (Sentinents are not tworking perfectly)
  # make visuals
    # Play around with groupings - DONE
  # remove unwanted tokens like the letters - DONE
  # Save the final data - DONE
  # Use list_multiword_all as compound list - DONE
  # answer questions
  # add sentiment source to 3.2 or 3.3
  # Add aditional packages to chapter 3.2 or 3.3




  
  
  
  
  
  
  
  

  # end this shit
  end_time <- Sys.time()
  cat("End Script:", format(Sys.time(), "%H:%M:%S"), "\n", 
      "Differenz: ", difftime(end_time, start_time, units = "secs"), "Sekunden", "\n") 
  
  
