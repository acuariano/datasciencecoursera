library(shiny)
library(shinyBS)
library(plotly)
shinyUI(fluidPage(
        titlePanel("Solar photo-voltaic capacity growth"),
        sidebarLayout(
                sidebarPanel(
                        checkboxInput("use_scale_log", "Log Scale", value = TRUE),
                        strong("Exponential gowth bases"), span("(?)", id="basesHelp", style="color:blue;font-weight:bold;"), br(),
                        "China:", textOutput(inline = TRUE, outputId = "china_base"), br(),
                        "Germany:", textOutput(inline = TRUE, outputId = "germany_base"), br(),
                        "USA:", textOutput(inline = TRUE, outputId = "usa_base"), br(),
                        "Japan:", textOutput(inline = TRUE, outputId = "japan_base"), br(),
                        "World:", textOutput(inline = TRUE, outputId = "world_base"), br(),
                        br(), 
                        "You can switch between log and linear scales. The linear scale gives you an idea of the stagering",
                        " growth we are experiencing. But for comparisons, the log scale is better.",
                        br(),br(),
                        "You can drag in the Plotly chart to select points for the bases calculation. I recommend you drag",
                        " in a horizontal line to select the segment of the graph.",
                        br(),br(),
                        "Try selecting the segments [2005, 2015] and [2010, 2015] to see the growth rate for the last 10",
                        " and 5 years respectively.",
                        br(),br(),
                        "Also try deselecting each country by clicking in their labels. Leave only 'World' and 'GTM Research',",
                        "so you can compare the best projection from ", 
                        a("Wikipedia",href="https://en.wikipedia.org/wiki/Growth_of_photovoltaics"), " to the derived growth rate.",
                        br(),br(),
                        em("The gray area are projections (after 2015.)"),
                        br(),br(),
                        "You can access the presentation for this application ", 
                        a("here", href="https://acuariano.github.io/datasciencecoursera/data-products/final/", target="_blank"),
                        ".",
                        bsTooltip("basesHelp", "The base is calculated with the formula (final-initial)^(1/years). <br/> It uses the selection to calculate the base.",
                                  "right", options = list(container = "body"))
                ),
                mainPanel(
                        h3("PV Growth"),
                        plotlyOutput("plot1", height = 600)
                        # plotOutput("plot1", brush =brushOpts(id = "brush1"))
                )
        )
))
