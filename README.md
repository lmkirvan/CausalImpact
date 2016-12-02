## Causal Impact of External Events on Wikipedia Page Views

This respository contains an analysis of the causal impact of external events on Wikipedia page views.  The analysis
was done for the [Data Skeptic Podcast](http://dataskeptic.com/).  For details on the episode, visit [Causal Impact shownotes](http://dataskeptic.com/l/snl-impact)

Subdirectories in this repository are:
* Notebook - Jupyter R Notebook containing example analyses.
* shinyapp - An R Shiny Web application to run causal impact analyses.

### Trying the Shiny App
You can try this app out by visiting [snl.dataskeptic.com](http://snl.dataskeptic.com)

### Running the Shiny App Yourself
Due to some painful configuration issues to get this running, we provide a `Dockerfile`.  All you need to do is have docker installed, build that image, and run it.  When it finishes building, it will launch the app on your local machine answering on port 3838.
