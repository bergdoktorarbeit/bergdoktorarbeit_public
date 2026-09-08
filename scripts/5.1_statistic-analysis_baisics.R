# Remove all stuff in Environment
rm(list = ls()) 

# start timer
start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")






# set working dirctory
#setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

source("init_v0.6.R")



# statistical base data the traceinterview

# get data
cat("Data load from:\n", paths$data_processed, "\n")

  # get Accounts - traceinterview.csv
  files <- list.files(
    paths$data_processed,
    pattern = ".csv",
    full.names = TRUE)
  
  file_names <- files[grepl("traceinterview", files)] 
  
  file_names <- head(file_names[order(file_names, decreasing = TRUE)], 5)
    
    # test if correct data is loaded
    test_if_data_complete <- if_else(str_detect(file_names, "(st|de|pr|all|all_meta).csv")  == TRUE, TRUE, FALSE)
    
    ifelse(length(test_if_data_complete[test_if_data_complete == TRUE]) == 5, 
           {cat("All traceinterview data loaded \n"); TRUE}, 
           {cat("Not all traceinterview data is loaded correctly \n"); FALSE} )
    
  # list files
  file_trace_all <- file_names[grepl("_all.csv", file_names)]
  file_trace_meta <- file_names[grepl("_meta.csv", file_names)]
  file_trace_st <- file_names[grepl("_st.csv", file_names)]
  file_trace_de <- file_names[grepl("_de.csv", file_names)]
  file_trace_pr <- file_names[grepl("_pr.csv", file_names)]
  
  
#   # get data
#   cat("Data load from:\n", paths$interview_data, "\n")
#   
# # get Accounts - traceinterview.csv
#   files <- list.files(
#     paste0(paths$interview_data, "/221027_Save Data/"),
#     pattern = ".csv",
#     full.names = TRUE)
#   
#   file_names <- files[grepl("values", files)]
#   file_value_bd <- file_names[grepl("bergdokotorarbeit", file_names)]
  
    
  
  # Inbound file data
  df_all_raw <- read.csv(file_trace_all, 
                     stringsAsFactors = FALSE,
                     sep = ";",
                     encoding="UTF-8")
  
  # df_meta_raw <- read.csv(file_trace_meta, #QUEST: Do I need to check the meta data?
  #                        stringsAsFactors = FALSE,
  #                        sep = ";",
  #                        encoding="UTF-8")
  
  df_st_raw <- read.csv(file_trace_st, 
                          stringsAsFactors = FALSE,
                          sep = ";",
                          encoding="UTF-8")
  
  df_de_raw <- read.csv(file_trace_de, 
                    stringsAsFactors = FALSE,
                    sep = ";",
                    encoding="UTF-8")
  
  df_pr_raw <- read.csv(file_trace_pr, 
                    stringsAsFactors = FALSE,
                    sep = ";",
                    encoding="UTF-8")
 
  # inbound values
  # df_val_raw <- read.csv(file_value_bd, 
  #                        stringsAsFactors = FALSE,
  #                        sep = ";",
  #                        encoding="UTF-8")
  # 
  
  
  
# statistical analysis

  # Get rid of all the unanswered questions (-9) 
    # to not disturb the statistical calculations (Mean etc.)
  df_all_raw[df_all_raw == -9] <- NA
  df_all_raw[df_all_raw == -1] <- NA
  #df_all_raw[df_all_raw %in% c("-9","-1")] <- NA # funktioniert nicht mit einer Liste?!
  #df_meta_raw[df_meta_raw == -9] <- NA
  #df_meta_raw[df_meta_raw == -1] <- NA
  df_st_raw[df_st_raw == -9] <- NA
  df_st_raw[df_st_raw == -1] <- NA
  
  df_de_raw[df_de_raw == -9] <- NA
  df_de_raw[df_de_raw == -1] <- NA
  
  df_pr_raw[df_pr_raw == -9] <- NA
  df_pr_raw[df_pr_raw == -1] <- NA
  
  
  # basic analysis
  str(df_all_raw)
  
  describe(df_all_raw)
  
  describe(df_de_raw)
  
  describe(df_st_raw)
  
  

  
  # Hints:
    # N - die Anzahl der Fälle
    # Missing - fehlende Werte
    # M - Mittelwert
    # SD - Standardabweichung
    # Min/Max - Mindestwert und Maximalwert
    # Range - die Spannweite, also max-min
    # Q25/Mdn/Q75- das 25er- (Q25), 50er- (Median, Mdn) und 75er- (Q75) Perzentil (auch: Quantil)
    # Mdn - der Median
    # Skewness - die Schiefe der Verteilung (Skew bzw. Skewness)
    # Kurtosis - die Wölbung der Verteilung
    

    
#### crosstabs (Kreuztabellen) ####

## group        
## df_all_raw with group
  
  # crosstab: group to Wie viele FOlgen?
  crosst_group_by_episode <- df_all_raw %>% 
    mutate(count_ep = EI06_EI07_st_episodesbd) %>%
    filter(group != "Pro") %>% 
    crosstab(col_var = group, 
             count_ep,
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE) %>% 
    arrange(desc(Total))
  crosst_group_by_episode
  
  # crosstab: group to Repost?
  crosst_group_by_respost <-  df_all_raw %>% 
    mutate(repost = IP01_IP21_IP39_st_de_pr_repost) %>%
    filter(repost != "") %>% 
    crosstab(col_var = group, 
             repost,
             add_total = TRUE,
             percentages = TRUE,
             chi_square = TRUE) #%>% 
    #arrange(desc(Total)) 
  crosst_group_by_respost
  
  # crosstab: group to Ddirekt gepostet?
  crosst_group_by_direct <- df_all_raw %>% 
    mutate(direct_post = IP13_IP49_st_pr_directfoto) %>%
    filter(direct_post != "") %>% 
    crosstab(col_var = group, 
             direct_post,
             add_total = TRUE,
             percentages = TRUE,
             chi_square = TRUE) #%>% 
    #arrange(desc(Total)) 
  crosst_group_by_direct
  
  # crosstab: group to Drehort Foto?
  crosst_group_by_location <- df_all_raw  %>% 
    mutate(drehort_foto = IP11_IP30_IP47_st_de_pr_scrloc) %>%
    filter(drehort_foto != "") %>% 
    crosstab(col_var = group, 
             drehort_foto,
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE) %>% 
    arrange(desc(Total)) 
  crosst_group_by_location
  
  # crosstab: group to Fotograf region
  crosst_group_by_f_rgs <- df_all_raw  %>% 
    mutate(fotograf_rgs = fotograf_region_st_de_pr) %>% 
    filter(fotograf_rgs != "") %>% 
    left_join(values_to_regions,
              by = c("fotograf_rgs" = "values") ) %>%
    select(-fotograf_rgs,
           -polygon_koordinates,
           fotograf_rgs = meaning) %>% 
    crosstab(col_var = group, 
             fotograf_rgs,
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE) %>% 
    arrange(desc(Total))
  crosst_group_by_f_rgs
  
  # crosstab: group to Motiv Region
  crosst_group_by_m_rgs <- df_all_raw  %>% 
    mutate(motiv_rgs = motiv_region_st_de_pr) %>% 
    filter(motiv_rgs != "" & group != "Pro") %>% 
    left_join(values_to_regions,
              by = c("motiv_rgs" = "values") ) %>%
    select(-motiv_rgs,
           -polygon_koordinates,
           motiv_rgs = meaning) %>% 
    crosstab(col_var = group, 
             motiv_rgs,
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE) %>% 
    arrange(desc(Total)) 
  crosst_group_by_m_rgs
  
  
############################################
## df_st_raw table ##
## age bucket  
  # crosstab: age_buckets to time on insta
  crosst_age_by_instatime <- df_st_raw %>% 
    mutate(time_insta = EI04_EI09_st_pr_timeinsta) %>% # Time on Insta
    #filter(age_buckets != "") %>% 
    crosstab(col_var = age_buckets, 
             time_insta,
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE) %>% 
    arrange(desc(Total)) 
  crosst_age_by_instatime
  
  # crosstab: age_buckets to fan_buckets
  crosst_age_by_fan <- df_st_raw %>% 
    filter(fan_buckets != "") %>%
    crosstab(col_var = age_buckets, 
             fan_buckets,
             add_total = TRUE,
             percentages = TRUE,
             chi_square = TRUE) %>% 
    arrange(desc(Total)) 
  crosst_age_by_fan
  
  
  # crosstab: age_buckets to reason to travel to WK: Fußstapfen
  crosst_age_by_reason_actor <- df_st_raw %>%  
    mutate(wk_reason_fußstapfen = IT08_01_st_ich_wollte_in_die_fußstapfen_meiner_lieblingsschauspieler.innen_treten.,
          ) %>% 
    #filter(age_buckets != "") %>%
    arrange(desc(wk_reason_fußstapfen) ) %>% 
    left_join(values_1to5_approval,
              by = c("wk_reason_fußstapfen" = "values") ) %>%
    select(-wk_reason_fußstapfen) %>% 
    select(wk_reason_fußstapfen = meaning,
           everything() ) %>%
    crosstab(col_var = age_buckets, 
             wk_reason_fußstapfen, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) #%>% 
    #arrange(desc(Total))
  crosst_age_by_reason_actor
  
  # crosstab: age_buckets to reason to travel to WK: Drehort
  crosst_age_by_reason_loc <- df_st_raw %>%  
    mutate(wk_reason_drehort = IT08_02_st_ich_wollte_selbst_einmal_an_dem_drehort_der_serie_.der_bergdoktor._stehen.,
    ) %>% 
    #filter(age_buckets != "") %>% 
    arrange(desc(wk_reason_drehort) ) %>% 
    left_join(values_1to5_approval,
              by = c("wk_reason_drehort" = "values") ) %>%
    select(-wk_reason_drehort) %>% 
    select(wk_reason_drehort = meaning,
           everything() ) %>% 
    crosstab(col_var = age_buckets, 
             wk_reason_drehort, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) #%>%
    #arrange(desc(Total))
  crosst_age_by_reason_loc
  
  # crosstab: age_buckets to reason to travel to WK: realer Ort
  crosst_age_by_reason_loc_real <- df_st_raw %>%  
    mutate(wk_reason_realerort = IT08_03_st_mich_interessiert_der_reale_ort._nicht_die_relevanz_des_ortes_als_drehort_in_der_serie_.der_bergdoktor..,
    ) %>% 
    #filter(age_buckets != "") %>%  
    arrange(desc(wk_reason_realerort) ) %>% 
    left_join(values_1to5_approval,
              by = c("wk_reason_realerort" = "values") ) %>%
    select(-wk_reason_realerort) %>% 
    select(wk_reason_realerort = meaning,
           everything() ) %>% 
    crosstab(col_var = age_buckets, 
             wk_reason_realerort, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) # %>%
    # arrange(desc(Total))
  crosst_age_by_reason_loc_real
  
  
  # crosstab: age_backets to reason to travel to WK: fan 
  crosst_age_by_reason_fan <- df_st_raw %>%  
    mutate(wk_reason_fan = IT08_04_st_ich_bin_ein_loyaler_fan_und_wollte_das_zum_ausdruck_bringen.,
    ) %>% 
    #filter(age_buckets != "") %>%  
    arrange(desc(wk_reason_fan) ) %>% 
    left_join(values_1to5_approval,
              by = c("wk_reason_fan" = "values") ) %>%
    select(-wk_reason_fan) %>% 
    select(wk_reason_fan = meaning,
           everything() ) %>% 
    crosstab(col_var = age_buckets, 
             wk_reason_fan, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )# %>%
    # arrange(desc(Total))
  crosst_age_by_reason_fan
  
  
  # crosstab: age_buckets to reason to travel to WK: landscape
  crosst_age_by_reason_landscape <- df_st_raw %>%  
    mutate(wk_reason_landschaft = IT08_05_st_ich_finde_die_landschaft_einfach_beeindruckend_und_wollte_sie_selbst_sehen.
    ) %>% 
    #filter(age_buckets != "") %>%  
    arrange(desc(wk_reason_landschaft) ) %>% 
    left_join(values_1to5_approval,
              by = c("wk_reason_landschaft" = "values") ) %>%
    select(-wk_reason_landschaft) %>% 
    select(wk_reason_landschaft = meaning,
           everything() ) %>% 
    crosstab(col_var = age_buckets, 
             wk_reason_landschaft, 
             add_total = TRUE,
             percentages = TRUE,
             chi_square = TRUE ) #%>%
    #arrange(desc(Total))
  crosst_age_by_reason_landscape
  
  
  # crosstab: age_buckets to reason to travel to WK: known
  crosst_age_by_reason_known <- df_st_raw %>%  
    mutate(wk_reason_bekannt = IT08_06_st_ich_habe_das_gefühl_durch_die_serie_den_wilden_kaiser_zu_kennen.
    ) %>% 
    #filter(age_buckets != "") %>%  
    arrange(desc(wk_reason_bekannt) ) %>% 
    left_join(values_1to5_approval,
              by = c("wk_reason_bekannt" = "values") ) %>%
    select(-wk_reason_bekannt) %>% 
    select(wk_reason_bekannt = meaning,
           everything() ) %>% 
    crosstab(col_var = age_buckets, 
             wk_reason_bekannt, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) # %>% 
    # arrange(desc(Total))
  crosst_age_by_reason_known
  
  # crosstab: age_buckets to reason to travel to WK: entertaiment (Hedonistic goals)
  crosst_age_by_reason_fun <- df_st_raw %>%  
    mutate(wk_reason_enteraiment = IT08_07_st_ich_wollte_einfach_spaß_haben_und_mich_entertainen_lassen.) %>% 
    #filter(age_buckets != "") %>%  
    arrange(desc(wk_reason_enteraiment) ) %>% 
    left_join(values_1to5_approval,
              by = c("wk_reason_enteraiment" = "values") ) %>%
    select(-wk_reason_enteraiment) %>% 
    select(wk_reason_enteraiment = meaning,
           everything() ) %>% 
    crosstab(col_var = age_buckets, 
             wk_reason_enteraiment, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) #%>%
    # arrange(desc(Total))
  crosst_age_by_reason_fun
  
  
  # crosstab: age_buckets to reason to travel to WK: something special (Hedonistic goals)
  crosst_age_by_reason_special <- df_st_raw %>%  
    mutate(wk_reason_besonderes = IT08_08_st_ich_wollte_etwas_besonderes_machen_in_meinem_urlaub.) %>% 
    #filter(age_buckets != "") %>%  
    arrange(desc(wk_reason_besonderes) ) %>% 
    left_join(values_1to5_approval,
              by = c("wk_reason_besonderes" = "values") ) %>%
    select(-wk_reason_besonderes) %>% 
    select(wk_reason_besonderes = meaning,
           everything() ) %>% 
    crosstab(col_var = age_buckets, 
             wk_reason_besonderes, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) #%>% 
    # arrange(desc(Total))
  crosst_age_by_reason_special
  
  
  # crossstab: age_buckets to reason to travel to WK: new (Hedonistic goals)
  crosst_age_by_reason_new <- df_st_raw %>%  
    mutate(wk_reason_neues = IT08_09_st_ich_wollte_etwas_neues_und_ungewöhnliches_wagen.) %>% 
    #filter(age_buckets != "") %>%  
    arrange(desc(wk_reason_neues) ) %>% 
    left_join(values_1to5_approval,
              by = c("wk_reason_neues" = "values") ) %>%
    select(-wk_reason_neues) %>% 
    select(wk_reason_neues = meaning,
           everything() ) %>% 
    crosstab(col_var = age_buckets, 
             wk_reason_neues, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) # %>%
    # arrange(desc(Total))
  crosst_age_by_reason_new
  
  
  # crosstab: age_buckets to reason to travel to WK: unique (Hedonistic goals)
  crosst_age_by_reason_unique <- df_st_raw %>%  
    mutate(wk_reason_einzigartig = IT08_10_st_ich_war_auf_der_suche_nach_einer_einzigartigen_erfahrung.) %>% 
    #filter(age_buckets != "") %>%  
    arrange(desc(wk_reason_einzigartig) ) %>% 
    left_join(values_1to5_approval,
              by = c("wk_reason_einzigartig" = "values") ) %>%
    select(-wk_reason_einzigartig) %>% 
    select(wk_reason_einzigartig = meaning,
           everything() ) %>% 
    crosstab(col_var = age_buckets, 
             wk_reason_einzigartig, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) # %>% 
    # arrange(desc(Total))
  crosst_age_by_reason_unique
  
  
  # Crosstab: agebuckets to reason to travel to WK: not my motivation
  crosst_age_by_reason_otheridear <- df_st_raw %>%  
    mutate(wk_reason_andereidee = IT08_11_st_es_war_nicht_meine_idee._sondern_die_meiner_reisebegleitung.) %>% 
    #filter(age_buckets != "") %>%  
    arrange(desc(wk_reason_andereidee) ) %>% 
    left_join(values_1to5_approval,
              by = c("wk_reason_andereidee" = "values") ) %>%
    select(-wk_reason_andereidee) %>% 
    select(wk_reason_andereidee = meaning,
           everything() ) %>% 
    crosstab(col_var = age_buckets, 
             wk_reason_andereidee, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) #%>% 
    # arrange(desc(Total))
  crosst_age_by_reason_otheridear
  
  
  
## Independent fan lvl ##    
  # crosstab fan lvl to time_on_insta
  crosst_fan_by_instatime <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           time_on_insta = EI04_EI09_st_pr_timeinsta) %>% 
    #filter(time_on_insta != "" & fan_lvl != "") %>%  
    arrange(desc(time_on_insta) ) %>% 
    crosstab(col_var = fan_lvl, 
             time_on_insta, 
             add_total = TRUE,
             percentages = TRUE,
             chi_square = TRUE ) %>% 
    arrange(desc(Total))
  crosst_fan_by_instatime
  

  # crosstab fan lvl to Drehorte: Gruberhof
  crosst_fan_by_time_gruberhof <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           dreh_gruberhof = IT10_01_st_gruberhof_.elternhaus.bauernhof.) %>% 
    #filter(dreh_gruberhof != "" & fan_lvl != "") %>%  
    arrange(desc(dreh_gruberhof) ) %>% 
    left_join(values_1to7,
              by = c("dreh_gruberhof" = "values") ) %>%
    select(-dreh_gruberhof) %>%
    select(dreh_gruberhof = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             dreh_gruberhof, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_fan_by_time_gruberhof
  
  
  # crosstab fan lvl to Drehorte: Praxis
  crosst_fan_by_time_praxis <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           dreh_praxis = IT10_02_st_praxis_des_bergdoktors) %>% 
    #filter(dreh_praxis != "" & fan_lvl != "") %>%  
    arrange(desc(dreh_praxis) ) %>% 
    left_join(values_1to7,
              by = c("dreh_praxis" = "values") ) %>%
    select(-dreh_praxis) %>%
    select(dreh_praxis = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             dreh_praxis, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_fan_by_time_praxis
  
  
  # crosstab fan lvl to Drehorte: Gasthof Wilder Kaiser
  crosst_fan_by_time_gasthofwk <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           dreh_gasthofwk = IT10_03_st_gasthof_zum_wilden_kaiser) %>% 
    #filter(dreh_gasthofwk != "" & fan_lvl != "") %>%  
    arrange(desc(dreh_gasthofwk) ) %>% 
    left_join(values_1to7,
              by = c("dreh_gasthofwk" = "values") ) %>%
    select(-dreh_gasthofwk) %>%
    select(dreh_gasthofwk = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             dreh_gasthofwk, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_fan_by_time_gasthofwk 
  
  
  # crosstab fan lvl to Drehorte: Dorfplatz und Kirche
  crosst_fan_by_time_dorfplatz <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           dreh_dorfplatz = IT10_05_st_dorfplatz_und_kirche) %>% 
    #filter(dreh_dorfplatz != "" & fan_lvl != "") %>%  
    arrange(desc(dreh_dorfplatz) ) %>% 
    left_join(values_1to7,
              by = c("dreh_dorfplatz" = "values") ) %>%
    select(-dreh_dorfplatz) %>%
    select(dreh_dorfplatz = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             dreh_dorfplatz, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_fan_by_time_dorfplatz
  
  
  # crosstab fan lvl to Drehorte: Apotheke
  crosst_fan_by_time_apotheke <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           dreh_apotheke = IT10_06_st_apotheke) %>% 
    #filter(dreh_apotheke != "" & fan_lvl != "") %>%  
    arrange(desc(dreh_apotheke) ) %>% 
    left_join(values_1to7,
              by = c("dreh_apotheke" = "values") ) %>%
    select(-dreh_apotheke) %>%
    select(dreh_apotheke = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             dreh_apotheke, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_fan_by_time_apotheke
  
  
  # crosstab fan lvl to Drehorte: See
  crosst_fan_by_time_see <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           dreh_see = IT10_07_st_hintersteiner_see) %>% 
    # filter(dreh_see != "" & fan_lvl != "") %>%  
    arrange(desc(dreh_see) ) %>% 
    left_join(values_1to7,
              by = c("dreh_see" = "values") ) %>%
    select(-dreh_see) %>%
    select(dreh_see = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             dreh_see, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_fan_by_time_see
  
  
  # crosstab fan lvl to reason: Actor
  crosst_fan_by_reason_actor <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           reason_actor = IT08_01_st_ich_wollte_in_die_fußstapfen_meiner_lieblingsschauspieler.innen_treten.) %>% 
    #filter(reason_actor != "" & fan_lvl != "") %>%  
    arrange(desc(reason_actor) ) %>% 
    left_join(values_1to5_approval,
              by = c("reason_actor" = "values") ) %>%
    select(-reason_actor) %>%
    select(reason_actor = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             reason_actor, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_fan_by_reason_actor
  
  # crosstab fan lvl to reason: location
  crosst_fan_by_reason_loc <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           reason_loc = IT08_02_st_ich_wollte_selbst_einmal_an_dem_drehort_der_serie_.der_bergdoktor._stehen.) %>% 
    #filter(reason_loc != "" & fan_lvl != "") %>%  
    arrange(desc(reason_loc) ) %>% 
    left_join(values_1to5_approval,
              by = c("reason_loc" = "values") ) %>%
    select(-reason_loc) %>%
    select(reason_loc = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             reason_loc, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_fan_by_reason_loc
  
  # crosstab fan lvl to reason: real location
  crosst_fan_by_reason_loc_real <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           reason_loc_real = IT08_03_st_mich_interessiert_der_reale_ort._nicht_die_relevanz_des_ortes_als_drehort_in_der_serie_.der_bergdoktor..) %>% 
    #filter(reason_loc_real != "" & fan_lvl != "") %>%  
    arrange(desc(reason_loc_real) ) %>% 
    left_join(values_1to5_approval,
              by = c("reason_loc_real" = "values") ) %>%
    select(-reason_loc_real) %>%
    select(reason_loc_real = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             reason_loc_real, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_fan_by_reason_loc_real
  
  
  # crosstab fan lvl to reason: loyal fan
  crosst_fan_by_reason_fan <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           reason_fan = IT08_04_st_ich_bin_ein_loyaler_fan_und_wollte_das_zum_ausdruck_bringen.) %>% 
    #filter(reason_fan != "" & fan_lvl != "") %>%  
    arrange(desc(reason_fan) ) %>% 
    left_join(values_1to5_approval,
              by = c("reason_fan" = "values") ) %>%
    select(-reason_fan) %>%
    select(reason_fan = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             reason_fan, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_fan_by_reason_fan
  
  
  # crosstab fan lvl to reason: nice landscape
  crosst_fan_by_reason_landscape <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           reason_landscape = IT08_05_st_ich_finde_die_landschaft_einfach_beeindruckend_und_wollte_sie_selbst_sehen.) %>% 
    #filter(reason_landscape != "" & fan_lvl != "") %>%  
    arrange(desc(reason_landscape) ) %>% 
    left_join(values_1to5_approval,
              by = c("reason_landscape" = "values") ) %>%
    select(-reason_landscape) %>%
    select(reason_landscape = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             reason_landscape, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_fan_by_reason_landscape
  
  # crosstab fan lvl to reason: know the landscape
  crosst_fan_by_reason_kown <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           reason_know_wk = IT08_06_st_ich_habe_das_gefühl_durch_die_serie_den_wilden_kaiser_zu_kennen.) %>% 
    #filter(reason_know_wk != "" & fan_lvl != "") %>%  
    arrange(desc(reason_know_wk) ) %>% 
    left_join(values_1to5_approval,
              by = c("reason_know_wk" = "values") ) %>%
    select(-reason_know_wk) %>%
    select(reason_know_wk = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             reason_know_wk, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_fan_by_reason_kown
  
  
  # crosstab fan lvl to reason: fun
  crosst_fan_by_reason_fun <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           reason_fun = IT08_07_st_ich_wollte_einfach_spaß_haben_und_mich_entertainen_lassen.) %>% 
    #filter(reason_fun != "" & fan_lvl != "") %>%  
    arrange(desc(reason_fun) ) %>% 
    left_join(values_1to5_approval,
              by = c("reason_fun" = "values") ) %>%
    select(-reason_fun) %>%
    select(reason_fun = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             reason_fun, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE)
  crosst_fan_by_reason_fun
  
  # crosstab fan lvl to reason: special
  crosst_fan_by_reason_special <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           reason_special = IT08_08_st_ich_wollte_etwas_besonderes_machen_in_meinem_urlaub.) %>% 
    #filter(reason_special != "" & fan_lvl != "") %>%  
    arrange(desc(reason_special) ) %>% 
    left_join(values_1to5_approval,
              by = c("reason_special" = "values") ) %>%
    select(-reason_special) %>%
    select(reason_special = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             reason_special, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE)
  crosst_fan_by_reason_special
  
  # crosstab fan lvl to reason: new
  crosst_fan_by_reason_new <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           reason_new = IT08_09_st_ich_wollte_etwas_neues_und_ungewöhnliches_wagen.) %>% 
    #filter(reason_new != "" & fan_lvl != "") %>%  
    arrange(desc(reason_new) ) %>% 
    left_join(values_1to5_approval,
              by = c("reason_new" = "values") ) %>%
    select(-reason_new) %>%
    select(reason_new = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             reason_new, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE)
  crosst_fan_by_reason_new
  
  # crosstab fan lvl to reason: unique
  crosst_fan_by_reason_unique <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           reason_unique = IT08_10_st_ich_war_auf_der_suche_nach_einer_einzigartigen_erfahrung.) %>% 
    #filter(reason_unique != "" & fan_lvl != "") %>%  
    arrange(desc(reason_unique) ) %>% 
    left_join(values_1to5_approval,
              by = c("reason_unique" = "values") ) %>%
    select(-reason_unique) %>%
    select(reason_unique = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             reason_unique, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE) 
  crosst_fan_by_reason_unique
  
  # crosstab fan lvl to reason: other idear
  crosst_fan_by_reason_otheridear <- df_st_raw %>%  
    mutate(fan_lvl = round(as.numeric(sub(",", ".", fan_lvl, fixed = TRUE)), 0),
           reason_other_idear = IT08_11_st_es_war_nicht_meine_idee._sondern_die_meiner_reisebegleitung.) %>% 
    #filter(reason_other_idear != "" & fan_lvl != "") %>%  
    arrange(desc(reason_other_idear) ) %>% 
    left_join(values_1to5_approval,
              by = c("reason_other_idear" = "values") ) %>%
    select(-reason_other_idear) %>%
    select(reason_other_idear = meaning,
           everything() ) %>%
    crosstab(col_var = fan_lvl, 
             reason_other_idear, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE)
  crosst_fan_by_reason_otheridear
  
  
  
## Independent time on insta ##  
  # crosstab time_on_insta to Vorbereitung auf Urlaub: research on Instagramn 
  crosst_instatime_by_info_wk <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           info_wk = IT01_01_st_ich_habe_vor_dem_urlaub_bei_instagram_über_den_wilden_kaiser_recherchiert.) %>% 
    #filter( infor_wk != "" & time_on_insta != "") %>%  
    arrange(desc(info_wk) ) %>% 
    left_join(values_1to5_approval,
              by = c("info_wk" = "values") ) %>%
    select(-info_wk) %>%
    select(info_wk = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             info_wk, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_instatime_by_info_wk
  
  # crosstab time_on_insta to Vorbereitung auf Urlaub: Tourism Instagram seen
  crosst_instatime_by_info_touri <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           info_touri = IT01_02_st_ich_habe_vor_oder_während_meines_urlaubs_andere_tourismusbeiträge_vom_wilden_kaiser_auf_instagram_wahrgnommen.) %>% 
    #filter( infor_wk != "" & time_on_insta != "") %>%  
    arrange(desc(info_touri) ) %>% 
    left_join(values_1to5_approval,
              by = c("info_touri" = "values") ) %>%
    select(-info_touri) %>%
    select(info_touri = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             info_touri, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_instatime_by_info_touri
  
  
  # crosstab time_on_insta to Vorbereitung auf Urlaub: Destination Instagram seen
  crosst_instatime_by_info_desti <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           info_desti = IT01_03_st_ich_habe_mir_beiträge_von_accounts_der_destination_angesehen_.bsp.._visit_tirol..) %>% 
    #filter( infor_wk != "" & time_on_insta != "") %>%  
    arrange(desc(info_desti) ) %>% 
    left_join(values_1to5_approval,
              by = c("info_desti" = "values") ) %>%
    select(-info_desti) %>%
    select(info_desti = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             info_desti, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_instatime_by_info_desti
  
  
  # crosstab time_on_insta to Vorbereitung auf Urlaub: Destination Instagram follow
  crosst_instatime_by_info_desti_fol <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           info_desti_fol = IT01_04_st_ich_folge_den_offiziellen_tourismusaccounts_der_destination_auf_instagram_.bsp.._wilder_kaiser._love_austria_oder_andere.) %>% 
    #filter( infor_wk != "" & time_on_insta != "") %>%  
    arrange(desc(info_desti_fol) ) %>% 
    left_join(values_1to5_approval,
              by = c("info_desti_fol" = "values") ) %>%
    select(-info_desti_fol) %>%
    select(info_desti_fol = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             info_desti_fol, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_instatime_by_info_desti_fol
  
  # crosstab time_on_insta to Vorbereitung auf Urlaub: Production Instagram follow
  crosst_instatime_by_info_pro <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           info_pro = IT01_05_st_ich_habe_mir_beiträge_von_schauspieler.innen_und_der_filmcrew_am_wilden_kaiser_angesehen.) %>% 
    #filter( infor_wk != "" & time_on_insta != "") %>%  
    arrange(desc(info_pro) ) %>% 
    left_join(values_1to5_approval,
              by = c("info_pro" = "values") ) %>%
    select(-info_pro) %>%
    select(info_pro = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             info_pro, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_instatime_by_info_pro
  

  # crosstab time_on_insta to Vorbereitung auf Urlaub: no instagram
  crosst_instatime_by_info_no <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           info_no = IT01_06_st_ich_habe_instagram_nicht_genutzt._um_mich_über_den_wilden_kaiser_zu_informieren.) %>% 
    filter(info_no != "" & time_on_insta != "") %>%  
    arrange(desc(info_no) ) %>% 
    left_join(values_1to5_approval,
              by = c("info_no" = "values") ) %>%
    select(-info_no) %>%
    select(info_no = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             info_no, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_instatime_by_info_no
  
  # crosstab time_on_insta to Beeinflusst: Tourist
  crosst_instatime_by_influ_tour <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           influence_tour = IT02_01_st_beiträge_von_anderen_touristen_im_urlaub_am_wilden_kaiser) %>% 
    #filter(influence_tour != "" & time_on_insta != "") %>%  
    arrange(desc(influence_tour) ) %>% 
    left_join(values_1to5_approval,
              by = c("influence_tour" = "values") ) %>%
    select(-influence_tour) %>%
    select(influence_tour = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             influence_tour, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_instatime_by_influ_tour
  
  
  # crosstab time_on_insta to Beeinflusst: Produktion
  crosst_instatime_by_influ_pro <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           influence_pro = IT02_02_st_beiträge_von_schauspieler.innen_und_der_filmcrew_am_wilden_kaiser) %>% 
    #filter(influence_pro != "" & time_on_insta != "") %>%  
    arrange(desc(influence_pro) ) %>% 
    left_join(values_1to5_approval,
              by = c("influence_pro" = "values") ) %>%
    select(-influence_pro) %>%
    select(influence_pro = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             influence_pro, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_instatime_by_influ_pro
  
  # crosstab time_on_insta to Beeinflusst: Destination
  crosst_instatime_by_influ_des <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           influence_des = IT02_03_st_beiträge_der_lokalen_tourismussaccounts_.bsp.._visit_tirol.) %>% 
    #filter(influence_des != "" & time_on_insta != "") %>%  
    arrange(desc(influence_des) ) %>% 
    left_join(values_1to5_approval,
              by = c("influence_des" = "values") ) %>%
    select(-influence_des) %>%
    select(influence_des = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             influence_des, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_instatime_by_influ_des
  
  # crosstab time_on_insta to perception: real WK
  crosst_instatime_by_perc_samke_wk <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           perception_same_wk = IT03_01_st_der_wilde_kaiser_erschien_mir_vor_ort_so._wie_ich_das_auf_instagram_wahrgenommen_habe.) %>% 
    #filter(perception_same_wk != "" & time_on_insta != "") %>%  
    arrange(desc(perception_same_wk) ) %>% 
    left_join(values_1to5_approval,
              by = c("perception_same_wk" = "values") ) %>%
    select(-perception_same_wk) %>%
    select(perception_same_wk = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             perception_same_wk, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_instatime_by_perc_samke_wk
  
  # crosstab time_on_insta to perception: prettier WK
  crosst_instatime_by_perc_pret_wk <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           perception_prettier_wk = IT03_02_st_es_war_vor_ort_am_wilden_kaiser_schöner_als_die_instagram.bilder_es_zeigen_konnten.) %>% 
    #filter(perception_prettier_wk != "" & time_on_insta != "") %>%  
    arrange(desc(perception_prettier_wk) ) %>% 
    left_join(values_1to5_approval,
              by = c("perception_prettier_wk" = "values") ) %>%
    select(-perception_prettier_wk) %>%
    select(perception_prettier_wk = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             perception_prettier_wk, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_instatime_by_perc_pret_wk
  
  # crosstab time_on_insta to perception: worse WK
  crosst_instatime_by_perc_worse_wk <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           perception_worse_wk = IT03_03_st_meine_erwartungen_durch_die_instagram.beiträge_konnte_der_wilde_kaiser_vor_ort_nicht_erfüllen.) %>% 
    #filter(perception_worse_wk != "" & time_on_insta != "") %>%  
    arrange(desc(perception_worse_wk) ) %>% 
    left_join(values_1to5_approval,
              by = c("perception_worse_wk" = "values") ) %>%
    select(-perception_worse_wk) %>%
    select(perception_worse_wk = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             perception_worse_wk, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE )
  crosst_instatime_by_perc_worse_wk
  
  
  # crosstab time_on_insta to perception: no WK
  crosst_instatime_by_perc_no_wk <- df_st_raw %>%  
    mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
           perception_no_wk = IT03_04_st_ich_habe_mir_vor_dem_urlaub_keine_instagram.beiträge_vom_wilden_kaiser_angesehen.) %>% 
    #filter(perception_no_wk != "" & time_on_insta != "") %>%  
    arrange(desc(perception_no_wk) ) %>% 
    left_join(values_1to5_approval,
              by = c("perception_no_wk" = "values") ) %>%
    select(-perception_no_wk) %>%
    select(perception_no_wk = meaning,
           everything() ) %>%
    crosstab(col_var = time_on_insta, 
             perception_no_wk, 
             add_total = TRUE,
             percentages = FALSE,
             chi_square = TRUE ) 
  crosst_instatime_by_perc_no_wk
  
  
  ############################################
  ## df_de_raw table ##
  
  # crosstab time_on_insta to perception: no WK
  # crosst_instatime_by_perc_no_wk <- df_de_raw %>% #INFO: This is not working because EI04_EI09_st_pr_timeinsta is not available for de?  
  #   mutate(time_on_insta = EI04_EI09_st_pr_timeinsta,
  #          perception_no_wk = IT03_04_st_ich_habe_mir_vor_dem_urlaub_keine_instagram.beiträge_vom_wilden_kaiser_angesehen.) %>% 
  #   #filter(perception_no_wk != "" & time_on_insta != "") %>%  
  #   arrange(desc(perception_no_wk) ) %>% 
  #   left_join(values_1to5_approval,
  #             by = c("perception_no_wk" = "values") ) %>%
  #   select(-perception_no_wk) %>%
  #   select(perception_no_wk = meaning,
  #          everything() ) %>%
  #   crosstab(col_var = time_on_insta, 
  #            perception_no_wk, 
  #            add_total = TRUE,
  #            percentages = FALSE,
  #            chi_square = TRUE ) 
  # crosst_instatime_by_perc_no_wk
  # 
  
  # Which other crosstables make sense?
      # As col_var (Indipendent) in crosstab table
      # DE05 (Wohnart)
      # DE06 (Bildung)
      # age_buckets
      # EI02_01 (Sind sie ein Fan) -> IT09 (Entdeckung der Drehorte)
      # EI06_EI07 (Wie viele Folgen gesehen?)
      # IT13 (Wie oft WK)
      # IT14 (An anderen Scr-Orten)
  # Put all the crosstable into a document?
  
  
  
  
  
  ## Saving them into one excel sheet

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
  addWorksheet(wb, "1 Group by")
  addWorksheet(wb, "2 Age Buckets by Intime & Fan")
  addWorksheet(wb, "3 Age Buckets by reason")
  addWorksheet(wb, "4 Fan Buckets by Instatime")
  addWorksheet(wb, "5 Fan Buckets by time")
  addWorksheet(wb, "6 Fan Buckets by reason")
  addWorksheet(wb, "7 Instatime by Info")
  addWorksheet(wb, "8 Instatime by Influence")
  addWorksheet(wb, "9 Instatime by Perception")
  
  # write data
  
  #page 1
  writeData(
    wb,
    sheet = 1,
    x = crosst_group_by_episode,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb,
    sheet = 1,
    x = crosst_group_by_respost,
    startCol = 1,
    startRow = nrow(crosst_group_by_episode)+3,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb,
    sheet = 1,
    x = crosst_group_by_direct,
    startCol = ncol(crosst_group_by_respost)+2,
    startRow = nrow(crosst_group_by_episode)+3,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb,
    sheet = 1,
    x = crosst_group_by_location,
    startCol = 1,
    startRow = nrow(crosst_group_by_episode)+
      nrow(crosst_group_by_respost)+6,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb,
    sheet = 1,
    x = crosst_group_by_f_rgs,
    startCol = 1,
    startRow = nrow(crosst_group_by_episode)+
      nrow(crosst_group_by_respost)+
      nrow(crosst_group_by_location)+
      9,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb,
    sheet = 1,
    x = crosst_group_by_f_rgs,
    startCol = ncol(crosst_group_by_f_rgs)+2,
    startRow = nrow(crosst_group_by_episode)+
      nrow(crosst_group_by_respost)+
      nrow(crosst_group_by_location)+
      9,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  
  
 #page 2
  writeData(
    wb,
    sheet = 2,
    x = crosst_age_by_instatime,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb,
    sheet = 2,
    x = crosst_age_by_fan,
    startRow = nrow(crosst_age_by_instatime)+3,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  
  # page 3
  writeData(
    wb, 
    sheet = 3,
    x = crosst_age_by_reason_actor,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 3,
    x = crosst_age_by_reason_loc,
    startRow = nrow(crosst_age_by_reason_actor)+3,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 3,
    x = crosst_age_by_reason_loc_real,
    startRow = nrow(crosst_age_by_reason_actor)+
      nrow(crosst_age_by_reason_loc)+
      6,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 3,
    x = crosst_age_by_reason_fan,
    startRow = nrow(crosst_age_by_reason_actor)+
      nrow(crosst_age_by_reason_loc)+
      nrow(crosst_age_by_reason_loc_real)+
      9,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 3,
    x = crosst_age_by_reason_otheridear,
    startRow = nrow(crosst_age_by_reason_actor)+
      nrow(crosst_age_by_reason_loc)+
      nrow(crosst_age_by_reason_loc_real)+
      nrow(crosst_age_by_reason_fan)+
      12,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 3,
    x = crosst_age_by_reason_landscape,
    startRow = nrow(crosst_age_by_reason_actor)+
      nrow(crosst_age_by_reason_loc)+
      nrow(crosst_age_by_reason_loc_real)+
      nrow(crosst_age_by_reason_fan)+
      nrow(crosst_age_by_reason_otheridear)+
      15,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 3,
    x = crosst_age_by_reason_known,
    startRow = nrow(crosst_age_by_reason_actor)+
      nrow(crosst_age_by_reason_loc)+
      nrow(crosst_age_by_reason_loc_real)+
      nrow(crosst_age_by_reason_fan)+
      nrow(crosst_age_by_reason_otheridear)+
      nrow(crosst_age_by_reason_landscape)+
      18,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 3,
    x = crosst_age_by_reason_new,
    startRow = nrow(crosst_age_by_reason_actor)+
      nrow(crosst_age_by_reason_loc)+
      nrow(crosst_age_by_reason_loc_real)+
      nrow(crosst_age_by_reason_fan)+
      nrow(crosst_age_by_reason_otheridear)+
      nrow(crosst_age_by_reason_landscape)+
      nrow(crosst_age_by_reason_known)+
      21,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 3,
    x = crosst_age_by_reason_fun,
    startRow = nrow(crosst_age_by_reason_actor)+
      nrow(crosst_age_by_reason_loc)+
      nrow(crosst_age_by_reason_loc_real)+
      nrow(crosst_age_by_reason_fan)+
      nrow(crosst_age_by_reason_otheridear)+
      nrow(crosst_age_by_reason_landscape)+
      nrow(crosst_age_by_reason_known)+
      nrow(crosst_age_by_reason_new)+
      24,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 3,
    x = crosst_age_by_reason_special,
    startRow = nrow(crosst_age_by_reason_actor)+
      nrow(crosst_age_by_reason_loc)+
      nrow(crosst_age_by_reason_loc_real)+
      nrow(crosst_age_by_reason_fan)+
      nrow(crosst_age_by_reason_otheridear)+
      nrow(crosst_age_by_reason_landscape)+
      nrow(crosst_age_by_reason_known)+
      nrow(crosst_age_by_reason_new)+
      nrow(crosst_age_by_reason_fun)+
      27,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 3,
    x = crosst_age_by_reason_unique,
    startRow = nrow(crosst_age_by_reason_actor)+
      nrow(crosst_age_by_reason_loc)+
      nrow(crosst_age_by_reason_loc_real)+
      nrow(crosst_age_by_reason_fan)+
      nrow(crosst_age_by_reason_otheridear)+
      nrow(crosst_age_by_reason_landscape)+
      nrow(crosst_age_by_reason_known)+
      nrow(crosst_age_by_reason_new)+
      nrow(crosst_age_by_reason_fun)+
      nrow(crosst_age_by_reason_special)+
      30,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )

  
  # page 4
  writeData(
    wb, 
    sheet = 4,
    x = crosst_fan_by_instatime,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  
  # page 5
  writeData(
    wb, 
    sheet = 5,
    x = crosst_fan_by_time_gruberhof,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 5,
    startRow = nrow(crosst_fan_by_time_gruberhof) + 3,
    x = crosst_fan_by_time_praxis,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 5,
    startRow = nrow(crosst_fan_by_time_gruberhof) +
      nrow(crosst_fan_by_time_praxis) + 6,
    x = crosst_fan_by_time_gasthofwk,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 5,
    startRow = nrow(crosst_fan_by_time_gruberhof) +
      nrow(crosst_fan_by_time_praxis) +
      nrow(crosst_fan_by_time_gasthofwk) + 9,
    x = crosst_fan_by_time_dorfplatz,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 5,
    startRow = nrow(crosst_fan_by_time_gruberhof) +
      nrow(crosst_fan_by_time_praxis) +
      nrow(crosst_fan_by_time_gasthofwk) +
      nrow(crosst_fan_by_time_dorfplatz) + 12,
    x = crosst_fan_by_time_apotheke,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 5,
    startRow = nrow(crosst_fan_by_time_gruberhof) +
      nrow(crosst_fan_by_time_praxis) +
      nrow(crosst_fan_by_time_gasthofwk) +
      nrow(crosst_fan_by_time_dorfplatz) +
      nrow(crosst_fan_by_time_apotheke) + 15,
    x = crosst_fan_by_time_see,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  
 # page 6
  writeData(
    wb, 
    sheet = 6,
    x = crosst_fan_by_reason_actor,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 6,
    startRow = nrow(crosst_fan_by_reason_actor) + 3,
    x = crosst_fan_by_reason_loc,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 6,
    startRow = nrow(crosst_fan_by_reason_actor) + 3,
    startCol = ncol(crosst_fan_by_reason_loc) + 2,
    x = crosst_fan_by_reason_loc_real,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 6,
    startRow = nrow(crosst_fan_by_reason_actor) +
      nrow(crosst_fan_by_reason_loc) + 6,
    x = crosst_fan_by_reason_fan,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 6,
    startRow = nrow(crosst_fan_by_reason_actor) +
      nrow(crosst_fan_by_reason_loc) + 6,
    startCol = ncol(crosst_fan_by_reason_fan) + 2,
    x = crosst_fan_by_reason_otheridear,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 6,
    startRow = nrow(crosst_fan_by_reason_actor) +
      nrow(crosst_fan_by_reason_loc) +
      nrow(crosst_fan_by_reason_fan) + 9,
    x = crosst_fan_by_reason_landscape,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 6,
    startRow = nrow(crosst_fan_by_reason_actor) +
      nrow(crosst_fan_by_reason_loc) +
      nrow(crosst_fan_by_reason_fan) +
      nrow(crosst_fan_by_reason_landscape) + 12,
    x = crosst_fan_by_reason_kown,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 6,
    startRow = nrow(crosst_fan_by_reason_actor) +
      nrow(crosst_fan_by_reason_loc) +
      nrow(crosst_fan_by_reason_fan) +
      nrow(crosst_fan_by_reason_landscape) + 12,
    startCol = ncol(crosst_fan_by_reason_kown) + 2,
    x = crosst_fan_by_reason_new,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 6,
    startRow = nrow(crosst_fan_by_reason_actor) +
      nrow(crosst_fan_by_reason_loc) +
      nrow(crosst_fan_by_reason_fan) +
      nrow(crosst_fan_by_reason_landscape) +
      nrow(crosst_fan_by_reason_kown) + 15,
    x = crosst_fan_by_reason_fun,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 6,
    startRow = nrow(crosst_fan_by_reason_actor) +
      nrow(crosst_fan_by_reason_loc) +
      nrow(crosst_fan_by_reason_fan) +
      nrow(crosst_fan_by_reason_landscape) +
      nrow(crosst_fan_by_reason_kown) + 15,
    startCol = ncol(crosst_fan_by_reason_fun) + 2,
    x = crosst_fan_by_reason_special,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  writeData(
    wb, 
    sheet = 6,
    startRow = nrow(crosst_fan_by_reason_actor) +
      nrow(crosst_fan_by_reason_loc) +
      nrow(crosst_fan_by_reason_fan) +
      nrow(crosst_fan_by_reason_landscape) +
      nrow(crosst_fan_by_reason_kown) + 15,
    startCol = ncol(crosst_fan_by_reason_fun) +
      ncol(crosst_fan_by_reason_special) + 3,
    x = crosst_fan_by_reason_unique,
    borders = "all",
    headerStyle = hs1,
    keepNA = FALSE
  )
  
  
  # page 7
  
    # define Ttables
    table_names <- c("crosst_instatime_by_info_wk", 
                     "crosst_instatime_by_info_touri", 
                     "crosst_instatime_by_info_desti", 
                     "crosst_instatime_by_info_desti_fol", 
                     "crosst_instatime_by_info_pro",
                     "crosst_instatime_by_info_no")
    
    # Loop through each cross table and add it to the worksheet
    row_start <- 1
    for (table_name in table_names) {
      # Load the cross table
      table_data <- get(table_name)
      
      # Determine the number of rows and columns in the cross table
      n_rows <- nrow(table_data)
      n_cols <- ncol(table_data)
      
      # Write the cross table to the worksheet
      writeData(
        wb, 
        sheet = 7,
        x = table_data,
        startRow = row_start,
        startCol = 1,
        borders = "all",
        headerStyle = hs1,
        keepNA = FALSE
      )
      
      # Increment the row_start variable so that the next table is written to the next row
      row_start <- row_start + n_rows + 2 # Add 2 for the blank row between tables
    }
  
  
  # page 8
  table_names <- c("crosst_instatime_by_influ_tour",
                   "crosst_instatime_by_influ_pro",
                   "crosst_instatime_by_influ_des")
  
  # Loop through each cross table and add it to the worksheet
  row_start <- 1
  for (table_name in table_names) {
    # Load the cross table
    table_data <- get(table_name)
    
    # Determine the number of rows and columns in the cross table
    n_rows <- nrow(table_data)
    n_cols <- ncol(table_data)
    
    # Write the cross table to the worksheet
    writeData(
      wb, 
      sheet = 8,
      x = table_data,
      startRow = row_start,
      startCol = 1,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    # Increment the row_start variable so that the next table is written to the next row
    row_start <- row_start + n_rows + 2 # Add 2 for the blank row between tables
  }
  

  # page 9
  table_names <- c("crosst_instatime_by_perc_samke_wk",
                   "crosst_instatime_by_perc_pret_wk",
                   "crosst_instatime_by_perc_worse_wk",
                   "crosst_instatime_by_perc_no_wk")
  
  # Loop through each cross table and add it to the worksheet
  row_start <- 1
  for (table_name in table_names) {
    # Load the cross table
    table_data <- get(table_name)
    
    # Determine the number of rows and columns in the cross table
    n_rows <- nrow(table_data)
    n_cols <- ncol(table_data)
    
    # Write the cross table to the worksheet
    writeData(
      wb, 
      sheet = 9,
      x = table_data,
      startRow = row_start,
      startCol = 1,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    )
    
    # Increment the row_start variable so that the next table is written to the next row
    row_start <- row_start + n_rows + 2 # Add 2 for the blank row between tables
  }
  
  
  # make it pretty
  setColWidths(wb, sheet = 1, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 2, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 3, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 4, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 5, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 6, cols = 1:25, widths = "auto")
  setColWidths(wb, sheet = 7, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 8, cols = 1:15, widths = "auto")
  setColWidths(wb, sheet = 9, cols = 1:15, widths = "auto")
  
  
  # save workbook
  output_path <- paste0(paths$data_processed)
  
  saveWorkbook(wb,
               paste0(output_path, "/", Sys.Date(),"_traceinterviews_crosstables_all" , ".xlsx"),
               overwrite = TRUE)
  
  cat("Save excel workbook under: ", output_path)
  
  # save the description
  output_path <- paste0(paths$data_interim)
  
  cat("Save csv description of the traceinterview data under: ", output_path)
  
  desc_df_all <- describe(df_all_raw)
  write.csv2(desc_df_all, # Diese Analyse kann ruhig in den Anhang der Arbeit gepackt werden.
             file = paste0(paths$data_interim, "/", Sys.Date(),  "_desc_traceinterview_all.csv"), 
             na = "", 
             row.names = FALSE,
             fileEncoding = "UTF-8")
  
  
  desc_df_de <- describe(df_de_raw)
  write.csv2(desc_df_de, # Diese Analyse kann ruhig in den Anhang der Arbeit gepackt werden.
             file = paste0(paths$data_interim, "/", Sys.Date(),  "_desc_traceinterview_de.csv"), 
             na = "", 
             row.names = FALSE,
             fileEncoding = "UTF-8")
  
  desc_df_st <- describe(df_st_raw)
  write.csv2(desc_df_st, # Diese Analyse kann ruhig in den Anhang der Arbeit gepackt werden.
             file = paste0(paths$data_interim, "/", Sys.Date(),  "_desc_traceinterview_st.csv"), 
             na = "", 
             row.names = FALSE,
             fileEncoding = "UTF-8")
    
  
  # Translation of the Questionair codes in the columns:
    # DE02_01	Welche Serien schauen Sie neben dem Bergdoktor im Fernsehen?
    # DE03_01	Was ist Ihre Lieblingsrubrik im Fernsehen gemessen an der Zeit, die sie damit verbringen?
    # DE03_02	Was ist Ihre Lieblingsrubrik im Fernsehen gemessen an der Zeit, die sie damit verbringen?
    # DE03_03	Was ist Ihre Lieblingsrubrik im Fernsehen gemessen an der Zeit, die sie damit verbringen?
    # DE03_04	Was ist Ihre Lieblingsrubrik im Fernsehen gemessen an der Zeit, die sie damit verbringen?
    # DE03_05	Was ist Ihre Lieblingsrubrik im Fernsehen gemessen an der Zeit, die sie damit verbringen?
    # DE03_06	Was ist Ihre Lieblingsrubrik im Fernsehen gemessen an der Zeit, die sie damit verbringen?
    # DE03_07	Was ist Ihre Lieblingsrubrik im Fernsehen gemessen an der Zeit, die sie damit verbringen?
    # DE03_08	Was ist Ihre Lieblingsrubrik im Fernsehen gemessen an der Zeit, die sie damit verbringen?
    # DE04_01	Wo wohnen Sie?
    # DE05	In welcher Art von Gemeinschaft leben Sie?
    # DE06	Was ist Ihr höchster Bildungsabschluss?
    # DE07_01	Was ist Ihr Gerburtsjahr?
    # DE08	Welchen Familienstand haben Sie zurzeit?
    # DE09	In welcher Berufsgruppe sind Sie tätig?
    # DE09_38	In welcher Berufsgruppe sind Sie tätig?
    # DE20_01	Möchten Sie noch etwas sagen?
    # DE12_01	Welche anderen Medienproduktionen locken Filmtouristen an den Wilden Kaiser?
    # DE13_01	Gibt es belastbare Zahlen zum durchschnittlichen Alter von Fans der Serie "Der Bergdoktor" am Wilden Kaiser?
    # DE14	Welche Art von Urlauber:innen entscheiden sich, motiviert durch die Serie "Der Bergdoktor", für Filmtourismus am Wilden Kaiser?
    # DE14_01	Welche Art von Urlauber:innen entscheiden sich, motiviert durch die Serie "Der Bergdoktor", für Filmtourismus am Wilden Kaiser?
    # DE14_02	Welche Art von Urlauber:innen entscheiden sich, motiviert durch die Serie "Der Bergdoktor", für Filmtourismus am Wilden Kaiser?
    # DE14_03	Welche Art von Urlauber:innen entscheiden sich, motiviert durch die Serie "Der Bergdoktor", für Filmtourismus am Wilden Kaiser?
    # DE14_04	Welche Art von Urlauber:innen entscheiden sich, motiviert durch die Serie "Der Bergdoktor", für Filmtourismus am Wilden Kaiser?
    # DE14_05	Welche Art von Urlauber:innen entscheiden sich, motiviert durch die Serie "Der Bergdoktor", für Filmtourismus am Wilden Kaiser?
    # DE14_06	Welche Art von Urlauber:innen entscheiden sich, motiviert durch die Serie "Der Bergdoktor", für Filmtourismus am Wilden Kaiser?
    # DE14_07	Welche Art von Urlauber:innen entscheiden sich, motiviert durch die Serie "Der Bergdoktor", für Filmtourismus am Wilden Kaiser?
    # DE14_08	Welche Art von Urlauber:innen entscheiden sich, motiviert durch die Serie "Der Bergdoktor", für Filmtourismus am Wilden Kaiser?
    # DE14_09	Welche Art von Urlauber:innen entscheiden sich, motiviert durch die Serie "Der Bergdoktor", für Filmtourismus am Wilden Kaiser?
    # DE14_09a	Welche Art von Urlauber:innen entscheiden sich, motiviert durch die Serie "Der Bergdoktor", für Filmtourismus am Wilden Kaiser?
    # DE15_01	In welcher Form reisen Filmtouristen der Serie "Der Bergdoktor" vorrangig an den Wilden Kaiser?
    # DE15_02	In welcher Form reisen Filmtouristen der Serie "Der Bergdoktor" vorrangig an den Wilden Kaiser?
    # DE15_03	In welcher Form reisen Filmtouristen der Serie "Der Bergdoktor" vorrangig an den Wilden Kaiser?
    # DE16	Mit welchem Verkehsmittel reisen die Filmtouristen der Serie "Der Bergdoktor" an den Wilden Kaiser?
    # DE16_01	Mit welchem Verkehsmittel reisen die Filmtouristen der Serie "Der Bergdoktor" an den Wilden Kaiser?
    # DE16_02	Mit welchem Verkehsmittel reisen die Filmtouristen der Serie "Der Bergdoktor" an den Wilden Kaiser?
    # DE16_03	Mit welchem Verkehsmittel reisen die Filmtouristen der Serie "Der Bergdoktor" an den Wilden Kaiser?
    # DE16_04	Mit welchem Verkehsmittel reisen die Filmtouristen der Serie "Der Bergdoktor" an den Wilden Kaiser?
    # DE16_05	Mit welchem Verkehsmittel reisen die Filmtouristen der Serie "Der Bergdoktor" an den Wilden Kaiser?
    # DE16_06	Mit welchem Verkehsmittel reisen die Filmtouristen der Serie "Der Bergdoktor" an den Wilden Kaiser?
    # DE16_07	Mit welchem Verkehsmittel reisen die Filmtouristen der Serie "Der Bergdoktor" an den Wilden Kaiser?
    # DE16_08	Mit welchem Verkehsmittel reisen die Filmtouristen der Serie "Der Bergdoktor" an den Wilden Kaiser?
    # DE16_08a	Mit welchem Verkehsmittel reisen die Filmtouristen der Serie "Der Bergdoktor" an den Wilden Kaiser?
    # DE17	Wie lange bleiben die Filmtouristen der Serie "Der Bergdoktor" durchschnittlich am Wilden Kaiser?
    # DE19_01	Möchten Sie noch etwas sagen?
    # DE21_01	"Wie viele Jahre bzw. Staffeln sind Sie bereits Teil der ""Der Bergdoktor"" Produktion?"
    # DE22	"Welche Rolle haben Sie bei der Produktion der Serie ""Der Bergdoktor""?"
    # DE23_01	"Bei welchen anderen Produktionen sind Sie neben der Serie ""Der Bergdoktor"" noch aktiv?"
    # DE25_01	Möchten Sie noch etwas sagen?
    #   
    # EI01	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_01	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_02	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_03	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_04	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_05	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_06	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_07	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_08	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_09	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_10	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_11	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_12	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_13	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_14	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_15	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI01_16	Welche Staffeln der Serie "Der Bergdoktor" haben sie gesehen?
    # EI06	Wie viele Folgen der Serie „Der Bergdoktor“ haben Sie gesehen?
    # EI02_01	Sind Sie ein Fan der Serie?
    # EI03_01	
    # EI04	Wie viel Zeit verbringen Sie durchschnittlich am Tag auf Instagram?
    # EI05_01	Welche Themen interessieren Sie normalerweise am meisten auf Instagram?
    # EI05_02	Welche Themen interessieren Sie normalerweise am meisten auf Instagram?
    # EI05_03	Welche Themen interessieren Sie normalerweise am meisten auf Instagram?
    # EI05_04	Welche Themen interessieren Sie normalerweise am meisten auf Instagram?
    # EI05_05	Welche Themen interessieren Sie normalerweise am meisten auf Instagram?
    # EI05_06	Welche Themen interessieren Sie normalerweise am meisten auf Instagram?
    # EI05_07	Welche Themen interessieren Sie normalerweise am meisten auf Instagram?
    # EI05_08	Welche Themen interessieren Sie normalerweise am meisten auf Instagram?
    # EI05_09	Welche Themen interessieren Sie normalerweise am meisten auf Instagram?
    # EI05_10	Welche Themen interessieren Sie normalerweise am meisten auf Instagram?
    # EI07	Haben die Mitarbeiter:innen, zuständig für Filmtourismusbeiträge, auf Instagram die Serie "Der Bergdoktor" gesehen?
    # EI08_01	Wie tritt der Account auf Instagram insgesamt auf?
    # EI08_02	Wie tritt der Account auf Instagram insgesamt auf?
    # EI08_03	Wie tritt der Account auf Instagram insgesamt auf?
    # EI08_04	Wie tritt der Account auf Instagram insgesamt auf?
    # EI08_05	Wie tritt der Account auf Instagram insgesamt auf?
    # EI08_06	Wie tritt der Account auf Instagram insgesamt auf?
    # EI09	Wie viel Zeit verbringen Sie durchschnittlich am Tag mit Instagram?
    # EI10_01	Wie tritt Ihr Account auf Instagram insgesamt auf?
    # EI10_02	Wie tritt Ihr Account auf Instagram insgesamt auf?
    # EI10_03	Wie tritt Ihr Account auf Instagram insgesamt auf?
    # EI10_04	Wie tritt Ihr Account auf Instagram insgesamt auf?
    # EI10_05	Wie tritt Ihr Account auf Instagram insgesamt auf?
    # EI10_06	Wie tritt Ihr Account auf Instagram insgesamt auf?
    # 
    # IP02	
    # IP51	
    # IP53	
    # IP55	
    # IP14_01	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP14_09	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP14_29	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP14_30	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP14_33	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP14_35	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP14_38	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP52_10	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP52_13	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP52_16	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP52_26	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP52_32	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP52_33	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP54_07	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP54_19	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP54_26	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP56_01	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP56_05	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP56_10	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP56_11	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP56_18	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP56_23	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP56_28	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP56_33	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP17	Ist das Ihr Beitrag zum Thema "Filmtourismus am Wilden Kaiser"?
    # IP01	Ist der Beitrag ein "repost" eines anderen Beitrags?
    # IP04_01	Warum haben Sie diesen Beitrag auf Instagram mit diesen Hashtags veröffentlicht?
    # IP05_01	Warum haben Sie diesen Beitrag auf Instagram mit diesen Mentions veröffentlicht?
    # IP06_01	Warum haben Sie diesen Beitrag auf Instagram mit diesem Text veröffentlicht?
    # IP07_01	Warum haben Sie sich bei diesem Instagram-Beitrag für dieses Foto (bzw. Albumfotos) entschieden?
    # IP08_01	Wie war die Situation vor Ort, als das Foto entstanden ist?
    # IP11	Welchen fiktionalen Ort aus der Serie "Der Bergdoktor" zeigt das Foto aus Ihrem Beitrag?
    # IP11s	Welchen fiktionalen Ort aus der Serie "Der Bergdoktor" zeigt das Foto aus Ihrem Beitrag?
    # IP12_01	Wann ist das Foto/Bild entstanden?
    # IP13	Wurde der Beitrag gepostet, direkt nachdem das Foto/Bild im Urlaub am Wilden Kaiser entstanden ist?
    # IP18	
    # IP57	
    # IP19_04	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP19_09	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP19_10	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP19_16	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP58_02	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP58_23	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP20	Ist das Ihr Beitrag zum Thema "Filmtourismus am Wilden Kaiser"?
    # IP21	Ist der Beitrag ein "Repost" eines anderen Beitrags?
    # IP23_01	Warum haben Sie diesen Beitrag auf Instagram mit diesen "Hashtags" veröffentlicht?
    # IP24_01	Warum haben Sie diesen Beitrag auf Instagram mit diesen "Mentions" veröffentlicht?
    # IP25_01	Warum haben Sie diesen Beitrag auf Instagram mit diesem Text veröffentlicht?
    # IP26_01	Warum haben Sie sich bei Ihrem Instagram-Beitrag für dieses Foto (bzw. Albumfotos) entschieden?
    # IP27	Handelt es sich im Beitrag um ein kommerzielles Foto?
    # IP30	Welchen fiktionalen Ort aus der Serie "Der Bergdoktor" zeigt das Foto aus Ihrem Beitrag?
    # IP30s	Welchen fiktionalen Ort aus der Serie "Der Bergdoktor" zeigt das Foto aus Ihrem Beitrag?
    # IP31_01	Wann ist das Foto/Bild entstanden?
    # IP32_01	Haben Sie für oder im Foto etwas verändert?
    # IP36	
    # IP37_19	Ich habe mir den Instagram-Beitrag hinter dem Link angesehen?
    # IP38	Ist das Ihr Beitrag zum Thema "Filmtourismus am Wilden Kaiser"?
    # IP39	Ist der Beitrag ein "repost" eines anderen Beitrags?
    # IP40_01	Warum haben Sie diesen Beitrag auf Instagram mit diesen "Hashtags" veröffentlicht?
    # IP41_01	Warum haben Sie diesen Beitrag auf Instagram mit diesen "Mentions" veröffentlicht?
    # IP42_01	Warum haben Sie diesen Beitrag auf Instagram mit diesem Text veröffentlicht?
    # IP43_01	Warum haben Sie sich bei diesem Instagram-Beitrag für dieses Foto (bzw. Albumfotos) entschieden?
    # IP44	Handelt es sich bei dem Foto im Beitrag um ein kommerzielles Foto?
    # IP45_01	Wie war die Situation vor Ort, als das Foto entstanden ist?
    # IP47	Welchen fiktionalen Ort aus der Serie "Der Bergdoktor" zeigt das Foto aus Ihrem Beitrag?
    # IP47s	Welchen fiktionalen Ort aus der Serie "Der Bergdoktor" zeigt das Foto aus Ihrem Beitrag?
    # IP48_01	Wann ist das Foto/Bild entstanden?
    # IP49	Wurde der Beitrag gepostet, direkt nachdem das Foto/Bild beim Dreh am Wilden Kaiser entstanden ist?
    # IP50_01	Haben Sie den Drehort so fotografiert wie Sie Ihn vor Ort vorgefunden haben? Haben Sie für oder im Foto etwas verändert?
    # 
    # IT01_01	Wie sehr haben Sie Instagram in der Vorbereitung auf den Urlaub am Wilden Kaiser genutzt?
    # IT01_02	Wie sehr haben Sie Instagram in der Vorbereitung auf den Urlaub am Wilden Kaiser genutzt?
    # IT01_03	Wie sehr haben Sie Instagram in der Vorbereitung auf den Urlaub am Wilden Kaiser genutzt?
    # IT01_04	Wie sehr haben Sie Instagram in der Vorbereitung auf den Urlaub am Wilden Kaiser genutzt?
    # IT01_05	Wie sehr haben Sie Instagram in der Vorbereitung auf den Urlaub am Wilden Kaiser genutzt?
    # IT01_06	Wie sehr haben Sie Instagram in der Vorbereitung auf den Urlaub am Wilden Kaiser genutzt?
    # IT02_01	Haben Sie die Beiträge der anderen Akteure in Ihrer Entscheidung, an den Wilden Kaiser zu fahren, beeinflusst?
    # IT02_02	Haben Sie die Beiträge der anderen Akteure in Ihrer Entscheidung, an den Wilden Kaiser zu fahren, beeinflusst?
    # IT02_03	Haben Sie die Beiträge der anderen Akteure in Ihrer Entscheidung, an den Wilden Kaiser zu fahren, beeinflusst?
    # IT03_01	Wie stellt sich der Wilde Kaiser dar?
    # IT03_02	Wie stellt sich der Wilde Kaiser dar?
    # IT03_03	Wie stellt sich der Wilde Kaiser dar?
    # IT03_04	Wie stellt sich der Wilde Kaiser dar?
    # IT04	Waren Sie schon mal auf einem Bergdoktor-Fantag am Wilden Kaiser?
    # IT05_01	In welchem Zeitraum fand der Urlaub am Wilden Kaiser statt, von dem die auf Instagram geposteten Fotos stammen?
    # IT05_02	In welchem Zeitraum fand der Urlaub am Wilden Kaiser statt, von dem die auf Instagram geposteten Fotos stammen?
    # IT06_01	Was hat Sie zu dieser Reise motiviert?
    # IT07	Welche Rolle hat die Serie "Der Bergdoktor" gespielt?
    # IT08_01	Was waren Ihre Gründe, die Drehorte des Bergdoktors am Wilden Kaiser zu besuchen?
    # IT08_02	Was waren Ihre Gründe, die Drehorte des Bergdoktors am Wilden Kaiser zu besuchen?
    # IT08_03	Was waren Ihre Gründe, die Drehorte des Bergdoktors am Wilden Kaiser zu besuchen?
    # IT08_04	Was waren Ihre Gründe, die Drehorte des Bergdoktors am Wilden Kaiser zu besuchen?
    # IT08_05	Was waren Ihre Gründe, die Drehorte des Bergdoktors am Wilden Kaiser zu besuchen?
    # IT08_06	Was waren Ihre Gründe, die Drehorte des Bergdoktors am Wilden Kaiser zu besuchen?
    # IT08_07	Was waren Ihre Gründe, die Drehorte des Bergdoktors am Wilden Kaiser zu besuchen?
    # IT08_08	Was waren Ihre Gründe, die Drehorte des Bergdoktors am Wilden Kaiser zu besuchen?
    # IT08_09	Was waren Ihre Gründe, die Drehorte des Bergdoktors am Wilden Kaiser zu besuchen?
    # IT08_10	Was waren Ihre Gründe, die Drehorte des Bergdoktors am Wilden Kaiser zu besuchen?
    # IT08_11	Was waren Ihre Gründe, die Drehorte des Bergdoktors am Wilden Kaiser zu besuchen?
    # IT09	Wie haben Sie die Drehorte entdeckt bzw. davon erfahren?
    # IT09_05	Wie haben Sie die Drehorte entdeckt bzw. davon erfahren?
    # IT10_01	Welche Drehorte haben Sie am Wilden Kaiser besucht?
    # IT10_02	Welche Drehorte haben Sie am Wilden Kaiser besucht?
    # IT10_03	Welche Drehorte haben Sie am Wilden Kaiser besucht?
    # IT10_04	Welche Drehorte haben Sie am Wilden Kaiser besucht?
    # IT10_05	Welche Drehorte haben Sie am Wilden Kaiser besucht?
    # IT10_06	Welche Drehorte haben Sie am Wilden Kaiser besucht?
    # IT10_07	Welche Drehorte haben Sie am Wilden Kaiser besucht?
    # IT15_01	An welchen Drehorten waren Sie ihrem Gefühl nach der fiktionalen Welt der Serie "Der Bergdoktor" und ihrer Charaktere besonders nahe?
    # IT15_02	An welchen Drehorten waren Sie ihrem Gefühl nach der fiktionalen Welt der Serie "Der Bergdoktor" und ihrer Charaktere besonders nahe?
    # IT15_03	An welchen Drehorten waren Sie ihrem Gefühl nach der fiktionalen Welt der Serie "Der Bergdoktor" und ihrer Charaktere besonders nahe?
    # IT15_04	An welchen Drehorten waren Sie ihrem Gefühl nach der fiktionalen Welt der Serie "Der Bergdoktor" und ihrer Charaktere besonders nahe?
    # IT15_05	An welchen Drehorten waren Sie ihrem Gefühl nach der fiktionalen Welt der Serie "Der Bergdoktor" und ihrer Charaktere besonders nahe?
    # IT15_06	An welchen Drehorten waren Sie ihrem Gefühl nach der fiktionalen Welt der Serie "Der Bergdoktor" und ihrer Charaktere besonders nahe?
    # IT15_07	An welchen Drehorten waren Sie ihrem Gefühl nach der fiktionalen Welt der Serie "Der Bergdoktor" und ihrer Charaktere besonders nahe?
    # IT13	Wie oft waren Sie schon am Wilden Kaiser?
    # IT14	Waren Sie schon mal bewusst an anderen Filmtourismus Orten?
    # IT16	Was kam zuerst?
    # IT17	Ist Filmtourismus Teil der Social-Media-Strategie Ihres Accounts?
    # IT18_01	Gibt es bestimmte Vorgaben speziell für Filmtourismus-Beiträge durch Verantwortliche in der Destination?
    # IT19_01	Versucht Ihr Account sich bei Filmtourismus-Beiträgen einem bestimmten Stil anderer Akteure auf Instagram anzunähern?
    # IT19_02	Versucht Ihr Account sich bei Filmtourismus-Beiträgen einem bestimmten Stil anderer Akteure auf Instagram anzunähern?
    # IT19_03	Versucht Ihr Account sich bei Filmtourismus-Beiträgen einem bestimmten Stil anderer Akteure auf Instagram anzunähern?
    # IT19_04	Versucht Ihr Account sich bei Filmtourismus-Beiträgen einem bestimmten Stil anderer Akteure auf Instagram anzunähern?
    # IT19_05	Versucht Ihr Account sich bei Filmtourismus-Beiträgen einem bestimmten Stil anderer Akteure auf Instagram anzunähern?
    # IT19_06	Versucht Ihr Account sich bei Filmtourismus-Beiträgen einem bestimmten Stil anderer Akteure auf Instagram anzunähern?
    # IT20	In welcher Jahreszeit findet Filmtourismus am Wilden Kaiser eher statt?
    # IT20_01	In welcher Jahreszeit findet Filmtourismus am Wilden Kaiser eher statt?
    # IT20_02	In welcher Jahreszeit findet Filmtourismus am Wilden Kaiser eher statt?
    # IT20_03	In welcher Jahreszeit findet Filmtourismus am Wilden Kaiser eher statt?
    # IT20_04	In welcher Jahreszeit findet Filmtourismus am Wilden Kaiser eher statt?
    # IT21_01	"Ermutigen Sie die Nutzer:innen?"
    # IT21_02	"Ermutigen Sie die Nutzer:innen?"
    # IT22_01	Hat sich das Image des Wilden Kaisers aufgrund der Serie "Der Bergdoktor" verändert? 
    # IT24_01	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Filmtourismusorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT24_02	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Filmtourismusorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT24_03	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Filmtourismusorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT24_04	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Filmtourismusorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT24_05	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Filmtourismusorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT24_06	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Filmtourismusorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT24_07	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Filmtourismusorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT25_01	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Drehorte der Serie "Der Bergdoktor" in den sozialen Medien?
    # IT25_02	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Drehorte der Serie "Der Bergdoktor" in den sozialen Medien?
    # IT25_03	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Drehorte der Serie "Der Bergdoktor" in den sozialen Medien?
    # IT25_04	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Drehorte der Serie "Der Bergdoktor" in den sozialen Medien?
    # IT25_05	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Drehorte der Serie "Der Bergdoktor" in den sozialen Medien?
    # IT25_06	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Drehorte der Serie "Der Bergdoktor" in den sozialen Medien?
    # IT25_07	Was sind laut Ihrer Meinung und Einsicht die beliebtesten Drehorte der Serie "Der Bergdoktor" in den sozialen Medien?
    # IT26_01	Wie schätzen Sie die Bergdoktor-Fantage am Wilden Kaiser ein?
    # IT27_01	"Gab oder gibt es Überlegungen Virtual Reality (VR) bzw. Augmented Reality (AR) oder verwandte Technologien beim Filmtourismus am Wilder Kaiser einzusetzen?"
    # IT27_02	"Gab oder gibt es Überlegungen Virtual Reality (VR) bzw. Augmented Reality (AR) oder verwandte Technologien beim Filmtourismus am Wilder Kaiser einzusetzen?"
    # IT27_03	"Gab oder gibt es Überlegungen Virtual Reality (VR) bzw. Augmented Reality (AR) oder verwandte Technologien beim Filmtourismus am Wilder Kaiser einzusetzen?"
    # IT27_04	"Gab oder gibt es Überlegungen Virtual Reality (VR) bzw. Augmented Reality (AR) oder verwandte Technologien beim Filmtourismus am Wilder Kaiser einzusetzen?"
    # IT28_01	Gibt es bestimmte Vorgaben speziell für Filmtourismus-Beiträge durch Verantwortliche in der Destination?
    # IT29_01	Gibt es bestimmte Vorgaben durch die Produktion (ZDF, ORF, NDF, etc.) wie die Serie "Der Bergdoktor" dargestellt werden soll auf Instagram?
    # IT33_01	Was sind laut Ihrer Meinung und Einsicht die von Touristen meist besuchten Drehorte der Serie "Der Bergdoktor"?
    # IT33_02	Was sind laut Ihrer Meinung und Einsicht die von Touristen meist besuchten Drehorte der Serie "Der Bergdoktor"?
    # IT33_03	Was sind laut Ihrer Meinung und Einsicht die von Touristen meist besuchten Drehorte der Serie "Der Bergdoktor"?
    # IT33_04	Was sind laut Ihrer Meinung und Einsicht die von Touristen meist besuchten Drehorte der Serie "Der Bergdoktor"?
    # IT33_05	Was sind laut Ihrer Meinung und Einsicht die von Touristen meist besuchten Drehorte der Serie "Der Bergdoktor"?
    # IT33_06	Was sind laut Ihrer Meinung und Einsicht die von Touristen meist besuchten Drehorte der Serie "Der Bergdoktor"?
    # IT33_07	Was sind laut Ihrer Meinung und Einsicht die von Touristen meist besuchten Drehorte der Serie "Der Bergdoktor"?
    # IT30_01	Was sind laut Ihrer Meinung und Einsicht die meist genutzten Drehorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT30_02	Was sind laut Ihrer Meinung und Einsicht die meist genutzten Drehorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT30_03	Was sind laut Ihrer Meinung und Einsicht die meist genutzten Drehorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT30_04	Was sind laut Ihrer Meinung und Einsicht die meist genutzten Drehorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT30_05	Was sind laut Ihrer Meinung und Einsicht die meist genutzten Drehorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT30_06	Was sind laut Ihrer Meinung und Einsicht die meist genutzten Drehorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT30_07	Was sind laut Ihrer Meinung und Einsicht die meist genutzten Drehorte der Serie "Der Bergdoktor" am Wilden Kaiser?
    # IT31_01	Wie schätzen Sie die Bergdoktor-Fantage am Wilden Kaiser ein?
    # IT32_01	War der Ort der Produktion am Wilden Kaiser einer der Gründe bei der Serie "Der Bergdoktor" mitzuwirken?
    # 

  





























# end this shit
end_time <- Sys.time()
cat("End Script:", format(Sys.time(), "%H:%M:%S"), "\n", 
    "Differenz: ", difftime(end_time, start_time, units = "secs"), "Sekunden", "\n") 