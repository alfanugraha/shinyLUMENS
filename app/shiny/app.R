# header
header <- dashboardHeader(title='LUMENS Dashboard')

# sidebar
sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem('Dashboard', tabName = 'dashboard', icon = icon('dashboard')),
        menuItem('GDP', tabName = 'GDPWidgets', icon = icon('th'))
    )
)

# body
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
                h2('GDP tab content'),
                box(
                    title='Penambahan Luasan (%)',
                    status='primary',
                    collapsible=TRUE,
                    sliderInput('sliderUndisturbedForest', 'Undisturbed Forest', 0, 100, 0),
                    sliderInput('sliderOilPalmMonoculture', 'Oil Palm Monoculture', 0, 100, 0),
                    sliderInput('sliderSettlement', 'Settlement', 0, 100, 0),
                    sliderInput('sliderWaterbody', 'Waterbody', 0, 100, 0)
                ),
                box(
                    title=HTML('&#916;GDP (%)'),
                    status='info',
                    collapsible=TRUE,
                    textOutput('textOutputPrecentageDeltaGDP')
                ),
                box(
                    title=HTML('&#916;GDP (Million Rupiahs)'),
                    status='info',
                    collapsible=TRUE,
                    textOutput('textOutputMillionDeltaGDP')
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

#setup ui server
server <- function(input, output, session) {
    output$textOutputPrecentageDeltaGDP <- renderText({
        mean(c(input$sliderUndisturbedForest, input$sliderOilPalmMonoculture, input$sliderSettlement, input$sliderWaterbody))
    })
    
    output$textOutputMillionDeltaGDP <- renderText({
        paste(
            sum(input$sliderUndisturbedForest, input$sliderOilPalmMonoculture, input$sliderSettlement, input$sliderWaterbody)*100
        )
    })
    
    session$onSessionEnded(function(){
      stopApp()
    })
}

shinyApp(ui, server)
