library(shiny)

shinyUI(fluidPage(theme = "bootstrap.css",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "http://dev.dataskeptic.com/css/snl-impact.css")
  ),
  div(
    titlePanel("Causal Impact on Wikipedia analysis"),
    p(
        span("Learn more about this Shiny app, how we built it, and why, visit "),
        a("http://dataskeptic.com/l/snl-impact", href='http://dataskeptic.com/l/snl-impact')
    )
    , class="header"
  ),
  sidebarLayout(
    sidebarPanel(
      textInput('y_article', 'Article:', 'Courtney Barnett'),
      textInput('x1_article', 'Control Article 1:', 'Joshua Tillman'),
      textInput('x2_article', 'Control Article 2:', 'Sleater Kinney'),
      textInput('x3_article', 'Control Article 3:', 'Sharon Van Etten'),
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
