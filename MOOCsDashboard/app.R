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
#全域變數設定
source("global.R", local = TRUE)

## header content
header <- dashboardHeader(
  title = "EdX Dashboard"
)

## Sidebar content
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("ReportInfo", tabName = "report", icon = icon("table")),
    menuItem("Widgets", tabName = "widgets", icon = icon("table"))
  )
)

## Body content
body <- dashboardBody(
  tabItems(
    # First tab content
    source("ui/dashboard.R", local = TRUE)$value,
    # Second tab content
    source("ui/reportInfo.R", local = TRUE)$value,
    # Third tab content
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
  #讀資料庫資料
  source("server/persistentdata.R", local = TRUE)
  source("server/dashboard-server.R", local = TRUE)
  source("server/reportInfo-server.R", local = TRUE)


  #組課程下拉選單
  courseOption <- c(loadCourseData()$id)
  names(courseOption) <- c(loadCourseData()$DisplayName)
  # View(courseOption)
  observe({
    # View(loadCourseData())
    updateSelectInput(
      session = session,
      inputId = "courseId",
      label = "課程名稱",
      choices = courseOption,
      selected = input$courseId
    )
    # print(loadCourseData()$id[1])
    print(input$courseId)
    videoCodes <- loadVideoData(input$courseId)
    # View(videoCodes)
    
    if (is.null(videoCodes)) return()

    videoOption <- c(videoCodes$VideoCode)
    names(videoOption) <- c(videoCodes$VideoTitle)
    #影片代碼
    updateSelectInput(
      session = session,
      inputId = "videoCode",
      label = "影片名稱",
      choices = videoOption,
      selected = input$videoCode
    )

    print(input$videoCode)
    selectUser <- listUserId(input$courseId, input$videoCode)
    #使用者
    updateSelectInput(
      session = session,
      inputId = "userId",
      label = "使用者",
      choices = selectUser$QTY
    )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)