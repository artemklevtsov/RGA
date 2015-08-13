library(rvest)
library(jsonlite)
library(stringi)
library(magrittr)

main_url <- "https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/"
urls <- html(main_url) %>% html_nodes("a") %>% html_attr("href") %>%
    stri_subset_regex("mgmt") %>% stri_subset_regex("list|get|resource") %>% na.omit %>%
    paste0("https://developers.google.com", .)

get_returns <- function(url) {
    res <- html(url)
    pre <- res %>% html_nodes("#alt-json") %>% html_text(trim = TRUE) %>%
        stri_replace_all_regex(" (\\w+)", " \"\\1\" ") %>% fromJSON
    names <- unique(c(names(pre), names(unlist(pre))))
    tbl <- res %>% html_nodes("#properties") %>% html_table(fill = TRUE)
    tbl <- tbl[[1]]
    tbl$`Property name` %<>% stri_replace_all_fixed("[]", "")
    tbl <- tbl[match(names, tbl$`Property name`), ]
    sprintf("#' \\item{%s}{%s}\n", tbl$`Property name`, tbl$Description)
}

get_params <- function(url) {
    res <- html(url)
    tbl <- res %>% html_nodes("#request_parameters") %>% html_table(fill = TRUE)
    tbl <- na.omit(tbl[[1]])
    tbl$`Parameter name` %<>% stri_replace_all_fixed("-", ".")
    sprintf("#' @param %s %s\n", tbl$`Parameter name`, tbl$Description)
}

if (!file.exists("tmp/"))
    dir.create("tmp/")

for (i in urls) {
    file_name <- i  %>% stri_split_regex("/|#", simplify = TRUE) %>% extract(11)
    suffix <- i  %>% stri_split_regex("/|#", simplify = TRUE) %>% extract(12)
    message("Getting ", file_name, " entries...")
    if (suffix == "resource")
        try(cat(get_returns(i), sep = "", file = paste0("tmp/", file_name, "-", suffix, ".txt")))
    else
        try(cat(get_params(i), sep = "", file = paste0("tmp/", file_name, "-", suffix, ".txt")))
}
