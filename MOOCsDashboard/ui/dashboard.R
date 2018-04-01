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
          width = 12
          #highchartOutput("ay_plot")
        )
      )
    ),
    box(
      width = 3,
      title = "Course Class",
      selectInput("courseId", label = "Course",
                  choices = c("Option 1" = "option1",
                              "Option 2" = "option2")
      ),
      selectInput("videoCode", label = "Video",
                  choices = c("Video 1" = "Video1A",
                              "Video 2" = "Video2A")
      )
    )
  )
)