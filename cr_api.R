
get_complaints <- function(api_endpoint = "https://data.consumerfinance.gov/resource/jhzv-w97w.csv?$$app_token=%s&$limit=50000", 
                           selects = NULL, 
                           filters = NULL,
                           token ="VWJa6qhKHXoOyZiCNnCRlbbNX"){
  base_url <- sprintf(api_endpoint,token)
  count <- read.csv(file = paste(base_url, "&$select=count(complaint_id)", sep = ""),
                    stringsAsFactors = F)
  count <- count[1,1]
  options(scipen = 999)
  pages <- as.character(seq(from = 0 , to = count, by = 50000))
  df <- data.frame()
  for(i in 1:length(pages)){
    temp <- read.csv(file = paste(base_url,
                                  filters,
                                  paste("&$offset=", pages[i], sep = ""),
                                  selects,
                                  sep = ""),
                     stringsAsFactors = F)
    df <- rbind(df, temp)
  }
  df
}





