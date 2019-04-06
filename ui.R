################################################################################################
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# R Shiny Dashboard for ALY6070 20919 Communication and Visualization for Data Analytics
# Last Revision: 04/06/2019
#
# Author:
# Lee Ping Tay - joylp.tay@gmail.com
#
# Description:
# This script is used to create user-interface definition for an interactive R Shiny Dashboards 
# on Scratch Dataset.
#
# The dataset contains user activity data from 2007 to 2012 on Scratch website which is created
# by the MIT Media Lab (https://scratch.mit.edu/about)
#
# Contents: 
# Libraries and Environment
# Data Import and Preprocessing
# User-interface definition of the Shiny web application
#
################################################################################################
# User-interface for R shiny application
################################################################################################

# Define User-interface definition for the Shiny web application.
ui <- dashboardPage(
      dashboardHeader(title = "Scratch Data Dashboard",
                      titleWidth = 250),
  
  ## Sidebar content  
  dashboardSidebar(width =  250,
    
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("bar-chart-o")),
      menuItem("Projects Viewed by Is Remixed", tabName = "isremixed", icon = icon("bar-chart-o")),
      menuItem("Distribution Histogram", tabName = "dashboard", icon = icon("dashboard")),       
      menuSubItem("Projects Viewed Histogram", tabName = "dashboard1"),
      menuSubItem("Projects Loved Histogram", tabName = "dashboard2"), 
      menuSubItem("Projects Downloaded Histogram", tabName = "dashboard3"),
      menuItem("Correlation Scatter Plots", tabName = "scatter", icon = icon("list-alt")),
      menuItem("Correlation Line Charts", tabName = "line", icon=icon("list-alt"))
    ) # end of sidebarMenu
  ),  # end of dashboardSidebar
  
  ## Body content
  dashboardBody(
    tabItems(
      
      # First tab content
      tabItem(tabName = "overview",
              h3("Projects Viewed increased over time followed by a sharp decline in 2012"),
              br(),
              mainPanel(
                plotOutput("bargraph", width =800)
              )  # end of mainPanel
      ),   
      
      # Second tab content
      tabItem(tabName = "isremixed",
              h3("Projects Viewed which were not remixed was almost double in 2012"),
              br(),
              mainPanel(
                plotOutput("bargraph2", width =800)
              )  # end of mainPanel
      ),  
      
      # Third tab content
      tabItem(tabName = "dashboard"),
      
      # Fourth tab content
      tabItem(tabName = "dashboard1",
              h1("Distribution of Projects Viewed"),
              
              # Boxes need to be put in a row (or column)
              fluidRow(box(width = 4,
                       title = "Controls",
                       sliderInput("bins", "Number of observations:", 1, 100, 50)
                ),
                
                box(width = 6,
                    plotOutput("histogram1"))
                )            
        ),    
      
      
      # Fifth tab content
      tabItem(tabName = "dashboard2",
              h1("Distribution of Projects Loved"),
              
              # Boxes need to be put in a row (or column)
              fluidRow(box(width = 4,
                       title = "Controls",
                       sliderInput("bins2", "Number of observations:", 1, 100, 50)
                ),
                
                box(width =6,
                    plotOutput("histogram2"))
                )
        ),    
      
      
      # Sixth tab content
      tabItem(tabName = "dashboard3",
              h1("Distribution of Projects Downloaded"),
             
              # Boxes need to be put in a row (or column)
              fluidRow(box(width = 4,
                       title = "Controls",
                       sliderInput("bins3", "Number of observations:", 1, 100, 50)
                ),
                
                box(width =6,
                    plotOutput("histogram3"))
                )
       ),    
      
      
      # Seventh tab content
      tabItem(tabName = "scatter",
              h1("Correlation Scatter Plots"),
              
              # Dropdown menu for selecting variable from sracth data.
              selectInput("var",
                          label = "Select X Axis Variable",
                          choices = c("viewers_website" = 2,
                                      "lovers_website"  = 3,
                                      "downloaders_website" = 4,
                                      "sprites_website"  = 5,
                                      "scripts_website"  = 6),
                          selected = 2),  # Default selection
              selectInput("var2",
                          label = "Select Y Axis Variable",
                          choices = c("viewers_website" = 2,
                                      "lovers_website"  = 3,
                                      "downloaders_website" = 4,
                                      "sprites_website"  = 5,
                                      "scripts_website"  = 6),
                          selected = 3), # Default selection
              
              mainPanel(
                plotOutput("ScratchPlot", height = 300)  
              )
       ),
      
      # Eighth tab content
      tabItem(tabName = "line",
              h1("Correlation Line Charts"),
              # Dropdown menu for selecting variable from sracth data.
              selectInput("var_1",
                          label = "Select X Axis Variable",
                          choices = c("viewers_website" = 2,
                                      "lovers_website"  = 3,
                                      "downloaders_website" = 4,
                                      "sprites_website"  = 5,
                                      "scripts_website"  = 6),
                          selected = 2),  # Default selection
              selectInput("var_2",
                          label = "Select Y Axis Variable",
                          choices = c("viewers_website" = 2,
                                      "lovers_website"  = 3,
                                      "downloaders_website" = 4,
                                      "sprites_website"  = 5,
                                      "scripts_website"  = 6),
                          selected = 4),  # Default selection
              
              mainPanel(plotOutput("ScratchLinePlot", height = 300)  
              )
        )
      
    ),   # end of tabItems
    
    
    tags$head(tags$style(HTML('
                              /* logo */
                              .skin-blue .main-header .logo {
                              #  background-color: #f4b943;
                              background-color: purple;
                              }
                              
                              /* logo when hovered */
                              .skin-blue .main-header .logo:hover {
                              background-color: #f4b943;
                              }
                              
                              /* navbar (rest of the header) */
                              .skin-blue .main-header .navbar {
                              background-color: purple;
                              }        
                              
                              /* main sidebar */
                              .skin-blue .main-sidebar {
                              background-color: #cccccc;
                              }
                              
                              /* active selected tab in the sidebarmenu */
                              .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                              background-color: #ff69b4;
                              }
                              
                              /* other links in the sidebarmenu */
                              .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                              background-color: #c6e2ff;
                              color: #000000;
                              }
                              
                              /* other links in the sidebarmenu when hovered */
                              .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                              background-color: #ff69b4;
                              }
                              /* toggle button when hovered  */                    
                              .skin-blue .main-header .navbar .sidebar-toggle:hover{
                              background-color: #ff69b4;
                              }
                              ')))
    
  )   # end of dashboardBody
)    # end of dashboardPage
