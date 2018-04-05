tabItem(
  tabName = "report",
  fluidRow(
    box(
      width = 9,
      div(
        style = "text-align: center;",
        h2("Report Info"),
        h3(textOutput("report_title"))
      ),
      dataTableOutput("report_tbl")
    ),
    box(
      width = 3,
      title = "查詢條件",
      selectInput("courseId2", label = "課程",
                  choices = c("Option 1" = "option1",
                              "Option 2" = "option2")
      ),
      selectInput("videoCode2", label = "影片代碼",
                  choices = c("Video 1" = "Video1A",
                              "Video 2" = "Video2A")
      )
    )
  )
)