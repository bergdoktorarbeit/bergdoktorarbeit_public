rm(list = ls()) # Remove all stuff in Environment

start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")

# set working dirctory
setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

source("scripts/init_v0.6.R")



# etl film geography data


# list files
cat("Data load from: ", paths$filmgeo_data, "\n")



# load files

# load data
filmgeo_file <- paste0(paths$filmgeo_data, 
                       "/20221215_Bergdoktor Orte in der Serie_Alle Staffeln.xlsx")

df_1.1_filmgeo_all_raw <- tibble()

for (xlsx_sheet in c(2:11)) {
  
  # xlsx_sheet <- 3      # zum testen

  df_temp <- read.xlsx(
    filmgeo_file,
    sheet = xlsx_sheet,
    startRow = 2,
    detectDates = TRUE) %>% 
    data.frame() %>% 
    mutate(
      season = as.numeric(Season),
      episode_total = as.numeric(Episode.Insgesamt),
      episode = as.numeric(Episode),
      elternhaus_num = as.numeric(Elternhaus),
      elternhaus_außen = as.character(Elternhaus.außen),
      elternhaus_innen = as.character(Elternhaus.innen),
      baum = as.character(Baum),
      baum_2_num = as.numeric(Baum2),
      essplatz = as.character(Essplatz),
      praxis_num = as.numeric(Praxis),
      praxis_innen = as.character(Praxis.innen),
      praxis_außen = as.character(Praxis.außen),
      kirche = as.character(Kirche),
      wilder_kaiser_num = as.numeric(Wilder.Kaiser.Hof),
      wilder_kaiser_außen = as.character(Wilder.Kaiser.Außen),
      wilder_kaiser_innen = as.character(Wilder.Kaiser.innen),
      dorfplatz = as.character(Dorfplatz),
      krankenhaus_num = as.numeric(Krankenhaus),
      krankenhaus_lp = as.character(Landeplatz),
      krankenhaus_sons = as.character(Krankenhaus..Sonstiges.),
      krankenhaus_forum = as.character(Krankenhaus..Forum.),
      krankenhaus_intensiv = as.character(Intensivstation),
      panorama_dorf = as.character(Dorfpanorama),
      panorama_berg = as.character(Bergpanorama),
      panorama_stadt = as.character(Stadtpanorama),
      distelmeier = as.character(Distelmeier.Haus),
      car_street = as.character(Auto.auf.Straße),
      kanzlei = as.character(Anwaltskanzlei),
      hintersteiner = as.character(Hintersteiner.See),
      segelschule = as.character(Segelschule.Rest.),
      bahnhof = as.character(Bahnhof),
      schule = as.character(Schule),
      sonstiges = as.character(Sonstiges),
      bezug = as.character(Bezug.zur.Landschaft),
      comment = as.character(Kommentar)
    ) %>% 
    select(
      season,
      episode_total,
      episode,
      elternhaus_num,
      elternhaus_außen,
      elternhaus_innen,
      baum,
      baum_2_num,
      essplatz,
      praxis_num,
      praxis_innen,
      praxis_außen,
      kirche,
      wilder_kaiser_num,
      wilder_kaiser_außen,
      wilder_kaiser_innen,
      dorfplatz,
      krankenhaus_num,
      krankenhaus_lp,
      krankenhaus_sons,
      krankenhaus_forum,
      krankenhaus_intensiv,
      panorama_dorf,
      panorama_berg,
      panorama_stadt,
      distelmeier,
      car_street,
      kanzlei,
      hintersteiner,
      segelschule,
      bahnhof,
      schule,
      sonstiges,
      bezug,
      comment
    )
  
  df_1.1_filmgeo_all_raw <- bind_rows(df_1.1_filmgeo_all_raw , df_temp)

}
  

# convert to char to get NA out for empty
df_1.2_filmgeo_all_char<-  sapply(df_1.1_filmgeo_all_raw, as.character)

df_1.2_filmgeo_all_char[is.na(df_1.2_filmgeo_all_char)] <- ""

df_1.2_filmgeo_all_char <-  df_1.2_filmgeo_all_char %>% 
  data.frame() %>% 
  filter(!season == "") 


# populate fields with data
df_2_filmgeo_all <- df_1.2_filmgeo_all_char %>% # count main locations
  mutate(elternhaus_num = if_else(elternhaus_num == "", 
                          as.character(str_count(elternhaus_außen,",") + 
                                         str_count(elternhaus_innen, ",") ),
                          elternhaus_num
                          ),
         praxis_num = if_else(praxis_num == "", 
                      as.character(str_count(praxis_außen,",") + 
                                   str_count(praxis_innen, ",") ),
                      praxis_num
                      ),
         kirche_num = if_else(str_detect(kirche, "\\d+(\\*|,)") == TRUE, 
                              as.character(str_count(kirche,",") ),
                              kirche
                        ),
         wilder_kaiser_num = if_else(wilder_kaiser_num == "", 
                              as.character(str_count(wilder_kaiser_außen,",") + 
                                           str_count(wilder_kaiser_innen, ",") ),
                              wilder_kaiser_num
                              ),
         dorfplatz_num = if_else(str_detect(dorfplatz, "\\d+(\\*|,)") == TRUE, 
                              as.character(str_count(dorfplatz,",") ),
                              dorfplatz
                            ),
         krankenhaus_num = if_else(krankenhaus_num == "", 
                           as.character(str_count(krankenhaus_lp,",") + 
                                        str_count(krankenhaus_sons,",") + 
                                        str_count(krankenhaus_forum, ",") +
                                        str_count(krankenhaus_intensiv, ",") ),
                           krankenhaus_num
                            )
         )%>% 
  mutate(
    elternhaus_außen_num = str_count(elternhaus_außen,","),
    elternhaus_innen_num = str_count(elternhaus_innen,","),
    baum = str_count(baum,","),
    praxis_außen_num = str_count(praxis_außen,","),
    praxis_innen_num = str_count(praxis_innen,","),
    wilder_kaiser_außen_num = str_count(wilder_kaiser_außen,","),
    wilder_kaiser_innen_num = str_count(wilder_kaiser_innen,","),
    krankenhaus_lp_num = str_count(krankenhaus_lp,","),
    krankenhaus_sons_num = str_count(krankenhaus_sons,","),
    krankenhaus_forum_num = str_count(krankenhaus_forum,","),
    krankenhaus_intensiv_num = str_count(krankenhaus_intensiv,",")
  ) %>% # Mutate, count and clean up panorama coloumns
  mutate(panorama_dorf_num = as.numeric(if_else(as.numeric(episode_total) <= 63, #NOTE: FROM episode 63 onwords location are coded with their sequential appereance in an episode
                                     panorama_dorf,
                                     as.character(str_count(panorama_dorf, ",") )
                              )),
         panorama_berg_num = as.numeric(if_else(as.numeric(episode_total) <= 63, 
                                     panorama_berg,
                                     as.character(str_count(panorama_berg, ",") )
                              )),
         panorama_stadt_num = as.numeric(if_else(as.numeric(episode_total) <= 63, 
                                     panorama_stadt,
                                     as.character(str_count(panorama_stadt, ",") )
                              )),
         elmau_num = as.numeric(kirche_num) + 
                     as.numeric(wilder_kaiser_num) + 
                     as.numeric(dorfplatz_num)
         ) %>% 
  replace(is.na(.), 0) %>% # replace NAs to count panorama total
  mutate(panorama_total_num = panorama_dorf_num + 
                        panorama_berg_num +
                        panorama_stadt_num ) %>%  # Mutate, count and clean up other location columns
mutate(car_street_num = as.numeric(if_else(as.numeric(episode_total) <= 63, 
                                              car_street,
                                              as.character(str_count(car_street, ",") )
                        )),
       hintersteiner_num = as.numeric(if_else(as.numeric(episode_total) <= 63, 
                                           hintersteiner,
                                           as.character(str_count(hintersteiner, ",") )
                            )),
       bahnhof_num = as.numeric(if_else(as.numeric(episode_total) <= 63, 
                                              bahnhof,
                                              as.character(str_count(bahnhof, ",") )
                      )),
       schule_num = as.numeric(if_else(as.numeric(episode_total) <= 63, 
                                        schule,
                                        as.character(str_count(schule, ",") )
                    )),
       essplatz_num = as.numeric(if_else(as.numeric(episode_total) <= 63, 
                                       essplatz,
                                       as.character(str_count(essplatz, ",") )
                      )),
        ) %>% 
  replace(is.na(.), 0) %>% 
  mutate(
    elternhaus_außen_gv = str_count(elternhaus_außen, "\\*"),
    elternhaus_innen_gv = str_count(elternhaus_innen, "\\*"),
    essplatz_gv = str_count(essplatz, "\\*"),
    baum_gv = str_count(baum, "\\*"),
    praxis_außen_gv = str_count(praxis_außen, "\\*"),
    praxis_innen_gv = str_count(praxis_innen, "\\*"),
    kirche_gv = str_count(kirche, "\\*"),
    wilder_kaiser_außen_gv = str_count(wilder_kaiser_außen, "\\*"),
    wilder_kaiser_innen_gv = str_count(wilder_kaiser_innen, "\\*"),
    dorfplatz_gv = str_count(dorfplatz, "\\*"),
    krankenhaus_lp_gv = str_count(krankenhaus_lp, "\\*"),
    krankenhaus_sons_gv = str_count(krankenhaus_sons, "\\*"),
    krankenhaus_forum_gv = str_count(krankenhaus_forum, "\\*"),
    krankenhaus_intensiv_gv = str_count(krankenhaus_intensiv, "\\*"), 
    distelmeier_gv = str_count(distelmeier, "\\*"),
    car_street_gv = str_count(car_street, "\\*"),
    hintersteiner_gv = str_count(hintersteiner, "\\*"),
    segelschule_gv = str_count(segelschule, "\\*"),
    bahnhof_gv = str_count(bahnhof, "\\*"),
    schule_gv = str_count(schule, "\\*"),
    sonstiges_gv = str_count(sonstiges, "\\*")
  )%>% # calculate good_view: every field with a *
  mutate(good_view = if_else(as.numeric(episode_total) <= 63,
                             "",
                             as.character(
                               elternhaus_außen_gv +
                               elternhaus_innen_gv +
                               baum_gv +
                               essplatz_gv +
                               praxis_außen_gv +
                               praxis_innen_gv +
                               kirche_gv +
                               wilder_kaiser_außen_gv +
                               wilder_kaiser_innen_gv +
                               dorfplatz_gv +
                               krankenhaus_lp_gv +
                               krankenhaus_sons_gv +
                               krankenhaus_forum_gv +
                               krankenhaus_intensiv_gv + 
                               distelmeier_gv +
                               car_street_gv +
                               hintersteiner_gv +
                               segelschule_gv +
                               bahnhof_gv +
                               schule_gv +
                               sonstiges_gv
                             )
                        )
  ) %>% #calculate good_view_total
  mutate(
    good_view_total = if_else(as.numeric(episode_total) <= 63,
                              "",
                              as.character(panorama_total_num + 
                                             as.numeric(good_view) ) 
                      )
  )



df_3_filmgeo_all_extract <- df_2_filmgeo_all %>% # extract the sonstiges locations
  mutate(sonstiges_loc_ = str_extract_all(df_2_filmgeo_all$sonstiges, 
                                          "[^;]+(?=;)", 
                                          simplify = TRUE) ) %>% 
  mutate(sonstiges_loc_1 = sonstiges_loc_[,1],
         sonstiges_loc_2 = sonstiges_loc_[,2],
         sonstiges_loc_3 = sonstiges_loc_[,3],
         sonstiges_loc_4 = sonstiges_loc_[,4],
         sonstiges_loc_5 = sonstiges_loc_[,5],
         sonstiges_loc_6 = sonstiges_loc_[,6],
         sonstiges_loc_7 = sonstiges_loc_[,7],
         sonstiges_loc_8 = sonstiges_loc_[,8],
         sonstiges_loc_9 = sonstiges_loc_[,9],
         sonstiges_loc_10 = sonstiges_loc_[,10],
         sonstiges_loc_11 = sonstiges_loc_[,11],
         sonstiges_loc_12 = sonstiges_loc_[,12],
         sonstiges_loc_13 = sonstiges_loc_[,13],
         sonstiges_loc_14 = sonstiges_loc_[,14],
         sonstiges_loc_15 = sonstiges_loc_[,15]) %>% 
  select(-sonstiges_loc_) %>% 
  #select(starts_with("sonstiges_loc_")) %>% 
  mutate(sonstiges_loc_num = str_count(sonstiges, ";")
         )



df_4_filmgeo_location_list <- df_3_filmgeo_all_extract %>% # clean up loactaions data
  #filter(as.numeric(episode_total) >= 57) %>% # remove * and , and digits and x
  mutate(sonstiges_loc_1 = str_remove_all(sonstiges_loc_1, "[\\*,(\\d+x)]+"),
         sonstiges_loc_2 = str_remove_all(sonstiges_loc_2, "[\\*,(\\d+x)]+"),
         sonstiges_loc_3 = str_remove_all(sonstiges_loc_3, "[\\*,(\\d+x)]+"),
         sonstiges_loc_4 = str_remove_all(sonstiges_loc_4, "[\\*,(\\d+x)]+"),
         sonstiges_loc_5 = str_remove_all(sonstiges_loc_5, "[\\*,(\\d+x)]+"),
         sonstiges_loc_6 = str_remove_all(sonstiges_loc_6, "[\\*,(\\d+x)]+"),
         sonstiges_loc_7 = str_remove_all(sonstiges_loc_7, "[\\*,(\\d+x)]+"),
         sonstiges_loc_8 = str_remove_all(sonstiges_loc_8, "[\\*,(\\d+x)]+"),
         sonstiges_loc_9 = str_remove_all(sonstiges_loc_9, "[\\*,(\\d+x)]+"),
         sonstiges_loc_10 = str_remove_all(sonstiges_loc_10, "[\\*,(\\d+x)]+"),
         sonstiges_loc_11 = str_remove_all(sonstiges_loc_11, "[\\*,(\\d+x)]+"),
         sonstiges_loc_12 = str_remove_all(sonstiges_loc_12, "[\\*,(\\d+x)]+"),
         sonstiges_loc_13 = str_remove_all(sonstiges_loc_13, "[\\*,(\\d+x)]+"),
         sonstiges_loc_14 = str_remove_all(sonstiges_loc_14, "[\\*,(\\d+x)]+"),
         sonstiges_loc_15 = str_remove_all(sonstiges_loc_15, "[\\*,(\\d+x)]+") ) %>% 
  mutate(sonstiges_loc_1 = str_remove(sonstiges_loc_1, "^\\s+"), # Clean up all spaces
         sonstiges_loc_2 = str_remove(sonstiges_loc_2, "^\\s+"),
         sonstiges_loc_3 = str_remove(sonstiges_loc_3, "^\\s+"),
         sonstiges_loc_4 = str_remove(sonstiges_loc_4, "^\\s+"),
         sonstiges_loc_5 = str_remove(sonstiges_loc_5, "^\\s+"),
         sonstiges_loc_6 = str_remove(sonstiges_loc_6, "^\\s+"),
         sonstiges_loc_7 = str_remove(sonstiges_loc_7, "^\\s+"),
         sonstiges_loc_8 = str_remove(sonstiges_loc_8, "^\\s+"),
         sonstiges_loc_9 = str_remove(sonstiges_loc_9, "^\\s+"),
         sonstiges_loc_10 = str_remove(sonstiges_loc_10, "^\\s+"),
         sonstiges_loc_11 = str_remove(sonstiges_loc_11, "^\\s+"),
         sonstiges_loc_12 = str_remove(sonstiges_loc_12, "^\\s+"),
         sonstiges_loc_13 = str_remove(sonstiges_loc_13, "^\\s+"),
         sonstiges_loc_14 = str_remove(sonstiges_loc_14, "^\\s+"),
         sonstiges_loc_15 = str_remove(sonstiges_loc_15, "^\\s+") ) %>% 
  select( # select necessary coloumns
    1:3,
    ends_with("_num"),
    ends_with("_gv"),
    -sonstiges_gv,
    starts_with("sonstiges_loc_"),
    -sonstiges_loc_num,
    -baum_2_num,
    -panorama_total_num,
    -krankenhaus_forum,
    -krankenhaus_intensiv
    ) %>% 
  mutate_if(is.double, as.character())


## Location num
  
df_4.1_filmgeo_main_location_num_1_96 <- df_4_filmgeo_location_list %>% # get all the locations episode 1 to 96
  mutate(
         panorama_dorf_num = as.character(panorama_dorf_num),
         panorama_berg_num = as.character(panorama_berg_num),
         panorama_stadt_num = as.character(panorama_stadt_num),
         car_street_num = as.character(car_street_num),
         hintersteiner_num = as.character(hintersteiner_num),
         bahnhof_num = as.character(bahnhof_num),
         schule_num = as.character(schule_num),
         essplatz_num = as.character(essplatz_num),
         elmau_num = as.character(elmau_num),
         elternhaus_außen_num = as.character(elternhaus_außen_num),
         elternhaus_innen_num = as.character(elternhaus_innen_num),
         praxis_außen_num = as.character(praxis_außen_num),
         praxis_innen_num = as.character(praxis_innen_num),
         wilder_kaiser_außen_num = as.character(wilder_kaiser_außen_num),
         wilder_kaiser_innen_num = as.character(wilder_kaiser_innen_num),
         krankenhaus_lp_num = as.character(krankenhaus_lp_num),
         krankenhaus_sons_num = as.character(krankenhaus_sons_num),
         krankenhaus_forum_num = as.character(krankenhaus_forum_num),
         krankenhaus_intensiv_num = as.character(krankenhaus_intensiv_num)
         ) %>%
  select(1:3,
         ends_with("_num")
         ) %>% 
  pivot_longer(cols = ends_with("_num")) %>%
  mutate(value_num = as.numeric(value),
         season = as.numeric(season),
         episode_total = as.numeric(episode_total),
         episode = as.numeric(episode),
         name = as.character(str_replace(name, "_num", ""))) %>% 
  filter(value_num != 0 | value_num != is.na(value_num)) %>% 
  select(-value)

df_4.1_filmgeo_main_location_num_1_96_location <- df_4.1_filmgeo_main_location_num_1_96 %>% 
  group_by(name) %>% 
  summarise(location_num_sum = sum(value_num) ) %>% 
  mutate(name = str_replace(name, "_num", "") ) %>% 
  select(
    location = name,
    2
  )

df_4.1_filmgeo_main_location_num_1_96_season <- df_4.1_filmgeo_main_location_num_1_96 %>% 
  group_by(name, season) %>% 
  summarise(location_num_sum = sum(value_num), .groups = "keep" ) %>% 
  mutate(name = str_replace(name, "_num", "") ) %>% 
  select(
    season,
    location = name,
    3
  )

df_4.1_filmgeo_main_location_num_1_96_episode <- df_4.1_filmgeo_main_location_num_1_96 %>% 
  group_by(name, episode) %>% 
  summarise(location_num_sum = sum(value_num), .groups = "keep" ) %>% 
  mutate(name = str_replace(name, "_num", "") ) %>% 
  select(
    episode,
    location = name,
    3
  )


# df_4.1_filmgeo_location_num_57_96 <- df_4_filmgeo_location_list %>% # get the locations episode 57 to 96
#   filter(as.numeric(episode_total) >= 57) %>% # filter for episodes with coded good view
#   mutate(panorama_dorf_num = as.character(panorama_dorf_num),
#          panorama_berg_num = as.character(panorama_berg_num),
#          panorama_stadt_num = as.character(panorama_stadt_num),
#          car_street_num = as.character(car_street_num),
#          hintersteiner_num = as.character(hintersteiner_num),
#          bahnhof_num = as.character(bahnhof_num),
#          schule_num = as.character(schule_num),
#          essplatz_num = as.character(essplatz_num),
#          elmau_num = as.character(elmau_num),
#          elternhaus_außen_num = as.character(elternhaus_außen_num),
#          elternhaus_innen_num = as.character(elternhaus_innen_num),
#          praxis_außen_num = as.character(praxis_außen_num),
#          praxis_innen_num = as.character(praxis_innen_num),
#          wilder_kaiser_außen_num = as.character(wilder_kaiser_außen_num),
#          wilder_kaiser_innen_num = as.character(wilder_kaiser_innen_num),
#          krankenhaus_lp_num = as.character(krankenhaus_lp_num),
#          krankenhaus_sons_num = as.character(krankenhaus_sons_num),
#          krankenhaus_forum_num = as.character(krankenhaus_forum_num),
#          krankenhaus_intensiv_num = as.character(krankenhaus_intensiv_num),
#   ) %>%
#   select(1:3,
#          ends_with("_num") 
#          ) %>% 
#   pivot_longer(cols = ends_with("_num")) %>%
#   mutate(value = as.numeric(value) ) %>% 
#   filter(value != 0 | value != is.na(value)) %>% 
#   group_by(name) %>% 
#   summarise(location_num_sum = sum(value) )

# df_4.1_filmgeo_location_num_64_96 <- df_4_filmgeo_location_list %>% # get the locations episode 64 to 96
#   filter(as.numeric(episode_total) >= 64) %>% # filter for episodes with coded sequence of location
#   mutate(panorama_dorf_num = as.character(panorama_dorf_num),
#          panorama_berg_num = as.character(panorama_berg_num),
#          panorama_stadt_num = as.character(panorama_stadt_num),
#          car_street_num = as.character(car_street_num),
#          hintersteiner_num = as.character(hintersteiner_num),
#          bahnhof_num = as.character(bahnhof_num),
#          schule_num = as.character(schule_num),
#          essplatz_num = as.character(essplatz_num),
#          elmau_num = as.character(elmau_num),
#          elternhaus_außen_num = as.character(elternhaus_außen_num),
#          elternhaus_innen_num = as.character(elternhaus_innen_num),
#          praxis_außen_num = as.character(praxis_außen_num),
#          praxis_innen_num = as.character(praxis_innen_num),
#          wilder_kaiser_außen_num = as.character(wilder_kaiser_außen_num),
#          wilder_kaiser_innen_num = as.character(wilder_kaiser_innen_num),
#          krankenhaus_lp_num = as.character(krankenhaus_lp_num),
#          krankenhaus_sons_num = as.character(krankenhaus_sons_num),
#          krankenhaus_forum_num = as.character(krankenhaus_forum_num),
#          krankenhaus_intensiv_num = as.character(krankenhaus_intensiv_num),
#   ) %>%
#   select(1:3,
#          ends_with("_num")) %>% 
#   pivot_longer(cols = ends_with("_num")) %>%
#   mutate(value = as.numeric(value) ) %>% 
#   filter(value != 0 | value != is.na(value)) %>% 
#   group_by(name) %>% 
#   summarise(location_num_sum = sum(value) )


df_4.2_filmgeo_main_location_season_1_96 <- df_4_filmgeo_location_list %>% # get the locations-episode mapping from 1 to 96
  mutate(panorama_dorf_num = as.character(panorama_dorf_num),
         panorama_berg_num = as.character(panorama_berg_num),
         panorama_stadt_num = as.character(panorama_stadt_num),
         car_street_num = as.character(car_street_num),
         hintersteiner_num = as.character(hintersteiner_num),
         bahnhof_num = as.character(bahnhof_num),
         schule_num = as.character(schule_num),
         essplatz_num = as.character(essplatz_num),
         elmau_num = as.character(elmau_num),
         elternhaus_außen_num = as.character(elternhaus_außen_num),
         elternhaus_innen_num = as.character(elternhaus_innen_num),
         praxis_außen_num = as.character(praxis_außen_num),
         praxis_innen_num = as.character(praxis_innen_num),
         wilder_kaiser_außen_num = as.character(wilder_kaiser_außen_num),
         wilder_kaiser_innen_num = as.character(wilder_kaiser_innen_num),
         krankenhaus_lp_num = as.character(krankenhaus_lp_num),
         krankenhaus_sons_num = as.character(krankenhaus_sons_num),
         krankenhaus_forum_num = as.character(krankenhaus_forum_num),
         krankenhaus_intensiv_num = as.character(krankenhaus_intensiv_num),
  ) %>%
    select(1:3,
           ends_with("_num")) %>% 
    pivot_longer(cols = ends_with("_num")) %>%
    mutate(value = as.numeric(value) ) %>% 
    filter(value != 0 | value != is.na(value)) %>% 
  mutate(name = str_replace(name, "_num", "") ) %>% 
  select(1:3,
         location = name) 



df_4.3_filmgeo_sons_location_season_1_96 <- bind_rows( # get all the sonstiges locations episode 1 to 96
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_1),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_2),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_3),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_4),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_5),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_6),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_7),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_8),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_9),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_10),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_11),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_12),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_13),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_14),
  df_4_filmgeo_location_list %>% 
    select(1:3, sonstiges_loc_15)
) %>% 
  unite(col = "sons_location", 
        starts_with("sonstiges_loc_"),
        sep = "",
        na.rm = TRUE) %>% 
 distinct(sons_location, .keep_all = TRUE) %>% 
  filter(sons_location != "") %>% 
  mutate(sons_location = str_replace_all(sons_location, "[\\d[:punct:]]+", ""),
         sons_location = str_replace(sons_location, "^\\s", ""),
         sons_location = str_replace(sons_location, "^\\s", ""),
         sons_location = str_replace(sons_location, "\\s+$", "") )

df_4.3_filmgeo_sons_distinct_location_season_1_96 <- df_4.3_filmgeo_sons_location_season_1_96 %>% 
  group_by(sons_location) %>% 
  summarise(sons_location_appearance =  as.numeric(n()) )


df_4.4_filmgeo_all_location_num_mapping <- bind_rows( # bind and join rows
  df_4.2_filmgeo_main_location_season_1_96, 
  df_4.3_filmgeo_sons_location_season_1_96 %>% select(1:3, location = sons_location)
  ) %>% 
  mutate(
    season = as.numeric(season),
    episode_total = as.numeric(episode_total),
    episode = as.numeric(episode),
    location = as.character(location)
  ) %>% 
  left_join(df_4.1_filmgeo_main_location_num_1_96 %>% 
              select(2,4, location_num_sum_by_episode_total = 5), 
            by = c("location" = "name", "episode_total")) %>% 
  left_join(df_4.1_filmgeo_main_location_num_1_96_season %>% 
              select(season, location, location_num_sum_by_season = location_num_sum), 
            by = c("location", "season"),
            keep = FALSE) %>% 
  left_join(df_4.1_filmgeo_main_location_num_1_96_episode %>% 
              select(episode, location, location_num_sum_by_episode = location_num_sum), 
            by = c("location", "episode"),
            keep = FALSE ) %>% 
  left_join(df_4.1_filmgeo_main_location_num_1_96_location %>% 
              select(location, location_num_sum_by_location = location_num_sum), 
            by = c("location"),
            keep = FALSE ) %>% 
  left_join(df_4.3_filmgeo_sons_distinct_location_season_1_96 %>% 
              select(location = sons_location, apearance_of_sons_loc_by_episode_appearance = sons_location_appearance), 
            by = c("location"),
            keep = FALSE ) %>%
  mutate(is_sons_loc = if_else(is.na(location_num_sum_by_location) == TRUE, TRUE, FALSE))


##location gv (good view)

df_4.1_filmgeo_main_location_gv_1_96 <- df_4_filmgeo_location_list %>% # get all the locations episode 1 to 96
  mutate(elternhaus_außen_gv = as.character(elternhaus_außen_gv),
         elternhaus_innen_gv = as.character(elternhaus_innen_gv),
         essplatz_gv = as.character(essplatz_gv),
         baum_gv = as.character(baum_gv),
         praxis_außen_gv = as.character(praxis_außen_gv),
         praxis_innen_gv = as.character(praxis_innen_gv),
         wilder_kaiser_außen_gv = as.character(wilder_kaiser_außen_gv),
         wilder_kaiser_innen_gv = as.character(wilder_kaiser_innen_gv),
         kirche_gv = as.character(kirche_gv),
         dorfplatz_gv = as.character(dorfplatz_gv),
         krankenhaus_lp_gv = as.character(krankenhaus_lp_gv),
         krankenhaus_sons_gv = as.character(krankenhaus_sons_gv),
         krankenhaus_forum_gv = as.character(krankenhaus_forum_gv),
         krankenhaus_intensiv_gv = as.character(krankenhaus_intensiv_gv),
         panorama_dorf_gv = as.character(panorama_dorf_num),
         panorama_berg_gv = as.character(panorama_berg_num),
         panorama_stadt_gv = as.character(panorama_stadt_num),
         car_street_gv = as.character(car_street_gv),
         distelmeier_gv = as.character(distelmeier_gv),
         hintersteiner_gv = as.character(hintersteiner_gv),
         segelschule_gv = as.character(segelschule_gv),
         bahnhof_gv = as.character(bahnhof_gv),
         schule_gv = as.character(schule_gv)
  ) %>%
  select(1:3,
         ends_with("_gv") ) %>% 
  pivot_longer(cols = ends_with("_gv")) %>%
  mutate(good_view = as.numeric(value),
         season = as.numeric(season),
         episode_total = as.numeric(episode_total),
         episode = as.numeric(episode),
         name = as.character(str_replace(name, "_gv", ""))) %>% 
  filter(good_view != 0 | good_view != is.na(good_view)) %>% 
  select(-value)


df_4.1_filmgeo_main_location_gv_1_96_location <- df_4.1_filmgeo_main_location_gv_1_96 %>% 
  group_by(name) %>% 
  summarise(location_gv_sum = sum(good_view) ) %>% 
  mutate(name = str_replace(name, "_gv", "") ) %>% 
  select(
    location = name,
    2
  )

df_4.1_filmgeo_main_location_gv_1_96_season <- df_4.1_filmgeo_main_location_gv_1_96 %>% 
  group_by(name, season) %>% 
  summarise(location_gv_sum = sum(good_view), .groups = "keep" ) %>% 
  mutate(name = str_replace(name, "_gv", "") ) %>% 
  select(
    season,
    location = name,
    3
  )

df_4.1_filmgeo_main_location_gv_1_96_episode <- df_4.1_filmgeo_main_location_gv_1_96 %>% 
  group_by(name, episode) %>% 
  summarise(location_gv_sum = sum(good_view), .groups = "keep" ) %>% 
  mutate(name = str_replace(name, "_gv", "") ) %>% 
  select(
    episode,
    location = name,
    3
  )

  
df_4.4_filmgeo_all_location_gv_mapping <- bind_rows( # bind and join rows
  df_4.2_filmgeo_main_location_season_1_96, 
  df_4.3_filmgeo_sons_location_season_1_96 %>% select(1:3, location = sons_location)
) %>% 
  mutate(
    season = as.numeric(season),
    episode_total = as.numeric(episode_total),
    episode = as.numeric(episode),
    location = as.character(location)
  ) %>% 
  left_join(df_4.1_filmgeo_main_location_gv_1_96 %>% 
              select(2,4, location_gv_sum_by_episode_total = 5), 
            by = c("location" = "name", "episode_total")) %>% 
  left_join(df_4.1_filmgeo_main_location_gv_1_96_season %>% 
              select(season, location, location_gv_sum_by_season = location_gv_sum), 
            by = c("location", "season"),
            keep = FALSE) %>% 
  left_join(df_4.1_filmgeo_main_location_gv_1_96_episode %>% 
              select(episode, location, location_gv_sum_by_episode = location_gv_sum), 
            by = c("location", "episode"),
            keep = FALSE ) %>% 
  left_join(df_4.1_filmgeo_main_location_gv_1_96_location %>% 
              select(location, location_gv_sum_by_location = location_gv_sum), 
            by = c("location"),
            keep = FALSE ) %>% 
  left_join(df_4.3_filmgeo_sons_distinct_location_season_1_96 %>% 
              select(location = sons_location, apearance_of_sons_loc_by_episode_gv = sons_location_appearance), 
            by = c("location"),
            keep = FALSE ) %>%
  mutate(is_sons_loc = if_else(is.na(apearance_of_sons_loc_by_episode_gv) == FALSE, TRUE, FALSE))



## merge num and gv into one df

df_5_filmgeo_loc_num_gv_all <- df_4.4_filmgeo_all_location_num_mapping %>% 
  left_join(df_4.4_filmgeo_all_location_gv_mapping %>% 
              select(2,
                     4,
                     5:8),
            by = c("episode_total", "location") 
            ) %>% 
  mutate(location_gv_sum_by_episode_total = if_else(is_sons_loc == TRUE, 
                                                     location_gv_sum_by_episode_total, 
                                                     replace_na(location_gv_sum_by_episode_total, 0)
                                                     ), 
         location_gv_sum_by_season = if_else(is_sons_loc == TRUE, 
                                              location_gv_sum_by_season,
                                              replace_na(location_gv_sum_by_season, 0)
                                              ), 
         location_gv_sum_by_episode = if_else(is_sons_loc == TRUE, 
                                               location_gv_sum_by_episode,
                                               replace_na(location_gv_sum_by_episode, 0)
                                               ), 
         location_gv_sum_by_location= if_else(is_sons_loc == TRUE, 
                                               location_gv_sum_by_location,
                                               replace_na(location_gv_sum_by_location, 0)
                                               ) 
         ) %>% 
  left_join(df_1.2_filmgeo_all_char %>% 
              select(episode_total, bezug, comment) %>%  
              mutate(episode_total = as.numeric(episode_total)), 
            by = "episode_total") %>% 
  select(1:4,
         5:8,
         11:14,
         9:10,
         15:16
         )


rm(#df_1.1_filmgeo_all_raw, # Keep because of raw data
   df_1.2_filmgeo_all_char,
   df_2_filmgeo_all,
   df_3_filmgeo_all_extract,
   df_4_filmgeo_location_list,
   #df_4.1_filmgeo_main_location_gv_1_96_season, # Keep because of raw locations num list
   df_4.1_filmgeo_main_location_num_1_96_episode,
   #df_4.1_filmgeo_main_location_num_1_96_location, # keep because this is also the distinct main location like 4.3
   df_4.1_filmgeo_main_location_num_1_96_season,
   #df_4.1_filmgeo_main_location_gv_1_96, # Keep because of main location gv list
   df_4.1_filmgeo_main_location_gv_1_96_episode,
   df_4.1_filmgeo_main_location_gv_1_96_location,
   df_4.1_filmgeo_main_location_gv_1_96_season,
   df_4.2_filmgeo_main_location_season_1_96, 
   df_4.3_filmgeo_sons_location_season_1_96,
   #df_4.3_filmgeo_sons_distinct_location_season_1_96, # Keep because of distinct list 
   df_4.4_filmgeo_all_location_gv_mapping,
   df_4.4_filmgeo_all_location_num_mapping
)



## build sqeuential order table

# clean up raw table
df_6.1_clean_table <- df_1.1_filmgeo_all_raw %>% 
  select(1:3,
         elternhaus_außen,
         elternhaus_innen,
         essplatz,
         praxis_innen,
         praxis_außen,
         kirche,
         wilder_kaiser_außen,
         wilder_kaiser_innen,
         dorfplatz,
         krankenhaus_lp,
         krankenhaus_sons,
         krankenhaus_forum,
         krankenhaus_intensiv,
         panorama_dorf,
         panorama_berg,
         panorama_stadt,
         distelmeier,
         car_street,
         hintersteiner,
         bahnhof,
         schule) %>% 
  filter(episode_total >= 65) %>% 
  mutate(elternhaus_außen = str_replace_all(elternhaus_außen, "[\\*,]", ""),
         elternhaus_innen = str_replace_all(elternhaus_innen, "[\\*,]", ""),
         essplatz = str_replace_all(essplatz, "[\\*,]", ""),
         praxis_innen = str_replace_all(praxis_innen, "[\\*,]", ""),
         praxis_außen = str_replace_all(praxis_außen, "[\\*,]", ""),
         kirche = str_replace_all(kirche, "[\\*,]", ""),
         wilder_kaiser_außen = str_replace_all(wilder_kaiser_außen, "[\\*,]", ""),
         wilder_kaiser_innen = str_replace_all(wilder_kaiser_innen, "[\\*,]", ""),
         dorfplatz = str_replace_all(dorfplatz, "[\\*,]", ""),
         krankenhaus_lp = str_replace_all(krankenhaus_lp, "[\\*,]", ""),
         krankenhaus_sons = str_replace_all(krankenhaus_sons, "[\\*,]", ""),
         krankenhaus_forum = str_replace_all(krankenhaus_forum, "[\\*,]", ""),
         krankenhaus_intensiv = str_replace_all(krankenhaus_intensiv, "[\\*,]", ""),
         panorama_dorf = str_replace_all(panorama_dorf, "[\\*,]", ""),
         panorama_berg = str_replace_all(panorama_berg, "[\\*,]", ""),
         panorama_stadt = str_replace_all(panorama_stadt, "[\\*,]", ""),
         distelmeier = str_replace_all(distelmeier, "[\\*,]", ""),
         car_street = str_replace_all(car_street, "[\\*,]", ""),
         hintersteiner = str_replace_all(hintersteiner, "[\\*,]", ""),
         bahnhof = str_replace_all(bahnhof, "[\\*,]", ""),
         schule = str_replace_all(schule, "[\\*,]", "")
         )


# build and transpose sequential order table

loc_col_names <- colnames(df_6.1_clean_table %>% select(-1, -2, -3) ) 
loc_col_names_length <- 1:length(loc_col_names)

df_6.2_loc_sequential <- tibble() %>% bind_rows(df_6.1_clean_table %>% select(2))

cat("Doing some loopy loops: \n")

for (n in loc_col_names_length) {

  #n <- loc_col_names_length[1]# zum testen des loops
  
  column <- loc_col_names[n]
  
  df_temp <- df_6.1_clean_table %>% 
    select(1:3,
           starts_with(column)) %>% 
    mutate(new_col = str_split_fixed(get(column), "\\s", n = 25) ) %>% 
    mutate(new_col_1 = as.numeric(new_col[,1]),
           new_col_2 = as.numeric(new_col[,2]),
           new_col_3 = as.numeric(new_col[,3]),
           new_col_4 = as.numeric(new_col[,4]),
           new_col_5 = as.numeric(new_col[,5]),
           new_col_6 = as.numeric(new_col[,6]),
           new_col_7 = as.numeric(new_col[,7]),
           new_col_8 = as.numeric(new_col[,8]),
           new_col_9 = as.numeric(new_col[,9]),
           new_col_10 = as.numeric(new_col[,10]),
           new_col_11 = as.numeric(new_col[,11]),
           new_col_12 = as.numeric(new_col[,12]),
           new_col_13 = as.numeric(new_col[,13]),
           new_col_14 = as.numeric(new_col[,14]),
           new_col_15 = as.numeric(new_col[,15]),
           new_col_16 = as.numeric(new_col[,16]),
           new_col_17 = as.numeric(new_col[,17]),
           new_col_18 = as.numeric(new_col[,18]),
           new_col_19 = as.numeric(new_col[,19]),
           new_col_20 = as.numeric(new_col[,20]),
           new_col_21 = as.numeric(new_col[,21]),
           new_col_22 = as.numeric(new_col[,22]),
           new_col_23 = as.numeric(new_col[,23]),
           new_col_24 = as.numeric(new_col[,24]),
           new_col_25 = as.numeric(new_col[,25]) ) %>% 
    select(-new_col) %>% 
    rename_with(~ gsub('new_col', column, .x))

  # delet the columns with only NAs or are completly empty
  delet_empty_cols <- sapply(df_temp, function(x) all(is.na(x) | x == ""))
  
  df_temp <- df_temp[, !delet_empty_cols] %>% 
    filter(is.na(column) == FALSE) %>% 
    select(-column)
  
  cat("Doing column: ", column, "\n")
  
  # build single column
  
  df_temp_2 <- tibble()
  
  col_count <- 1:ncol(df_temp %>% select(-1, -2, -3))
  
  for (n_2 in col_count) {
    
    #n_2 <- col_count[1] # zum testen des loobs
    
    df_temp_2 <- bind_rows(df_temp_2, 
                           df_temp %>% select(1:3, 3+n_2) %>% 
                             rename_with(~ gsub(paste0(column, "_", n_2), column, .x))) %>% 
      filter(is.na(get(column)) == FALSE)
    
    cat("and bind column:", n_2, "\n")
    
  }

  
  
  df_6.2_loc_sequential <- bind_rows(df_6.2_loc_sequential, df_temp_2)
  
  # df_6.2_loc_sequential <- df_6.2_loc_sequential %>%
  #   left_join(df_temp_2 %>% select(2,4), by = "episode_total")
  
  #df_6.2_loc_sequential <- bind_cols(df_temp_2 %>% select(2,4))
}

df_6.2_loc_sequential <- df_6.2_loc_sequential %>% 
  filter(is.na(season) == FALSE) %>% 
  arrange(episode_total)

df_6.3_loc_sequential_list <- df_6.2_loc_sequential %>% 
  filter(is.na(season) == FALSE) %>% 
  pivot_longer(4:24) %>% 
  select(1:3,
         location = name,
         scene = value) %>% 
  filter(is.na(scene) == FALSE) %>% 
  arrange(episode_total)

rm(df_temp, 
   df_temp_2,
   df_6.1_clean_table)


## pivoting the lines of secenes to columns

loc_col_names <- colnames(df_6.2_loc_sequential %>% select(-1, -2, -3) ) 
loc_col_names_length <- 1:length(loc_col_names)


df_7_loc_sequential_per_scene <- tibble()

for (n in loc_col_names_length) {
  
  # n <- 1 #to test the loop
  
  column <- loc_col_names[n]
  n <- n+3



df_temp <- df_6.2_loc_sequential %>% 
  select(1:3,
         n) %>% 
  filter(is.na(season) == FALSE,
         is.na(get(column)) == FALSE) %>% 
  arrange(get(column)) %>% 
  pivot_wider(
              names_from = paste0(column),
              values_from = paste0(column),
              names_prefix = "scene_") %>% 
  mutate(location = column)


df_7_loc_sequential_per_scene <- bind_rows(df_7_loc_sequential_per_scene, 
                                            df_temp)

cat("More shit with loops: ", column,  "\n")

}

rm(df_temp)

df_7_loc_sequential_per_scene <- df_7_loc_sequential_per_scene %>% 
  # mutate(scene_80 = as.numeric("")) %>% # trying to add sonstiges column but it was to hard.
  # add_row(
  #   scene_80 = if_else(is.na(scene_79) == FALSE, 80, NULL)#,
  #   episode_total = if_else(is.na(scene_79) == FALSE, episode_total, episode_total)
  # ) %>% 
  select(
    1:3,
    location,
    'scene_1','scene_2','scene_3','scene_4','scene_5','scene_6','scene_7','scene_8',
    'scene_9','scene_10','scene_11','scene_12','scene_13','scene_14','scene_15',
    'scene_16','scene_17','scene_18','scene_19','scene_20','scene_21','scene_22',
    'scene_23','scene_24','scene_25','scene_26','scene_27','scene_28','scene_29',
    'scene_30','scene_31','scene_32','scene_33','scene_34','scene_35','scene_36',
    'scene_37','scene_38','scene_39','scene_40','scene_41','scene_42','scene_43',
    'scene_44','scene_45','scene_46','scene_47','scene_48','scene_49','scene_50',
    'scene_51','scene_52','scene_53','scene_54','scene_55','scene_56','scene_57',
    'scene_58','scene_59','scene_60','scene_61','scene_62','scene_63','scene_64',
    'scene_65','scene_66','scene_67','scene_68','scene_69','scene_70','scene_71',
    'scene_72','scene_73','scene_74','scene_75','scene_76','scene_77','scene_78',
    'scene_79'#,'scene_80' # Sonstiges Scene
    ,'scene_81','scene_82','scene_83','scene_84','scene_85','scene_86','scene_87',
    'scene_88','scene_89','scene_90','scene_91',#'scene_92', # sonstiges scene
    'scene_93'
  ) %>% 
  arrange(episode_total)




### save as csv
output_path <- paste0(paths$data_processed)


write.csv2(df_4.1_filmgeo_main_location_num_1_96,
           file = paste0(output_path, "/", Sys.Date(),  "_main-loc_per-total-episode_num.csv"), 
           na = "", 
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_4.1_filmgeo_main_location_num_1_96_location,
           file = paste0(output_path, "/", Sys.Date(),  "_main-loc_per-location_num.csv"), 
           na = "", 
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_4.1_filmgeo_main_location_gv_1_96,
           file = paste0(output_path, "/", Sys.Date(),  "_main-loc_per-total-episode_gv.csv"), 
           na = "", 
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_4.3_filmgeo_sons_distinct_location_season_1_96,
           file = paste0(output_path, "/", Sys.Date(),  "_sons-loc_distinct_appearance.csv"), 
           na = "", 
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_5_filmgeo_loc_num_gv_all,
           file = paste0(output_path, "/", Sys.Date(),  "_all-loc_all-metrics.csv"), 
           na = "",
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_6.2_loc_sequential,
           file = paste0(output_path, "/", Sys.Date(),  "_main-loc_per-location_sequence.csv"), 
           na = "",
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_6.3_loc_sequential_list,
           file = paste0(output_path, "/", Sys.Date(),  "_main-loc_sequence.csv"), 
           na = "",
           row.names = FALSE,
           fileEncoding = "UTF-8")


write.csv2(df_7_loc_sequential_per_scene,
           file = paste0(output_path, "/", Sys.Date(),  "_main-loc_per-scene_sequence.csv"), 
           na = "",
           row.names = FALSE,
           fileEncoding = "UTF-8")

cat("Data saved in: ", output_path,  "\n")


# end this shit
end_time <- Sys.time()
cat("End Script:", format(Sys.time(), "%H:%M:%S"), "\n", 
    "Differenz: ", difftime(end_time, start_time, units = "secs"), "Sekunden", "\n") 


## to do: -done
# extract locations to build a unique list - Done
# How much good_view per location? - Done
# Something important in comments? - Done
# Sort rows and class - Done
# Primary Key? -> location or episode
# Metadate table?
# save data as csv - Done


#NOTE: FROM episode 63 on words locations are coded with their sequential appearance in an episode
#NOTE: FROM episode 57 on words locations are coded with a good view *
#NOTE: FROM Season 7 on words locations are devid into innen and außen. 
  #So probably just use the data from Season 7 to 10. Season 7 starts with ep 65.

