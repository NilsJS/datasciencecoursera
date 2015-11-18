# http://www.magesblog.com/2013/02/first-steps-of-using-googlevis-on-shiny.html

library(shiny)
# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)
library(ggvis)

# Mapping between different country codes
# http://www.nationsonline.org/oneworld/country_code_list.htm
cc <- read.csv("data/countries.csv", header=TRUE)

# Cell phones by country
# http://data.worldbank.org/indicator/IT.CEL.SETS.P2/
ph <- read.table("data/cellphones.csv", header=TRUE, skip = 4, sep = ',')
ph$ISO.ALPHA.3.Code <- ph$Country.Code

phm <- merge(ph, cc, by.x = "Country.Code", by.y = "ISO.ALPHA.3.Code")

# Population estimates
# http://esa.un.org/unpd/wpp/DVD/
pop <- read.csv("data/population.csv", header=TRUE)


ypop <- select(subset(pop, !is.na(X1981)), 
               Country.Code = Country.code, 
               Population = X1981)
ypop$Population <- as.numeric(gsub(" ", "", ypop$Population, fixed=TRUE)) # Remove whitespace from the numbers
yphm <- subset(select(phm, 
                      Country.Name = Country.or.Area.Name, 
                      Country.Code=ISO.Numeric.Code.UN.M49.Numerical.Code,
                      CellPhones = X1981),
               !is.na(CellPhones) & CellPhones > 0)
# Years cellphones by population
ycpbypop <- inner_join(ypop, yphm, by ="Country.Code")


country_tooltip <- function(x) { 
    if (is.null(x)) return(NULL) 
    if (is.null(x$Country.Code)) return(NULL) 

    paste0("<b>", x$Country.Code, "</b>") 
    
    # Pick out the country with this Code 
#    country <- ycpbypop[ycpbypop$Country.Code == x$Country.Code, ] 
    
#     paste0("<b>", country$Country.Name, "</b><br>", 
#            "Population: ", country$Population * 1000, "<br>", 
#            "Cellphones: ", country$Cellphones * country$Population * 10) 
} 


ycpbypop %>% ggvis(~Population, ~CellPhones) %>% 
    layer_points(size := 50, size.hover := 200, fillOpacity := 0.2, fillOpacity.hover := 0.5, key := ~Country.Code) %>%
    add_tooltip(country_tooltip, "hover")

#                  stroke = ~has_oscar, key := ~ID) %>% 
#     add_axis("x", title = xvar_name) %>% 
#     add_axis("y", title = yvar_name) %>% 
#     add_legend("stroke", title = "Won Oscar", values = c("Yes", "No")) %>% 
#     scale_nominal("stroke", domain = c("Yes", "No"), 
#                   range = c("orange", "#aaa")) %>% 
#     set_options(width = 500, height = 500) 
# }) 


# Example of inner join
# Join tables, filtering out those with <10 reviews, and select specified columns 
#  all_movies <- inner_join(omdb, tomatoes, by = "ID") %>% 
#      filter(Reviews >= 10) %>% 
#      select(ID, imdbID, Title, Year, Rating_m = Rating.x, Runtime, Genre, Released, 
#                    Director, Writer, imdbRating, imdbVotes, Language, Country, Oscars, 
#                    Rating = Rating.y, Meter, Reviews, Fresh, Rotten, userMeter, userRating, userReviews, 
#                    BoxOffice, Production) 


# Define a server for the Shiny app
shinyServer(function(input, output) {
#  output$phonePlot <- reactive({input$Years})
  variables <- reactiveValues(year = 0)
  inputYear <-reactive({
      variables$year <- paste('x', input$Year) 
  })
  datasetInput <- reactive({
#    year <- paste('x', input$Year) 
    select(subset(phm, !is.na(year), c('Country.or.Area.Name', year)))
  #                       main=input$region,
  #                       ylab="Number of Telephones",
  #                       xlab="Year"
  })
                
  output$debugText <- renderText(paste("Year: ", inputYear()))
  
  # Function for generating tooltip text 
  country_tooltip <- function(x) { 
     if (is.null(x)) return(NULL) 
     if (is.null(x$ID)) return(NULL) 
  
     # Pick out the country with this ID 
     all_movies <- isolate(movies()) 
     movie <- all_movies[all_movies$ID == x$ID, ] 
  
     paste0("<b>", movie$Title, "</b><br>", 
                     movie$Year, "<br>", 
                     "$", format(movie$BoxOffice, big.mark = ",", scientific = FALSE) 
                   ) 
   } 

  
  
  # A reactive expression with the ggvis plot 
  vis <- reactive({ 
     # Lables for axes 
     xvar_name <- names(axis_vars)[axis_vars == input$xvar] 
     yvar_name <- names(axis_vars)[axis_vars == input$yvar] 
    
     # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews), 
     # but since the inputs are strings, we need to do a little more work. 
     xvar <- prop("x", as.symbol(input$xvar)) 
     yvar <- prop("y", as.symbol(input$yvar)) 
     
    
     movies %>% 
         ggvis(x = xvar, y = yvar) %>% 
         layer_points(size := 50, size.hover := 200, 
                                 fillOpacity := 0.2, fillOpacity.hover := 0.5, 
                                 stroke = ~has_oscar, key := ~ID) %>% 
         add_tooltip(movie_tooltip, "hover") %>% 
         add_axis("x", title = xvar_name) %>% 
         add_axis("y", title = yvar_name) %>% 
         add_legend("stroke", title = "Won Oscar", values = c("Yes", "No")) %>% 
         scale_nominal("stroke", domain = c("Yes", "No"), 
                                 range = c("orange", "#aaa")) %>% 
         set_options(width = 500, height = 500) 
   }) 
  
  
  vis %>% bind_shiny("plot1") 
  
  
#     output$phonePlot <- renderPlot({
#     barplot(datasetInput(), 
#             main=input$Year,
#             ylab="Number of Cellphones",
#             xlab="Year")
#   })
#     output$phonePlot <- renderPlot({
#       barplot(ph[paste('x', as.character(input$Year)), ]*1000, 
#               main=input$Year,
#               ylab="Number of Cellphones",
#               xlab="Year")
#     })
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



