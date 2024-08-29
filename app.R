#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(tidyverse)
library(readxl)
library(DT)

path_to_file <- "~/Desktop/CGIAR_R_training/livestock_data.xlsx"
#path_to_file <- "~/Desktop/CGIAR_R_training/Lungcancer.xlsx"

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Plotting histograms with ggplot2"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("variable",
                  "Please select a variable from the dataset:",
                  choices = character())
    ),
    
    # Show a plot of the generated distribution,
    # below the table itself.
    mainPanel(
      dataTableOutput("table"),
      plotOutput("distPlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  read_xlsx(path_to_file, sheet = 1) |> 
    select(where(is.numeric)) -> dat
  # with the above, we retain only the numeric columns from
  # the imported tibble
  
  # update the drop-down list of variables
  # using the names in the dataframe just read
  updateSelectInput(inputId = "variable",
                    choices = names(dat))
  
  output$distPlot <- renderPlot({
    req(input$variable)
    # the above prevents the display of an error message
    # until input$variable is ready.
    dat |> ggplot(aes(x = .data[[input$variable]])) +
      geom_histogram() +
      labs(x = input$variable,
           title = paste('Histogram of', input$variable))
  })
  
  output$table <- renderDataTable({
    dat |> DT::datatable(extensions = 'Buttons',
              options = list(
                paging = TRUE,
                dom = 'Blfrtip',
                # DOM elements are B: Buttons, l: page Length, f: Filtering input,
                # r: pRocessing display element, t: table,
                # i: table Information summary, p: Pagination control
                buttons = list('copy', 'print', list(
                  extend = 'collection',
                  buttons = c('csv', 'excel', 'pdf'),
                  text = 'Download'
                )),
                pageLength = 5,
                lengthMenu = list(
                  c(5, 10, 15, 20, -1), # values
                  c(5, 10, 15, 20, "all")) # displayed text
              ))
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
