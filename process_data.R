library(xlsx)
library(dplyr)
library(RODBC)
library(reshape2)

source("~/Documents/codebase/census_pulse/set_vars.R")

getData <- function(wk, tab){
  link <- subset(datatables, dtable == tab, select = "link") %>%
    unique()
  dir.create("_tmp")
  setwd("_tmp")
  download.file(sprintf(link, wk), destfile = "data.xlsx", mode = "wb")
  setwd("../")
}

processSheet <- function(skipRows = 6, sheet, cnames, demo_cats){
  ### skipRows for Employ 3 should be 5
  # tmp <- read.xlsx("_tmp/data.xlsx", skip = skipRows, sheetName = sheet, header = F) %>%  ### wfh... personal computer doesn't have java
  tmp <- read_xlsx("~/Downloads/employ2.xlsx", skip = 6, sheet = sheet, col_names = F)
    setNames(cnames)
  demo_indies <- grep(paste(demo_cats, collapse = "|"), tmp$characteristics)
  demo_split <- split(tmp, cumsum(1:nrow(tmp) %in% demo_indies))
  names(demo_split) <- demo_cats
  lapply(demo_split, function(x){
    x %>%
      filter(!is.na(total)) %>%
      melt() %>%
      setNames(c("demo_value", "response", "value"))
  }) %>%
    bind_rows(.id = "demo_cat") %>%
    mutate(region = sheet)
}

saveData <- function(dat, dbcon, wk, dbtab){
  tablename <- sprintf("census.%s", dbtab)
  dat %>%
    mutate(wk = wk) %>%
    sqlSave(channel = dbcon,
      tablename = tablename,
      append = dbexists(dbcon, tablename),
      rownames = F)
}

processData <- function(wk, tab){
  meta <- getTableMeta(tab)
  dbtab <- sprintf("census.%s", meta$dbname)
  getData(wk, tab)
  ret <- lapply(data_sheets, function(sheet){
    processSheet(skipRows = meta$skipRows,
      sheet = sheet,
      cnames = meta$cnames,
      demo_cats = meta$characteristics)
  }) %>%
  bind_rows() %>%
  sqlSave(channel = dbcon,
    tablename = dbtab,
    append = dbexists(dbcon, dbtab),
    rownames = F)
}

### testing
lapply(unique(questions$dtable), function(xtab){
  lapply(1:4, function(i){
    processData(wk = i, tab = xtab)
  })
})
