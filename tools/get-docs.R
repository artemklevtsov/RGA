library(rvest)
library(jsonlite)
library(stringr)
library(magrittr)

urls <- read_html("https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/") %>%
    html_nodes("a") %>% html_attr("href") %>%
    str_subset("https://.*/mgmtReference/management")

to_separated <- function(x, sep = ".") {
    x <- gsub("PropertyId", "propertyId", x, fixed = TRUE)
    x <- gsub("-", ".", x, fixed = TRUE)
    x <- gsub("ids", "profile.id", x, fixed = TRUE)
    gsub("([[:lower:]])([[:upper:]])", paste0("\\1", sep, "\\L\\2"), x, perl = TRUE)
}

get_returns <- function(url, output.dir = ".") {
    res <- read_html(url)
    pre <- res %>% html_nodes("#alt-json") %>%
        html_text(trim = TRUE) %>%
        str_replace_all(" (\\w+)", " \"\\1\" ") %>%
        fromJSON()
    prop_names <- unique(c(names(pre), names(unlist(pre)))) %>%
        to_separated()
    tbl <- res %>% html_nodes("#properties") %>%
        html_table(fill = TRUE) %>%
        extract2(1)
    tbl$`Property name` %<>% str_replace_all("\\[\\]", "") %>% to_separated()
    tbl <- tbl[match(prop_names, tbl$`Property name`), ]
    txt <- sprintf("#' \\item{%s}{%s}", tbl$`Property name`, tbl$Description)
    file_name <- url %>% str_split("/|#") %>%
        unlist %>% extract(11) %>%
        str_c("-resource.txt")
    message("Writing ", file_name, "...")
    writeLines(txt, file.path(output.dir, file_name))
}

get_params <- function(url, output.dir = ".") {
    tbl <- read_html(url) %>%
        html_nodes("#request_parameters") %>%
        html_table(fill = TRUE) %>%
        extract2(1) %>%
        na.omit()
    tbl$`Parameter name` %<>% to_separated()
    txt <- sprintf("#' @param %s %s", tbl$`Parameter name`, tbl$Description)
    file_name <- url %>% str_split("/|#") %>%
        unlist %>%  extract(c(11, 12)) %>%
        str_c(collapse = "-") %>% str_c(".txt")
    message("Writing ", file_name, "...")
    writeLines(txt, file.path(output.dir, file_name))
}

if (!file.exists("tmp/"))
    dir.create("tmp/")

idx <- grep("get|list|insert|delete|patch|update|uploadData|deleteUploadData", urls)

urls[-idx] %>%
    lapply(get_returns, output.dir = "tmp/") %>%
    invisible()
urls[idx] %>%
    lapply(get_params, output.dir = "tmp/") %>%
    invisible()
