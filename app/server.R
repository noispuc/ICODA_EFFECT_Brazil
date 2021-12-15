server  <- function(input, output, session)({
  # leva para a aba de Casos
  observeEvent(input$switch_tab_cases, {
    updateTabsetPanel(session, 
                      inputId = 'app',
                      selected = 'Casos')
  })
  # leva para a aba de Óbitos
  observeEvent(input$switch_tab_deaths, {
    updateTabsetPanel(session, 
                      inputId = 'app',
                      selected = 'Óbitos')
  })
  # leva para a aba de Hospitalizações
  observeEvent(input$switch_tab_hospitalization, {
    updateTabsetPanel(session, 
                      inputId = 'app',
                      selected = 'Hospitalizações')
  })
  # leva para a aba de Vacinação
  observeEvent(input$switch_tab_vaccination, {
    updateTabsetPanel(session, 
                      inputId = 'app',
                      selected = 'Vacinação')
  })
  
  
  ### Aba Casos ####  
  
  variaveis <- reactive({ get(input$cases_metric) })
  
  create_cases_dygraph <- reactive({validate(up_two(input$cases_metric, input$cases_mean))
    
    filtered <- filter(cases_Brazil,
                       state == input$cases_state,
                       date <= max(input$cases_date),
                       date >= min(input$cases_date))
    
    
    series <- xts(select(filtered,!!!input$cases_metric),
                  order.by = as.Date(filtered$date))
    
    if (input$cases_mean == 'withmean') {
      series <- rollmean(series, k = input$cases_MA_size, align  = 'right')
      colnames(series) = paste(colnames(series), 'media_movel', sep = '_')
      observe(show('cases_MA_size'))
    } else if (input$cases_mean == 'both') {
      series_mean <- rollmean(series, k = input$cases_MA_size, align  = 'right')
      colnames(series_mean) = paste(colnames(series_mean), 'media_movel', sep = '_')
      series <- cbind(series, series_mean)
      observe(show('cases_MA_size'))
    }
    
    
    create_dygraph(series, input$cases_metric)
    
  })
  
  # dygraph de casos
  output$cases_plot <- renderDygraph({create_cases_dygraph()})
  
  # mapa de casos
  output$cases_map <- renderPlot({create_covid_map(cases_Brazil, 
                                                   input$cases_date2, 
                                                   input$cases_metric2)})
  
  # mapa sociodemográfico
  output$demographic_map1<- renderPlot({create_sociodem_map(input$demographic_metric1)})
  
  
  
  ### Aba Óbitos ####  
  
  variaveis <- reactive({ get(input$deaths_metric) })
  
  create_deaths_dygraph <- reactive({validate(up_two(input$deaths_metric, input$deaths_mean))
    
    filtered <- filter(deaths_Brazil,
                       state == input$deaths_state,
                       date <= max(input$deaths_date),
                       date >= min(input$deaths_date))
    
    
    series <- xts(select(filtered,!!!input$deaths_metric),
                  order.by = as.Date(filtered$date))
    
    if (input$deaths_mean == 'withmean') {
      series <- rollmean(series, k = input$deaths_MA_size, align  = 'right')
      colnames(series) = paste(colnames(series), 'media_movel', sep = '_')
      observe(show('deaths_MA_size'))
    } else if (input$deaths_mean == 'both') {
      series_mean <- rollmean(series, k = input$deaths_MA_size, align  = 'right')
      colnames(series_mean) = paste(colnames(series_mean), 'media_movel', sep = '_')
      series <- cbind(series, series_mean)
      observe(show('deaths_MA_size'))
    }
    
    
    create_dygraph(series, input$deaths_metric)
    
    
  })
  
  # dygraph de óbitos
  output$deaths_plot <- renderDygraph({create_deaths_dygraph()})
  
  # mapa de óbitos
  output$deaths_map <- renderPlot({create_covid_map(deaths_Brazil, 
                                                    input$deaths_date2, 
                                                    input$deaths_metric2)})
  
  # mapa sociodemográfico
  output$demographic_map2<- renderPlot({create_sociodem_map(input$demographic_metric2)})
  
  
  
  
  ### Aba Vacinação ####  
  
  variaveis <- reactive({ get(input$vaccination_metric) })
  
  create_vaccination_dygraph <- reactive({
    
    filtered <- filter(vaccination_Brazil,
                       state == input$vaccination_state,
                       date <= max(input$vaccination_date),
                       date >= min(input$vaccination_date))
    
    
    series <- xts(select(filtered,!!!input$vaccination_metric),
                  order.by = as.Date(filtered$date))
    
    
    create_dygraph(series, input$vaccination_metric)
    
    
  })
  
  # dygraph de vacinação
  output$vaccination_plot <- renderDygraph({create_vaccination_dygraph()})
  
  # mapa de vacinação
  output$vaccination_map <- renderPlot({create_covid_map(vaccination_Brazil, 
                                                         input$vaccination_date2, 
                                                         input$vaccination_metric2)})
  
  # mapa sociodemográfico
  output$demographic_map4 <- renderPlot({create_sociodem_map(input$demographic_metric4)})
  
})
  



