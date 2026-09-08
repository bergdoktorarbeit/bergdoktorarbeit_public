rm(list = ls()) # Remove all stuff in Environment

start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")









# set working dirctory
# setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

source("init_v0.6.R")




# List files

  # get Accounts - Art List
  files <- list.files(
    paste0(paths$ctdata, "/Input"),
    pattern = ".xlsx",
    full.names = TRUE)
  
  
  name_files <- files[grepl("Accounts", files)]
  
  
  # get output data from steps before
  files <- list.files(
    paste0(paths$ctdata, "/Ouput/WK BD Data"),
    pattern = ".csv",
    full.names = TRUE)
  
  
  meta_files <- files[grepl("meta_interim", files)] # get meta data
  
  geo_files <- files[grepl("geotag", files)] # get geo data




# Inbound file data
  df_acc_raw <- read.xlsx(name_files, 
                       startRow = 1,
                       check.names = FALSE)
  
  df_meta_raw <- read.csv(meta_files, 
                          stringsAsFactors = FALSE,
                          sep = ";",
                          encoding="UTF-8") %>% 
                select(user_name,
                       post_url,
                       post_type) %>%
                mutate(post_type = tolower(post_type))
  

  #geo data
  df_geo_raw <- read.csv(geo_files, 
                          stringsAsFactors = FALSE,
                          sep = ";",
                          encoding="UTF-8") %>% 
                select(loc_name_long,
                       loc_name_adress,
                       loc_zip,
                       loc_city,
                       loc_region,
                       loc_country_code)


  #questionaire url data
  sosci_questionair_links <- read.csv(paste0(paths$ctdata, 
                                             "/Input/SoSci Questionaire URLs.txt"), 
                                      stringsAsFactors = FALSE,
                                      sep = ";",
                                      encoding="UTF-8") %>% 
    select(quest = Questionaire,
           quest_url = Questionaire.URL)




# build table

  # build id
  df_acc_data <- df_acc_raw %>%
    select(Account,
           User.Name,
           Art) %>% 
    filter(Art %in% c("Destination", "Screentourist", "Produktion")) %>% 
    distinct(User.Name, .keep_all = TRUE) %>% 
    arrange(Art) %>%
    mutate(#Account = str_extract(replace_non_ascii(Account), "[[:alpha:]([:blank:]|[:punct:])[:alpha:]]+"),
           Account = replace_non_ascii(Account),
           Account = replace_na(Account, " "),
           sosci_sort_quest = str_c(User.Name, "; ", User.Name, "; ", replace_na(Account)),
           id = row_number()) %>% 
    select(id,
           acc_clean = Account,
           user_name = User.Name,
           art = Art,
           sosci_sort_quest)
  
  # join meta data
  df_sosci_data <- df_acc_data %>% 
    left_join(df_meta_raw, by = "user_name") %>% 
    filter(post_type != "video",
           post_type != "igtv") %>%
    arrange(post_url) %>% 
    distinct(id, .keep_all = TRUE) %>% 
    arrange(id) %>% 
    filter(is.na(post_url) == FALSE) %>% 
    mutate(sosci_id = row_number()#,
           #sosci_sort_quest_url = str_c(sosci_id, " ", post_url),
           #sosci_sort_quest = str_c(sosci_id, " ", sosci_sort_quest) 
           ) %>% 
    select(acc_clean,
           user_name,
           art,
           sosci_sort_quest_url = post_url,
           sosci_id,
           sosci_sort_quest)
  
  # build different tables for excel worksheets
  df_sosci_data_st <- df_sosci_data %>% 
    filter(art == "Screentourist") %>% 
    mutate( sosci_id_st = row_number(),
            sosci_id_st = ifelse(sosci_id_st > 40, sosci_id_st - 40, sosci_id_st), # To group the data for sosci Survey 
            sosci_id_st = ifelse(sosci_id_st > 40, sosci_id_st - 40, sosci_id_st), # To group the data for sosci Survey 
            sosci_id_st = ifelse(sosci_id_st > 40, sosci_id_st - 40, sosci_id_st), # To group the data for sosci Survey 
            sosci_id_st = ifelse(sosci_id_st > 40, sosci_id_st - 40, sosci_id_st), # To group the data for sosci Survey
            #NOTE: if more data comes in, 4 ifelses might not be enough! 
            sosci_sort_quest = str_c(sosci_id_st, " ", sosci_sort_quest, "; -", str_sub(art, 1, 3), sosci_id) ) %>% 
    select(acc_clean,
           user_name,
           art,
           sosci_id_st,
           sosci_sort_quest_url,
           sosci_sort_quest)
  
df_sosci_data_des <- df_sosci_data %>% 
    filter(art == "Destination") %>% 
    mutate( sosci_id_de = row_number(),
            sosci_id_de = ifelse(sosci_id_de > 40, sosci_id_de - 40, sosci_id_de), # To group the data for sosci Survey 
            sosci_id_de = ifelse(sosci_id_de > 40, sosci_id_de - 40, sosci_id_de), # To group the data for sosci Survey 
            sosci_id_de = ifelse(sosci_id_de > 40, sosci_id_de - 40, sosci_id_de), # To group the data for sosci Survey 
            sosci_id_de = ifelse(sosci_id_de > 40, sosci_id_de - 40, sosci_id_de), # To group the data for sosci Survey 
            sosci_sort_quest = str_c(sosci_id_de, " ", sosci_sort_quest, "; -", str_sub(art, 1, 3), sosci_id) ) %>% 
    select(acc_clean,
           user_name,
           art,
           sosci_id_de,
           sosci_sort_quest_url,
           sosci_sort_quest)
  
  df_sosci_data_prod <- df_sosci_data %>% 
    filter(art == "Produktion") %>% 
    mutate( sosci_id_pr = row_number(),
            sosci_id_pr = ifelse(sosci_id_pr > 40, sosci_id_pr - 40, sosci_id_pr), # To group the data for sosci Survey 
            sosci_id_pr = ifelse(sosci_id_pr > 40, sosci_id_pr - 40, sosci_id_pr), # To group the data for sosci Survey 
            sosci_id_pr = ifelse(sosci_id_pr > 40, sosci_id_pr - 40, sosci_id_pr), # To group the data for sosci Survey 
            sosci_id_pr = ifelse(sosci_id_pr > 40, sosci_id_pr - 40, sosci_id_pr), # To group the data for sosci Survey 
            sosci_sort_quest = str_c(sosci_id_pr, " ", sosci_sort_quest, "; -", str_sub(art, 1, 3), sosci_id) ) %>%  
    select(acc_clean,
           user_name,
           art,
           sosci_id_pr,
           sosci_sort_quest_url,
           sosci_sort_quest)
  
  
  # Get Geodata for Space questions in SociSurvey
  df_sosci_data_geo <- df_geo_raw %>% 
    distinct(loc_name_long, .keep_all = TRUE) %>% 
    mutate(loc_name_long = str_replace(loc_name_long, "NULL", ""),
           loc_name_adress = str_replace(loc_name_adress, "NULL", ""),
           loc_zip = str_replace(loc_zip, "NULL", ""),
           loc_city = str_replace(loc_city, "NULL", ""),
           loc_region = str_replace(loc_region, "NULL", ""),
           loc_region = str_replace(loc_region, "Tyrol", "Tirol"),
           loc_country_code = str_replace(loc_country_code, "NULL", ""),
           loc_country_code = str_replace(loc_country_code, "AT", "Österreich"),
           loc_country_code = str_replace(loc_country_code, "DE", "Deustchland"),
           loc_country_code = str_replace(loc_country_code, "IT", "Italien") ) %>%
    mutate(sosci_geo_quest_1 = str_c(loc_name_long, "; ", loc_name_adress, "; ", loc_zip, "; ", loc_city, "; ", loc_region, "; ", loc_country_code),
           sosci_geo_quest_2 = str_c(loc_name_adress, "; ", loc_zip, "; ", loc_city, "; ", loc_region, "; ", loc_country_code),
           sosci_geo_quest_3 = str_c(loc_city, "; ", loc_region, "; ", loc_country_code),
           sosci_geo_quest_4 = str_c(loc_country_code) )
    
    
    
  df_sosci_data_geo <- bind_rows(cols = c(df_sosci_data_geo$sosci_geo_quest_1,
                                                 df_sosci_data_geo$sosci_geo_quest_2,
                                                 df_sosci_data_geo$sosci_geo_quest_3,
                                                 df_sosci_data_geo$sosci_geo_quest_4) ) %>% 
    select(sosci_geo_quest = cols) %>% 
    mutate(sosci_geo_quest = str_replace_all(sosci_geo_quest, "; ;", ";"),
           sosci_geo_quest = str_replace_all(sosci_geo_quest, "; ;", ";"),
           sosci_geo_quest = str_replace_all(sosci_geo_quest, "; ;", ";")) %>% 
    distinct(sosci_geo_quest, .keep_all = TRUE) %>% 
    mutate(sosci_geo_quest = str_replace(sosci_geo_quest, "^; ", ""),
           sosci_geo_quest = str_replace(sosci_geo_quest, "^[:digit:]+; ", "")) %>% 
    filter(sosci_geo_quest != "") %>% 
    distinct(sosci_geo_quest, .keep_all = TRUE) %>% 
    arrange(sosci_geo_quest) %>% 
    mutate(sosci_id = row_number(),
           sosci_geo_quest = str_c(sosci_id, " ", sosci_geo_quest)) %>% 
    select(soschi_id_geo = sosci_id,
           sosci_geo_quest)
  
  
  #Build text
  #NOTE DB: Actually this part has to be his own script because it logically and timely it is set after the survey is created.
  
  #prepare link list to survey monkey
  sosci_questionair_links <- sosci_questionair_links %>% 
    mutate(sosci_id_start = str_extract(quest, "\\d+(?=-)"),
           sosci_id_end = str_extract(quest, "(?<=-)\\d+"))
  
  
  #Build text for talking to survey participants (Screentourist = st = Scr)
  df_insta_text_st <- df_sosci_data_st %>% 
    mutate(sosci_id = as.numeric(str_extract(sosci_sort_quest, "(?<=-Scr)\\d+"))) %>% 
    select(user_name,
           sosci_id_st,
           sosci_id,
           sosci_sort_quest_url) %>% 
    mutate(quest_url = ifelse(sosci_id >= 207, sosci_questionair_links$quest_url[7], 
                              ifelse(sosci_id >= 167, sosci_questionair_links$quest_url[6], 
                                     ifelse(sosci_id >= 127, sosci_questionair_links$quest_url[5], 
                                            ifelse(sosci_id >= 87, sosci_questionair_links$quest_url[4], 
                                                   ifelse(sosci_id >= 60, sosci_questionair_links$quest_url[3], 
                                                          ifelse(sosci_id >= 41, sosci_questionair_links$quest_url[2], 
                                                                 ifelse(sosci_id >= 1, sosci_questionair_links$quest_url[1], 
                                                                        "FAIL")))))))) 
  
  

  # put the texte into the table 
    df_loop <- tibble()
    
    for (n in 1:nrow(df_insta_text_st)) {
      text_1 <- paste0(df_insta_text_st$sosci_sort_quest_url[n], " Hallo @", df_insta_text_st$user_name[n], ", ich bin Humangeograph an der @unimainz und forsche zum Filmtourismus in der Region des Wilden Kaisers. Ich habe den verlinkten Beitrag Ihres Accounts gefunden und würde Ihnen dazu gerne ein paar Fragen stellen. Der Fragebogen wird im Rahmen der Kulturgeographischen-Forschung am @geounimainz Institut ausgewertet. 
  Den Fragebogen können Sie unter folgendem Link erreichen: ", df_insta_text_st$quest_url[n], "Alle weiteren Informationen zum Fragebogen und zur Studie finden Sie im Link. Bitte nehmen Sie möglichst Zeitnah an der Befragung teil.
  Vielen Dank für Ihre Unterstützung.
  Daniel Böcher")
      text_2 <- paste0(" Hallo @", df_insta_text_st$user_name[n], ", ich bin Humangeograph an der @unimainz und forsche zum Filmtourismus in der Region des Wilden Kaisers. Ich habe den verlinkten Beitrag Ihres Accounts gefunden und würde Ihnen dazu gerne ein paar Fragen stellen. Der Fragebogen wird im Rahmen der Kulturgeographischen-Forschung am @geounimainz Institut ausgewertet. 
  Den Fragebogen können Sie unter folgendem Link erreichen: ", df_insta_text_st$quest_url[n], " Alle weiteren Informationen zum Fragebogen und zur Studie finden Sie im Link. Bitte nehmen Sie möglichst Zeitnah an der Befragung teil.
  Vielen Dank für Ihre Unterstützung.
  Daniel Böcher")
  
      df_temp <- tibble(text_1,
                        text_2)
      
      df_loop <- bind_rows(df_loop, df_temp)
      
  
    }
    
    df_insta_text_st <- bind_cols(df_insta_text_st, df_loop)
    
    rm(df_temp, df_loop)
    
    
    
    #Build text for talking to survey participants (Destination = de = Des)
    df_insta_text_des <- df_sosci_data_des %>% 
      mutate(sosci_id = as.numeric(str_extract(sosci_sort_quest, "(?<=-Des)\\d+"))) %>% 
      select(user_name,
             sosci_id_de,
             sosci_id,
             sosci_sort_quest_url) %>% 
      mutate(quest_url = ifelse(sosci_id >= 207, sosci_questionair_links$quest_url[7], 
                                ifelse(sosci_id >= 167, sosci_questionair_links$quest_url[6], 
                                       ifelse(sosci_id >= 127, sosci_questionair_links$quest_url[5], 
                                              ifelse(sosci_id >= 87, sosci_questionair_links$quest_url[4], 
                                                     ifelse(sosci_id >= 60, sosci_questionair_links$quest_url[3], 
                                                            ifelse(sosci_id >= 41, sosci_questionair_links$quest_url[2], 
                                                                   ifelse(sosci_id >= 1, sosci_questionair_links$quest_url[1], 
                                                                          "FAIL")))))))) 
    
    
    df_loop <- tibble()
    
    for (n in 1:nrow(df_insta_text_des)) {
      text_1 <- paste0(df_insta_text_des$sosci_sort_quest_url[n], " Hallo liebes Team vom Account @", df_insta_text_des$user_name[n], ", ich bin Humangeograph an der @unimainz und forsche zum Filmtourismus in der Region des Wilden Kaisers. Ich habe den verlinkten Beitrag Ihres Accounts gefunden und würde Ihnen dazu gerne ein paar Fragen stellen. Der Fragebogen wird im Rahmen der Kulturgeographischen-Forschung am @geounimainz Institut ausgewertet. 
Den Fragebogen können Sie unter folgendem Link erreichen: ", df_insta_text_des$quest_url[n], "Sollten Sie nicht der:die richtige Ansprechpartner:in für dieses Thema sein, leiten Sie diese Anfrage doch bitte an die:den Zuständige:n weiter. Bitte nehmen Sie möglichst Zeitnah an der Befragung teil.
Vielen Dank für Ihre Unterstützung.
Daniel Böcher")
      text_2 <- paste0(" Hallo liebes Team vom Account @", df_insta_text_des$user_name[n], ", ich bin Humangeograph an der @unimainz und forsche zum Filmtourismus in der Region des Wilden Kaisers. Ich habe den verlinkten Beitrag Ihres Accounts gefunden und würde Ihnen dazu gerne ein paar Fragen stellen. Der Fragebogen wird im Rahmen der Kulturgeographischen-Forschung am @geounimainz Institut ausgewertet. 
Den Fragebogen können Sie unter folgendem Link erreichen: ", df_insta_text_des$quest_url[n], " Sollten Sie nicht der:die richtige Ansprechpartner:in für dieses Thema sein, leiten Sie diese Anfrage doch bitte an die:den Zuständige:n weiter. Bitte nehmen Sie möglichst Zeitnah an der Befragung teil.
Vielen Dank für Ihre Unterstützung.
Daniel Böcher")
      
      df_temp <- tibble(text_1,
                        text_2)
      
      df_loop <- bind_rows(df_loop, df_temp)
      
      
    }
    
    df_insta_text_des <- bind_cols(df_insta_text_des, df_loop)
    
    rm(df_temp, df_loop)
    
    
    #Build text for talking to survey participants (Produktion = pr = Pro)
    df_insta_text_prod <- df_sosci_data_prod %>% 
      mutate(sosci_id = as.numeric(str_extract(sosci_sort_quest, "(?<=-Pro)\\d+"))) %>% 
      select(user_name,
             sosci_id_pr,
             sosci_id,
             sosci_sort_quest_url) %>% 
      mutate(quest_url = ifelse(sosci_id >= 207, sosci_questionair_links$quest_url[7], 
                                ifelse(sosci_id >= 167, sosci_questionair_links$quest_url[6], 
                                       ifelse(sosci_id >= 127, sosci_questionair_links$quest_url[5], 
                                              ifelse(sosci_id >= 87, sosci_questionair_links$quest_url[4], 
                                                     ifelse(sosci_id >= 60, sosci_questionair_links$quest_url[3], 
                                                            ifelse(sosci_id >= 41, sosci_questionair_links$quest_url[2], 
                                                                   ifelse(sosci_id >= 1, sosci_questionair_links$quest_url[1], 
                                                                          "FAIL")))))))) 
    
    
    df_loop <- tibble()
    
    for (n in 1:nrow(df_insta_text_prod)) {
      text_1 <- paste0(df_insta_text_prod$sosci_sort_quest_url[n], " Hallo lieber Account @", df_insta_text_prod$user_name[n], ", ich bin Humangeograph an der @unimainz und forsche zum Filmtourismus in der Region des Wilden Kaisers. Ich habe den verlinkten Beitrag Ihres Accounts gefunden und würde Ihnen dazu gerne ein paar Fragen stellen. Der Fragebogen wird im Rahmen der Kulturgeographischen-Forschung am @geounimainz Institut ausgewertet. 
Den Fragebogen können Sie unter folgendem Link erreichen:  ", df_insta_text_prod$quest_url[n], "Ich stehe bereits in Kontakt mit dem ZDF, der Produktionsfirma und dem Destinationen-Management am @wilder.kaiser, die über diese Studie Informiert wurden. Alle weiteren Informationen zum Fragebogen und zur Studie finden Sie im Link. Bitte nehmen Sie möglichst Zeitnah an der Befragung teil.
Vielen Dank für Ihre Unterstützung.
Daniel Böcher")
      
      text_2 <- paste0(" Hallo lieber Account @", df_insta_text_prod$user_name[n], ", ich bin Humangeograph an der @unimainz und forsche zum Filmtourismus in der Region des Wilden Kaisers. Ich habe den verlinkten Beitrag Ihres Accounts gefunden und würde Ihnen dazu gerne ein paar Fragen stellen. Der Fragebogen wird im Rahmen der Kulturgeographischen-Forschung am @geounimainz Institut ausgewertet. 
Den Fragebogen können Sie unter folgendem Link erreichen:  ", df_insta_text_prod$quest_url[n], " Ich stehe bereits in Kontakt mit dem ZDF, der Produktionsfirma und dem Destinationen-Management am @wilder.kaiser, die über diese Studie Informiert wurden. Alle weiteren Informationen zum Fragebogen und zur Studie finden Sie im Link. Bitte nehmen Sie möglichst Zeitnah an der Befragung teil.
Vielen Dank für Ihre Unterstützung.
Daniel Böcher")
      
      
      df_temp <- tibble(text_1,
                        text_2)
      
      df_loop <- bind_rows(df_loop, df_temp)
      
      
    }
    
    df_insta_text_prod <- bind_cols(df_insta_text_prod, df_loop)
    
    rm(df_temp, df_loop)
  
  


# remove unnecessary data frames
  rm(df_acc_raw, 
     df_meta_raw, 
     df_geo_raw, 
     df_acc_data)
  

  
# Outbound data
  
  
  # save as csv - all in one  
  # write.csv2(df_sosci_data,
  #            file = paste0(getwd(), "/Ouput/WK BD Data/", "bd_sosci_sort_quest.csv"), 
  #            na = "NULL", 
  #            row.names = FALSE,
  #            fileEncoding = "UTF-8")
  
  
  
  # Save as excel with defined worksheets for the different groups
  
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
    addWorksheet(wb, "SoSci Screentourist")
    addWorksheet(wb, "SoSci Destination")
    addWorksheet(wb, "SoSci Produktion")
    addWorksheet(wb, "SoSci Alle Akteure")
    addWorksheet(wb, "SoSci Orte")
    addWorksheet(wb, "SoSci Insta Texte Screetourist")
    addWorksheet(wb, "SoSci Insta Texte Destination")
    addWorksheet(wb, "SoSci Insta Texte Produktion")
    addWorksheet(wb, "SoSci Questionaire URL")
    
    # write data
    writeData(
      wb,
      sheet = 1,
      x = df_sosci_data_st,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    writeData(
      wb,
      sheet = 2,
      x = df_sosci_data_des,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    writeData(
      wb, 
      sheet = 3,
      x = df_sosci_data_prod,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    writeData(
      wb, 
      sheet = 4,
      x = df_sosci_data,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    writeData(
      wb, 
      sheet = 5,
      x = df_sosci_data_geo,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    writeData(
      wb, 
      sheet = 6,
      x = df_insta_text_st,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    writeData(
      wb, 
      sheet = 7,
      x = df_insta_text_des,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    writeData(
      wb, 
      sheet = 8,
      x = df_insta_text_prod,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    writeData(
      wb, 
      sheet = 9,
      x = sosci_questionair_links,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    
    # make it pretty
    setColWidths(wb, sheet = 1, cols = 1:ncol(df_sosci_data_st), widths = "auto")
    setColWidths(wb, sheet = 2, cols = 1:ncol(df_sosci_data_des), widths = "auto")
    setColWidths(wb, sheet = 3, cols = 1:ncol(df_sosci_data_prod), widths = "auto")
    setColWidths(wb, sheet = 4, cols = 1:ncol(df_sosci_data), widths = "auto")
    setColWidths(wb, sheet = 5, cols = 1:ncol(df_sosci_data_geo), widths = "auto")
    setColWidths(wb, sheet = 6, cols = 1:ncol(df_insta_text_st), widths = "auto")
    setColWidths(wb, sheet = 7, cols = 1:ncol(df_insta_text_des), widths = "auto")
    setColWidths(wb, sheet = 8, cols = 1:ncol(df_insta_text_prod), widths = "auto")
    setColWidths(wb, sheet = 8, cols = 1:ncol(sosci_questionair_links), widths = "auto")
    
    
    # save workbook
    output_path <- paste0(paths$data_interim)
    
    saveWorkbook(wb,
                 paste0(output_path, "/bd_sosci_quest_", Sys.Date(), ".xlsx"),
                 overwrite = FALSE)

    
    
    
  
# last message
print(paste0("Everything Done. Find Data here: ", output_path))








# end this shit
end_time <- Sys.time()
cat("End Script:", format(Sys.time(), "%H:%M:%S"), "\n", 
    "Differenz: ", difftime(end_time, start_time, units = "min"), "min.", "\n") 

