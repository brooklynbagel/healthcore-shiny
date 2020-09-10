library(shiny)
library(dplyr)
library(DT)
library(ggplot2)
library(glue)
library(lubridate)
library(stringr)
library(tidyr)

songs <- readr::read_csv(here::here("data/spotify_songs.csv"))
songs <- songs %>%
  separate(track_album_release_date, into = c("year", "month", "day"), sep = "-", fill = "right") %>%
  replace_na(list(month = "01", day = "01")) %>%
  unite(track_album_release_date, year:day, sep = "-") %>%
  mutate(track_album_release_date = ymd(track_album_release_date))

numeric_cols <- c(
  `Track Popularity` = "track_popularity",
  Danceability = "danceability",
  Energy = "energy",
  Key = "key",
  Loudness = "loudness",
  Mode = "mode",
  Speechiness = "speechiness",
  Acousticness = "acousticness",
  Instrumentalness = "instrumentalness",
  Liveness = "liveness",
  Valence = "valence",
  Tempo = "tempo",
  Duration = "duration_ms"
)

ui <- fluidPage(
  shinythemes::themeSelector(),
  titlePanel("Spotify Songs Explorer"),
  sidebarLayout(
    sidebarPanel(
      p("Original dataset provided courtesy of TidyTuesday. It can be found ", a("here", href = "https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-01-21/readme.md", target = "_blank"), "."),
      hr(),
      h2("Data filters"),
      h3("Release date"),
      dateRangeInput(
        "filter_release_date", "Filter by release date",
        start = min(songs$track_album_release_date),
        end = max(songs$track_album_release_date)
      ),
      hr(),
      h3("Genre"),
      checkboxGroupInput(
        "filter_genre", "Filter genre(s):",
        choices = c(
          "Pop" = "pop",
          "Rap" = "rap",
          "Rock" = "rock",
          "Latin" = "latin",
          "R&B" = "r&b",
          "EDM" = "edm"
        ),
        selected = c("pop", "rap")
      ),
      actionButton("select_all_genres", "Select all genres"),
      actionButton("unselect_all_genres", "Unselect all genres"),
      hr(),
      h3("User-defined"),
      radioButtons("search_by", "Select a filter:", choices = c(
        None = "",
        Track = "track_name",
        Artist = "track_artist",
        Album = "track_album_name"
      )),
      uiOutput("search_input"),
      hr(),
      h2("Generate report"),
      radioButtons("report_theme", "Select a report theme:", choices = list(
        Architect = "architect",
        Cayman = "cayman",
        HPSTR = "hpster",
        Leonids = "leonids",
        Tactile = "tactile"
      )),
      p("You can see what the ", code("{prettydoc}"), " themes look like ", a("here", href = "https://prettydoc.statr.me/themes.html", target = "_blank"), "."),
      numericInput("num_rows", "Number of rows in report table:", value = 20, min = 1, max = 1000),
      downloadButton("report", label = "Generate report"),
      hr(),
      bookmarkButton()
    ),
    mainPanel(
      textOutput("text"),
      br(),
      br(),
      tabsetPanel(
        tabPanel(
          "Plot",
          wellPanel(
            h2("Plot controls"),
            selectInput("var_x", "Select the x-var:", choices = numeric_cols, selected = numeric_cols[2]),
            selectInput("var_y", "Select the y-var:", choices = numeric_cols, selected = numeric_cols[1]),
            sliderInput("alpha", "Select the plot opacity:", min = 0, max = 1, value = 0.2),
            checkboxInput("color_by_genre", "Color by playlist genre?")
          ),
          plotOutput("plot")
        ),
        tabPanel("Table", DTOutput("table")),
        tabPanel("Summary", verbatimTextOutput("summary"))
      )
    )
  )
)

server <- function(input, output, session) {
  # bookmarks excludes ----
  setBookmarkExclude(names = c("shinytheme-selector", "table_cell_clicked", "table_cells_selected", "table_columns_selected", "table_rows_all", "table_rows_current", "table_rows_selected", "table_search", "table_state"))

  # filter by date ----
  songs_filter_date <- reactive({
    songs %>%
      filter(
        track_album_release_date >= input$filter_release_date[1],
        track_album_release_date <= input$filter_release_date[2]
      )
  })

  # filter by genre ----
  observeEvent(input$select_all_genres, {
    updateCheckboxGroupInput(session, "filter_genre", selected = c("pop", "rap", "rock", "latin", "r&b", "edm"))
  })

  observeEvent(input$unselect_all_genres, {
    updateCheckboxGroupInput(session, "filter_genre", selected = character())
  })

  songs_filter_genre <- reactive({
    songs_filter_date() %>%
      filter(playlist_genre %in% input$filter_genre)
  })

  # user-defined filter ----
  output$search_input <- renderUI({
    req(input$search_by)

    label <- switch(
      input$search_by,
      track_name = "track",
      track_artist = "artist",
      track_album_name = "album"
    )

    textInput("text_search", label = glue("Search by {label}:"))
  })

  songs_filter_user_defined <- reactive({
    songs <- songs_filter_genre()

    if (!(isTruthy(input$search_by) && isTruthy(input$text_search))) {
      return(songs)
    }

    songs %>%
      filter(str_detect(
        .data[[input$search_by]],
        regex(input$text_search, ignore_case = TRUE)
      ))
  })

  # songs filtered ----
  songs_filtered <- reactive({
    songs_filter_user_defined()
  })


  # output text ----
  output$text <- renderText({
    glue(
      "Out of {nrow(songs)} in the Spotify Songs dataset",
      ", {nrow(songs_filtered())} have been selected."
    )
  })

  # output plot ----
  output$plot <- renderPlot({
    p <- ggplot(songs_filtered(), aes_string(x = input$var_x, y = input$var_y)) +
      theme_minimal()
    if (input$color_by_genre) {
      p + geom_point(alpha = input$alpha, aes(color = playlist_genre))
    } else {
      p + geom_point(alpha = input$alpha)
    }
  })

  # output table ----
  output$table <- renderDT({
    data <- songs_filtered() %>%
      mutate(duration = round(duration_ms / 1000)) %>%
      select(-ends_with("_id"), -duration_ms)
    colnames <- colnames(data) %>%
      str_replace_all("_", " ") %>%
      str_to_title()
    datatable(
      data,
      colnames = colnames, rownames = FALSE,
      extensions = c("Buttons", "Responsive"),
      options = list(
        dom = "Bipt",
        buttons = c("csv", "excel")
      )
    )
  })

  # output summary ----
  output$summary <- renderPrint({
    songs_filtered() %>%
      mutate(duration = round(duration_ms / 1000)) %>%
      select( track_popularity, danceability:duration, -duration_ms) %>%
      summary()
  })

  # output file
  output$report <- downloadHandler(
    filename = "report.html",
    content = function(file) {
      on.exit(unlink(tmp))

      tmp <- tempfile(fileext = ".rds")
      readr::write_rds(songs_filtered(), tmp)

      rmarkdown::render(
        input = here::here("rmarkdown/report.Rmd"),
        output_file = file,
        prettydoc::html_pretty(
          theme = input$report_theme
        ),
        params = list(
          file = tmp,
          var_x = input$var_x,
          var_y = input$var_y,
          alpha = input$alpha,
          color_by_genre = input$color_by_genre,
          num_rows = input$num_rows
        ),
        envir = new.env()
      )
    }
  )

}

enableBookmarking(store = "url")

shinyApp(ui, server)
