

pre_start <- "2016-01-01"
pre_end <- "2016-04-20"
post_start <- "2016-04-21"
post_end <- "2016-08-20"

# Load Pageview Counts.
#start_timestamp <- substring(pageview_timestamps(pre_start), 0, 10) # convert to 'yymmddhh'
#end_timestamp   <- substring(pageview_timestamps(post_end) , 0, 10)    # convert to 'yymmddhh'

#input$y_article <- gsub(input$y_article, pattern = " ", replacement = "%20")
#input$x1_article <- gsub(input$x1_article, pattern = " ", replacement = "%20")
#input$x2_article<- gsub(input$x2_article, pattern = " ", replacement = "%20")
#input$x3_article <- gsub(input$x3_article, pattern = " ", replacement = "%20")


y_pageviews <- get_complaints(selects = "&$select=date_trunc_ymd(date_received),company",
                              filters = sprintf("&company=%s", gsub(input$y_article, pattern = " ",
                                                                    replacement = "%20")),
                              date_range = paste("&$where=date_received%20between%20","'",
                                                 pre_start,"'","%20and%20","'",post_end,"'",sep=""),
                              products = paste("&product=", gsub(input$products, pattern = " ",
                                                                 replacement = "%20"), sep = ""))



y_pageviews <- y_pageviews %>% 
  `colnames<-`(c("company","date")) %>% 
  group_by(date) %>% 
  summarise(count = n()) %>% 
  mutate(date = substr(date, start = 0, stop = 10))


x1_pageviews <- get_complaints(selects = "&$select=date_trunc_ymd(date_received),company",
                               filters = sprintf("&company=%s", gsub(input$x1_article, pattern = " ",
                                                                     replacement = "%20")),
                               date_range = paste("&$where=date_received%20between%20","'",
                                                  pre_start,"'","%20and%20","'",post_end,"'",sep=""),
                               products = paste("&product=", gsub(input$products, pattern = " ",
                                                                  replacement = "%20"), sep = ""))

x1_pageviews <- x1_pageviews %>% 
  `colnames<-`(c("company","date")) %>% 
  group_by(date) %>% 
  summarise(count = n()) %>% 
  mutate(date = substr(date, start = 0, stop = 10))



x2_pageviews <- get_complaints(selects = "&$select=date_trunc_ymd(date_received),company", 
                               filters = sprintf("&company=%s", gsub(input$x2_article, pattern = " ", 
                                                                     replacement = "%20")),
                               date_range = paste("&$where=date_received%20between%20","'",
                                                  pre_start,"'","%20and%20","'",post_end,"'", sep=""),
                               products = paste("&product=", gsub(input$products, pattern = " ",
                                                                  replacement = "%20"), sep = ""))

x2_pageviews <- x2_pageviews %>% 
  `colnames<-`(c("company","date")) %>% 
  group_by(date) %>% 
  summarise(count = n()) %>% 
  mutate(date = substr(date, start = 0, stop = 10))



x3_pageviews <- get_complaints(selects = "&$select=date_trunc_ymd(date_received),company",
                               filters = sprintf("&company=%s", gsub(input$x3_article, pattern = " ",
                                                                     replacement = "%20")),
                               date_range = paste("&$where=date_received%20between%20","'",
                                                  pre_start,"'","%20and%20","'",post_end,"'", sep=""),
                               products = paste("&product=", gsub(input$products, pattern = " ",
                                                                  replacement = "%20"), sep = ""))


x3_pageviews <- x3_pageviews %>% 
  `colnames<-`(c("company","date")) %>% 
  group_by(date) %>% 
  summarise(count = n()) %>% 
  mutate(date = substr(date, start = 0, stop = 10))




# Create Data Set
#   From the dataframes above, create data sets of time series consisting 
#   of the response variable y and predictors x[i].
data <- list(y = zoo(y_pageviews$count, as.Date(y_pageviews$date)),
             x1 = zoo(x1_pageviews$count, as.Date(x1_pageviews$date)),
             x2 = zoo(x2_pageviews$count, as.Date(x2_pageviews$date)),
             x3 = zoo(x3_pageviews$count, as.Date(x3_pageviews$date)))



data <- lapply(data, apply.monthly, sum)

data <- merge(data[["y"]], data[["x1"]], data[["x2"]], data[["x3"]], 
              fill = 0, 
              suffixes = names(data))

matplot(data, type = "l")


str(data)
# Construct Time Series Model
pre.period <- c(as.Date(pre_start), as.Date(pre_end))
post.period <- c(as.Date(post_start), as.Date(post_end))

impact <- CausalImpact(data[, 1:4], pre.period, post.period)

plot(impact)
summary(impact)
