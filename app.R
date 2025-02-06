library(shiny)
install.packages("styler")
ui <- fluidPage(
  titlePanel("My first Shiny app"),
  h2("My app from scratch"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "newbins",
        label = "Number of bins:",
        min = 1,
        max = 50,
        value = 30
      )
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)


server <- function(input, output) {
  output$distPlot <- renderPlot({
    x <- faithful[, 2]
    newbins <- seq(min(x), max(x), length.out = input$newbins + 1)

    hist(x,
      breaks = newbins, col = "darkgray", border = "white",
      xlab = "Waiting time to next eruption (in mins)",
      main = "Histogram of waiting times"
    )
  })
}


shinyApp(ui = ui, server = server)
