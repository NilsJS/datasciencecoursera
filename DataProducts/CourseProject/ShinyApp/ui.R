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
                          choices = as.character(cc$Country.or.Area.Name),
                          selected = "Norway"),
              hr(),
              helpText("Data from worldbank.org (IT.CELL.SETS) & UN (Population both sexes).")
            ),
            
            # Create a spot for the barplot
            mainPanel(
              textOutput("debugText"),
              ggvisOutput("plot1"),
              p("Use the Year slider in the left panel to indicate the year to display (or simply press the animation button)."),
              p("The Population range slider allows you to focus on countries of a certain population level."),
              p("Selecting a country to highlight will mark the relevant country with a red dot if found in the set for the given year."),
              p("A mouse-over tooltip will provide information on total population and total number of cellphones for each country.")
            )
            
        )
    )
)
