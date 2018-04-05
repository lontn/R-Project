
tabItem(
  tabName = "dashboard",
  fluidRow(
    column(
      width = 9,
      fluidRow(
        valueBoxOutput("course_box"),
        valueBoxOutput("case_box"),
        valueBoxOutput("reported_box")
      ),
      fluidRow(
        box(
          width = 12,
          highchartOutput("lineChart")
        )
      )
    ),
    box(
      width = 3,
      title = "課程專區XX",
      selectInput("courseId", label = "課程",
                  choices = c("Option 1" = "option1",
                              "Option 2" = "option2")
      ),
      selectInput("videoCode", label = "影片代碼",
                  choices = c("Video 1" = "Video1A",
                              "Video 2" = "Video2A")
      )
    )
  )
)