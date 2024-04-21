library(shiny)
library(bslib)

# Define UI for application
ui <- navbarPage(
  # Application title
  title = "Property Visualizer",
  tags$head(
    tags$style(
      HTML("
        .navbar-default {
          background-color: #8B0000; /* Dark red */
          border-color: #8B0000;
        }
        .navbar-default .navbar-brand {
          color: white; /* Set brand text color to white */
        }
        .navbar-default .navbar-nav > .active > a,
        .navbar-default .navbar-nav > .active > a:hover,
        .navbar-default .navbar-nav > .active > a:focus {
          background-color: #CD5C5C; /* Slightly lighter red */
        }
        .navbar-default .nav > li > a {
          color: white; /* Set tab text color to white */
        }
      ")
    )
  ),
  # Custom CSS to change navigation bar color
  tags$head(
    tags$style(
      HTML("
        .navbar-default {
          background-color: #8B0000; /* Dark red */
          border-color: #8B0000;
        }
        .navbar-default .navbar-nav > .active > a,
        .navbar-default .navbar-nav > .active > a:hover,
        .navbar-default .navbar-nav > .active > a:focus {
          background-color: #CD5C5C; /* Slightly lighter red */
        }
      ")
    )
  ),
  # Tab 1: First tab content
  tabPanel("Home",
           fluidRow(
             column(6, h4("Try out our app to learn more about properties in singapore")),
             img(src = "DBAproj.png", width = 800),
             column(6, h4("Filter by your preferences and Click on the unit to learn more! Go to the buyers tab to try it out")),
           )
  ),
  # Tab 2: Second tab content
  tabPanel("Buyers",
           sidebarLayout(
             sidebarPanel(
               checkboxGroupInput("Type", "Type",
                                  choices = c("Apartment & Condo", "Landed","Public Housing")),
               checkboxGroupInput("Location", "Location",
                                  choices = c("North", "South", "East", "West","Central")),
               sliderInput("slider", "Price Range:",
                           min = 0, max = 10000000, value = c(0, 5000000)),
               selectInput("pets", "Pet Friendly",
                           choices = c("Im not realy Bothered","Yes I love animals", "No I dont like animals"))
               ,plotOutput("other_plot") # Add this line to include the plot
             ),
             mainPanel(
               leafletOutput("PointPlot")
             )
             
           )
  ),
  # Tab 3: Third tab content
  tabPanel("Overview",
           sidebarLayout(
             sidebarPanel(
               selectInput("dropdown", "Dropdown Menu:",
                           choices = c("Resale Price", "PSM")), # Removed "Area (SQM)"
               radioButtons("housing_type2", "House Type:",
                            choices = c("Apartment & Condo", "Landed","Public Housing")),
               dateInput("Heatmapstart_date", "Start Date:", value = "2022-01"),
               dateInput("Heatmapend_date", "End Date:", value = "2023-12")
             ),
             mainPanel(
               leafletOutput("heatmap"),  # Add leafletOutput for map
               #verbatimTextOutput("HeatmapOutput")
             )
           )
  ),
  # Tab 4: Fourth tab content
  tabPanel("Time Based Analysis",
           sidebarLayout(
             sidebarPanel(
               radioButtons("housing_type", "House Type:",
                            choices = c("Apartment & Condo", "Landed","Public Housing")),
               radioButtons("market_segment", "Market Segment:",
                            choices = c("Core Central Region", "Downtown Core",
                                        "Outside Central Region", "Rest of Central Region")), 
               dateInput("start_date", "Start Date:", value = "2022-01"),
               dateInput("end_date", "End Date:", value = "2023-12")
             ),
             mainPanel(
               plotOutput("TSeriesPlot")
               #,verbatimTextOutput("TSeriesOutput")
             )
           )
  )
)
