pkgs <- c(
  "DT",
  "dygraphs",
  "flexdashboard",
  "ggiraph",
  "glue",
  "here",
  "highcharter",
  "htmltools",
  "httr",
  "jsonlite",
  "leaflet",
  "plotly",
  "rmarkdown",
  "rsconnect",
  "sass",
  "shiny",
  "shinyalert",
  "shinycssloaders",
  "shinydashboard",
  "shinyjs",
  "shinytest",
  "shinyloadtest",
  "shinythemes",
  "tidyverse",
  "timevis"
)

install.packages(pkgs, repos = "https://cloud.r-project.org/")

tidyverse::tidyverse_update()
