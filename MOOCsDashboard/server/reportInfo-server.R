output$report_title <- renderText({
  input$courseId2
})

output$report_tbl <- DT::renderDataTable({
  print(input$courseId2)
  out <- loadStudentData()
  col_headers <- htmltools::withTags(
    table(
      thead(
        tr(
          th("UserId"),
          th("VideoCode"),
          th("StartTime"),
          th("EndTime"),
          th("WatchTime"),
          th("EventList")
        )
      )
    )
  )
  
  datatable(
    out,
    rownames = FALSE,
    container = col_headers,
    extensions = "Buttons",
    options = list(
      dom = 'Brtip',
      scrollX = TRUE,
      buttons = list( 
        list(
          extend = 'collection',
          buttons = c('csv', 'excel', 'pdf'),
          text = 'Download'
        )
      )
    )
  )
})