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
      textInput('y_article', 'Article:', 'Sia'),
      textInput('x1_article', 'Control Article 1:', 'Dragonette'),
      textInput('x2_article', 'Control Article 2:', 'PJ Harvey'),
      textInput('x3_article', 'Control Article 3:', 'Serena Ryder'),
      dateRangeInput('pre_period', 'Pre-period:', start = '2015-10-01', end = '2015-11-06'),
      dateRangeInput('post_period', 'Post-period:', start = '2015-11-07', end = '2015-11-14'),
      actionButton("submit", "Run analysis")
    ),
    mainPanel(
      plotOutput('plots'),
      verbatimTextOutput('summary')
    )
  )
))