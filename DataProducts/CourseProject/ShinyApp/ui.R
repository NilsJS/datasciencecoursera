library(shiny)

# Rely on the 'WorldPhones' dataset in the datasets
#library(googleVis)
library(datasets)

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
        titlePanel("Telephones by region and year"),
        
        # Generate a row with a sidebar
        sidebarLayout(      
            
            # Define the sidebar with one input
            sidebarPanel(
              # Simple integer interval
#               sliderInput("Year", "Year:", 
#                           min=1951, max=1961, value=1958),
              selectInput("Year", "Year:", 
                            choices=row.names(WorldPhones)),
                hr(),
                helpText("Data from AT&T (1961) The World's Telephones.")
            ),
            
            # Create a spot for the barplot
            mainPanel(
                plotOutput("phonePlot")  
            )
            
        )
    )
)
