library(shiny)
data(ga, package = "RGA")

shinyApp(
    ui = fluidPage(
        titlePanel("Google Analytics: Dimensions & Metrics"),
        absolutePanel(fixed = TRUE, draggable = TRUE, class = "modal",
                      top = "auto", left = "auto", right = 20, bottom = 20,
                      width = 300, height = 420,
                      wellPanel(
                          checkboxGroupInput(inputId = "columns", label = "Columns to show:",
                                             names(ga), selected = c("id", "uiName", "type", "description"))
                      )
        ),
        fluidRow(
            column(3,
                   selectInput(inputId = "group", label = "Group:",
                               choices = c("All", unique(ga$group)))
            ),
            column(3,
                   selectInput(inputId = "type", label = "Type:",
                               choices = c("All", unique(ga$type)))
            ),
            column(3,
                   selectInput(inputId = "status", label = "Status:",
                               choices = c("All", unique(ga$status)), selected = "PUBLIC")
            ),
            column(3,
                   selectInput(inputId = "allowedInSegments", label = "Allowed in Segments:",
                               choices = c("All", unique(ga$allowedInSegments)))
            )),
        fluidRow(
            dataTableOutput(outputId = "table")
        )
    ),
    server =  function(input, output) {
        output$table <- renderDataTable({
            if (input$group != "All") {
                ga <- ga[ga$group == input$group,]
            }
            if (input$type != "All") {
                ga <- ga[ga$type == input$type,]
            }
            if (input$status != "All") {
                ga <- ga[ga$status == input$status,]
            }
            if (input$allowedInSegments != "All") {
                ga <- ga[ga$allowedInSegments == input$allowedInSegments,]
            }
            ga[, input$columns, drop = FALSE]
        })
    }
)
