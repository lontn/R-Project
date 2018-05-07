
tabItem(
  tabName = "dashboard",
  fluidRow(
    column(
      width = 9,
      fluidRow(
        valueBoxOutput("course_box"),
        valueBoxOutput("video_box"),
        valueBoxOutput("pass_box")
      ),
      fluidRow(
        box(
          width = 12,
          highchartOutput("lineChart")
        )
      ),
      fluidRow(
        box(
          width = 6,
          highchartOutput("columnChart")
        ),
        box(
          width = 6,
          selectInput("userId", label = "使用者",
                      choices = c("Option 1" = "option11",
                                  "Option 2" = "option22")
          ),
          uiOutput("userInfo"),
          highchartOutput("columnType"),
          DiagrammeROutput('gVizDiagram',height = 600, width = 600)
          # wordcloud2Output("wordcloud")
        )
      )
    ),
    box(
      width = 3,
      title = "課程專區",
      selectInput("courseId", label = "課程",
                  choices = c("Option 1" = "option1",
                              "Option 2" = "option2")
      ),
      # htmlOutput("courseId"),
      selectInput("videoCode", label = "影片代碼",
                  choices = c("Video 1" = "Video1A",
                              "Video 2" = "Video2A")
      )
    )
  )
)