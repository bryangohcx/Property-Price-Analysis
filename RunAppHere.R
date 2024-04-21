library(shiny)
library(leaflet)
library(ggplot2)
library(dplyr)
library(tidyr)
library(leaflet.extras)

shinyApp(ui = source("ui.R")$value, server = source("server.R")$value)