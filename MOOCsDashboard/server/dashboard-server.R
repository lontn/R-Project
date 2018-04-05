### dashboard tab

output$course_box <- renderValueBox({
  valueBox(
    paste0(300, "P"), "peopele", icon = icon("list"),
    color = "purple"
  )
})

output$case_box <- renderValueBox({
  valueBox(
    paste0(300, "P"), "peopele", icon = icon("list"),
    color = "purple"
  )
})

output$reported_box <- renderValueBox({
  valueBox(
    paste0(300, "P"), "peopele", icon = icon("list"),
    color = "yellow"
  )
})

output$lineChart <- renderHighchart({
  tableResult <- loadEventData("FCUx/2015004/201509", "vN6zidatews")
  # View(tableResult)
  highchart() %>%
    hc_title(text = "大學普通物理實驗─手作坊", style = list(color = "#BBB")) %>%
    hc_subtitle(text = "1-4-b 儀器架設") %>%
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