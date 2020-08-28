pkgs <- c(
  # basics
  "shiny",
  "tidyverse",
  "here",
  "glue",
  "httr",
  "htmltools",
  "shinyjs",
  "shinyalert",
  "shinycssloaders",
  # basic styling
  "shinythemes",
  "shinydashboard",
  "flexdashboard",
  # htmlwidgets
  "DT",
  "plotly",
  "highcharter",
  "leaflet",
  "dygraphs",
  "ggiraph",
  "timevis",
  # other
  "sass",
  "shinytest",
  "shinyloadtest",
  "jsonlite"
)

install.packages(pkgs, repos = "https://cloud.r-project.org/")

tidyverse::tidyverse_update()
