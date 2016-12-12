library(shiny)
library(CausalImpact)
library(dplyr)
library(tidyr)

example <- pageviews::article_pageviews()



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
                                  offset = paste("&$offset=", pages[i], sep = ""),
                                  selects, 
                                  filters, 
                                  sep = ""),
                     stringsAsFactors = F)
    df <- rbind(df, temp)
  }
  df
}


df <- get_complaints(selects = "&$select=company,product")

companies <- unique(df$company)
products <- unique(df$product)

rm(df)


shinyServer(function(input, output) {
  
  impact <- eventReactive(input$submit, {

    # Log query to a csv file.
    #   Create csv file if it does not exist, writing header line.
    #   Entries consist of "current_time, pre_start, pre_end, post_start, post_end,
    #     y_article, x1_article, x2_article, x3_article"
    LOGFILE <- "causalimpact.csv"
    if(!file.exists(LOGFILE)) {
      file.create(LOGFILE)
      write("current_time, pre_start, pre_end, post_start, post_end, y, x1, x2, x3",
        file=LOGFILE, append=TRUE)
    }
    line <- sprintf("%s, %s, %s, %s, %s, %s, %s, %s, %s", Sys.time(), input$pre_period[1],
      input$pre_period[2], input$post_period[1], input$post_period[2],
      input$y_article, input$x1_article, input$x2_article, input$x3_article)
    write(line, file=LOGFILE, append=TRUE)

    # Convert date strings to R objects
    pre_start <- as.Date(input$pre_period[1])
    pre_end <- as.Date(input$pre_period[2])
    post_start <- as.Date(input$post_period[1])
    post_end <- as.Date(input$post_period[2])

    # Load Pageview Counts.
    start_timestamp <- substring(pageview_timestamps(pre_start), 0, 10) # convert to 'yymmddhh'
    end_timestamp   <- substring(pageview_timestamps(post_end) , 0, 10)    # convert to 'yymmddhh'
    
    #input$y_article <- gsub(input$y_article, pattern = " ", replacement = "%20")
    #input$x1_article <- gsub(input$x1_article, pattern = " ", replacement = "%20")
    #input$x2_article<- gsub(input$x2_article, pattern = " ", replacement = "%20")
    #input$x3_article <- gsub(input$x3_article, pattern = " ", replacement = "%20")
    
    y_pageviews <- get_complaints(selects = "&$select=date_received,company",
                                  filters = sprintf("&company=%s", gsub(input$y_article, pattern = " ", replacement = "%20")))
    x1_pageviews <- get_complaints(selects = "&$select=date_received,company",
                                   filters = sprintf("&company=%s", gsub(input$x1_article, pattern = " ", replacement = "%20")))
    x2_pageviews <- get_complaints(selects = "&$select=date_received,company", 
                                   filters = sprintf("&company=%s", gsub(input$x2_article, pattern = " ", replacement = "%20")))
    x3_pageviews <- get_complaints(selects = "&$select=date_received,company",
                                   filters = sprintf("&company=%s", gsub(input$x3_article, pattern = " ", replacement = "%20")))
    
    

    aggregate(x1_pageviews$date_received, FUN = sum, by = )
    # Create Data Set
    #   From the dataframes above, create data sets of time series consisting 
    #   of the response variable y and predictors x[i].
    data <- 
    colnames(data) <- c("y", "x1", "x2", "x3")

    # Construct Time Series Model
    pre.period <- c(pre_start, pre_end)
    post.period <- c(post_start, post_end)
    impact <- CausalImpact(data, pre.period, post.period)
    
    
  })

  output$plots <- renderPlot({
    plot(impact)
  })

  output$summary <- renderPrint({
    summary()
  })
})

