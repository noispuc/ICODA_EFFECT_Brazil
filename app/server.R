server  <- function(input, output, session)({
  # leva para a aba de Casos
  observeEvent(input$switch_tab_cases, {
    updateTabsetPanel(session, 
                      inputId = 'app',
                      selected = 'Cases')
  })
  # leva para a aba de Óbitos
  observeEvent(input$switch_tab_deaths, {
    updateTabsetPanel(session, 
                      inputId = 'app',
                      selected = 'Deaths')
  })
  # leva para a aba de Hospitalizações
  observeEvent(input$switch_tab_hospitalization, {
    updateTabsetPanel(session, 
                      inputId = 'app',
                      selected = 'Hospitalizations')
  })
  # leva para a aba de Vacinação
  observeEvent(input$switch_tab_vaccination, {
    updateTabsetPanel(session, 
                      inputId = 'app',
                      selected = 'Vaccinations')
  })
  
  
  ### Aba Casos ####  
  
  variaveis <- reactive({ get(input$cases_metric) })
  
  create_cases_plotly <- reactive({validate(up_two(input$cases_metric, input$cases_mean))
    
    filtered <- filter(cases_Brazil,
                       state == input$cases_state,
                       date <= max(input$cases_date),
                       date >= min(input$cases_date))
    
    
    series <- xts(select(filtered,!!!input$cases_metric),
                  order.by = as.Date(filtered$date))
    
    
    if (input$cases_mean == 'withmean') {
      series <- rollmean(series, k = input$cases_MA_size, align  = 'right')
      colnames(series) = paste(colnames(series), 'moving average', sep = ' ')
      observe(show('cases_MA_size'))
    } else if (input$cases_mean == 'both') {
      series_mean <- rollmean(series, k = input$cases_MA_size, align  = 'right')
      colnames(series_mean) = paste(colnames(series_mean), 'moving average', sep = ' ')
      series <- cbind(series, series_mean)
      observe(show('cases_MA_size'))
    }
    
    colnames(series) = gsub("\\.", " ", colnames(series)) # removendo o "." do nome das colunas
    
    series <- as.data.frame(series)
    series <- rownames_to_column(series, 'date')
    series$date <- as.Date(series$date)
    
    create_plotly(series, input$cases_metric)
    
  })
  
  # plotly de casos
  output$cases_plot <- renderPlotly({create_cases_plotly()})
  
  #botão de download de casos
  
  output$table_out_cases  <- DT::renderDataTable(
    datatable(
      cases_Brazil,
      rownames = TRUE, 
      options = list(
        fixedColumns = FALSE,
        autoWidth = FALSE,
        ordering = FALSE,
        lengthMenu = list(c(10,50,100, -1), 
                          c('10', '50', '100','All')),
        dom = 'Btlfipr',
        buttons = c('copy', 'csv', 'excel', 'pdf')
      ),
      class = "display", 
      extensions = "Buttons"
    ))
  
  # mapa de casos
  output$cases_map <- renderPlot({create_covid_map(cases_Brazil, 
                                                   input$cases_date2, 
                                                   input$cases_metric2)})
  
  # mapa sociodemográfico
  output$demographic_map1<- renderPlot({create_sociodem_map(input$demographic_metric1)})
  

  
  ### Aba Óbitos ####  
  
  variaveis <- reactive({ get(input$deaths_metric) })
  
  create_deaths_plotly <- reactive({validate(up_two(input$deaths_metric, input$deaths_mean))
    
    filtered <- filter(deaths_Brazil,
                       state == input$deaths_state,
                       date <= max(input$deaths_date),
                       date >= min(input$deaths_date))
    
    
    series <- xts(select(filtered,!!!input$deaths_metric),
                  order.by = as.Date(filtered$date))
    
    if (input$deaths_mean == 'withmean') {
      series <- rollmean(series, k = input$deaths_MA_size, align  = 'right')
      colnames(series) = paste(colnames(series), 'moving average', sep = ' ')
      observe(show('deaths_MA_size'))
    } else if (input$deaths_mean == 'both') {
      series_mean <- rollmean(series, k = input$deaths_MA_size, align  = 'right')
      colnames(series_mean) = paste(colnames(series_mean), 'moving average', sep = ' ')
      series <- cbind(series, series_mean)
      observe(show('deaths_MA_size'))
    }
    
    colnames(series) = gsub("\\.", " ", colnames(series)) # removendo o "." do nome das colunas
    
    series <- as.data.frame(series)
    series <- rownames_to_column(series, 'date')
    series$date <- as.Date(series$date)
    
    create_plotly(series, input$deaths_metric)
    
    
  })
  
  # plotly de óbitos
  output$deaths_plot <- renderPlotly({create_deaths_plotly()})
  
  
  #botão de download de óbitos
  output$table_out_deaths  <- DT::renderDataTable(
    datatable(
      deaths_Brazil,
      rownames = TRUE, 
      options = list(
        fixedColumns = FALSE,
        autoWidth = FALSE,
        ordering = FALSE,
        lengthMenu = list(c(10,50,100, -1), 
                          c('10', '50', '100','All')),
        dom = 'Btlfipr',
        buttons = c('copy', 'csv', 'excel', 'pdf')
      ),
      class = "display", 
      extensions = "Buttons"
    ))
  
  # mapa de óbitos
  output$deaths_map <- renderPlot({create_covid_map(deaths_Brazil, 
                                                    input$deaths_date2, 
                                                    input$deaths_metric2)})
  
  # mapa sociodemográfico
  output$demographic_map2<- renderPlot({create_sociodem_map(input$demographic_metric2)})

  
  ### Aba Vacinação ####  
  
  variaveis <- reactive({ get(input$vaccination_metric) })
  
  create_vaccination_plotly <- reactive({
    
    filtered <- filter(vaccination_Brazil,
                       state == input$vaccination_state,
                       date <= max(input$vaccination_date),
                       date >= min(input$vaccination_date))
    
    series <- xts(select(filtered,!!!input$vaccination_metric),
                  order.by = as.Date(filtered$date))
    
    colnames(series) = gsub("\\.", " ", colnames(series)) # removendo o "." do nome das colunas
    
    series <- as.data.frame(series)
    series <- rownames_to_column(series, 'date')
    series$date <- as.Date(series$date)

    
    create_plotly(series, input$vaccination_metric)
    
    
  })
  
  # plotly de vacinação
  output$vaccination_plot <- renderPlotly({create_vaccination_plotly()})

  
  #botão de download de vacinação
  
  output$table_out_vaccination  <- DT::renderDataTable(
    datatable(
      vaccination_Brazil,
      rownames = FALSE,
      options = list(
        fixedColumns = FALSE,
        order = list(1, 'desc'),
        autoWidth = TRUE,
        ordering = FALSE,
        scrollX = TRUE,
        lengthMenu = list(c(10,50,100, -1), 
                          c('10', '50', '100','All')),
        dom = 'Btlfipr',
        buttons = c('copy', 'csv', 'excel', 'pdf')
      ),
      class = "display", 
      extensions = "Buttons"
    ))
  
   # 1º plotly estatísticas de vacinação
  
  output$graph_1 <- renderPlotly({vaccination_Brazil %>% 
      inner_join(Brazil_Populations)%>%
      filter(date == input$vaccination_date_statistics,
             state != "TOTAL") %>% 
      mutate(fully_vaccinated_ratio = `People fully vaccinated`/`Population`) %>% 
      subset(state %in% c(input$vaccination_state_statistics))%>%
      mutate(state.order = reorder(state,fully_vaccinated_ratio )) %>%
      plot_ly(y = ~state.order,
              x = ~ round(100 * fully_vaccinated_ratio, 2),
              text = ~ paste(round(100 *  fully_vaccinated_ratio, 1), "%"),
              textposition = 'auto',
              orientation = "h",
              type = "bar") %>%
      layout(title = "Percentage of Fully Vaccinated Population - Brazilian States",
             yaxis = list(title = ""),
             xaxis = list(title = "Source: https://github.com/wcota/covid19br",
                          ticksuffix = "%",
                          range = c(0, 100)))
  })
  
  
  # 2º plotly estatísticas de vacinação
  
  output$graph_2 <- renderPlotly({
    p <- plotly::plot_ly()
    
    p <- p %>% plotly::add_lines(data = vaccination_Brazil %>% 
                                   inner_join(Brazil_Populations)%>%
                                   filter(state != "TOTAL") %>% 
                                   mutate(fully_vaccinated_ratio = `People fully vaccinated`*(100000)/`Population`) %>% 
                                   subset(state %in% c(input$vaccination_state_statistics)), 
                                 x = ~date, 
                                 y = ~fully_vaccinated_ratio,
                                 color = ~ordered(state))
    
    p %>% 
      layout(title = "Vaccinated Population per 100k Inhabitants - Brazilian States",
             yaxis = list(title = "",
                          range = c(0, 100000)),
             xaxis = list(title = "Source: https://github.com/wcota/covid19br"))
  })
  
  # mapa de vacinação
  output$vaccination_map <- renderPlot({create_covid_map(vaccination_Brazil, 
                                                         input$vaccination_date2, 
                                                         input$vaccination_metric2)})
  
  # mapa sociodemográfico
  output$demographic_map4 <- renderPlot({create_sociodem_map(input$demographic_metric4)})
  
  
})
  



