# http://data.worldbank.org/indicator/IT.CEL.SETS.P2/
# http://www.magesblog.com/2013/02/first-steps-of-using-googlevis-on-shiny.html


library(googleVis)
library(shiny)
library(datasets)
library(dplyr)

x <- data.frame()
for(y in row.names(WorldPhones)) 
    for(r in colnames(WorldPhones)) 
        x <- rbind(x, cbind(Year=y, NumPhones=WorldPhones[y,r]*1000, Region=r))
x$Year <- as.integer(x$Year)
x$NumPhones <- as.integer(x$NumPhones)
#                          WorldPhones[,input$region]*1000, 
#                          main=input$region,
#                          ylab="Number of Telephones",
#                          xlab="Year"

# switch(input$dataset,
#        "rock" = rock,
#        "pressure" = pressure,
#        "cars" = cars)

wp <- data.frame(WorldPhones)

shinyServer(function(input, output) {
     datasetInput <- reactive({
                      select(subset(x, Region==input$region), c('Year', 'NumPhones'))
#                       main=input$region,
#                       ylab="Number of Telephones",
#                       xlab="Year"
     })
    
    output$view <- renderGvis({
        gvisScatterChart(datasetInput(), options=list(width=400, height=450))
    })
})



# # Rely on the 'WorldPhones' dataset in the datasets
# # package (which generally comes preloaded).
# library(datasets)
# 
# # Define a server for the Shiny app
# shinyServer(function(input, output) {
#     
#     # Fill in the spot we created for a plot
#     output$phonePlot <- renderPlot({
#         
#         # Render a barplot
#         barplot(WorldPhones[,input$region]*1000, 
#                 main=input$region,
#                 ylab="Number of Telephones",
#                 xlab="Year")
#     })
# })