
# Define a function to clean the text of each post
clean_text <- function(text) {
  
  # Convert text to lowercase
  text <- tolower(text)
  
  # Remove URLs
  text <- str_replace_all(text, "https\\S+\\s?", " ")
  text <- str_replace_all(text, "http\\S+\\s?", " ")
  text <- str_replace_all(text, "www\\S+\\s?", " ")
  
  # Remove mentions
  text <- str_replace_all(text, "@\\S+", " ")
  
  # Remove hashtags
  text <- str_replace_all(text, "#\\S+", " ")
  
  # Remove emojis
  text <- stri_replace_all(text, regex="\\p{Emoji}", " ")
  text <- str_remove_all(text, "<.+>")
  
  # Remove non-alphanumeric characters except for spaces and apostrophes
  text <- str_replace_all(text, "[^[:alnum:]'\\s]", " ")
  
  # Remove numbers
  text <- str_replace_all(text, "[:digit:]+", " ")
  
  # Remove stopwords #NOTE: Do it later in the tokens, 
                     #      because it erases also the whitespaces
  # text <- removeWords(text, stopwords("de"))
  
  # Remove lonely letters
  text <- str_remove_all(text, "\\s{1}[:alpha:]{1}\\s{1}")
  #NOTE: Takes out the "a" or "I" in english texts
  
  # Remove excess whitespace
  text <- str_trim(text)
  # reduce the white spaces (step by step)
  text <- str_replace_all(text, "\\s{2}", " ") 
  text <- str_replace_all(text, "\\s{2}", " ")
  text <- str_replace_all(text, "\\s{2}", " ")
  text <- str_replace_all(text, "\\s{2}", " ")
  
  # Cleaning up very special charakters
  #text <- str_remove_all(text, "[^[:alpha:][:blank:]]")
  text <- str_remove_all(text, " 🅲 ")
  text <- str_replace_all(text, "\\\n", " ")
  text <- str_remove_all(text, "𝙰+")
  text <- str_remove_all(text, "𝑨+") 
  text <- str_remove_all(text, "𝓐+")
  text <- str_remove_all(text, "𝙱+")
  text <- str_remove_all(text, "🅳+") 
  text <- str_remove_all(text, "𝗗+") 
  text <- str_remove_all(text, "𝕯+")
  text <- str_remove_all(text, "𝙴+") 
  text <- str_remove_all(text, "ℯ+")
  text <- str_remove_all(text, "𝕰+")
  text <- str_remove_all(text, "𝙵+")
  text <- str_remove_all(text, "𝙶+")
  text <- str_remove_all(text, "𝙷+") 
  text <- str_remove_all(text, "𝗛+")
  text <- str_remove_all(text, "𝙸+")
  text <- str_remove_all(text, "🄺+")
  text <- str_remove_all(text, "𝙺+")
  text <- str_remove_all(text, "𝙻+")
  text <- str_remove_all(text, "𝙼+")
  text <- str_remove_all(text, "𝙿+")
  text <- str_remove_all(text, "🅠+")
  text <- str_remove_all(text, "𝚁+")
  text <- str_remove_all(text, "𝚂+")
  text <- str_remove_all(text, "𝚄+")
  text <- str_remove_all(text, "𝜈+")
  text <- str_remove_all(text, "v{2,}")
  text <- str_remove_all(text, "𝚅{2,}")
  text <- str_remove_all(text, "𝚆+")
  text <- str_remove_all(text, "𝙒+") 
  text <- str_remove_all(text, "𝐰+") 
  text <- str_remove_all(text, "🅩+")
  
  






  text <- str_remove_all(text, "𝙺+")
  text <- str_remove_all(text, "𝙺+")
  text <- str_remove_all(text, "𝙺+")
  
  
  return(text)
}
