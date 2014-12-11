#' @title The shiny app to lists all columns for a Google Analytics given report type
#'
#' @param data dataset to show (now available only \code{ga}).
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}{Core Reporting API - Dimensions & Metrics Reference}
#'
#' @seealso \code{\link{ga}} \code{\link{get_ga}}
#'
#' @return \code{shiny.appobj} class object to show \code{\link{ga}} dataset.
#'
#' @export
#'
#' @import shiny
#'
dims_mets <- function(data = ga) {
    shinyApp(
        ui = fluidPage(
            titlePanel("Google Analytics: Dimensions & Metrics"),
            absolutePanel(fixed = TRUE, dragdatable = TRUE, class = "modal",
                          top = "auto", left = "auto", right = 20, bottom = 20,
                          width = 300, height = 420,
                          wellPanel(
                              checkboxGroupInput(inputId = "columns", label = "Columns to show:",
                                                 names(data), selected = c("id", "uiName", "type", "description"))
                          )
            ),
            fluidRow(
                column(3,
                       selectInput(inputId = "group", label = "Group:",
                                   choices = c("All", unique(data$group)))
                ),
                column(3,
                       selectInput(inputId = "type", label = "Type:",
                                   choices = c("All", unique(data$type)))
                ),
                column(3,
                       selectInput(inputId = "status", label = "Status:",
                                   choices = c("All", unique(data$status)), selected = "PUBLIC")
                ),
                column(3,
                       selectInput(inputId = "allowedInSegments", label = "Allowed in Segments:",
                                   choices = c("All", unique(data$allowedInSegments)))
                )),
            fluidRow(
                dataTableOutput(outputId = "table")
            )
        ),
        server =  function(input, output) {
            output$table <- renderDataTable({
                if (input$group != "All")
                    data <- data[data$group == input$group,]
                if (input$type != "All")
                    data <- data[data$type == input$type,]
                if (input$status != "All")
                    data <- data[data$status == input$status,]
                if (input$allowedInSegments != "All")
                    data <- data[data$allowedInSegments == input$allowedInSegments,]
                data[, input$columns, drop = FALSE]
            })
        }
    )
}
