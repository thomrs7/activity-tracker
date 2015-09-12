library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
    
    output$distPlot <- renderPlot({
        
        p <-ggplot(steps, aes(x=value)) + geom_histogram(binwidth=90)

        print(p)
        
    }, height=700)
    
})