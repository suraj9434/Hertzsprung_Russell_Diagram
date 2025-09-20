


# Interactive Hertzsprung–Russell Diagram Explorer

An interactive R Shiny dashboard for visualizing and exploring astrophysical data of nearby stars. ### [View the Live Application on shinyapps.io](https://surajshrestha.shinyapps.io/Interactive_Hertzsprung_Russell_Diagram_App/)


## Project Overview

This application provides an interactive Hertzsprung–Russell (H-R) diagram, a fundamental tool in astronomy for understanding stellar evolution. Users can explore the relationship between a star's luminosity, temperature, radius, and color. The dashboard is designed to be both educational for astronomy enthusiasts and a practical tool for data exploration.

This project demonstrates proficiency in:
*   **R Shiny App Development:** Building a complete, reactive web application from scratch.
*   **Interactive Data Visualization:** Using `ggplot2` and `plotly` to create dynamic and informative charts.
*   **Data Wrangling & Enrichment:** Preparing and cleaning data with `dplyr` to make it suitable for visualization.
*   **Dashboard UI/UX Design:** Creating an intuitive and aesthetically pleasing user interface with `shinythemes`.

## Features

*   **Interactive H-R Diagram:** A scatterplot of stars where luminosity is plotted against color index/temperature.
    *   **Rich Tooltips:** Hover over any star to see detailed information, including its name, spectral type, temperature, radius, and luminosity.
    *   **Dynamic Sizing & Coloring:** Point size corresponds to the star's radius (R☉), and color maps to its surface temperature (K).
*   **Detailed Star Information Panel:** Select a star from a dropdown list to view its complete properties and a description of its spectral class.
*   **Sortable Data Table:** Switch to the "Data Table" tab to view, search, and sort the raw data for all stars in the dataset.
*   **User-Friendly Guide:** A handy reference box in the sidebar explains the units used (R☉, L☉, K, B-V).

## Screenshot


*(A screenshot of the live application showing the interactive H-R Diagram and the star information sidebar.)*

## Technologies & Libraries

The application is built entirely in **R** and leverages the following packages:

*   **Shiny:** The core web application framework.
*   **ggplot2:** For creating the static plot layer.
*   **plotly:** For adding interactivity (hover tooltips, zoom, pan) to the ggplot.
*   **dplyr:** For data manipulation and preparation.
*   **readr:** For efficient loading of CSV data.
*   **DT:** To render beautiful and interactive data tables.
*   **shinythemes:** For applying a clean, modern "Cosmo" theme to the UI.
*   **scales:** For plot scaling utilities.

## Data Sources

The application uses two datasets, which must be present in the same directory as the `app.R` file:

1.  `near_stars.csv`: Contains the primary astrophysical parameters for a collection of nearby stars (e.g., name, temperature, luminosity, radius, color index).
2.  `star_types.csv`: A supplementary file that provides descriptive information for each major spectral class (O, B, A, F, G, K, M).

## Setup and Installation

To run this application on your local machine, follow these steps:

1.  **Prerequisites:**
    *   Ensure you have [R](https://cran.r-project.org/) and [RStudio](https://posit.co/download/rstudio-desktop/) installed.

2.  **Clone the Repository:**
    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

3.  **Install Required Packages:**
    Open R or RStudio and run the following command in the console to install all necessary libraries:
    ```r
    install.packages(c("shiny", "ggplot2", "plotly", "dplyr", "readr", "DT", "shinythemes", "scales"))
    ```

4.  **Prepare Data:**
    Make sure the `near_stars.csv` and `star_types.csv` files are located in the same folder as the `app.R` script.

5.  **Run the Application:**
    Open the `app.R` file in RStudio and click the "Run App" button in the top-right corner of the script editor. The application will launch in a new window or your default web browser.
