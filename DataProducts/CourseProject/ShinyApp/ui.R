library(shiny)

# Rely on the 'WorldPhones' dataset in the datasets
#library(googleVis)
library(datasets)
library(ggvis)

# shinyUI(pageWithSidebar(
#     headerPanel("Example 1: scatter chart"),
#     sidebarPanel(
#         selectInput("Year", "Choose a Year:", 
#                     choices = row.names(WorldPhones))
#     ),
#     mainPanel(
#         # htmlOutput("phonePlot")
#         plotOutput("phonePlot")
#     )
# ))

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
                          min=1980, max=2014, value=1980),
#               selectInput("Year", "Year:", 
#                             choices=row.names(WorldPhones)),
                hr(),
                helpText("Data from AT&T (1961) The World's Telephones.")
            ),
            
            # Create a spot for the barplot
            mainPanel(
              textOutput("debugText"),
              ggvisOutput("plot1"),
              plotOutput("phonePlot")  
            )
            
        )
    )
)
