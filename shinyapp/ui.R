df <- get_complaints(selects = "&$select=company,product")

companies <- unique(df$company)
products <- unique(df$product)

rm(df)


shinyUI(fluidPage(theme = "bootstrap.css",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "http://dev.dataskeptic.com/css/snl-impact.css")
  ),
  div(
    titlePanel("Causal Impact on Wikipedia analysis"),
    p(
        span("A shiny app for causal impact analysis of consumer financial complaints")
    )
    , class="header"
  ),
  sidebarLayout(
    sidebarPanel(
      selectizeInput('y_company', label = "Company to test", choices = companies, 
                     selected = "Bank of America", multiple = FALSE,
                     options = NULL),
      selectizeInput('x1_company', label = "Control company", choices = companies, 
                     selected = "Bank of America", multiple = FALSE,
                     options = NULL),
      selectizeInput('x2_company', label = "Control company", choices = companies, 
                     selected = "Bank of America", multiple = FALSE,
                     options = NULL),
      selectizeInput('x3_company', label = "Control company", choices = companies, 
                     selected = "Bank of America", multiple = FALSE,
                     options = NULL),
      dateRangeInput('pre_period', 'Pre-period:', start = '2016-05-13', end = '2016-05-21'),
      dateRangeInput('post_period', 'Post-period:', start = '2016-05-22', end = '2016-05-27'),
      actionButton("submit", "Run analysis")
    ),
    mainPanel(
      plotOutput('plots'),
      verbatimTextOutput('summary')
    )
  )
))


