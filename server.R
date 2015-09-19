library(shiny)
library(ggplot2)
library(viridis)

shinyServer(function(input, output) {
    
    output$distPlot <- renderPlot({
        
        p <- ggplot(steps, aes(x=dateTime, y=value)) + 
            geom_bar(stat="identity", aes(color=value)) +
            scale_colour_gradientn(colours= viridis(12) )
        
            #p <- ggplot(steps, aes(x=value)) + geom_histogram(binwidth=input$bins)

        print(p)
        
    }, height=700)
    
})