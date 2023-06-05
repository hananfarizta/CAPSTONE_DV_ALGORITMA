
#Library deploy
library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(glue)
library(scales)
library(DT)
library(lubridate)
library(ggplot2)
library(padr)
library(broom)
library(kableExtra)
library(magrittr)
library(dplyr)
library(tidyr)

#Read Data
coffee_ratings <- read_csv ("coffee_ratings.csv")

#data preparation 
cof_clean <- coffee_ratings %>%
  drop_na()

# tema yang sudah dicustom
theme_coffee <- theme(legend.key = element_rect(fill="grey"),
                     legend.background = element_rect(color="red",
                                                      fill="#263238"),
                     plot.subtitle = element_text(size=6, color="red"),
                     panel.background = element_rect(fill="#dddddd"),
                     panel.border = element_rect(fill=NA),
                     panel.grid.minor.x = element_blank(),
                     panel.grid.major.x = element_blank(),
                     panel.grid.major.y = element_line(color="darkgrey",
                                                       linetype=2),
                     panel.grid.minor.y = element_blank(),
                     plot.background = element_rect(fill="#263238"),
                     text = element_text(color="red"),
                     axis.text = element_text(color="black"))
