rm(list = ls()) # Remove all stuff in Environment

start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")






# set working dirctory
#setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

#source("scripts/init_v0.6.R")
source("init_v0.6.R")





# load geoloc data form des-pro and Scr

# build paths
cat("Data load from: \n", paths$data_processed, "\n")


#list files
files_csv <- list.files(
  paste0(paths$data_processed, "/"),
  pattern = ".csv",
  full.names = TRUE)


# load variables
geoloc_x_y_file <- files_csv[grepl("_x_y_koordinates.csv", files_csv)]

df_geoloc_x_y_raw <- read.csv(geoloc_x_y_file[1],
                              stringsAsFactors = FALSE,
                              sep = ";",
                              encoding="UTF-8") %>% 
  as.data.frame() %>% 
  bind_rows(read.csv(geoloc_x_y_file[2],
                     stringsAsFactors = FALSE,
                     sep = ";",
                     encoding="UTF-8"))


df_x_y_final <- df_geoloc_x_y_raw %>% 
  filter(!x_name %in% c("c_1_x", "c_2_x") )

df_x_y_corners <- df_geoloc_x_y_raw






####################
### making plots ###
####################



# ggplot Orte nach Fotograf/Motiv + Corners
ggp_all_m_f_c_vertex <- ggplot(df_x_y_corners, aes(x_koordinate, y_koordinate) ) + 
  geom_point(aes(colour = x_name), size = 2) + # NO colors for Photo but it does not look so confusing  
  scale_color_manual(values = motiv_photo_corner_color,
                     labels = motiv_photo_corner_labels) +
  geom_point(aes(shape = x_name ), size = 2) + 
  scale_shape_manual(values = motiv_photo_corner_shapes,
                     labels = motiv_photo_corner_labels) + 
  geom_smooth() +
  scale_x_continuous(position = "top") +
  scale_y_reverse(lim =c(max(df_x_y_corners$y_koordinate),0)) +
  labs(title = "Locations of Photographer and Motive + Corners", 
       x = "X", 
       y = "Y", 
       shape = "Photo", 
       color = "Photo") 
print(ggp_all_m_f_c_vertex)

Sys.sleep(3)

# ggplot Orte nach Fotograf/Motiv + Corners Gruppuert nach art
ggp_all_m_f_c_vertex_grouped <- ggplot(df_x_y_corners, aes(x_koordinate, y_koordinate) ) + 
  geom_point(aes(colour = art), size = 2) + # NO colors for Photo but it does not look so confusing  
  scale_color_manual(values = group_color,
                     labels = group_labels) +
  geom_point(aes(shape = x_name ), size = 2) + 
  scale_shape_manual(values = motiv_photo_corner_shapes,
                     labels = motiv_photo_corner_labels) + 
  geom_smooth() +
  scale_x_continuous(position = "top") +
  scale_y_reverse(lim =c(max(df_x_y_corners$y_koordinate),0)) +
  labs(title = "Locations of Photographer and Motive + Corners (grouped by STR, DES and PRO)", 
       x = "X", 
       y = "Y", 
       shape = "Photo", 
       color = "Photo") 
print(ggp_all_m_f_c_vertex_grouped)

Sys.sleep(3)


# Make plots for every group
list_ggp_m_f_c_vertex <- list() 

n <- 2 # to test without loop

for (n in seq(group_labels)) {
  
  # Filter table
  df_x_y <- df_x_y_corners %>% 
    filter(art == group_labels[n])
  
  # build ggplots
  ggp_temp <- ggplot(df_x_y, aes(x_koordinate, y_koordinate) ) + 
    geom_point(aes(colour = x_name), size = 2) + # NO colors for Photo but it does not look so confusing  
    scale_color_manual(values = motiv_photo_corner_color,
                       labels = motiv_photo_corner_labels) +
    geom_point(aes(shape = x_name ), size = 2) + 
    scale_shape_manual(values = motiv_photo_corner_shapes,
                       labels = motiv_photo_corner_labels) + 
    geom_smooth() +
    scale_x_continuous(position = "top") +
    scale_y_reverse(lim =c(max(df_x_y_corners$y_koordinate),0)) +
    labs(title = paste0("Locations of Photographer and Motive + Corners (", group_labels[n],")"), 
         x = "X", 
         y = "Y", 
         shape = "Photo", 
         color = "Photo") 
  
  # Put ggplot into list
  list_ggp_m_f_c_vertex[[n]] <- ggp_temp
  
  # Print ggplots
  cat("Motives, Photographer and Corner in group ", group_labels[n])
  
  print(list_ggp_m_f_c_vertex[n])
  
  Sys.sleep(3)
  
}

# ggplot Orte & Verbindungen nach Fotograf/Motiv und Gruppe (All)
ggp_all_m_f_con_grouped <- ggplot(
  df_x_y_final, aes(x_koordinate, y_koordinate) ) + 
  geom_segment(aes(x = x_koordinate, y = y_koordinate, 
                   xend = if_else(x_name == "m_x", x_koordinate, lead(x_koordinate, n=1)), 
                   yend = if_else(y_name == "m_y", y_koordinate, lead(y_koordinate, n=1)),
                   color = art
  ), linewidth = 0.5 ) +
  geom_point(aes(colour = art ), size = 4) + 
  # scale_color_manual(values=c("#E69F00", "#56B4E9"),
  #                    labels = c("Fotograf", "Motiv") ) +  
  scale_color_manual(values = group_color,
                     labels = group_labels ) + 
  geom_point(aes(shape = x_name ), size = 2) + 
  scale_shape_manual(values = c(4, 1),
                     labels = c("Photographer", "Motiv") ) + 
  geom_smooth() +
  scale_x_continuous(position = "top") +
  scale_y_reverse(lim =c(max(df_x_y_final$y_koordinate),0)) +
  labs(title = "Locations and connection for  Photographer and Motive (All) grouped by Art", x = "X", y = "Y", color = "Akteursgruppe", shape = "Foto")

print(ggp_all_m_f_con_grouped)


# ggplot Orte & Verbindungen nach Fotograf/Motiv und Gruppe (All)
ggp_all_m_f_con <- ggplot(
  df_x_y_final, aes(x_koordinate, y_koordinate) ) + 
  geom_segment(aes(x = x_koordinate, y = y_koordinate, 
                   xend = if_else(x_name == "m_x", x_koordinate, lead(x_koordinate, n=1)), 
                   yend = if_else(y_name == "m_y", y_koordinate, lead(y_koordinate, n=1))
  ), linewidth = 0.5 ) +
  geom_point(aes(colour = x_name ), size = 2) + 
  scale_color_manual(values = motiv_photo_color,
                     labels = motiv_photo_labels ) + 
  geom_point(aes(shape = x_name ), size = 2) + 
  scale_shape_manual(values = motiv_photo_shapes,
                     labels = motiv_photo_labels ) + 
  geom_smooth() +
  scale_x_continuous(position = "top") +
  scale_y_reverse(lim =c(max(df_x_y_final$y_koordinate),0)) +
  labs(title = "Locations & connections of Photographer and motive location (All)", 
       x = "X", 
       y = "Y", 
       color = "Photo",
       shape = "Photo")

print(ggp_all_m_f_con)



# Make plots for every group
list_ggp_m_f_con <- list() 

n <- 2 # to test without loop

for (n in seq(group_labels)) {
  
  # Filter table
  df_x_y <- df_x_y_final %>% 
    filter(art == group_labels[n])

  ggp_temp <- ggplot(
     df_x_y, aes(x_koordinate, y_koordinate) ) + 
     geom_segment(aes(x = x_koordinate, y = y_koordinate, 
                      xend = if_else(x_name == "m_x", x_koordinate, lead(x_koordinate, n=1)), 
                      yend = if_else(y_name == "m_y", y_koordinate, lead(y_koordinate, n=1))#,
                      #color = art
                  ), linewidth = 0.5 ) +
     geom_point(aes(color = art), size = 2) + 
     scale_color_manual(values = group_color[n], 
                       labels = group_labels[n] ) + 
     geom_point(aes(shape = x_name), size = 2) +
     scale_shape_manual(values = motiv_photo_shapes,
                        labels = motiv_photo_labels) +
     geom_smooth() +
     scale_x_continuous(position = "top") +
     scale_y_reverse(lim =c(max(df_x_y_final$y_koordinate),0)) +
     labs(title = paste0("Locations & connections of Photographer and motive location (", group_labels[n],")"),
          x = "X",
          y = "Y",
          color = "Group",
          shape = "Photo")
  
  # Put ggplot into list
  list_ggp_m_f_con[[n]] <- ggp_temp
  
  # Print ggplots
  cat("Connections with Motives and Photographer in group ", group_labels[n])
  
  print(list_ggp_m_f_con[n])
  
  Sys.sleep(3)
    
}


# ggplot Pfade zwischen  Fotograf Motiv und Gruppe (All)
ggp_all_m_f_paths_grouped <- ggplot(
    df_x_y_final, aes(x_koordinate, y_koordinate) ) + 
    geom_segment(aes(x = x_koordinate, y = y_koordinate, 
                     xend = if_else(x_name == "m_x", x_koordinate, lead(x_koordinate, n=1)), 
                     yend = if_else(y_name == "m_y", y_koordinate, lead(y_koordinate, n=1)),
                     color = art
    ), linewidth = 0.8 ) +
    scale_color_manual(values = group_color, 
                       labels = group_labels ) + 
    scale_x_continuous(position = "top") +
    scale_y_reverse(lim =c(max(df_x_y_final$y_koordinate),0)) +
    labs(title = paste0("Paths between motives and photograhper location (All) grouped after Art"),
         x = "X",
         y = "Y",
         color = "Group",
         shape = "Photo")
  
  
  # Print ggplots
  cat("Paths between Motives and Photographer in group ", group_labels[n])
  
  print(ggp_all_m_f_paths_grouped)
 
  
  # Make plots for every group
  list_ggp_m_f_paths <- list() 
  
  n <- 2 # to test without loop
  
  for (n in seq(group_labels)) {
    
    # Filter table
    df_x_y <- df_x_y_final %>% 
      filter(art == group_labels[n])
    
    # make plot
    ggp_temp <- ggplot(
      df_x_y, aes(x_koordinate, y_koordinate) ) + 
      geom_segment(aes(x = x_koordinate, y = y_koordinate, 
                       xend = if_else(x_name == "m_x", x_koordinate, lead(x_koordinate, n=1)), 
                       yend = if_else(y_name == "m_y", y_koordinate, lead(y_koordinate, n=1)),
                       color = art
      ), linewidth = 0.8 ) +
      scale_color_manual(values = group_color[n], 
                         labels = group_labels[n] ) + 
      scale_x_continuous(position = "top") +
      scale_y_reverse(lim =c(max(df_x_y_final$y_koordinate),0)) +
      labs(title = paste0("Paths between motives and photograhper location (", group_labels[n],")"),
           x = "X",
           y = "Y",
           color = "Group",
           shape = "Photo")
    
    # Put ggplot into list
    list_ggp_m_f_paths[[n]] <- ggp_temp
    
    # Print ggplots
    cat("Connections with Motives and Photographer in group ", group_labels[n])
    
    print(list_ggp_m_f_paths[n])
    
    Sys.sleep(3)
  
  }
  
  

# Make plots for individual groups with nitive and photographer

# prepare for coming loop
groups_art <- group_labels
groups_color <- group_color # coming from init.R and the first Des, Pro, Scr
list_ggp_m_f_vertex <- list() 

n <- 3 # to test without loop

# Make plots for every group
for (n in seq(groups_art)) {

  df_x_y <- df_x_y_final %>% 
    filter(art == groups_art[n])
  
  ggp_temp <- ggplot(
    df_x_y, aes(x_koordinate, y_koordinate) ) + 
    geom_point(aes(colour = art ), size = 4) + 
    scale_color_manual(values= groups_color[n],
      labels = groups_art[n]) + 
    geom_point(aes(shape = x_name ), size = 2) + 
    scale_shape_manual(values = motiv_photo_shapes,
                       labels = motiv_photo_labels ) + 
    geom_smooth() +
    scale_x_continuous(position = "top") +
    scale_y_reverse(lim =c(max(df_x_y_final$y_koordinate),0)) +
    labs(title = paste0("Photographer and Motive locations (", groups_art[n],")"), 
         x = "X", 
         y = "Y", 
         color = "Group", 
         shape = "Photo")
  
  list_ggp_m_f_vertex[[n]] <- ggp_temp
  
  # Print plots
  
  cat("Coordinates with Motives and Photographer in group ", group_labels[n])
  
  print(list_ggp_m_f_vertex[n])
  
  Sys.sleep(3)

}



# Make plots for every group with only Motiv or fotograf

motiv_photo_names <- c("f_x", "m_x")
motiv_photo_names_2 <- motiv_photo_labels
list2_ggp_m_or_f_vertex <- list()

n = 1 # To test without loop

for (n in seq(groups_art)) {
  
  n_2 = 1 # To test without loop
  
  list_ggp_m_or_f_vertex <- list()
  
  for (n_2 in seq(motiv_photo_color) ) {  
    
    # make filtered data
    df_x_y <- df_x_y_final %>% 
      filter(art == groups_art[n],
             x_name == motiv_photo_names[n_2])
    
    # build plot  
    ggp_temp <- ggplot(df_x_y, aes(x_koordinate, y_koordinate) ) + 
      geom_point(aes(colour = art ), size = 4) + 
      scale_color_manual(values= groups_color[n],
                         labels = groups_art[n]) + 
      geom_point(aes(shape = x_name ), size = 2) + 
      scale_shape_manual(values = motiv_photo_shapes[n_2],
                         labels = motiv_photo_names_2[n_2] ) + 
      geom_smooth() +
      scale_x_continuous(position = "top") +
      scale_y_reverse(lim =c(max(df_x_y$y_koordinate),0)) +
      labs(title = paste0("Locations of ", motiv_photo_names_2[n_2], " (", groups_art[n],")"), 
                          x = "X", 
                          y = "Y", 
                          color = "Group",
                          shape = "Photo") 
    
    # put plot into list
    list_ggp_m_or_f_vertex[[n_2]] <- ggp_temp
    
    # Print the ggplots
    cat(motiv_photo_names_2[n_2], "der Gruppe ", groups_art[n])
    
    print(list_ggp_m_or_f_vertex[n_2])
    
    Sys.sleep(3)
  
  } 

# put plots into list
list2_ggp_m_or_f_vertex[[n]] <- list_ggp_m_or_f_vertex  
    
}

#my_ggplots_art[[2]][1] # Show what is inside a list of a list





# Make plots for only Motiv or fotograf

list_ggp_all_m_or_f_vertex <- list()

n = 1 # To test without loop

for (n in seq(motiv_photo_names_2)) {
  
  # make filtered data
  df_x_y <- df_x_y_final %>% 
    filter(x_name == motiv_photo_names[n])
  
  # build plot  
  ggp_temp <- ggplot(df_x_y, aes(x_koordinate, y_koordinate) ) + 
    geom_point(aes(shape = x_name ), size = 2, stroke = 1) + 
    scale_shape_manual(values = motiv_photo_shapes[n],
                       labels = motiv_photo_names_2[n] ) + 
    geom_smooth() +
    scale_x_continuous(position = "top") +
    scale_y_reverse(lim =c(max(df_x_y$y_koordinate),0)) +
    labs(title = paste0("Locations after ", motiv_photo_names_2[n]), 
         x = "X", 
         y = "Y",
         shape = "Photo") 
  
  # put plot into list
  list_ggp_all_m_or_f_vertex[[n]] <- ggp_temp
  
  # Print the ggplots
  cat(motiv_photo_names_2[n], "über alle Akteursgruppen")
  
  print(list_ggp_all_m_or_f_vertex[n])
  
  Sys.sleep(3)
  
}

#list_ggp_all_m_or_f_vertex[[1]]


#################################







# Make plots for only Motiv or fotograf gruped by the art

list_ggp_all_m_or_f_vertex_grouped <- list()

n = 1 # To test without loop

for (n in seq(motiv_photo_names_2)) {
  
  # make filtered data
  df_x_y <- df_x_y_final %>% 
    filter(x_name == motiv_photo_names[n])
  
  # build plot  
  ggp_temp <- ggplot(df_x_y, aes(x_koordinate, y_koordinate) ) + 
    geom_point(aes(colour = art ), size = 3) + 
    geom_point(aes(shape = x_name ), size = 2, stroke = 1) + 
    scale_color_manual(values= group_color,
                       labels = group_labels) +
    scale_shape_manual(values = motiv_photo_shapes[n],
                       labels = motiv_photo_names_2[n] ) + 
    geom_smooth() +
    scale_x_continuous(position = "top") +
    scale_y_reverse(lim =c(max(df_x_y$y_koordinate),0)) +
    labs(title = paste0("Vertexes of ", motiv_photo_names_2[n], " groupped by Art"), 
         x = "X", 
         y = "Y",
         colour = "Group",
         shape = "Photo") 
  
  # put plot into list
  list_ggp_all_m_or_f_vertex_grouped[[n]] <- ggp_temp
  
  # Print the ggplots
  cat(motiv_photo_names_2[n], "über alle Akteursgruppen")
  
  print(list_ggp_all_m_or_f_vertex_grouped[n])
  
  Sys.sleep(3)
  
}




# buildin interactiv ggplotly graph for SPaces and connection after Photo and motiv
# This plot helps to identify the spaces where the pictures were taken
# This can only be used inside R
ggp_all_m_f_con_bw <- ggplot(
  df_x_y_final, 
  aes(x_koordinate, y_koordinate, 
      text = paste ("Name: ", x_name,
                    "<br>Group: ", art,
                    "<br>jpg_id: ", quest_jpg_id_code,
                    "<br>jpg_name: ", jpg_name) )
) + 
  # geom_point(aes(colour = x_name ), size = 1) + 
  # scale_color_manual(values = motiv_photo_color,
  #                    labels = motiv_photo_labels ) +  
  geom_point(aes(shape = x_name ), size = 2) + 
  scale_shape_manual(values = motiv_photo_shapes,
                     labels = motiv_photo_labels ) + 
  geom_segment(aes(x = x_koordinate, y = y_koordinate, 
                   xend = if_else(x_name == "m_x", x_koordinate, lead(x_koordinate, n=1)), 
                   yend = if_else(y_name == "m_y", y_koordinate, lead(y_koordinate, n=1))
  ) ) +
  scale_x_continuous(position = "top") +
  scale_y_reverse(lim =c(max(df_x_y_final$y_koordinate),0)) +
  labs(title = "Locations and connections of photographer and motive locations (All)", 
       x = "X", 
       y = "Y", 
       color = "Photo", 
       shape = "Photo")


ggpy_all_m_f_con <- ggplotly(ggp_all_m_f_con_bw, 
                                  tooltip = "text" ) %>% 
  layout(autosize = F, width = 1000, height = 700)

print(ggpy_all_m_f_con)







rm(df_geoloc_x_y_raw, 
   ggp_temp)



####################
### Save ggplots ###
####################


# Specify the pattern to match object names
target_object_pattern <- 
  c("ggp_", "list", "list_", "list2_")

# Get a list of all objects in the global environment
all_objects <- ls()

# Find the objects with names matching the pattern
matching_objects <- all_objects[grep(target_object_pattern[1], all_objects)]

match_plots_all <- matching_objects[!grepl(target_object_pattern[2], matching_objects)]
match_list_all <- matching_objects[grepl(target_object_pattern[3], matching_objects)]
match_list2_all <- matching_objects[grepl(target_object_pattern[4], matching_objects)]



# Directory where you want to save the plots
save_directory <- paths$data_processed



# Loop through the matching objects and save each plot
for (plot_name in match_plots_all) {
  
    plot <- get(plot_name)
    file_name <- paste0(Sys.Date(), "_", plot_name)
  
  ggsave(
    file.path(save_directory, paste0(file_name, ".jpg") ),
    plot = plot,
    device = "jpg",
    scale = 1,
    width = 26,
    height = 14,
    units = "cm",
    dpi = 300,
    limitsize = TRUE,
    bg = NULL
  )

  ggsave(
    file.path(save_directory, paste0(file_name, "_scaled", ".jpg") ),
    plot = plot,
    device = "jpg",
    scale = 3,
    width = 26,
    height = 14,
    units = "cm",
    dpi = 300,
    limitsize = TRUE,
    bg = NULL
  )  
  
  Sys.sleep(1)
}


# save all the list plots
list_name = "list_ggp_all_m_or_f_vertex" # to test without loop

# Loop through the matching objects and save each plot
for (list_name in match_list_all) {
  
  print(list_name)
  
  plot_num = 1 # to test without loop

  
  for (plot_num in 1:length(get(list_name)) ) {
    
    plot <- get(list_name)[[plot_num]]
    file_name <- paste0(Sys.Date(), "_", list_name, "_", plot_num)
    
    ggsave(
      file.path(save_directory, paste0(file_name, ".jpg") ),
      plot = plot,
      device = "jpg",
      scale = 1,
      width = 26,
      height = 14,
      units = "cm",
      dpi = 300,
      limitsize = TRUE,
      bg = NULL
    )
    
    ggsave(
      file.path(save_directory, paste0(file_name, "_scaled", ".jpg") ),
      plot = plot,
      device = "jpg",
      scale = 3,
      width = 26,
      height = 14,
      units = "cm",
      dpi = 300,
      limitsize = TRUE,
      bg = NULL
    )
    
    Sys.sleep(1)
  }
}




# save the list2 plots

list_num = 3 # to test without loop

# Loop through the matching objects and save each plot
for (list_num in 1:length(get(match_list2_all))) {
  
  current_list <- get(match_list2_all)[[list_num]]
  
  plot_num = 2 # to test without loop
  
  for (plot_num in 1:length(current_list)) {
    
    plot <- current_list[[plot_num]]
    file_name <- paste0(Sys.Date(), "_", match_list2_all, "_", list_num, "_", plot_num)
    
    ggsave(
      file.path(save_directory, paste0(file_name, ".jpg")),
      plot = plot,
      device = "jpg",
      scale = 1,
      width = 26,
      height = 14,
      units = "cm",
      dpi = 300,
      limitsize = TRUE,
      bg = NULL
    )
    
    ggsave(
      file.path(save_directory, paste0(file_name, "_scaled", ".jpg")),
      plot = plot,
      device = "jpg",
      scale = 3,
      width = 26,
      height = 14,
      units = "cm",
      dpi = 300,
      limitsize = TRUE,
      bg = NULL
    )
    
    Sys.sleep(1)
    
  }
}



###################
### Save tables ###
###################

# reverse y coordinates and make it to real lat and long values 

# get factor for lat long transition
    zero_zero = c(47.5886593, 12.1301535) #NOTE: (0,0) of the trace interview map is 47,5886593 N, 12,1301535 O in Qgis (WGS 84 EPSG: 4326)
    full_full = c(47.468817173, 12.432638403) #NOTE (100,100) of the trace interview map is 47,468817173 N, 12,432638403 O in Qgis (WGS 84 EPSG: 4326)
    diff_map = c(abs(zero_zero[1]- full_full[1]), abs(zero_zero[2]- full_full[2]) ) #NOTE: Diff N: 0,119842127 , Diff O: 0,302484903
    diff_traceinterview_map = c(759, 1368) #NOTE: 759 N , 1368 O
    factor = c(diff_traceinterview_map[1] / diff_map[1], diff_traceinterview_map[2] / diff_map[2]) #NOTE: lat: 6333.332 , lon: 4522.540) 
    
# mutate koordianates after factor
df_x_y_corners_lat_long <- df_x_y_corners %>% 
  drop_na(x_koordinate) %>%  # cleaning the rows without any x,y coordinates because the do not have a photographer coordinated for example
  mutate(y_koordinate = y_koordinate * -1) %>% # Mutate y into the right coordinate system
  mutate(y_lat = y_koordinate / factor[1] + zero_zero[1],     # mutate to the right latitude coordinates
         x_long = x_koordinate / factor[2] + zero_zero[2]) %>% # mutate to the right longitude coordinates
  select(quest_jpg_id_code,
         jpg_name,
         user_name,
         art,
         sub_art,
         x_name,
         x_koordinate,
         x_long,
         y_name,
         y_koordinate,
         y_lat)


#build table for geoloc meta and data
df_final_all <- df_x_y_corners_lat_long


#build table for geoloc data
df_final_all_data <- df_x_y_corners_lat_long %>% 
  select(everything(),
         -jpg_name,
         -user_name,
         -art,
         -sub_art,
  ) 



#build table for geoloc meta data
df_final_all_meta <- df_x_y_corners_lat_long %>% 
  select(quest_jpg_id_code,
         jpg_name,
         user_name,
         art,
         sub_art
  ) 


# remove stuff at the end
rm(df_x_y
   ,df_x_y_corners
   ,df_x_y_final
   #,df_x_y_corners_lat_long
  )


#save as csv
write.csv2(df_final_all,
           file = paste0(paths$data_processed, "/", Sys.Date(),  "_geoloc_all.csv"), 
           na = "", 
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_final_all_data,
           file = paste0(paths$data_processed, "/", Sys.Date(),  "_geoloc_all_data.csv"), 
           na = "", 
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_final_all_meta,
           file = paste0(paths$data_processed, "/", Sys.Date(),  "_geoloc_all_meta.csv"), 
           na = "", 
           row.names = FALSE,
           fileEncoding = "UTF-8")
