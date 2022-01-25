# install.packages('tidyverse')
# install.packages('shiny')
# install.packages('shinythemes')
# install.packages('rsconnect')
# install.packages('dygraphs')
# install.packages('shinyjs')
# install.packages('plotly')
# install.packages('png')
# install.packages('ggplot2')
# install.packages('ggplotify')
# install.packages('DescTools')
# install.packages('argonR')
# install.packages('argonR')
# install.packages('devtools')
# install.packages('geobr')
# install.packages('sf')
# install.packages('data.table')
# install.packages('DT')
# install.packages('scales')

library(tidyverse)
library(shiny)
library(shinythemes)
library(rsconnect)
library(dygraphs)
library(xts)
library(dplyr)
library(zoo)
library(plotly)
library(shinyjs)
library(ggplot2)
library(ggplotify)
library(DescTools)
library(readxl)
library(shinydashboard)
library(shinyWidgets)
library(rintrojs)
library(shinyjs)
library(lubridate)
library(plotly)
# library(geobr)
library(sf)
library(data.table)
library(scales)
library(lubridate)
library(DT)


# importando funções criadas
source('functions/plot_functions.R')
source('functions/utils.R')


# importação de dados
source('data/data_preparation.R')


# configuração padrão para mapas
# all_muni <- read_municipality(year = 2019)
# states <- read_state(year = 2019)
all_muni <- read_rds('shape_files/shp_brazil_municipalities.rds')
states <- read_rds('shape_files/shp_state_brazil_map.rds')
no_axis <- theme(axis.title = element_blank(),
                 axis.text = element_blank(),
                 axis.ticks = element_blank())
options(scipen = 10000) # definição de ausência de Notação Científica


source('ui.R') 
source('server.R')

shinyApp(ui = ui,
         server = server)
