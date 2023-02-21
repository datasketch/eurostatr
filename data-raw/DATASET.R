## code to prepare `DATASET` dataset goes here

library(tidyverse)

# Download eurostat


## Bulk download list
# https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing

#https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&dir=dic

# comext database at http://epp.eurostat.ec.europa.eu/newxtweb/

# List of available tables
#https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&downfile=dic%2Fen%2Ftable_dic.dic


tables_url <- "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&downfile=dic%2Fen%2Ftable_dic.dic"
tables_file <- "data-raw/tables/table.dic"
download.file(tables_url, tables_file)
tables_dic <- read_tsv(tables_file, col_names = c("id", "label"))

dmlst_url <- "http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&downfile=dic/en/dimlst.dic"
dmlst_file <-  "data-raw/tables/dmlst.dic"
download.file(dmlst_url, dmlst_file)
dmlst <- read_tsv(dmlst_file, col_names = c("id", "label"))

metabase_url <- "http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=metabase.txt.gz"
metabase_file <- "data-raw/tables/metabase.txt"
download.file(metabase_url, metabase_file)
metabase <- read_tsv(metabase_file, col_names = c("id", "label"))


toc_url <- "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=table_of_contents_en.txt"
toc_file <- "data-raw/tables/toc.txt"
download.file(toc_url, toc_file)
toc <- read_tsv(toc_file)


## Full list of items

items <- read_tsv("data-raw/tables/Full_Items_List_EN.txt")


# file list

full_list <- "https://ec.europa.eu/eurostat/databrowser-backend/api/bulk/1.0/LIVE/export/download/bulk/2783f485-9922-42f8-9957-aa3441e94063"
download.file(full_list, "data-raw/tables/full-list.zip")
library(zip)
unzip("data-raw/tables/full-list.zip", exdir = "data-raw/tables")

full_list <- read_tsv("data-raw/tables/Full_Items_List_EN.txt")

## Base URL
CODE <- "AACT_ALI01"
base_url <- "https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/{CODE}/?format=SDMX-CSV"
data_url <- glue::glue(base_url)
data_file <- file.path("data-raw","browse",paste0(code,".tsv.gz"))
download.file(data_url, data_file)
aact_ali01 <- read_csv(data_file)


base_url <- "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=data%2F{code}.tsv.gz"

code <- "aact_ali01"
data_url <- glue::glue(base_url)
data_file <- file.path("data-raw","data",paste0(code,".tsv.gz"))
download.file(data_url, data_file)
aact_ali01 <- read_tsv(data_file)

code <- "tec00118"
data_url <- glue::glue(base_url)
data_file <- file.path("data-raw","data",paste0(code,".tsv.gz"))
download.file(data_url, data_file)
tec00118 <- read_tsv(data_file)


ld <- list()


code <- "MIGR_EIPRE"
# Third country nationals found to be illegally present - annual data (rounded)
third_country_illegals0 <- get_dataset(code)

third_country_illegals <- third_country_illegals0 |>
  filter(age == "TOTAL") |>
  group_by(geo, TIME_PERIOD) |>
  summarise(value = sum(OBS_VALUE), .groups = "drop") |>
  group_by(geo) |>
  arrange(desc(TIME_PERIOD), .by_group = TRUE) |>
  slice(1) |>
  ungroup()
third_country_illegals

l1 <- list(
  code = code,
  description = "Third country nationals found to be illegally present - annual data (rounded)",
  data = third_country_illegals
)


ld <- c(l1, ld)



#Population connected to public water supply
code <- "ENV_WAT_POP"
pop_public_water0 <- get_dataset(code)
pop_public_water <- pop_public_water0 |>
  group_by(geo, TIME_PERIOD) |>
  summarise(value = sum(OBS_VALUE), .groups = "drop") |>
  group_by(geo) |>
  arrange(desc(TIME_PERIOD), .by_group = TRUE) |>
  slice(1) |>
  ungroup()
l2 <- list(
  code = code,
  description = "Population connected to public water supply",
  data = pop_public_water
)

ld <- c(l2, ld)


code <- "CRIM_PRIS_POP"
# Prison population
prison_pop0 <- get_dataset(code)

prison_pop <- prison_pop0 |>
  group_by(geo, TIME_PERIOD) |>
  summarise(value = sum(OBS_VALUE), .groups = "drop") |>
  group_by(geo) |>
  arrange(desc(TIME_PERIOD), .by_group = TRUE) |>
  slice(1) |>
  ungroup()

l3 <- list(
  code = code,
  description = "Prison population",
  data = prison_pop
)

ld <- c(l3, ld)



code <- "DEMO_PJANBROAD"
pop0 <- get_dataset(code)
# Population on 1 January by broad age group and sex

pop <- pop0 |>
  filter(age == "TOTAL") |>
  group_by(geo, TIME_PERIOD) |>
  summarise(value = sum(OBS_VALUE), .groups = "drop") |>
  filter(!is.na(value)) |>
  group_by(geo) |>
  arrange(desc(TIME_PERIOD), .by_group = TRUE) |>
  slice(1) |>
  ungroup()

l4 <- list(
  code = code,
  description = "Population on 1 January by broad age group and sex",
  data = pop
)

ld <- c(l4, ld)




code <- "CENS_21UA_A"
# Population with Ukrainian citizenship by age
ukranians <- get_dataset(code)
ukranians <- ukranians0 |>
  filter(age == "TOTAL") |>
  group_by(geo, TIME_PERIOD) |>
  summarise(value = sum(OBS_VALUE), .groups = "drop") |>
  group_by(geo) |>
  arrange(desc(TIME_PERIOD), .by_group = TRUE) |>
  slice(1) |>
  ungroup()

l5 <- list(
  code = code,
  description = "Population with Ukrainian citizenship",
  data = ukranians
)

ld <- c(l5, ld)

eu_data <- ld

usethis::use_data(eu_data, overwrite = TRUE)
