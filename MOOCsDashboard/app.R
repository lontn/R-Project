#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

## header content
header <- dashboardHeader(
  title = "EdX Dashboard"
)

## Sidebar content
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", tabName = "widgets", icon = icon("table"))
  )
)

## Body content
body <- dashboardBody(
  tabItems(
    # First tab content
    source("ui/dashboard.R", local = TRUE)$value,
    
    # Second tab content
    tabItem(tabName = "widgets", h2("Widgets tab content"))
  )
)

# Define UI for application that draws a histogram
ui <- dashboardPage(
  header,
  sidebar,
  body
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  source("server/dashboard-server.R", local = TRUE)
  #讀資料庫資料
  source("server/persistentdata.R", local = TRUE)
  
  observe({
    choice <- c(loadCourseData()$DisplayName, loadCourseData()$CourseId)
    updateSelectInput(
      session = session,
      inputId = "courseId",
      label = "Course",
      choices = choice
    )
  })
  
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

