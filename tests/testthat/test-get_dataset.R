test_that("get dataset", {

  code <- "LFSO_14LUNER"
  # Unemployment rate by sex, age, migration status, citizenship and educational attainment level

  tmp <- get_dataset(code)



  #"Mean monthly earnings by sex, economic activity and employment contract"
  code <- "EARN_SES18_22"
  tmp <- get_dataset(code)

  #Population connected to public water supply
  code <- "ENV_WAT_POP"
  pop_public_water <- get_dataset(code)

  code <- "APRO_MT_LSPIG"
  # Pig population - annual data
  pigs <- get_dataset(code)


  code <- "CENS_91AAGE"
  # Active population by sex and age
  pop <- get_dataset(code)

  code <- "CENS_21UA_A"
  # Population with Ukrainian citizenship by age
  ukranians <- get_dataset(code)





})
