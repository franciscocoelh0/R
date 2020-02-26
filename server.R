

library(shiny)
library(plotly)
library(rhandsontable)

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  library(readxl)
  mydf <- read_excel("german credit card.xls")
  
  mydf$purpose <- as.numeric(gsub("x", "", mydf$purpose))
  
  mydf$good_bad <- gsub("good", "1", mydf$good_bad)
  mydf$good_bad <- gsub("bad", "0", mydf$good_bad)
  mydf$good_bad <- as.numeric(mydf$good_bad)
  mydf <<- mydf
  
  output$p <- renderPlotly({
    z <- plot_ly(mydf, x=~age, y=~amount)%>%
      layout(dragmode = "select")
    z
  })
  
  
  
  
  output$hot <- renderRHandsontable({
    DF <<- as.data.frame(event_data("plotly_selected"))
    if (!is.null(DF))
      rhandsontable(DF, stretchH = "all")
  })
  ###########################################
  ###########################################
  ##########################################
  correlation <- round(cor(mydf), 3)
  
  output$heat <- renderPlotly({
    plot_ly(source = "heat_plot") %>%
      add_heatmap(
        x = names(mydf), 
        y = names(mydf), 
        z = correlation
      )
  })
  
  output$scatterplot <- renderPlotly({
    # if there is no click data, render nothing!
    clickData <- event_data("plotly_click", source = "heat_plot")
    if (is.null(clickData)) return(NULL)
    
    # Obtain the clicked x/y variables and fit linear model
    vars <- c(clickData[["x"]], clickData[["y"]])
    d <- setNames(mydf[vars], c("x", "y"))
    yhat <- fitted(lm(y ~ x, data = d))
    

    p <- ggplot(d, aes(x=x, y=y))+
      geom_jitter(aes(color=x, width=0.25, apha=0.5))
    z<-ggplotly(p)
    z
    
  })
  
  
})
