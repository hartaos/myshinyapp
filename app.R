library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(glue)
library(shinylive)
library(bslib)
library(thematic)
# install.packages("shinylive")
#shinylive::export(appdir = ".",destdir="docs")

thematic_shiny(font="auto")

ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "solar" ),
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
        ),
       actionButton(
         inputId = "boutton",
         label = "cliquez-moi"
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
        fill = "#8EC58E",
        color ="black"
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

  observeEvent(input$boutton,{
    message("vous avez cliqué sur le bouton")
  })
               
  observeEvent(input$taille,{
    showNotification(glue("la valeur du slider a changé, elle est de {input$taille}"),
                     type = "message")
  })          
               
}


shinyApp(ui = ui, server = server)
