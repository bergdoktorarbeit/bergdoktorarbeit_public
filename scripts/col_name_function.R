
# build function to change column names in traceinterviews
col_name_funct <- function(n){
  
   # n = 72 # to test 1 third comment extraction regex option
   # n = 5  # to test the clean up functions
   # n = 17 # to test 2 third comment extraction regex option
   # n = 16 # to test 3 third comment extraction regex option
   # n = 184 # to test random
  
  column <- colnames(df_4[n])
  
  df_col <- df_4[[column]]
  
  # extract comment
  col_comment <- tolower(str_replace_all(
    if_else(str_detect(comment(df_col),"(?<=: )\\[01\\]") == TRUE, 
            str_extract(comment(df_col), "[:alpha:]+(?=: )"), 
            str_extract(comment(df_col), "((?<=: ).+)|([-[:alpha:]]+$)" ) ), 
    "\\s", "_") 
  )
  
  # filter group (st/de/pr)
  col_group <- df_quest_raw %>% 
    filter(col == column) %>% 
    select(group)
  
  # build column name
  col_name_prep <- paste0(colnames(df_4[n]), "_", col_group, "_", col_comment)
  
  # clean up
  col_name_prep <- if_else(str_detect(col_name_prep,"_character") == TRUE, 
                      str_replace(col_name_prep, "(?<=_character)[^_]+", ""),
                      col_name_prep) 
  
  col_name_prep <- str_replace(col_name_prep, "character", "")
  col_name_prep <- str_replace(col_name_prep, "NA", "")
  col_name_prep <- str_replace(col_name_prep, "\\[01\\]", "")
  col_name_prep <- str_replace(col_name_prep, "___", "_")
  col_name_prep <- str_replace(col_name_prep, "__", "_")
  
  # final
  col_name <- col_name_prep
  col_name
  
  return(col_name)
}