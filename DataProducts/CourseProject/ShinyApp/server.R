# http://www.magesblog.com/2013/02/first-steps-of-using-googlevis-on-shiny.html

library(shiny)
# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)
library(ggvis)
library(plyr)
library(dplyr)

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


# Define a server for the Shiny app
shinyServer(function(input, output) {

    countries <- reactive({
        year <- paste('X', input$Year, sep="") 
        lowPopRange <- input$PoplationRange[[1]] * 1000
        highPopRange <- input$PoplationRange[[2]] * 1000
        
        followCountry <- input$FollowCountry
              
        popidx <- match(year, names(pop))
        ypop <- select(pop, Country.Code = Country.code, popidx)
        names(ypop)[2] <- c("Population")
        ypop <- subset(ypop, !is.na(Population))
        ypop$Population <- as.numeric(gsub(" ", "", ypop$Population, fixed=TRUE)) 
        
        ypop <- subset(ypop, Population >= lowPopRange & Population <= highPopRange)
        
        output$debugText <- renderText(paste("Year: ", input$Year, 
                                           ", Population range: ", 
                                           format(lowPopRange * 1000, big.mark = ",", scientific = FALSE), 
                                           " - ", 
                                           format(highPopRange * 1000, big.mark = ",", scientific = FALSE)))
        
        # Remove whitespace from the numbers
        phmidx <- match(year, names(phm))
        yphm <- select(phm, 
                     Country.Name = Country.or.Area.Name, 
                     Country.Code=ISO.Numeric.Code.UN.M49.Numerical.Code,
                     phmidx)
        names(yphm)[3] <- "CellPhones"
        yphm <- subset(yphm, !is.na(CellPhones) & CellPhones > 0)
        # Years cellphones by population
        ycpbypop <- inner_join(ypop, yphm, by ="Country.Code")
        ycpbypop$Point.Size <- 50
        ycpbypop$Point.Color <- "blue"
        if (!empty(ycpbypop[ycpbypop$Country.Name == followCountry,])) {
            ycpbypop[ycpbypop$Country.Name == followCountry,]$Point.Size <- 150
            ycpbypop[ycpbypop$Country.Name == followCountry,]$Point.Color <- "red"
        }
        ycpbypop
    })

  country_tooltip <- function(x) { 
    if (is.null(x)) return(NULL) 
    if (is.null(x$Country.Code)) return(NULL) 
    
    # Pick out the country with this Code 
    countries <- isolate(countries())
    country <- countries[countries$Country.Code == x$Country.Code, ] 
    paste0("<b>", country$Country.Name, "</b><br>", 
           "Population: ", 
           format(country$Population * 1000, big.mark = ",", scientific = FALSE), 
           "<br>", 
           "Cellphones: ", 
           format(round(country$CellPhones * country$Population * 10), big.mark = ",", scientific = FALSE), 0) 
  } 
  
  # A reactive expression with the ggvis plot 
  vis <- reactive({ 
    countries %>% ggvis(~Population, ~CellPhones) %>% 
      layer_points(size := ~Point.Size, 
                   size.hover := 200, 
                   fill := ~Point.Color,
                   fillOpacity := 0.2, 
                   fillOpacity.hover := 0.5, 
                   key := ~Country.Code) %>%
      add_tooltip(country_tooltip, "hover") %>%
      add_axis("x", title = "Population x 1000",
               properties = axis_props(labels = list(angle = 45, align = "left"))) %>% 
      add_axis("y", title = "Cellphones per 100 people") %>% 
      set_options(width = 500, height = 500) 
  }) 
  
  vis %>% bind_shiny("plot1") 
})
