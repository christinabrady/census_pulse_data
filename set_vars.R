### example url: "https://www2.census.gov/programs-surveys/demo/tables/hhp/2020/wk1/employ1.xlsx"
library(dplyr)

### questions
questions <- data.frame(
  qnumber = c(
    "Q11",
    "Q12",
    "Q13",
    "Q32",
    "Q33",
    "Q34",
    "Q35",
    "Q37",
    "Q38"),
  qtext = c(
    "In the last 7 days, did you do any work for either pay or profit?",
    "Are you employed by government, by a private company, a nonprofit organization or were you self-employed or working in a family business?",
    "What is your main reason for not working for pay or profit?",
    "Over the last 7 days, how often have you been bothered by the following problems... Feeling nervous, anxious or on edge.",
    "Over the last 7 days, how often have you been bothered by the following problems... Not being able to stop or control worrying?",
    "Over the last 7 days, how often have you been bothered by ... having little interest or pleasure in doing things?",
    "Over the last 7 days, how often have you been bothered by ... feeling down, depressed or hopeless?",
    "At any time in the last 4 weeks, did you delay getting medical care because of the coronavirus pandemic?",
    "At any time in the lst 4 weeks did you need meidciare care for something other than coronavirus, but did not get it because of the coronavirus pandemic?"
  ),
  dtable = c(
    rep("Employment Tables: Table 2", 2),
    "Employment Tables: Table 3",
    rep("Health Tables: Table 2a", 2),
    rep("Health Tables: Table 2b", 2),
    rep("Health Tables: Table 1", 2)
    )
)
getTableMeta <- function(tname){
  list(
    "Employment Tables: Table 2" = list(
      dbtable = "employment2",
      link = "https://www2.census.gov/programs-surveys/demo/tables/hhp/2020/wk%s/employ2.xlsx",
      characteristics =
        c("Total",
        "Age",
        "Sex",
        "Hispanic origin and Race",
        "Education",
        "Marital status",
        "Presence of children",
        "Health status",
        "Household income"),
      cnames = c("characteristics",
        "total",
        "yes_gov",
        "yes_private_company",
        "yes_nonprofit",
        "yes_self",
        "yes_family",
        "yes_dnr",
        "no",
        "dnr"),
      skipRows = 6
      ),
    "Employment Tables: Table 3" = list(
      dbtable = "employment3",
      link = "https://www2.census.gov/programs-surveys/demo/tables/hhp/2020/wk%s/employ3.xlsx",
      characteristics =
        c("Total",
        "Reason for not working",
        "Receiving pay during time not working"),
      cnames =   c("characteristics",
          "total",
          "less_high_school",
          "some_high_school",
          "high_school",
          "some_college",
          "associates_degree",
          "bachelors_degree",
          "graduate_degree"),
        skipRows = 5
      ),
    "Health Tables: Table 2a" = list(
      dbtable = "health2a",
      link = "https://www2.census.gov/programs-surveys/demo/tables/hhp/2020/wk%s/health2a.xlsx",
      characteristics = c("Total",
        "Age",
        "Sex",
        "Hispanic origin and Race",
        "Education",
        "Marital status",
        "Presence of children",
        "Respondent or household member experienced loss of employment income",
        "Respondent currently employed",
        "Household income"),
      cnames = c("characteristics",
        "anxious_not_at_all",
        "anxious_several_days",
        "anxious_half",
        "anxious_everyday",
        "anxious_dnr",
        "worry_not_at_all",
        "worry_several_days",
        "worry_half",
        "worry_everyday",
        "worry_dnr"),
      skipRows = 6
    ),
    "Health Tables: Table 2b" = list(
      dbtable = "health2b",
      link = "https://www2.census.gov/programs-surveys/demo/tables/hhp/2020/wk%s/health2b.xlsx",
      characteristics = c("Total",
        "Age",
        "Sex",
        "Hispanic origin and Race",
        "Education",
        "Marital status",
        "Presence of children",
        "Respondent or household member experienced loss of employment income",
        "Respondent currently employed",
        "Household income"),
      cnames = c("characteristics",
        "no_interest_not_at_all",
        "no_interest_several_days",
        "no_interest_half",
        "no_interest_everyday",
        "no_interest_dnr",
        "depressed_not_at_all",
        "depressed_several_days",
        "depressed_half",
        "depressed_everyday",
        "depressed_dnr"),
      skipRows = 6
    ),
    "Health Tables: Table 1" = list(
      dbtable = "health1",
      link = "https://www2.census.gov/programs-surveys/demo/tables/hhp/2020/wk%s/health1.xlsx",
      characteristics = c("Total",
        "Age",
        "Sex",
        "Hispanic origin and Race",
        "Education",
        "Marital status",
        "Presence of children",
        "Respondent or household member experienced loss of employment income",
        "Respondent currently employed",
        "Household income"),
      cnames = c("characteristics",
        "delayed_yes",
        "delayed_no",
        "delayed_dnr",
        "needed_yes",
        "needed_no",
        "needed_dnr"),
      xskipRows = 6
    )
  )[[tname]]
}

data_sheets <- c("US", state.abb)
