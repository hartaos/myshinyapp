library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(glue)
library(shinylive)
# install.packages("shinylive")
shinylive::export(appdir = ".",destdir="docs")

ui <- fluidPage(
  titlePanel("My First Shiny App"),
  sidebarLayout(
    sidebarPanel(
      h1("Star Wars Characters"),
      h2("My app from scratch"),
      sliderInput("taille",
        label = "Height of characters",
        min = 0,
        max = 250,
        value = 30),
        selectInput(
          inputId = "gender",
          label = "choisir le genre des personnages",
          choices = c("masculine", "feminine")
        )
      ),
      mainPanel(
        textOutput(outputId ="starwarstitle" ),
        plotOutput("StarWarsPlot"),
        DTOutput(
          outputId ="StarwarsTable"
        )
      )
    )
  )






server <- function(input, output) {
  output$StarWarsPlot <- renderPlot({
    starwars |>
      filter(height > input$taille) |>
      filter(gender == input$gender) |>
    ggplot(aes(x = height)) +
      geom_histogram(
        binwidth  = 10,
        fill = "darkgray",
        color = "white"
      )+
      labs(
        title = glue("Vous avez selectionné le genre :{input$gender} ")
      )
  })
  output$starwarstitle <-renderText({
    nb_lignes <- starwars |> 
      filter(height > input$taille) |>
      filter(gender == input$gender) |>
      nrow()
    
    glue("Nb de ligne sélectionner : {nb_lignes}")
  })
  output$StarwarsTable <- renderDT({
    starwars |> 
      filter(height > input$taille) |>
      filter(gender == input$gender)
    })
}

shinyApp(ui = ui, server = server)
