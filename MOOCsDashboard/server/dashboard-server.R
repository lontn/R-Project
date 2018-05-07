### dashboard tab

output$course_box <- renderValueBox({
  if(input$courseId == ""){
    return(valueBox(
      paste0(0, "人"), "課程人數", icon = icon("users"),
      color = "red"
    ))
  }
  courseQTY <- countCourseData(input$courseId)
  valueBox(
    paste0(courseQTY$QTY, "人"), "課程人數", icon = icon("users"),
    color = "red"
  )
})

output$video_box <- renderValueBox({
  if(input$courseId == ""){
    return(valueBox(
      paste0(0, "人"), "影片人數", icon = icon("users"),
      color = "purple"
    ))
  }
  videoQTY <-countVideoData(input$courseId, input$videoCode)
  valueBox(
    paste0(videoQTY$QTY, "人"), "影片人數", icon = icon("users"),
    color = "purple"
  )
})

output$pass_box <- renderValueBox({
  if(input$courseId == ""){
    return(valueBox(
      paste0(0, "人"), "取得證書人數", icon = icon("certificate"),
      color = "yellow"
    ))
  }
  certQTY <- certData(input$courseId)
  valueBox(
    paste0(certQTY$QTY, "人"), "取得證書人數", icon = icon("certificate"),
    color = "yellow"
  )
})

# output$courseId <- renderUI({
#   #組課程下拉選單
#   courseOption <- c(loadCourseData()$id)
#   names(courseOption) <- c(loadCourseData()$DisplayName)
#   selectInput(
#     inputId = "courseId",
#     label = "課程",
#     choices = courseOption
#   )
# })

output$lineChart <- renderHighchart({
  # print(input$courseId)
  # if(input$courseId == "" || input$userId == "" || input$userId == "option11"){
  #   return(NULL)
  # }
  tableResult <- loadEventData(input$courseId, input$videoCode)
  if (length(tableResult$EventType) == 0) {
    return(NULL)
  }

  course <- filter(loadVideoData(input$courseId), CourseId == input$courseId, VideoCode == input$videoCode)
  # View(tableResult)
  highchart() %>%
    hc_title(text = course$DisplayName, style = list(color = "#BBB")) %>%
    hc_subtitle(text = course$VideoTitle) %>%
    # hc_xAxis(categories = tableResult$VideoSec) %>%
    hc_yAxis(title = list(text = "次數", align = "middle")) %>%
    hc_tooltip(
      split = TRUE,
      valueSuffix = " count",
      sort = TRUE,
      table = TRUE
    ) %>%
    hc_plotOptions(area = list(
      stacking = "normal",
      lineColor = "#ffffff",
      lineWidth = 1,
      marker = list(lineWidth = 1, lineColor = "#ffffff")
    )) %>%
    hc_add_series_df(
      data = tableResult,
      # mapping = hcaes(
        x = tableResult$VideoSec,
        y = tableResult$Sum,
        # size = tableResult$Sum,
        group = tableResult$EventType,
      # ),
      type = "areaspline"
    )
})

output$columnChart <- renderHighchart({
  # if(input$courseId == "" || input$userId == "" || input$userId == "option11"){
  #   return(NULL)
  # }
  columnResult <- loadSampleData(input$courseId, input$videoCode)
  if (length(columnResult$user_id) == 0) {
    return(NULL)
  }
  course <- filter(loadVideoData(input$courseId), CourseId == input$courseId, VideoCode == input$videoCode)
  highchart() %>%
    hc_title(text = course$DisplayName, style = list(color = "#BBB")) %>%
    hc_subtitle(text = course$VideoTitle) %>%
    hc_xAxis(title = list(text = "使用者", align = "middle"), type='category', categories = columnResult$user_id) %>%
    hc_yAxis(title = list(text = "花費時間(秒)", align = "middle")) %>%
    hc_legend(enabled = FALSE) %>%
    hc_tooltip(headerFormat = '<b>{series.name}</b><br>',
               pointFormat = "UserId: {point.x} <br> 花費時間: {point.y}") %>%
    hc_add_series_df(
      data = columnResult,
      x = columnResult$user_id,
      y = columnResult$WatchTime,
      group = "User",
      # color = "#F0A1EA",
      type = "scatter"
    )
  
})

output$userInfo <- renderUI({
  if(input$courseId == "" || input$userId == "" || input$userId == "option11"){
    return(NULL)
  }
  userData <- videoEventType(input$courseId, input$userId, input$videoCode)
  tagList(div(paste("看影片時間:", userData$WatchTime)),
          # div(paste("事件行為順序:", userData$EventList)),
          div(paste("取得證書:", "")),
          div(paste("影片重複次數:", "")),
          div(paste("影片完成率:", ""))
  )
})

output$columnType <- renderHighchart({
  if(input$courseId == "" || input$userId == "" || input$userId == "option11"){
    return(NULL)
  }
  typeCount <- wordCloudSum(input$courseId, input$userId, input$videoCode)
  word <- c(colnames(typeCount))
  freqCount <-
    c(
      typeCount$hide_transcript,
      typeCount$show_transcript,
      typeCount$load_video,
      typeCount$play_video,
      typeCount$pause_video,
      typeCount$stop_video,
      typeCount$seek_video,
      typeCount$speed_change
    )
  wordFreq <- data.frame(word, freqCount)
  # View(wordFreq)
  course <- filter(loadVideoData(input$courseId), CourseId == input$courseId, VideoCode == input$videoCode)
  highchart() %>%
    hc_title(text = course$DisplayName, style = list(color = "#BBB")) %>%
    hc_subtitle(text = course$VideoTitle) %>%
    hc_xAxis(title = list(text = "EventType", align = "middle"), type='category', categories = wordFreq$word) %>%
    hc_yAxis(title = list(text = "次數(count)", align = "middle")) %>%
    hc_legend(enabled = FALSE) %>%
    hc_tooltip(pointFormat = "次數: {point.y}") %>%
    hc_add_series_df(
      data = wordFreq,
      x = wordFreq$word,
      y = wordFreq$freqCount,
      group = "EventType",
      # color = "#F0A1EA",
      type = "column"
    )
  
})

output$gVizDiagram <- renderDiagrammeR({
  if (input$courseId == "" || input$userId == "" || input$userId == "option11") {
    return(NULL)
  }
  userData <- videoEventType(input$courseId, input$userId, input$videoCode)
  eventList <- gsub(",",replacement="->", userData$EventList)
  digrViz <- sprintf("
  digraph {
    %s
  }
", eventList)
  DiagrammeR::grViz(digrViz)
})

# output$wordcloud <- renderWordcloud2({
#   # print(input$userId)
#   if(input$courseId == "" || input$userId == "" || input$userId == "option11"){
#     return(NULL)
#   }
#   wordCount <- wordCloudSum(input$courseId, input$userId, input$videoCode)
#   View(wordCount)
#   word <- c(colnames(wordCount))
#   freqCount <-
#     c(
#       wordCount$hide_transcript,
#       wordCount$show_transcript,
#       wordCount$load_video,
#       wordCount$play_video,
#       wordCount$pause_video,
#       wordCount$stop_video,
#       wordCount$seek_video,
#       wordCount$speed_change
#     )
#   wordFreq <- data.frame(word, freqCount)
#   View(wordFreq)
#   wordcloud2(wordFreq, size = 1, backgroundColor = "grey", shape= "cloud")
# })