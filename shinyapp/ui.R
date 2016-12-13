


shinyUI(fluidPage(theme = "bootstrap.css",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "http://dev.dataskeptic.com/css/snl-impact.css")
  ),
  div(
    titlePanel("Causal Impact Analysis on Consumer Financial complaints"),
    p(
        span("A shiny app for causal impact analysis of consumer financial complaints")
    )
    , class="header"
  ),
  sidebarLayout(
    sidebarPanel(
      selectizeInput('products', label = "Product selection", choices = products, 
                     multiple = F,
                     options = NULL),
      selectizeInput('y_company', label = "Company to test", choices = companies, 
                     selected = "Citbank", multiple = FALSE,
                     options = NULL),
      selectizeInput('x1_company', label = "Control company", choices = companies, 
                     selected = "Discover", multiple = FALSE,
                     options = NULL),
      selectizeInput('x2_company', label = "Control company", choices = companies, 
                     selected = "JPMorgan Chase & Co.", multiple = FALSE,
                     options = NULL),
      selectizeInput('x3_company', label = "Control company", choices = companies, 
                     selected = "Synchrony Financial", multiple = FALSE,
                     options = NULL),
      dateRangeInput('pre_period', 'Pre-period:', start = '2016-01-03', end = '2016-06-18'),
      dateRangeInput('post_period', 'Post-period:', start = '2016-06-26', end = '2016-12-10'),
      actionButton("submit", "Run analysis")
    ),
    mainPanel(
      plotOutput('plots'),
      verbatimTextOutput('summary')
    )
  )
))


