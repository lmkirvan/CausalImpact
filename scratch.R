

pre_start <- "2016-01-01"
pre_end <- "2016-06-20"
post_start <- "2016-06-27"
post_end <- "2016-11-20"

# Load Pageview Counts.
#start_timestamp <- substring(pageview_timestamps(pre_start), 0, 10) # convert to 'yymmddhh'
#end_timestamp   <- substring(pageview_timestamps(post_end) , 0, 10)    # convert to 'yymmddhh'

#input$y_article <- gsub(input$y_article, pattern = " ", replacement = "%20")
#input$x1_article <- gsub(input$x1_article, pattern = " ", replacement = "%20")
#input$x2_article<- gsub(input$x2_article, pattern = " ", replacement = "%20")
#input$x3_article <- gsub(input$x3_article, pattern = " ", replacement = "%20")

y_pageviews <- get_complaints(selects = "&$select=date_trunc_ymd(date_received),company",
                              filters = sprintf("&company=%s", gsub("Citibank", pattern = " ",
                                                                    replacement = "%20")),
                              date_range = paste("&$where=date_received%20between%20","'",
                                                 pre_start,"'","%20and%20","'",post_end,"'",sep=""))

y_pageviews <- y_pageviews %>% 
  `colnames<-`(c("company","date")) %>% 
  group_by(date) %>% 
  summarise(count = n()) %>% 
  mutate(date = substr(date, start = 0, stop = 10))

x1_pageviews <- get_complaints(selects = "&$select=date_trunc_ymd(date_received),company",
                               filters = sprintf("&company=%s", gsub("Capital One", pattern = " ",
                                                                     replacement = "%20")),
                               date_range = paste("&$where=date_received%20between%20","'",
                                                  pre_start,"'","%20and%20","'",post_end,"'",sep=""))

x1_pageviews <- x1_pageviews %>% 
  `colnames<-`(c("company","date")) %>% 
  group_by(date) %>% 
  summarise(count = n()) %>% 
  mutate(date = substr(date, start = 0, stop = 10))

x2_pageviews <- get_complaints(selects = "&$select=date_trunc_ymd(date_received),company", 
                               filters = sprintf("&company=%s", gsub("Discover", pattern = " ", 
                                                                     replacement = "%20")),
                               date_range = paste("&$where=date_received%20between%20","'",
                                                  pre_start,"'","%20and%20","'",post_end,"'", sep=""))

x2_pageviews <- x2_pageviews %>% 
  `colnames<-`(c("company","date")) %>% 
  group_by(date) %>% 
  summarise(count = n()) %>% 
  mutate(date = substr(date, start = 0, stop = 10))


x3_pageviews <- get_complaints(selects = "&$select=date_trunc_ymd(date_received),company",
                               filters = sprintf("&company=%s", gsub('Bank of America', pattern = " ",
                                                                     replacement = "%20")),
                               date_range = paste("&$where=date_received%20between%20","'",
                                                  pre_start,"'","%20and%20","'",post_end,"'", sep=""))

x3_pageviews <- x3_pageviews %>% 
  `colnames<-`(c("company","date")) %>% 
  group_by(date) %>% 
  summarise(count = n()) %>% 
  mutate(date = substr(date, start = 0, stop = 10))




# Create Data Set
#   From the dataframes above, create data sets of time series consisting 
#   of the response variable y and predictors x[i].
data <- cbind(zoo(y_pageviews$count, as.Date(y_pageviews$date)),
              zoo(x1_pageviews$count, as.Date(x1_pageviews$date)),
              zoo(x2_pageviews$count, as.Date(x2_pageviews$date)),
              zoo(x3_pageviews$count, as.Date(x3_pageviews$date)), fill = 0)


colnames(data) <- c("y", "x1", "x2", "x3")

# Construct Time Series Model
pre.period <- c(as.Date(pre_start), as.Date(pre_end))
post.period <- c(as.Date(post_start), as.Date(post_end))

impact <- CausalImpact(data, pre.period, post.period)

plot(impact)

str_c(c(pre_end,post_end), collapse= ",")


