
#' @export
get_dataset <- function(code){
  #CODE <- "LFSO_14LUNER"
  code <- toupper(code)
  base_url <- "https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/{code}/?format=SDMX-CSV"
  data_url <- glue::glue(base_url)
  tmpfile <- tempfile()
  download.file(data_url, tmpfile)
  d <- read_csv(tmpfile)
  unlink(tmpfile)
  d
}


get_last_value <- function(d){

  d2 <- d |>
    filter(age == "TOTAL") |>
    group_by(geo, TIME_PERIOD) |>
    summarise(value = sum(OBS_VALUE), .groups = "drop") |>
    group_by(geo) |>
    arrange(desc(TIME_PERIOD), .by_group = TRUE) |>
    slice(1) |>
    ungroup()
  d2

}

