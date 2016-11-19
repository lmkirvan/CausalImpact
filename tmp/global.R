# Install any missing packages and load
# ==============================================================================

# Global file which will be run before the shiny app:

for(pack in c("curl", "devtools", "BoomSpikeSlab", "shiny", "pageviews")) {

  if(! pack %in% installed.packages()){
    install.packages(pack, repos="http://cran.us.r-project.org")
  }

  library(pack, character.only=TRUE)
}

if(! "CausalImpact" %in% installed.packages()){
  library(devtools)
  devtools::install_github("google/CausalImpact")
}

library(CausalImpact)
