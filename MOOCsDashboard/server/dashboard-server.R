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