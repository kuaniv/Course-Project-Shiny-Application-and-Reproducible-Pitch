library(shiny)
library(plotly)


shinyUI(fluidPage(

    # Application title
    titlePanel("FAANG Financial Charts"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("stock", 
                        "Choose a stock:", as.list(c("Facebook", "Amazon", "Apple", "Netflix", "Google")), 
                        selected = "Apple"),
            radioButtons("type", "Choose a chart type:",
                         c("Candlestick"="candlestick",
                           "OHLC Charts" = "ohlc"),
                         selected = "candlestick"),
            checkboxGroupInput("chkGroup", label = h3("Technical analisis tools:"),
                               choices = list("Volume" = 1,"Moving Average" = 2, "Bollinger Bands" = 3),
                               selected = NULL)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h3(textOutput("text1")),
            plotlyOutput("distPlot")
        )
    ),
    hr(),
    fluidRow(
        column(4, h3("FAANG Financial Charts"), h3("Facebook"), h3("Amazon"), h3("Apple"), h3("Netflix"), h3("Google"), 
               h3(" "), h6("by Anton Kuklev")),
        column(6, 
               h3("Instructions"),
               p("The app has several inputs to manipulate the data and plot. A user can select a stock and chart type."),
               HTML("<ol>
                <li>Select a stock from FAANG-list</li>
                <li>Select a chart type</li>
                <li>Select a Technical analisis tools:</li>
               </ol>"),
               HTML("<ul>
                  <li>  Volume</li>
                  <li>  Moving Average</li>
                  <li>  Bollinger Bands</li>
                </ul>")
        )
        
    )
    
))
