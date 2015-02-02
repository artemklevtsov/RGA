#' @title The shiny app to lists all columns for a Google Analytics given report type
#'
#' @param report.type character. Report type. Allowed Values: ga. Where ga corresponds to the Core Reporting API.
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}{Dimensions & Metrics Reference}
#'
#' @seealso \code{\link{list_metadata}} \code{\link{get_ga}}
#'
#' @return \code{shiny.appobj} class object to show \code{\link{list_metadata}} output.
#'
#' @include metadata.R
#'
#' @importFrom shiny shinyApp fluidPage titlePanel absolutePanel wellPanel checkboxGroupInput fluidRow column selectInput dataTableOutput renderDataTable
#'
#' @export
#'
dimsmets <- function(report.type = "ga") {
    data <- try(list_metadata(report.type), silent = TRUE)
    if (inherits(data, "try-error")) {
        data <- try(get(report.type), silent = TRUE)
        if (inherits(data, "try-error"))
            stop("Unknown report.type ", dQuote(report.type), ".")
        else
            warning("Use ", dQuote(report.type)," data from package.", call. = FALSE)
    }
    shinyApp(
        ui = fluidPage(
            titlePanel("Google Analytics: Dimensions & Metrics"),
            absolutePanel(id = "controls", class = "panel panel-default", style = "z-index: 1000",
                dragdatable = TRUE, fixed = TRUE, width = 280, height = 400,
                top = "auto", left = "auto", right = 20, bottom = 20, cursor = "move",
                wellPanel(
                    checkboxGroupInput(inputId = "columns",
                                       label = "Columns to show:",
                                       choices = names(data),
                                       selected = c("id", "ui.name", "type", "description"))
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
                       selectInput(inputId = "segments", label = "Allowed in Segments:",
                                   choices = c("All", unique(data$allowed.in.segments)))
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
                if (input$segments != "All")
                    data <- data[data$allowed.in.segments == input$segments,]
                data[, input$columns, drop = FALSE]
            })
        }
    )
}
