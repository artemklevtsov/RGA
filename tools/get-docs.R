library(rvest)
library(jsonlite)
library(stringr)
library(magrittr)

api_methods <- c("list", "get")

base_url <- "https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/"

urls <- read_html(base_url) %>%
    html_nodes("a") %>% html_attr("href") %>%
    str_subset("#resource") %>% str_replace_all("#resource", "") %>%
    str_c("https://developers.google.com", .)

to_separated <- function(x, sep = ".") {
    x <- gsub("PropertyId", "propertyId", x, fixed = TRUE)
    x <- gsub("-", ".", x, fixed = TRUE)
    x <- gsub("ids", "profile.id", x, fixed = TRUE)
    gsub("([[:lower:]])([[:upper:]])", paste0("\\1", sep, "\\L\\2"), x, perl = TRUE)
}

get_return <- function(x) {
    pre <- x %>% html_nodes("pre#alt-json") %>% html_text(trim = TRUE) %>%
        str_replace_all(" (\\w+)", " \"\\1\" ") %>% fromJSON()
    prop_names <- unique(c(names(pre), names(unlist(pre))))
    tbl <- x %>% html_nodes("table#properties") %>%
        html_table(fill = TRUE) %>% extract2(1)
    tbl$`Property name` %<>% str_replace_all("\\[\\]", "")
    tbl <- tbl[match(prop_names, tbl$`Property name`), ]
    title <- x %>% html_nodes("section#overview p") %>% html_text(trim = TRUE) %>% extract(1)
    title <- sprintf("#' @return %s", title)
    items <- sprintf("#' \\item{%s}{%s}", tbl$`Property name` %>% to_separated(), tbl$Description)
    items %<>% extract(items %>% str_detect("self.link|parent.link|child.link") %>% not())
    c(title, items)
}

get_title <- function(x) {
    title <- x %>% html_nodes("h1.devsite-page-title") %>% html_text(trim = TRUE) %>%
        str_split(":") %>% unlist %>% extract(1)
    sprintf("#' @title %s", title)
}

get_methods <- function(x) {
    methods <- x %>% html_nodes("section#methods dt") %>% html_text()
    desc <- x %>% html_nodes("section#methods dd") %>% html_text()
    txt <- sprintf("#' @description %s", desc)
    names(txt) <- methods
    return(txt)
}

get_params <- function(x) {
    tbl <- x %>% html_nodes("table#request_parameters") %>%
        html_table(fill = TRUE) %>% extract2(1) %>% na.omit()
    tbl$Value %<>% str_replace_all("string", "character")
    tbl$`Parameter name` %<>% to_separated() %>% tolower()
    params <- sprintf("#' @param %s %s. %s", tbl$`Parameter name`, tbl$Value, tbl$Description)
    token <- "#' @param token \\code{\\link[httr]{Token2.0}} class object with a valid authorization data."
    c(params, token)
}

get_man <- function(url) {
    html <- read_html(url)
    nm <- url %>% str_split("/management/") %>% unlist() %>% extract(2) %>% to_separated(sep = "_")
    title <- get_title(html)
    values <- get_return(html)
    descs <- get_methods(html)
    family <- "#' @family Management API"
    ref <- sprintf("#' @references \\href{%s}{Management API - %s Overview}\n", url, title %>% str_replace_all("#' @title ", ""))
    methods <- descs %>% names() %>% str_subset(api_methods %>% str_c(collapse = "|"))
    for (m in methods) {
        url2 <- str_c(url, m, sep = "/")
        html2 <- read_html(url2)
        desc <- descs[m]
        params <- get_params(html2)
        txt <- c(title, desc, params, values, ref, family)
        txt %<>% str_replace_all("[^\x20-\x7E]", " ") %>% str_trim()
        fn <- str_c(m, nm, sep = "_") %>% str_c(".R")
        message("Writing ", fn, "...")
        writeLines(txt, file.path("man-roxygen", fn))
    }
}

for (url in urls %>% extract(urls %>% str_detect("Links$") %>% not())) get_man(url)
