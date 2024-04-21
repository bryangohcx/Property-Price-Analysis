library(shiny)
library(leaflet)
library(ggplot2)
library(dplyr)
library(tidyr)
library(leaflet.extras)

# Read data from the CSV file
Sample_Data <- read.csv("./Property Price Data/sample.csv", stringsAsFactors = FALSE)
Final_Data <- read.csv("./Property Price Data/Final_Dataset.csv", stringsAsFactors = FALSE)

# Define server logic for the Shiny app
shinyServer(function(input, output, session) {
  #convert to datetime
  Final_Data$Sale.Month <- as.Date(paste(Final_Data$Sale.Month,sep = "-"))
  Final_Data$Property.Type <- as.character(Final_Data$Property.Type)
  # Points Filter
  PointFiltered <- reactive({
    locations <- input$Location
    type <- input$Type
    price_range <- input$slider
    
    # Filter by price range
    filtered <- Sample_Data[Sample_Data$Resale.Price >= price_range[1] & Sample_Data$Resale.Price <= price_range[2], ]
    
    # Filter by locations
    if (is.null(locations) || length(locations) == 0) {
      filtered1 <- filtered
    } else {
      filtered1 <- filtered[filtered$location %in% locations, ]
    }
    
    # Filter by property types
    if (is.null(type) || length(type) == 0) {
      return(filtered1)  # Return filtered1 if no property type selected
    } else {
      return(filtered1[filtered1$Type.of.Housing %in% type, ])
    }
  })
  
  # Heatmap Filter
  HeatmapFiltered <- reactive({
    Final_Data %>%
      filter(`Type.of.Housing` == input$housing_type2,
             Sale.Month >= input$Heatmapstart_date,
             Sale.Month <= input$Heatmapend_date)
  })
  
  # TSeries Reactive Filter
  TSeriesFiltered <- reactive({
    Final_Data %>%
      filter(`Type.of.Housing` == input$housing_type,
             `Market.Segment` == input$market_segment,
             Sale.Month >= input$start_date,
             Sale.Month <= input$end_date)
  })
  
  # Point Output
  output$PointPlot <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(data = PointFiltered(), lng = ~lon, lat = ~lat, popup = ~paste("Property:" , Project.Name, "<br>",
                                                                                "Resale Price: $", Resale.Price, "<br>",
                                                                                "Property Type: ", Property.Type, "<br>",
                                                                                "<a href='#' id='learnmore'>Learn More!</a>"))
  })
  
  # Heatmap Output
  output$heatmap <- renderLeaflet({
    data <- HeatmapFiltered()
    focus <- switch(input$dropdown,
                    "Resale Price" = log(data$Resale.Price),
                    "PSM" = log(data$Unit.Price.in.PSM))
    leaflet(data) %>%
      addTiles() %>%
      addHeatmap(lng = ~lon, lat = ~lat, intensity = focus, radius = 10)
  })
  
  # TSeries Output
  output$TSeriesPlot <- renderPlot({
    ggplot(TSeriesFiltered(), aes(x = Sale.Month, y = Resale.Price)) +
      geom_line(stat = "summary", fun = "mean") +
      scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m") +
      scale_y_continuous(labels = scales::comma) +
      labs(title = "Average Resale Price Time Series",
           x = "Date", y = "Average Resale Price") +
      theme_minimal(base_size = 16) +  # Increase base font size
      theme(axis.title = element_text(size = 20, margin = margin(t = 20, r = 0, b = 20, l = 0)),  # Increase axis title font size and adjust spacing
            output$TSeriesPlot <- renderPlot({
    ggplot(TSeriesFiltered(), aes(x = Sale.Month, y = Resale.Price)) +
      geom_line(stat = "summary", fun = "mean") +
      scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m") +
      scale_y_continuous(labels = scales::comma) +
      labs(title = "Average Resale Price Time Series",
           x = "Date", y = "Average Resale Price") +
      theme_minimal(base_size = 16) +  # Increase base font size
      theme(axis.title = element_text(size = 20, margin = margin(t = 20, r = 0, b = 20, l = 0)),  # Increase axis title font size and adjust spacing
            axis.text.x = element_text(size = 18, angle = 45, vjust = 1, hjust = 1),
            plot.title = element_text(size = 24, margin = margin(t = 20, r = 0, b = 20, l = 0)))  # Increase plot title font size and adjust spacing
  }),
            plot.title = element_text(size = 24, margin = margin(t = 20, r = 0, b = 20, l = 0)))  # Increase plot title font size and adjust spacing
  })
  
  #printchecks
  output$HeatmapOutput <- renderPrint({
    HeatmapFiltered()
    })
  
  output$TSeriesOutput <- renderPrint({
    TSeriesFiltered()
  })
})
