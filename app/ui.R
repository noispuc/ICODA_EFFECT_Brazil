# construindo a UI do shiny que plotara o grafico
ui <- fluidPage(
  
  navbarPage('EFFECT-Brazil', 
             id = 'app', 
             theme = shinytheme('flatly'),
             
             tabPanel('Home',
                      useShinydashboard(),
                      mainPanel(width = 11, 
                                style='margin-left:4%; margin-right:4%',
                                introBox(  
                                  fluidRow(column(7,
                                                  h3('Welcome to EFFECT-Brazil app!', 
                                                     style='margin-top:0px;'),
                                                  h4('COVID-19 tracker and data explorer in Brazil - 
                                                      Explore state-level data on a variety of COVID-19 metrics according confirmed COVID-19 data in Brazil by: 
                                                      number of cases and case trends over time including deaths, hospitalizations and vaccines.', 
                                                     style='margin-top:0px;'))
                                  )
                                )
                      ),
                      
                      br(),
                      
                      fluidRow(
                        box(title = 'Cases', 
                            width = 3, 
                            background = 'blue',
                            'Explore the data on confirmed COVID-19 cases for Brazil',
                            br(),
                            actionBttn(inputId = 'switch_tab_cases',
                                       label = 'Acessar página',
                                       style = 'minimal',
                                       size = 'sm')),
                        
                        box(title = 'Deaths', 
                            width = 3, 
                            background = 'yellow',
                            'Explore the data on confirmed COVID-19 deaths for Brazil',
                            br(),
                            actionBttn(inputId = 'switch_tab_deaths',
                                       label = 'Acessar página',
                                       style = 'minimal',
                                       size = 'sm')),
                        
                        box(title = 'Hospitalizations', 
                            width = 3, 
                            background = 'red',
                            'Explore the data on confirmed COVID-19 hospitalizations for Brazil',
                            br(),
                            actionBttn(inputId = 'switch_tab_hospitalization',
                                       label = 'Acessar página',
                                       style = 'minimal',
                                       size = 'sm')),
                        
                        box(title = 'Vaccinations', 
                            width = 3, 
                            background = 'navy',
                            'Explore data on COVID-19 vaccine uptake and immunization coverage over time in Brazil',
                            br(),
                            actionBttn(inputId = 'switch_tab_vaccination',
                                       label = 'Acessar página',
                                       style = 'minimal',
                                       size = 'sm')),
                        
                        tags$div(style = "display:inherit; padding-top:3%; text-align:center;",
                                 ## Twitter
                                 actionButton(inputId = "twitter_share",
                                              label = "",
                                              icon = icon("twitter"),
                                              style = "background-color:#1DA1F2; border-color:#1DA1F2",
                                              onclick = sprintf("window.open('%s')", "https://twitter.com/intent/tweet?url=https://noispuc.shinyapps.io/effect-br-monitor/")),
                                 
                                 ## Facebook
                                 actionButton(inputId = "facebook_share",
                                              label = "",
                                              icon = icon("facebook"),
                                              style = "background-color:#4267B2; border-color:#4267B2",
                                              onclick = sprintf("window.open('%s')", "https://www.facebook.com/sharer/sharer.php?u=https://noispuc.shinyapps.io/effect-br-monitor/")),
                                 
                                 
                                 ## LinkedIn
                                 actionButton(inputId = "linkedin_share",
                                              label = "",
                                              icon = icon("linkedin"),
                                              style = "background-color:#0e76a8; border-color:#0e76a8",
                                              onclick = sprintf("window.open('%s')", "https://www.linkedin.com/shareArticle?mini=true&url=https://noispuc.shinyapps.io/effect-br-monitor/")),
                                 br(),
                                 img(src = '210812_Logo Lockup_IG2.jpg')
                        )
                        
                        
                      ),
             ),
             
             
             tabPanel('Cases',
                      mainPanel(width = 11, 
                                style='margin-left:4%; margin-right:4%',
                                introBox(  
                                  fluidRow(column(12,
                                                  h3('Explore the data on confirmed COVID-19 cases for Brazil', 
                                                     style='margin-top:0px;')))
                                ),
                                
                                br()
                                
                      ),
                      
                      sidebarLayout(
                        # criando barra lateral para inputar dados
                        sidebarPanel(
                          useShinyjs(),
                          
                          # criando caixa de selecao de variavel plotada
                          varSelectInput(inputId = 'cases_metric',
                                         label = 'Metric:',
                                         data = casos_colunas, 
                                         selected = 'New cases',
                                         multiple = TRUE),
                          
                          # criando caixa de intervalo temporal
                          dateRangeInput(inputId = 'cases_date',
                                         label = 'Tracking date (dd/mm/yy):',
                                         start = max(cases_Brazil$date) - months(6),
                                         end = max(cases_Brazil$date),
                                         format = 'dd/mm/yy'),
                          
                          # criando botão de escolha de agrupamento
                          # radioGroupButtons(inputId = 'cases_groupby',
                          #                   label = 'Group by:', 
                          #                   choices = list('State' = 'state',
                          #                                  'City' = 'city'),
                          #                   status = 'primary'),
                          
                          # criando caixa de selecao de estados
                          selectInput(inputId = 'cases_state',
                                      label = 'State:',
                                      choices = estados_casos_obitos, # precisa ser um vetor com valores unicos
                                      selected = 'RJ'),
                          
                          # criando caixa de selecao de cidades
                          # selectInput(inputId = 'cases_city',
                          #             label = 'City:',
                          #             choices = NULL),
                          
                          # criando caixa para cálculo com ou sem média móvel
                          selectInput(inputId = 'cases_mean',
                                      label = 'Plot the Moving Average',
                                      choices = list('No' = 'withoutmean',
                                                     'Yes (display the Moving Average only)' = 'withmean',
                                                     'Yes (display both)' = 'both'),
                                      selected = 'withoutmean'),
                          
                          # criando caixa de selecao de periodos de media movel
                          # a caixa começa escondida quando o app é iniciado
                          hidden(sliderInput(inputId = 'cases_MA_size',
                                             label = 'Period:',
                                             min = 1,
                                             max = 14,
                                             value = 7)),
                          
                          # criando a referência aos dados
                          h6('Source: W. Cota, “Monitoring the number of COVID-19 cases and deaths in brazil at municipal and federative units level”, SciELOPreprints:362 (2020), 10.1590/scielopreprints.362',
                             style='margin-top:0px;'),
                          
                          tags$a(href="https://github.com/wcota/covid19br", "https://github.com/wcota/covid19br")
                        ),
                        
                        
                        # painel principal para apresentar outputs
                        mainPanel(dygraphOutput(outputId = 'cases_plot'))
                        
                      ),
                      
                      
                      # painel principal para apresentar outputs
                      mainPanel(br(),
                                
                                width = 11, 
                                style='margin-left:4%; margin-right:4%',
                                
                                introBox(  
                                  fluidRow(column(12,
                                                  h3('Geographical visualization of data by state/city on sociodemographic aspects and on confirmed cases of COVID-19 in Brazil', 
                                                     style='margin-top:0px;')))
                                ),
                                
                                br()
                      ),
                      
                      mainPanel(
                        fluidRow(
                          useShinyjs(),
                          
                          
                          splitLayout(cellWidths = c('50%', '50%'),
                                      # criando filtro de data
                                      sliderInput(inputId = 'cases_date2',
                                                  'Date:',
                                                  min = as.Date(min(cases_Brazil$date),'%Y-%m-%d'),
                                                  max = as.Date(max(cases_Brazil$date),'%Y-%m-%d'),
                                                  value=as.Date(max(cases_Brazil$date)),
                                                  timeFormat='%d-%m-%Y')),
                          
                          splitLayout(cellWidths = c('50%', '50%'),
                                      # criando caixa de selecao de variavel plotada
                                      varSelectInput(inputId = 'cases_metric2',
                                                     label = 'Metric (state-level):',
                                                     data = casos_colunas, 
                                                     selected = 'New cases',
                                                     multiple = FALSE,
                                                     selectize = FALSE,
                                                     size = 3),
                                      
                                      # criando caixa de selecao de variavel plotada
                                      varSelectInput(inputId = 'demographic_metric1',
                                                     label = 'Metric (city-level):',
                                                     data = sociodem_colunas, 
                                                     selected = 'Per capita GDP',
                                                     multiple = FALSE,
                                                     selectize = FALSE,
                                                     size = 3,
                                                     width = '110%')),
                          
                          splitLayout(cellWidths = c('50%', '50%'),
                                      plotOutput(outputId = 'cases_map'),
                                      
                                      plotOutput(outputId = 'demographic_map1'))
                        )
                      )
                      
             ),
             
             
             tabPanel('Deaths',
                      mainPanel(width = 11, 
                                style='margin-left:4%; margin-right:4%',
                                introBox(  
                                  fluidRow(column(12,
                                                  h3('Explore the data on confirmed COVID-19 deaths for Brazil', 
                                                     style='margin-top:0px;')))
                                ),
                                
                                br()
                                
                      ),
                      
                      sidebarLayout(
                        # criando barra lateral para inputar dados
                        sidebarPanel(
                          useShinyjs(),
                          
                          # criando caixa de selecao de variavel plotada
                          varSelectInput(inputId = 'deaths_metric',
                                         label = 'Metric:',
                                         data = obitos_colunas, 
                                         selected = 'Recent deaths registered',
                                         multiple = TRUE),
                          
                          # criando caixa de intervalo temporal
                          dateRangeInput(inputId = 'deaths_date',
                                         label = 'Tracking date (dd/mm/yy)',
                                         start = max(deaths_Brazil$date)- months(6),
                                         end = max(deaths_Brazil$date),
                                         format = 'dd/mm/yy'),
                          
                          # criando botão de escolha de agrupamento
                          # radioGroupButtons(inputId = 'deaths_groupby',
                          #                   label = 'Group by:', 
                          #                   choices = list('State' = 'state',
                          #                                  'City' = 'city'),
                          #                   status = 'primary'),
                          
                          # criando caixa de selecao de estados
                          selectInput(inputId = 'deaths_state',
                                      label = 'State:',
                                      choices = estados_casos_obitos, # precisa ser um vetor com valores unicos
                                      selected = 'RJ'),
                          
                          # criando caixa de selecao de cidades
                          # selectInput(inputId = 'deaths_city',
                          #             label = 'City:',
                          #             choices = NULL),
                          
                          # criando caixa para cálculo com ou sem média móvel
                          selectInput(inputId = 'deaths_mean',
                                      label = 'Plot the Moving Average',
                                      choices = list('No' = 'withoutmean',
                                                     'Yes (display the Moving Average only)' = 'withmean',
                                                     'Yes (display both)' = 'both'),
                                      selected = 'withoutmean'),
                          
                          # criando caixa de selecao de periodos de media movel
                          # a caixa começa escondida quando o app é iniciado
                          hidden(sliderInput(inputId = 'deaths_MA_size',
                                             label = 'Period:',
                                             min = 1,
                                             max = 14,
                                             value = 7)),
                          
                          # criando a referência aos dados
                          h6('Source: W. Cota, “Monitoring the number of COVID-19 cases and deaths in brazil at municipal and federative units level”, SciELOPreprints:362 (2020), 10.1590/scielopreprints.362',
                             style='margin-top:0px;'),
                          
                          tags$a(href="https://github.com/wcota/covid19br", "https://github.com/wcota/covid19br")
                        ),
                        
                        # painel principal para apresentar outputs
                        mainPanel(dygraphOutput(outputId = 'deaths_plot'))
                        
                      ),
                      
                      mainPanel(width = 11, 
                                style='margin-left:4%; margin-right:4%',
                                br(),
                                
                                introBox(  
                                  fluidRow(column(12,
                                                  h3('Geographical visualization of data by state/city on sociodemographic aspects and on confirmed deaths of COVID-19 in Brazil', 
                                                     style='margin-top:0px;')))
                                ),
                                
                                br()
                                
                      ),
                      
                      mainPanel(
                        fluidRow(
                          useShinyjs(),
                          
                          
                          splitLayout(cellWidths = c('50%', '50%'),
                                      # criando filtro de data
                                      sliderInput(inputId = 'deaths_date2',
                                                  'Arraste para selecionar a data:',
                                                  min = as.Date(min(deaths_Brazil$date),'%Y-%m-%d'),
                                                  max = as.Date(max(deaths_Brazil$date),'%Y-%m-%d'),
                                                  value=as.Date(max(deaths_Brazil$date)),
                                                  timeFormat='%d-%m-%Y')),
                          
                          splitLayout(cellWidths = c('50%', '50%'),
                                      # criando caixa de selecao de variavel plotada
                                      varSelectInput(inputId = 'deaths_metric2',
                                                     label = 'Metric (state-level):',
                                                     data = obitos_colunas, 
                                                     selected = 'Recent deaths registered',
                                                     multiple = FALSE,
                                                     selectize = FALSE,
                                                     size = 3),
                                      
                                      # criando caixa de selecao de variavel plotada
                                      varSelectInput(inputId = 'demographic_metric2',
                                                     label = 'Metric (city-level):',
                                                     data = sociodem_colunas, 
                                                     selected = 'Per capita GDP',
                                                     multiple = FALSE,
                                                     selectize = FALSE,
                                                     size = 3,
                                                     width = '110%')),
                          
                          splitLayout(cellWidths = c('50%', '50%'),
                                      plotOutput(outputId = 'deaths_map'),
                                      
                                      plotOutput(outputId = 'demographic_map2'))
                        )
                      )
                      
             ),
             
             tabPanel('Hospitalizations',
                      menuItem('Source code', icon = icon('file-code-o'), 
                               href = 'https://github.com/lslbastos/Bastos_Ranzani_etal_COVID19_ChangeWaves'),
                      fluidRow(
                        tags$iframe(
                          seamless = 'seamless',
                          src = 'https://lslbastos.shinyapps.io/sivep_covid_brazil/',
                          height = 800, width = 1400))
                      
                      
             ),
             
             tabPanel('Vaccinations',
                      mainPanel(width = 11, 
                                style='margin-left:4%; margin-right:4%',
                                introBox(  
                                  fluidRow(column(12,
                                                  h3('Explore data on COVID-19 vaccine uptake and immunization coverage over time in Brazil', 
                                                     style='margin-top:0px;')))
                                ),
                                
                                br()
                                
                      ),
                      
                      sidebarLayout(
                        # criando barra lateral para inputar dados
                        sidebarPanel(
                          useShinyjs(),
                          
                          # criando caixa de selecao de variavel plotada
                          varSelectInput(inputId = 'vaccination_metric',
                                         label = 'Metric:',
                                         data = vacinacao_colunas, 
                                         selected = '1st dose vaccinations (except Johnson & Johnson/Janssen)',
                                         multiple = TRUE),
                          
                          # criando caixa de intervalo temporal
                          dateRangeInput(inputId = 'vaccination_date',
                                         label = 'Tracking date (dd/mm/yy):',
                                         start = max(vaccination_Brazil$date) - months(6),
                                         end = max(vaccination_Brazil$date),
                                         format = 'dd/mm/yy'),
                          
                          # criando caixa de selecao de estados
                          selectInput(inputId = 'vaccination_state',
                                      label = 'State:',
                                      choices = estados_vacinacao, # precisa ser um vetor com valores unicos
                                      selected = 'RJ'),
                          
                          # criando a referência aos dados
                          h6('Source: W. Cota, “Monitoring the number of COVID-19 cases and deaths in brazil at municipal and federative units level”, SciELOPreprints:362 (2020), 10.1590/scielopreprints.362',
                             style='margin-top:0px;'),
                          
                          tags$a(href="https://github.com/wcota/covid19br", "https://github.com/wcota/covid19br")
                          
                        ),
                        
                        # painel principal para apresentar outputs
                        mainPanel(dygraphOutput(outputId = 'vaccination_plot'))
                        
                      ),
                      
                      mainPanel(width = 11, 
                                style='margin-left:4%; margin-right:4%',
                                br(),
                                br(),
                                
                                introBox(  
                                  fluidRow(column(12,
                                                  h3('Geographical visualization of data by state/city on sociodemographic aspects and on vaccine uptake and immunization coverage of COVID-19 in Brazil', 
                                                     style='margin-top:0px;')))
                                ),
                                
                                br()
                                
                                
                                
                      ),
                      
                      mainPanel(
                        fluidRow(
                          useShinyjs(),
                          
                          
                          splitLayout(cellWidths = c('50%', '50%'),
                                      # criando filtro de data
                                      sliderInput(inputId = 'vaccination_date2',
                                                  'Date:',
                                                  min = as.Date(min(vaccination_Brazil$date),'%Y-%m-%d'),
                                                  max = as.Date(max(vaccination_Brazil$date),'%Y-%m-%d'),
                                                  value=as.Date(max(vaccination_Brazil$date)),
                                                  timeFormat='%d-%m-%Y')),
                          
                          splitLayout(cellWidths = c('50%', '50%'),
                                      # criando caixa de selecao de variavel plotada
                                      varSelectInput(inputId = 'vaccination_metric2',
                                                     label = 'Metric (state-level):',
                                                     data = vacinacao_colunas, 
                                                     selected = '1st dose vaccinations (except Johnson & Johnson/Janssen)',
                                                     multiple = FALSE,
                                                     selectize = FALSE,
                                                     size = 3),
                                      
                                      # criando caixa de selecao de variavel plotada
                                      varSelectInput(inputId = 'demographic_metric4',
                                                     label = 'Metric (city-level):',
                                                     data = sociodem_colunas, 
                                                     selected = 'Per capita GDP',
                                                     multiple = FALSE,
                                                     selectize = FALSE,
                                                     size = 3,
                                                     width = '110%')),
                          
                          splitLayout(cellWidths = c('50%', '50%'),
                                      plotOutput(outputId = 'vaccination_map'),
                                      
                                      plotOutput(outputId = 'demographic_map4'))
                        )
                      )
                      
                      
             )
             
             
  )
)
