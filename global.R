# packages ----------------------------------------------------------------
library(shiny)
library(shinydashboard)
library(lubridate)
library(tidyverse)
library(data.table)
library(ggplot2)
library(plotly)
library(Cairo)
options(shiny.usecairo = TRUE)
library(shinycssloaders)
# constants ---------------------------------------------------------------
adj_coef <- 2.422
std.df <- read.csv("data/standard_data.csv", header = TRUE, sep = ',')