library(httr)
library(rvest)
library(stringr)
library(purrr)
library(tibble)
library(dplyr)
library(readr)

parse_altmetric_explorer <- function(html_file) {

  # this html file comes from a manual download (due to loginwall) of
  # https://www.altmetric.com/explorer/institution/departments
  if (missing(html_file))
    html_file <- "Altmetric Explorer.html"

  ae <-
    read_html(html_file) %>%
    html_nodes(css = ".department-hierarchy-wrapper > ol") %>%
    html_nodes(css = ".department")

  # fcns to scrape department data

  x_level <- function(x)
    x %>% html_attr("class")

  x_id_desc <- function(x)
    x %>% html_nodes(".name") %>%
    html_text() %>%
    # use two capture groups to extract id and desc
    str_match_all("\\[(\\d+)\\]\\s+(.*?)$") %>%
    map_df(as_tibble) %>%
    select(id = 2, desc = 3) %>%
    mutate(id = as.integer(id))

  x_count <- function(x)
    x %>% html_nodes(css = ".count") %>%
    html_node("strong") %>%
    html_text() %>%
    parse_number()

  x_href <- function(x)
    ae %>% html_nodes(css = "a") %>%
    html_attr("href")

  # parse individual components and merge into a data frame
  t1 <- bind_cols(
    tibble(
      level = ae %>% x_level,
      count = ae %>% x_count,
      href = ae %>% x_href
    ),
    ae %>% x_id_desc
  )

  # return results
  t1 %>%
  mutate(aid = str_match(href, "department_id=(.*?):department:(.*?)$")[,3]) %>%
  select(diva_id = id, altmetric_id = aid, desc, level, count, href)

}

library(here)

html_file <- file.path(here(), "data-raw", "Altmetric Explorer.html")
altmetric_explorer <- parse_altmetric_explorer(html_file)

usethis::use_data(altmetric_explorer, overwrite = TRUE)
