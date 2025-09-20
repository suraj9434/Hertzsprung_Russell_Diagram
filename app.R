###########################################################
# Interactive Shiny Dashboard:
# Hertzsprung–Russell Diagram Explorer

# Purpose: Visualize nearby stars using astrophysical 
#          parameters and enable interactive exploration.

# Skills Demonstrated:
#   • R Shiny app development
#   • Interactive data visualization (ggplot2 + plotly)
#   • Data wrangling & enrichment (dplyr)
#   • Dashboard UI/UX design
###########################################################

# ----------------------------
# Load Required Libraries
# ----------------------------
library(readr)        # For reading CSV data
library(shiny)        # Shiny framework for interactive apps
library(ggplot2)      # Base visualization layer
library(plotly)       # Interactivity on top of ggplot
library(dplyr)        # Data wrangling
library(scales)       # Scaling utilities
library(shinythemes)  # Pre-built UI themes
library(DT)           # Interactive data tables

# ----------------------------
# Load & Prepare Data
# ----------------------------
# Dataset: 
#   - near_stars.csv: stellar parameters
#   - star_types.csv: descriptions of spectral classes

# Data cleaning:
#   - Extract spectral class initials
#   - Join descriptive metadata
#   - Compute log luminosity (base 10)
#   - Create custom labels for interactive tooltips
# ----------------------------

near_stars <- read_csv("near_stars.csv")
star_types <- read_csv("star_types.csv")

# Extract initial spectral type & join with descriptions
near_stars <- near_stars %>%
  mutate(spect_initial = substr(spect_type, 1, 1)) %>%  
  left_join(star_types, by = c("spect_initial" = "Type")) %>%
  mutate(
    log_L = log10(L),
    name_label = paste0(
      "Name: ", name, "<br>",
      "Alt: ", alt_name, "<br>",
      "Spectral Type: ", spect_type, "<br>",
      "Temp: ", round(temp, 2), " K<br>",
      "Radius: ", round(R, 2), " R☉<br>",
      "Log Luminosity: ", round(log_L, 2), " L☉<br>",
      "Color Index (B–V): ", round(bv_color, 2)
    )
  )

# ----------------------------
# User Interface (UI)
# ----------------------------
# Layout:
#   - Sidebar: star selector, star details, units guide
#   - Main panel: tabbed view with H-R Diagram + data table

# Design choices:
#   - Cosmo theme (modern + clean)
#   - Centered title for professional look
#   - Clear hover instructions
# ----------------------------

ui <- fluidPage(
  theme = shinytheme("cosmo"),
  
  # Centered title
  div(
    h1("Hertzsprung–Russell Diagram App", 
       style = "text-align: center; font-weight: bold; margin-bottom: 20px;")
  ),
  
  sidebarLayout(
    sidebarPanel(
      h3("🔭 Star Information"),
      selectInput("selected_star", "Select a Star:", choices = sort(near_stars$name)),
      hr(),
      uiOutput("star_info"),
      br(),
      
      # Units guide box for user clarity
      div(
        style = "background-color:#f9f9f9; padding:8px; border-radius:5px; font-size:13px;",
        HTML("<strong>Units & Guide:</strong><br>
              • Radius (R☉): Sun’s radius (≈ 695,700 km)<br>
              • Luminosity (L☉): Sun’s brightness (log scale)<br>
              • Temp (K): surface temperature<br>
              • Color Index (B–V): blue → red")
      )
    ),
    
    mainPanel(
      tabsetPanel(
        # H-R Diagram visualization
        tabPanel("H-R Diagram",
                 plotlyOutput("hr_plot", height = "580px"),
                 br(),
                 div(
                   style = "text-align: center; font-size: 16px; font-weight: bold; color: #0073e6;",
                   "ℹ️ Hover over points for details: Size = Radius, Color = Temperature"
                 )
        ),
        
        # Raw data exploration table
        tabPanel("Data Table",
                 DT::dataTableOutput("star_table"))
      )
    )
  )
)

# ----------------------------
# Server Logic
# ----------------------------
# Features:
#   - Dynamic star information panel
#   - Interactive scatterplot (log luminosity vs. color index)
#   - Rich tooltips with astrophysical details
#   - Filterable, sortable data table
# ----------------------------
server <- function(input, output, session) {
  
  # Reactive filter: currently selected star
  selected_star_data <- reactive({
    near_stars %>% filter(name == input$selected_star) %>% slice(1)
  })
  
  # H-R diagram (scatterplot)
  output$hr_plot <- renderPlotly({
    p <- ggplot(near_stars, aes(x = bv_color, y = log_L)) +
      geom_point(aes(size = R, color = temp, text = name_label), alpha = 0.75) +
      scale_color_gradientn(
        colors = c("blue", "green", "yellow", "orange", "red"),
        limits = c(min(near_stars$temp, na.rm = TRUE),
                   max(near_stars$temp, na.rm = TRUE))
      ) +
      theme_minimal(base_family = "Arial") +
      theme(
        plot.background = element_rect(fill = "black"),
        panel.background = element_rect(fill = "black"),
        text = element_text(color = "white"),
        axis.title = element_text(size = 12, color = "white"),
        axis.text = element_text(color = "white"),
        plot.title = element_text(size = 16, face = "bold", color = "white")
      ) +
      labs(
        title = "Hertzsprung–Russell Diagram",
        x = "Color Index (B–V)",
        y = "Log Luminosity (L☉)",
        color = "Temperature (K)",
        size = "Radius (R☉)"
      )
    
    ggplotly(p, tooltip = "text")
  })
  
  # Dynamic star information panel
  output$star_info <- renderUI({
    s <- selected_star_data()
    tagList(
      HTML(paste("<strong>Name:</strong>", s$name)),
      HTML(paste("<br><strong>Alt Name:</strong>", s$alt_name)),
      HTML(paste("<br><strong>Spectral Type:</strong>", s$spect_type)),
      HTML(paste("<br><strong>Temperature:</strong>", round(s$temp, 2), " K")),
      HTML(paste("<br><strong>Radius:</strong>", round(s$R, 2), " R☉")),
      HTML(paste("<br><strong>Log Luminosity:</strong>", round(s$log_L, 2), " L☉")),
      HTML(paste("<br><strong>Color Index (B–V):</strong>", round(s$bv_color, 2))),
      HTML(paste("<br><strong>Type Info:</strong>", s$Description))
    )
  })
  
  # Interactive data table
  output$star_table <- DT::renderDataTable({
    near_stars %>%
      select(name, alt_name, spect_type, temp, R, log_L, bv_color) %>%
      mutate(
        temp = round(temp, 2),
        R = round(R, 2),
        log_L = round(log_L, 2),
        bv_color = round(bv_color, 2)
      ) %>%
      arrange(desc(log_L))
  })
}

# ----------------------------
# Run App
# ----------------------------
shinyApp(ui = ui, server = server)
