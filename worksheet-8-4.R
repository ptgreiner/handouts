# Libraries
library(ggplot2)
library(dplyr)

# Data
species <- read.csv('data/species.csv', stringsAsFactors = FALSE)
animals <- read.csv('data/animals.csv', na.strings = '', stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput('pick_species',
                   label = 'Pick a species',
                   choices = unique(species[['id']]))
img <- img(src = 'image-filename.png', alt = 'short image description')
in2 <- sliderInput('slider_months',
                   label = 'Month Range',
                   min = 1,
                   max = 12,
                   value = c(1, 12))
side <- sidebarPanel(img, 'Options', in1, in2)									    
out1 <- textOutput('species_name')
out2 <- tabPanel('Plot',
                 plotOutput('species_plot'))
out3 <- tabPanel('Data',
                 dataTableOutput('species_table'))                 
main <- mainPanel(out1,
                  tabsetPanel(out2, out3))
tab <- tabPanel(title = 'Species',
                sidebarLayout(side, main))
ui <- navbarPage(title = 'Portal Project', tab)

# Server
server <- function(input, output) {
  reactive_data_frame <- reactive({
    months <- seq(input[['slider_months']][1],
                  input[['slider_months']][2])
    animals %>%
      filter(species_id == input[['pick_species']]) %>%
      filter(month %in% months)
  })
  output[['species_name']] <- renderText(
    species %>%
      filter(id == input[['pick_species']]) %>%
      select(genus, species) %>%
      paste(collapse = ' ')
  )
  output[['species_plot']] <- renderPlot(
    ggplot(reactive_data_frame(), aes(year)) +
      geom_bar()
  )
  output[['species_table']] <- renderDataTable(reactive_data_frame())
}

# Create the Shiny App
shinyApp(ui = ui, server = server)