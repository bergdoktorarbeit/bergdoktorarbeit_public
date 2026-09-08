#NOTE: NOT working at the moment!


# define function
sheet_col_function <- function(table_names, sheet_num) {

  # # define tables
  # table_names <- c("df_8.4_top_count_scr_final",
  #                  "df_8.4_top_count_des_final",
  #                  "df_8.4_top_count_pro_final")
  
  # Loop through each cross table and add it to the worksheet
  col_start <- 1
  for (table_name in table_names) {
    # Load the cross table
    table_data <- get(table_name)
    
    # Determine the number of rows and columns in the cross table
    n_rows <- nrow(table_data)
    n_cols <- ncol(table_data)
    
    # Write the cross table to the worksheet
    return(writeData(
      wb, 
      sheet = sheet_num,
      x = table_data,
      startRow = 1,
      startCol = col_start,
      borders = "all",
      headerStyle = hs1,
      keepNA = FALSE
    ) )
    
    # Increment the col_start variable so that the next table is written to the next column
    col_start <- col_start + n_cols + 2 # Add 2 for the blank column between tables
  }

   
}
