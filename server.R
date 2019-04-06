################################################################################################
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# R Shiny Dashboard for ALY6070 20919 Communication and Visualization for Data Analytics
# Last Revision: 04/06/2019
#
# Author:
# Lee Ping Tay - joylp.tay@gmail.com
#
# Description:
# This script is used to create server logic for an interactive R Shiny Dashboard on Scratch 
# Dataset.
#
# The dataset contains user activity data from 2007 to 2012 on Scratch website which is created
# designed by the MIT Media Lab (https://scratch.mit.edu/about)
#
# Contents: 
# Libraries and Environment
# Data Import and Preprocessing
# R Shiny Dashboards
#
################################################################################################
# Libraries and Environment
################################################################################################

library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(tidyr)


################################################################################################
# Data Import and Pre-processing
################################################################################################

# Import csv file
df_view <-  read.csv("Group One_251-300 Views.csv")


# Filter data on df_view, change column Year to yyyy format and save as df_view1
df_view1 <- df_view %>% 
  select(date_created, viewers_website, lovers_website, downloaders_website,
         scripts_website, sprites_website) %>%
  na.omit() %>%
  dplyr::rename("Year" = date_created) %>%
  mutate(Year = format(as.Date(Year, format="%m/%d/%Y"),"%Y"))


# Filter data on df_view, rename all columns, and change column Year to yyyy format
df_view2 <- df_view %>% 
  select(date_created, viewers_website, lovers_website, downloaders_website,
         scripts_website, sprites_website) %>%
  na.omit() %>%
  dplyr::rename("Year" = date_created,
                "Viewed" = viewers_website,
                "Loved" = lovers_website,
                "Downloaded" = downloaders_website,
                "Scripts" = scripts_website,
                "Sprites" = sprites_website ) %>%
  mutate(Year = format(as.Date(Year, format="%m/%d/%Y"),"%Y"))

dim(df_view2) # 4276    6

# Check for missing data on df_view2
colSums(is.na(df_view2))


# Calculate total number of views by year for Viewed, Loved, Downloaded, Scripts, and 
# Sprites columns
agg1 <- aggregate(Viewed~Year, df_view2, sum)
agg2 <- aggregate(Loved~Year, df_view2, sum)
agg3 <- aggregate(Downloaded~Year, df_view2, sum)
agg4 <- aggregate(Scripts~Year, df_view2, sum)
agg5 <- aggregate(Sprites~Year, df_view2, sum)


# Merge total number of views by year
agg <- merge(agg1, agg2, by = "Year")
agg <- merge(agg, agg3, by = "Year")
agg <- merge(agg, agg4, by = "Year")
agg <- merge(agg, agg5, by = "Year")
agg


# Convert data on total number of views from wide to long format and save as df_view3
df_view3 <- gather(agg, variable, value, -Year)


# Filter data on Viewed and Is_Remixed, renamed all columns and change column Year to yyyy format
df_view5 <- df_view %>% 
  select(date_created, viewers_website, is_remixed) %>%
  dplyr::rename("Year" = date_created,
                "Viewed" = viewers_website,
                "Is_Remixed" = is_remixed) %>%
  mutate(Year = format(as.Date(Year, format="%m/%d/%Y"),"%Y"))


# Group data by Is_Remixed (True/False) and total number of views
df_view6 <- df_view5 %>% 
  tbl_df() %>% 
  group_by(Year, Is_Remixed) %>% 
  summarise(Projects_Viewed=sum(Viewed)) 


################################################################################################
# server logic of the R Shiny web application
################################################################################################

# Define server logic of the R Shiny web application
server <- function(input, output) {
  
  output$bargraph <- renderPlot ({ 
    ggplot(df_view3, aes(Year, value/1000)) +   
      geom_bar(aes(fill = variable), position = "dodge", stat = "identity") +
      theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
      theme(axis.text.x = element_text(face = "bold", size = 11),
            axis.text.y = element_text(face = "bold", size = 11)) +
      labs(title = "Number of Views or Creations Per Year", y ="Number of Projects Viewed in thousand")
  })
  
  
  output$bargraph2 <- renderPlot ({ 
    ggplot(data = df_view6, aes(x = Year, y = Projects_Viewed/1000, fill = Is_Remixed)) + 
      geom_bar(stat="identity") +
      theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
      theme(axis.text.x = element_text(face = "bold", size = 11),
            axis.text.y = element_text(face = "bold", size = 11)) +
      labs(title = "Yearly Projects Viewed Grouped by Is Remixed", y ="Number of Projects Viewed in thousand")
  })
  

  output$histogram1 <- renderPlot ({ 
    hist(df_view$viewers_website, breaks = input$bins, col="sky blue",
         main="Histogram", xlab="Projects Viewed")})
  
  output$histogram2 <- renderPlot ({ 
    hist(df_view$lovers_website, breaks = input$bins2, col="sky blue",
         main="Histogram", xlab="Projects Loved")})
  
  output$histogram3 <- renderPlot ({ 
    hist(df_view$downloaders_website, breaks = input$bins3, col="sky blue",
         main="Histogram", xlab="Projects Downloaded")})
  
  
  output$ScratchPlot <- renderPlot({  
    iX   <- as.numeric(input$var)  
    iY   <- as.numeric(input$var2)
    x    <- df_view1[, iX]
    y    <- df_view1[, iY]
    require(graphics)
    
    ggplot(df_view1, aes(x,y)) +
      geom_point(aes(colour = factor(Year)), size = 4) +
      theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
      labs(title = "Scatter Plot") +
      xlab(paste("Total of", names(df_view1[iX]))) +
      ylab(paste("Total of", names(df_view1[iY]))) +
      geom_smooth(method = lm)  
    
  })
  
  output$ScratchLinePlot <- renderPlot({  
    iX   <- as.numeric(input$var_1)  
    iY   <- as.numeric(input$var_2) #
    x    <- df_view1[, iX]
    y    <- df_view1[, iY]
    
    require(graphics)
    ggplot(df_view1, 
           aes(x,y)) +
      #geom_point(aes(colour = factor(Year)), size = 4) +
      xlab(paste("Total of", names(df_view1[iX]))) +
      ylab(paste("Total of", names(df_view1[iY]))) +
      ggtitle("Line Chart") +
      geom_line() +
      geom_smooth(method = lm)  
     })
  
} 
