# User Interface
ui <- navbarPage(title = 'Hello, Friends!')

# Server
server <- function(input, output){}

# Create the Shiny App
shinyApp(ui=ui, server=server)
