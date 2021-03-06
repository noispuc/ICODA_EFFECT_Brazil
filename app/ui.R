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
                                                  h3('Welcome to EFFECT-Brazil Monitor app!', 
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
                                       label = 'Take me there',
                                       style = 'minimal',
                                       size = 'sm')),
                        
                        box(title = 'Deaths', 
                            width = 3, 
                            background = 'yellow',
                            'Explore the data on confirmed COVID-19 deaths for Brazil',
                            br(),
                            actionBttn(inputId = 'switch_tab_deaths',
                                       label = 'Take me there',
                                       style = 'minimal',
                                       size = 'sm')),
                        
                        box(title = 'Hospitalizations', 
                            width = 3, 
                            background = 'red',
                            'Explore the data on confirmed COVID-19 hospitalizations for Brazil',
                            br(),
                            actionBttn(inputId = 'switch_tab_hospitalization',
                                       label = 'Take me there',
                                       style = 'minimal',
                                       size = 'sm')),
                        
                        box(title = 'Vaccinations', 
                            width = 3, 
                            background = 'navy',
                            'Explore data on COVID-19 vaccine uptake and immunization coverage over time in Brazil',
                            br(),
                            actionBttn(inputId = 'switch_tab_vaccination',
                                       label = 'Take me there',
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
                                 img(src = 'logo.png')
                        )
                        
                        
                      ),
             ),
             
             
             tabPanel('Cases',
                      tabsetPanel(
                        tabPanel(
                          title = "Overview",
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
                                             label = 'Date range (dd/mm/yy):',
                                             start = max(cases_Brazil$date) - months(1),
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
                              useShinyjs(),
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
                            mainPanel(plotlyOutput(outputId = 'cases_plot'))
                            
                          ),
                        ),
                          
                          tabPanel(
                            title = "Geo Heat Maps",
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
                                                        animate=animationOptions(interval = 700, loop = FALSE),
                                                        timeFormat='%d-%m-%Y')),
                                
                                splitLayout(cellWidths = c('50%', '50%'),
                                            # criando caixa de selecao de variavel plotada
                                            varSelectInput(inputId = 'cases_metric2',
                                                           label = 'Select a metric (state-level):',
                                                           data = casos_colunas, 
                                                           selected = 'New cases',
                                                           multiple = FALSE,
                                                           selectize = FALSE,
                                                           size = 3),
                                            
                                            # criando caixa de selecao de variavel plotada
                                            varSelectInput(inputId = 'demographic_metric1',
                                                           label = 'Select a metric (city-level):',
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
                              
                              
                              tabPanel(
                                title = "Download Data",
                                DT::dataTableOutput("table_out_cases")
                              )
                            )
             ),
             
             
             tabPanel('Deaths',
                      tabsetPanel(
                        tabPanel(
                          title = "Overview",
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
                                             label = 'Date range (dd/mm/yy)',
                                             start = max(deaths_Brazil$date)- months(1),
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
                            mainPanel(plotlyOutput(outputId = 'deaths_plot'))
                          ),
                        ),
                        
                        tabPanel(
                          title = "Geo Heat Maps",
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
                                                    animate=animationOptions(interval = 700, loop = FALSE),
                                                    timeFormat='%d-%m-%Y')),
                            
                            splitLayout(cellWidths = c('50%', '50%'),
                                        # criando caixa de selecao de variavel plotada
                                        varSelectInput(inputId = 'deaths_metric2',
                                                       label = 'Select a metric (state-level):',
                                                       data = obitos_colunas, 
                                                       selected = 'Recent deaths registered',
                                                       multiple = FALSE,
                                                       selectize = FALSE,
                                                       size = 3),
                                        
                                        # criando caixa de selecao de variavel plotada
                                        varSelectInput(inputId = 'demographic_metric2',
                                                       label = 'Select a metric (city-level):',
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
                        
                        
                        tabPanel(
                          title = "Download Data",
                          DT::dataTableOutput("table_out_deaths")
                        )
                      )
                      
             ),
         
             
             tabPanel('Hospitalizations',
                      menuItem('Source code', 
                               href = 'https://github.com/lslbastos/Bastos_Ranzani_etal_COVID19_ChangeWaves'),
                      fluidRow(
                        tags$iframe(
                          seamless = 'seamless',
                          src = 'https://lslbastos.shinyapps.io/sivep_covid_brazil/',
                          height = 800, width = 1400))
                      
                      
             ),
             
             tabPanel('Vaccinations',
                      tabsetPanel(
                        tabPanel(
                          title = "Overview",
                          sidebarLayout(
                            # criando barra lateral para inputar dados
                            sidebarPanel(
                              useShinyjs(),
                              
                              # criando caixa de selecao de variavel plotada
                              varSelectInput(inputId = 'vaccination_metric',
                                             label = 'Metric:',
                                             data = vacinacao_colunas, 
                                             selected = 'People fully vaccinated',
                                             multiple = TRUE),
                              
                              # criando caixa de intervalo temporal
                              dateRangeInput(inputId = 'vaccination_date',
                                             label = 'Date range (dd/mm/yy):',
                                             start = max(vaccination_Brazil$date) - months(1),
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
                            mainPanel(plotlyOutput(outputId = 'vaccination_plot'))
                          ),
                        ),
                        
                        tabPanel(
                          title = "Statistics", 
                          sidebarLayout(
                            # criando barra lateral para inputar dados para o gráfico estatísticas de vacinação
                            sidebarPanel(
                              useShinyjs(),
                              
                              
                              # criando caixa de selecao de estados
                              selectInput(inputId = 'vaccination_state_statistics',
                                          label = 'States:',
                                          choices = Brazil_Populations$state, # precisa ser um vetor com valores unicos
                                          selected = list('SP','PI','MS','MG','CE','RS','ES','PR','RJ'),
                                          multiple = TRUE),
                              
                              # criando filtro de data
                              sliderInput(inputId = 'vaccination_date_statistics',
                                          'Date range:',
                                          min = as.Date("2021-06-30",'%Y-%m-%d'),
                                          max = as.Date(max(vaccination_Brazil$date),'%Y-%m-%d'),
                                          value=as.Date(max(vaccination_Brazil$date)),
                                          animate=animationOptions(interval = 400, loop = FALSE),
                                          timeFormat='%d-%m-%Y')
                            ),
                            
                            
                            mainPanel(
                              plotlyOutput("graph_1"),
                              
                              br(),
                              
                              plotlyOutput("graph_2"))
                          )
                        ),
                        
                        
                        
                        tabPanel(
                          title = "Geo Heat Maps",
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
                                                      animate=animationOptions(interval = 700, loop = FALSE),
                                                      timeFormat='%d-%m-%Y')),
                              
                              splitLayout(cellWidths = c('50%', '50%'),
                                          # criando caixa de selecao de variavel plotada
                                          varSelectInput(inputId = 'vaccination_metric2',
                                                         label = 'Metric (state-level):',
                                                         data = vacinacao_colunas, 
                                                         selected = 'People fully vaccinated',
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
                          
                        ),
                        
                        
                        tabPanel(
                          title = "Download Data",
                          DT::dataTableOutput("table_out_vaccination")
                        )
                      )
                      
             ),
             
             tabPanel('About us',
                      h1('About us'),
                      h3('EFFECT-Brazil Monitor'),
                      p('This app is a COVID-19 tracker and data explorer in Brazil.'),
                      p('You can explore state-level data on a variety of COVID-19 metrics according confirmed COVID-19 data in Brazil by: 
                         number of cases and case trends over time including deaths, hospitalizations and vaccines.'),
                      br(),
                      h3('Web development team'),
                      br(),
                      fluidRow(
                        # JÉSSICA
                        column(width = 2, align = "center",
                               img(src = "jessica.png")
                        ),
                        column(width = 2,
                               p('Jéssica Villar'),
                               p('jessica.c.villar@hotmail.com'),
                               a('Lattes', href = 'http://buscatextual.cnpq.br/buscatextual/visualizacv.do?id=K8611793T6&tokenCaptchar=03AGdBq250XljBHqd_AOWghMWr795prPtraUIbFTdN651iErGiRn9Dksnk0E8bSTpCL3AtpLXVvygoiBkpRhHvZ5Ma7cUNs1cnatyiwHXHjo_3OM2orSCsgQ_JdaIEZV7qCZ2HRGTD6dQJiF7ytKlVdsm-1wrKO-u5vUbjK60PZpRRwT58uSOFuFNIToQTYTUVapbCXjOyNBi-BTcXvKUu3mzWtZulaBRS5C_nsNAXyHNKyDmsuCGOULV0lYIUX8I-03rX6XQ0i4IQ0Q0guhjSKyhCbWX8KCGLVgweoEs0B-yNn7_02n_fzZTCDJs09nve6Ab0Ww34WFlFV0nRN-hrnuo7OVxlPJ-g4bJnMXmGiZ66gW2qykWr8LfQDdsAQ932KGM8tQ6PwLQReHMcMvrBLBSnO3xY1CDvWCjbkoY-Fs0PgjILmQPs399l52rbnKVTiofe3Ggp6KLDz-GiU9ETy2nRY7fim3bVWQ'),
                               br(),
                               a('Linkedin', href = 'https://www.linkedin.com/in/jessica-villar/')
                        ),
                        # THAIS
                        column(width = 2, align = "center",
                               img(src = "thais.jpg")
                        ),
                        column(width = 2,
                               p('Thaís Camargo'),
                               p('thaisdeabreuc@gmail.com'),
                               a('Lattes', href = 'http://buscatextual.cnpq.br/buscatextual/visualizacv.do?id=K2870836T1&tokenCaptchar=03AGdBq27mMSzjprRp6swWCWHIK0PwfspLX2ZJWeRATKlcQGjVu_cRK_hm2ltSqXLT4yrZbWnkGAawMollaaabfblqpcC7YeIft7N_XogIsjDlOYk7xQ1ckr1jcKvoeenD0Hk3RmsbD4MwkdkGRvGteyHEQWxiyWP96bRd6Ovz2ptvGgnyOj3IMcoNji_AIjAHcUm5vHN7UOi2J-76M3uWV_Bd3pLQHlQ3wvbDzxdXqPwplg44_6NLUthbaXGySg0PEBsvrrtNCSjSgJaJA7ZoM4dVs6Py5iKt7w1sQv47tFDfKch3mYJM5aO6tunqnSlhBJVzfSlJfbuZ1uqgtjl9oDsGljloYI2TIXFK05JLGds_XfmizMid-t3yK3fsVftgQQou5DRIUfoE3ktu5WM8eSwAd8TXX1wit3JarVCKpVssIZ16XfV9JMTihp1_gyArwklM0ttcHhFRTkwZoVTUQkhni7OXvmoAhg'),
                               br(),
                               a('Linkedin', href = 'https://www.linkedin.com/in/tha%C3%ADs-camargo-8172a319a/')
                        )
                      )
                      
             )
             
             
  )
)
