


######################

shinyServer(function(input, output) {
  

  
# output table of score per criterion
  
  output$my_table <- renderTable({ 
    sanitize.text.function = function(x){x}
    numConv <- reactive({as.numeric( which(unlist(tmp[2]) ==  input$nameInput ))})
    n <- numConv()
    # get all responses from person n
    person <- lapply(tmp, function(i) unlist(i[n]))
    person_ <- person[-c(1:2)]
    scr_c <- scr_c_f(person_, n)
    # score for each criterion
    scr_df <- data.frame(criteria = scores$Criterion, 
                         score = scr_c[1:24])
    scr_df
  })

# output table of person's name and total score
  output$my_table1 <- renderTable({ 
    
    numConv <- reactive({as.numeric( which(unlist(tmp[2]) ==  input$nameInput ))})
    n <- numConv()
    person <- lapply(tmp, function(i) unlist(i[n]))
    person_ <- person[-c(1:2)]

    scr_c <- scr_c_f(person_, n)
    scr_df <- data.frame(criteria = scores$Criterion, 
                         score = scr_c[1:24])
    sums <- sum(scr_c[1:24], na.rm = TRUE)
    badge = ifelse(sums >= 50, "Gold", 
                   ifelse(sums %in% 25:49, "Silver",   "Bronze"))
    
    badge_col = ifelse(sums >= 50, "yellow", 
                   ifelse(sums %in% 25:49, "lightgrey",   "yellowgreen"))
    
    badge_img <- paste0('<a href=\"http://htmlpreview.github.io/?https://github.com/sr320/tmp-badge/blob/master/rros-badge-web.html\"> <img src=\"https://img.shields.io/badge/RROS%20Badge-',sums,'-',badge_col,'.svg\" alt=\"ROS Badge\"></a>')
    
    
    my_table1 <- data.frame(person = input$nameInput,
                            total_score = sums,
                            rank = badge, 
                            badge = badge_img )
    my_table1
  }, sanitize.text.function = function(x){x})
  
# output table of specific responses to each criterion
  output$my_table2 <- renderTable({ 
    
    numConv <- reactive({as.numeric( which(unlist(tmp[2]) ==  input$nameInput ))})
    n <- numConv()
    # get response detail for specific person
    person <- lapply(tmp, function(i) unlist(i[n]))
    # make links clickable
    responses <- sapply(person, function(i) paste0(i, collapse = ", "))[1:26]
    for(i in seq_along(responses)){
      # if there is http, do this loop, otherwise skip it
      if(grepl("http", responses[i])){
      # string to vector
      tmp1 <- unlist(strsplit(responses[i], split = ", | "))
      # remove empty elements
      tmp2 <- tmp1[!tmp1 == ""]
      # get urls only, in case there are non-url entries
      tmp3 <- tmp2[grepl('http.*', tmp2)]
      # wrap with html
      my_links <- vector()
      for(j in seq_along(tmp3)){
        my_links[j] <- paste0("<a href='",tmp3[j],"'>",tmp3[j],"</a>")
      }
      responses[i] <- paste0(my_links, collapse = ", ")
      print(i)
      }
      else
      # what to do if the row has no http in it...
      {
      responses[i] <- responses[i] 
      print(i)
      }
    }
    
    # make into a table
    data.frame(prompt = c("date", "name", scores$Criterion[1:24]),
      responses = responses)
    
    
  }, sanitize.text.function = function(x){x})
  
  
})
