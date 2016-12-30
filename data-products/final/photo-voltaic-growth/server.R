library(shiny)
library(plotly)
library(lme4)
createBases <- function(selected, pvCapacity) {
        # base for China
        values <- pvCapacity[pvCapacity$Country=='China',]$Capacity
        n <- length(values)
        chinaBase <- format((max(values)/min(values))^(1/(n-1)), digits=4, nsmall=4)
        # base for Germany
        values <- pvCapacity[pvCapacity$Country=='Germany',]$Capacity
        n <- length(values)
        germanyBase <- format((max(values)/min(values))^(1/(n-1)), digits=4, nsmall=4)
        # base for Japan
        values <- pvCapacity[pvCapacity$Country=='Japan',]$Capacity
        n <- length(values)
        japanBase <- format((max(values)/min(values))^(1/(n-1)), digits=4, nsmall=4)
        # base for USA
        values <- pvCapacity[pvCapacity$Country=='USA',]$Capacity
        n <- length(values)
        usaBase <- format((max(values)/min(values))^(1/(n-1)), digits=4, nsmall=4)
        # base for World
        values <- pvCapacity[pvCapacity$Country=='World',]$Capacity
        n <- length(values)
        worldBase <- format((max(values)/min(values))^(1/(n-1)), digits=4, nsmall=4)
        if (!is.null(selected)) {
                # base for China (0)
                values <- selected[selected$curveNumber ==  0,]$y
                n <- length(values)
                if (n > 0) {
                        chinaBase <- format((max(values)/min(values))^(1/(n-1)), digits=4, nsmall=4)
                }
                # base for Germany (1)
                values <- selected[selected$curveNumber ==  1,]$y
                n <- length(values)
                if (n > 0) {
                        germanyBase <- format((max(values)/min(values))^(1/(n-1)), digits=4, nsmall=4)
                }
                # base for Japan (3)
                values <- selected[selected$curveNumber ==  3,]$y
                n <- length(values)
                if (n > 0) {
                        japanBase <- format((max(values)/min(values))^(1/(n-1)), digits=4, nsmall=4)
                }
                # base for USA (4)
                values <- selected[selected$curveNumber ==  4,]$y
                n <- length(values)
                if (n > 0) {
                        usaBase <- format((max(values)/min(values))^(1/(n-1)), digits=4, nsmall=4)
                }
                # base for World (5)
                values <- selected[selected$curveNumber ==  5,]$y
                n <- length(values)
                if (n > 0) {
                        worldBase <- format((max(values)/min(values))^(1/(n-1)), digits=4, nsmall=4)
                }
        }
        list(china = chinaBase, germany = germanyBase, japan = japanBase, usa = usaBase, world = worldBase)

}
shinyServer(function(input, output) {
        pvCapacity <- read.csv("pv_capacity.csv", encoding = "UTF-8")
        pvCapacity$Capacity <- pvCapacity$Capacity/1000
        pvCapacity$Installed <- pvCapacity$Installed/1000
        countriesBases <- reactive({
                selectedPoints <- event_data("plotly_selected")
                createBases(selectedPoints, pvCapacity)
        })
        # output$plot1 <- renderPlot({
        #         g <- ggplot(pvCapacity) + geom_point(aes(Year, log(Capacity), colour = Country)) +
        #             geom_smooth(aes(Year, log(Capacity), colour = Country), method=lm, se=FALSE)
        #         g
        #         # plot(pvCapacity$Year, log(pvCapacity$Capacity))
        # })
                
        output$plot1 <- renderPlotly({
                p <- plot_ly(pvCapacity, x = ~Year, y = ~Capacity, type = "scatter", mode="markers",
                             color = ~Country, size=~Installed, hoverinfo = 'text',
                             text = ~paste('<b>', Country, '</b>',
                                           '</br>Year: ', Year,
                                           '</br>Capacity: ', format(Capacity, digits=3, nsmall=3, scientific = FALSE),
                                           '</br>Installed: ', format(Installed, digits=3, nsmall=3, scientific = FALSE),
                                           '</br>Y/Y: ', format(Y.Y, digits=4, nsmall=4, scientific = FALSE))) %>%
                        layout(plot_bgcolor='rgb(247, 247, 255)') %>%
                        layout(dragmode = "select")
                
                if (input$use_scale_log) {
                        p <- layout(p, shapes = list(
                                list(type = "rect",
                                     fillcolor = "gray", line = list(color = "gray"), opacity = 0.1,
                                     x0 = "2015", x1 = "2025", xref = "x",
                                     y0 = 0, y1 = 10000, yref = "y")
                        ))
                        p <- layout(p, yaxis = list(type = "log", title="Capacity (TW)"))
                } else {
                        p <- layout(p, shapes = list(
                                list(type = "rect",
                                     fillcolor = "gray", line = list(color = "gray"), opacity = 0.1,
                                     x0 = "2015", x1 = "2025", xref = "x",
                                     y0 = 0, y1 = 5500, yref = "y")
                        ))
                }
                p
        })
        output$china_base <- renderText(countriesBases()$china)
        output$germany_base <- renderText(countriesBases()$germany)
        output$usa_base <- renderText(countriesBases()$usa)
        output$japan_base <- renderText(countriesBases()$japan)
        output$world_base <- renderText(countriesBases()$world)
        
})
