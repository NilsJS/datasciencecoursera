# http://www.magesblog.com/2013/02/first-steps-of-using-googlevis-on-shiny.html

library(shiny)
# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)

# Cell phones by country
# http://data.worldbank.org/indicator/IT.CEL.SETS.P2/
ph <- read.table("data/cellphones.csv", header=TRUE, skip = 4, sep = ',')

# Population estimates
# http://esa.un.org/unpd/wpp/DVD/
pop <- read.csv("data/population.csv", header=TRUE)
                                                                                        pop$Numerical.Country.Code <- pop$Country.Code

# Mapping between different country codes
# http://www.nationsonline.org/oneworld/country_code_list.htm
cc <- read.csv("data/countries.csv", header=TRUE)

# Define a server for the Shiny app
shinyServer(function(input, output) {
#  output$phonePlot <- reactive({input$Years})
    output$phonePlot <- renderPlot({
    barplot(WorldPhones[as.character(input$Year), ]*1000, 
            main=input$Year,
            ylab="Number of Telephones",
            xlab="Year")
  })
})
# library(googleVis)
# library(datasets)
# library(dplyr)
# 
# x <- data.frame()
# for(y in as.numeric(row.names(WorldPhones)))
#     for(r in colnames(WorldPhones)) 
#         x <- rbind(x, cbind(Year=y, NumPhones=WorldPhones[as.factor(y),r]*1000, Region=r))
#x$Year <- as.numeric(x$Year)
#x$NumPhones <- as.integer(x$NumPhones)
#                          WorldPhones[,input$region]*1000, 
#                          main=input$region,
#                          ylab="Number of Telephones",
#                          xlab="Year"

# switch(input$dataset,
#        "rock" = rock,
#        "pressure" = pressure,
#        "cars" = cars)

# shinyServer(function(input, output) {
#      datasetInput <- reactive({
#                       select(subset(x, Region==input$region), c('Year', 'NumPhones'))
# #                       main=input$region,
# #                       ylab="Number of Telephones",
# #                       xlab="Year"
#      })
#     
#     output$view <- renderGvis({
#         gvisScatterChart(datasetInput(), options=list(width=400, height=450))
#     })
# })



