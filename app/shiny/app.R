source('helpers.R')
counties <- readRDS('data/counties.rds')


#=============================== DASHBOARD HEADER ====================================
#
#   Create a header for a dashboard page
#   It can be left blank, or it can include dropdown menu items on the right side
#   
#       dashboardHeader(..., title=NULL, titleWidth = NULL, disable=FALSE, .list=NULL)
#
#       ...     Items to put in the header. Should be drowdownMenu(s)
#       .list   An optional list containing items to put in the header
#
#======================================================================================
header <- dashboardHeader(title='LUMENS Dashboard')

#=============================== DASHBOARD SIDEBAR ====================================
#
#   Create a dashboard sidebar
#   It typically contains a sidebarMenu, sidebarSearchForm, or other Shiny inputs
#   
#       dashboardSidebar(..., disable=FALSE, width=NULL)
#
#       ...     Items to put in the sidebar
#       
#======================================================================================
sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem('Dashboard', tabName = 'dashboard', icon = icon('dashboard')),
        menuItem('GDP', tabName = 'GDPWidgets', icon = icon('th')),

        selectInput("var", 
            label = "Choose a variable to display",
            choices = c("Percent White", "Percent Black",
                        "Percent Hispanic", "Percent Asian"),
            selected = "Percent White"),
        
        sliderInput("range", 
            label = "Range of interest:",
            min = 0, max = 100, value = c(0, 100))

    )
)

#=============================== DASHBOARD BODY =======================================
#
#   The main body of a dashboard page
#   It typically contains a sidebarMenu, sidebarSearchForm, or other Shiny inputs
#   
#       dashboardSidebar(...)
#
#       ...     Items to put in the dashboard body
#       
#======================================================================================
body <- dashboardBody(
    tags$head(
        tags$link(ref='stylesheet', type='text/css', href='style.css')
    ),
    
    tabItems(
        tabItem(tabName='dashboard',
                withTags({
                    h2(b(
                        span('L', style='color:red'),
                        span('U', style='color:rgb(146,208,80)'),
                        span('M', style='color:rgb(0,176,240)'),
                        span('E', style='color:rgb(194,214,155)'),
                        span('N', style='color:rgb(0,112,192)'),
                        span('S', style='color:rgb(79,98,40)')
                    ))
                }),
                p(em('Land Use Planning for Multiple Environmental Services'))
        ),
        
        tabItem(tabName='GDPWidgets',
            box(
                title='Population Density',
                collapsible=TRUE,
                plotOutput('map')
            )
        )
    )
)


# setup ui shiny
# dashboard page
ui <- dashboardPage(
    skin = 'black',
    header,
    sidebar,
    body
)

#======================================== OUTPUT & RENDER FUNCTION ======================================
#
#       *Output function    creates             render* function    creates 
#       ----------------------------            ---------------------------
#       htmlOutput          raw HTML            renderImage         images (saved as a link to a source file)
#       imageOutput         image               renderPlot          plots    
#       plotOutput          plot                renderPrint         any printed output
#       tableOutput         table               renderTable         data frame, matrix, other table like structures
#       textOutput          text                renderText          character strings
#       uiOutput            raw HTML            renderUI            a Shiny tag object or HTML
#       verbatimTextOtput   text
#   
#=========================================================================================================
#setup ui server
server <- function(input, output, session) {
    
    
    # args <- switch(input$var,
    #               "Percent White" = list(counties$white, "darkgreen", "% White"),
    #               "Percent Black" = list(counties$black, "black", "% Black"),
    #               "Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
    #               "Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
    
    # args$min <- input$range[1]
    # args$max <- input$range[2]
    
    # do.call(percent_map, args)
    
    output$map <- renderPlot({
        data <- switch (input$var,
            "Percent White" = counties$white,
            "Percent Black" = counties$black,
            "Percent Hispanic" = counties$hispanic,
            "Percent Asian" = counties$asian
        )
        color <- switch(input$var, 
            "Percent White" = "darkgreen",
            "Percent Black" = "black",
            "Percent Hispanic" = "darkorange",
            "Percent Asian" = "darkviolet"
        )
        legend <- switch(input$var, 
             "Percent White" = "% White",
             "Percent Black" = "% Black",
             "Percent Hispanic" = "% Hispanic",
             "Percent Asian" = "% Asian"
        )
        percent_map(var = data, color = color, legend.title = legend, max = input$range[2], min = input$range[1])
    })
    
    # comment this function if on live reloading mode
    session$onSessionEnded(function(){
      stopApp()
    })
}

shinyApp(ui, server)
