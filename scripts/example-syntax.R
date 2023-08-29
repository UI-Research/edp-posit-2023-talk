library(tidyverse)
library(educationdata)

# How has Carleton College tuition changed since the 90s?
carleton_unitid <- "173258"

carleton_data <- get_education_data(
    level = "college-university",
    source = "ipeds",
    topic = "academic-year-tuition",
    filters = list(year = c(1990:2020), unitid = carleton_unitid)
)

carleton_data %>%
    filter(tuition_type == 4) %>%
    ggplot(aes(x = year, y = tuition_fees_ft)) +
    geom_line()

# How about the University of Chicago?
uchicago_unitid <- "144050"

uchicago_data <- get_education_data(
    level = "college-university",
    source = "ipeds",
    topic = "academic-year-tuition",
    filters = list(year = c(1990:2020), unitid = uchicago_unitid)
)

uchicago_data %>%
    filter(tuition_type == 4, level_of_study == 2) %>%
    ggplot(aes(x = year, y = tuition_fees_ft)) +
    geom_line()

# TODO: How can I compare that to the median income in the Census tract?


# How can I compare the average between public and private colleges?
private_public_avg_data <- get_education_data_summary(
    level = "college-university",
    source = "ipeds",
    topic = "academic-year-tuition",
    stat = "avg",
    var = "tuition_fees_ft",
    by = "sector",
    filters = list(level_of_study = 1, tuition_type = 4)
)

private_public_avg_data %>%
    filter(sector %in% list(1, 2)) %>%
    mutate(sector = factor(sector) %>%
               fct_recode("public" = "1",
                          "private" = "2")) %>%
    ggplot(aes(x = year, y = tuition_fees_ft, group = sector, color = sector)) +
    geom_line()
