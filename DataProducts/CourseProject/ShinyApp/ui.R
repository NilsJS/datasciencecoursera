library(shiny)

# Rely on the 'WorldPhones' dataset in the datasets
library(googleVis)
library(datasets)

shinyUI(pageWithSidebar(
    headerPanel("Example 1: scatter chart"),
    sidebarPanel(
        selectInput("region", "Choose a region:", 
                    choices = colnames(WorldPhones))
    ),
    mainPanel(
        htmlOutput("view")
    )
))

# Define the overall UI
# shinyUI(
#     
#     # Use a fluid Bootstrap layout
#     fluidPage(    
#         
#         # Give the page a title
#         titlePanel("Telephones by region"),
#         
#         # Generate a row with a sidebar
#         sidebarLayout(      
#             
#             # Define the sidebar with one input
#             sidebarPanel(
#                 selectInput("region", "Region:", 
#                             choices=colnames(WorldPhones)),
#                 hr(),
#                 helpText("Data from AT&T (1961) The World's Telephones.")
#             ),
#             
#             # Create a spot for the barplot
#             mainPanel(
#                 plotOutput("phonePlot")  
#             )
#             
#         )
#     )
# )
