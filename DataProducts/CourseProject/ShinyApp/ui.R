library(shiny)

# Rely on the 'WorldPhones' dataset in the datasets
#library(googleVis)
library(datasets)
library(ggvis)

# Mapping between different country codes
# http://www.nationsonline.org/oneworld/country_code_list.htm
cc <- read.csv("data/countries.csv", header=TRUE)


# Define the overall UI
shinyUI(
    
    # Use a fluid Bootstrap layout
    fluidPage(    
        
        # Give the page a title
        titlePanel("Cellphones by country and year"),
        
        # Generate a row with a sidebar
        sidebarLayout(      
            
            # Define the sidebar with one input
            sidebarPanel(
              # Simple integer interval
              sliderInput("Year", "Year:", 
                          min=1981, max=2014, value=1981, sep="",
                          step = 1, 
                          animate=animationOptions(interval=300, loop=TRUE)),
              sliderInput("PoplationRange", "Population range (x1M):",
                          min = 0, max = 1500, value = c(000,1500)),
              selectInput("FollowCountry", "Country to highlight (red):",
                          choices = c("Norway", "Sweden", "Denmark", "China", "India")),
              hr(),
              helpText("Data from worldbank.org (IT.CELL.SETS) & UN (Population both sexes).")
            ),
            
            # Create a spot for the barplot
            mainPanel(
              textOutput("debugText"),
              ggvisOutput("plot1")
            )
            
        )
    )
)
