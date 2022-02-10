# função para criação de dygraph
create_dygraph <- function(df, input_metric) {
  
  plot_dygraph <- dygraph(df) %>%
    {# fluxo de plotar duas variaveis
      if(length(input_metric) > 1 )
        dySeries(.,str(input_metric[2]), axis = 'y2')
      else
        .
    } %>%
    dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = FALSE) %>% # mexendo na estrutura do grafico
    dyHighlight(highlightCircleSize = 5, 
                highlightSeriesBackgroundAlpha = 0.5) # config ao passar mouse em cima do grafico
  
}


# função para criação de gráfico com plotly
create_plotly <- function(df, input_metric) {
  
  if(length(input_metric) == 1){# fluxo de plotar apenas 1 variável
    plot_ly() %>%
      add_lines(data = df,
                x = ~date,
                y = ~df[[as.name(input_metric[[1]])]],
                yaxis = 'y1') %>%
      layout(yaxis = list(title = as_name(input_metric[[1]]) ))
  } else {# fluxo de plotar duas variaveis
    plot_ly() %>%
      add_lines(data = df,
                x = ~date,
                y = ~df[[as.name(input_metric[[1]])]],
                name = as_name(input_metric[[1]]),
                yaxis = 'y1') %>%
      layout(yaxis = list(title = as_name(input_metric[[1]]) )) %>%
      add_lines(data = df,
                x = ~date,
                y = ~df[[as.name(input_metric[[2]])]],
                name = as_name(input_metric[[2]]),
                yaxis = 'y2') %>%
      layout(yaxis2 = list(overlaying = 'y',
                           side = 'right',
                           title = as_name(input_metric[[2]])))
  }
  
  
    
  
}



# função para criação de mapa com variáveis de COVID
create_covid_map <- function(df, input_date, input_metric) {
  
  corona_res <- df %>% 
    filter(date == input_date,
           state != 'TOTAL') %>% 
    select(state, input_metric)
  
  states <- left_join(states, corona_res, by = c('abbrev_state' = 'state'))
  
  titulo_map <- input_metric
  
  plot_map <- ggplot() +
    geom_sf(data = states, 
            aes_string(fill = input_metric), 
            color = NA) +
    labs(title = titulo_map, 
         size = 15,
         caption = "Source: https://github.com/wcota/covid19br") +
    scale_fill_distiller(palette = 'BuPu',
                         direction = 1) +
    theme_minimal() +
    theme(legend.title = element_blank(), 
          legend.position = c(0.2, 0.2)) +
    no_axis 
  
  return(plot_map)
}



# função para criação de mapa sociodemografico
create_sociodem_map <- function(metric){
  
  
  sociodem_res <- select(mysociodata_Brazil,
                         c('codigo', metric))
  
  all_muni <- left_join(all_muni, sociodem_res, by = c('code_muni' = 'codigo'))
  
  titulo_map <- metric
  
  plot_map <- ggplot() +
    geom_sf(data = all_muni, aes_string(fill = metric), 
            color = NA) +
    labs(title = titulo_map, 
         size = 15,
         caption = "Source:IBGE and DataSUS' open data") +
    scale_fill_distiller(palette = 'YlOrBr',
                         direction = 1) +
    theme_minimal() +
    theme(legend.title = element_blank(),
          legend.position = c(0.2, 0.2))+
    no_axis 
  
  return(plot_map)
}

