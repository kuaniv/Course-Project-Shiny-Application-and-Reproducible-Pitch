library(shiny)
library(quantmod)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    stockNames <- data.frame(name=c("Facebook", "Amazon", "Apple", "Netflix", "Google"), 
                             code=c("FB","AMZN", "AAPL", "NFLX", "GOOGL"),
                             id=c(1:5))
    getSymbols(c("FB","AMZN", "AAPL", "NFLX", "GOOGL"), src='yahoo')
    stock_list <- list(FB, AMZN, AAPL, NFLX, GOOGL)

    output$distPlot <- renderPlotly({
        stck <- stock_list[[stockNames$id[stockNames$name==input$stock]]]
        df <- data.frame(Date=index(stck),coredata(stck))
        colnames(df) <- c("Date", "Open", "High", "Low", "Close", "Volume", "Adjusted")
        df <- cbind(df,BBands(df[,c("High","Low","Close")]))
        df <- tail(df, 150)

        fig <- df %>% plot_ly(x = ~Date, type=input$type,
                              open = ~Open, close = ~Close,
                              high = ~High, low = ~Low)
        fig <- fig %>% layout(title = paste(input$stock, "Chart"))
        fig <- fig %>% layout(yaxis = list(title = "Price"))
        if ("2" %in% input$chkGroup){
            fig <- fig %>% add_lines(x = ~Date, y = ~mavg, name = "Mv Avg",
                                     line = list(color = '#E377C2', width = 0.5),
                                     hoverinfo = "none", inherit = F, showlegend = FALSE)
        }
        if ("3" %in% input$chkGroup){
            fig <- fig %>% add_lines(x = ~Date, y = ~up , name = "B Bands",
                                     line = list(color = '#ccc', width = 0.5),
                                     legendgroup = "Bollinger Bands",
                                     hoverinfo = "none", inherit = F, showlegend = FALSE) 
            fig <- fig %>% add_lines(x = ~Date, y = ~dn, name = "B Bands",
                                     line = list(color = '#ccc', width = 0.5),
                                     legendgroup = "Bollinger Bands", inherit = F,
                                     showlegend = FALSE, hoverinfo = "none") 
            
        }
        if ("1" %in% input$chkGroup){
            fig2 <- df 
            fig2 <- fig2 %>% plot_ly(x=~Date, y=~Volume, type='bar', name = "Volume", color = '#E377C2') 
            fig2 <- fig2 %>% layout(yaxis = list(title = "Volume"))
            fig <- subplot(fig, fig2, heights = c(0.7,0.2), nrows=2,
                           shareX = TRUE, titleY = TRUE)
        }
        fig <- fig %>% layout(xaxis = list(rangeslider = list(visible = F)))
        fig
    })

    output$text1 <- renderText({
        paste(stockNames$code[stockNames$name==input$stock])
    })

})
