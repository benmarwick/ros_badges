shinyUI(fluidPage(
  titlePanel("UW eScience Reproducibility Badge Survey Responses"),
  
  sidebarLayout(

    sidebarPanel(
      
      includeHTML("text.html"), 
      selectInput("nameInput", "Choose a name to see the details of their responses:", unlist(tmp[2]))
    ),
    
    
    
    mainPanel("Reproducibility Badge Score",
              tableOutput("my_table1"),
              tableOutput("my_table"),
              tableOutput("my_table2")
    )
  )
))
