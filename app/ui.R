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
                                                  h3('Bem vindo ao EFFECT-Brazil!', 
                                                     style='margin-top:0px;'),
                                                  h4('[Breve descrição do app]', 
                                                     style='margin-top:0px;'))
                                  )
                                  )
                                ),
                                
                                br(),
                                
                                fluidRow(
                                  box(title = 'Casos', 
                                      width = 3, 
                                      background = 'blue',
                                      'Explore dados sobre os casos confirmados de COVID-19',
                                      br(),
                                      actionBttn(inputId = 'switch_tab_cases',
                                                 label = 'Acessar página',
                                                 style = 'minimal',
                                                 size = 'sm')),
                                  
                                  box(title = 'Óbitos', 
                                      width = 3, 
                                      background = 'yellow',
                                      'Explore dados sobre os óbitos confirmados de COVID-19',
                                      br(),
                                      actionBttn(inputId = 'switch_tab_deaths',
                                                 label = 'Acessar página',
                                                 style = 'minimal',
                                                 size = 'sm')),
                                  
                                  box(title = 'Hospitalizações', 
                                      width = 3, 
                                      background = 'red',
                                      'Explore dados sobre as hospitalizações de COVID-19',
                                      br(),
                                      actionBttn(inputId = 'switch_tab_hospitalization',
                                                 label = 'Acessar página',
                                                 style = 'minimal',
                                                 size = 'sm')),
                                  
                                  box(title = 'Vacinação', 
                                      width = 3, 
                                      background = 'navy',
                                      'Explore dados sobre a vacinação contra a COVID-19',
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
                                                 onclick = sprintf("window.open('%s')", "https://twitter.com/intent/tweet?url=https://jessicavillar.shinyapps.io/icoda/")),

                                    ## Facebook
                                    actionButton(inputId = "facebook_share",
                                                 label = "",
                                                 icon = icon("facebook"),
                                                 style = "background-color:#4267B2; border-color:#4267B2",
                                                 onclick = sprintf("window.open('%s')", "https://www.facebook.com/sharer/sharer.php?u=https://jessicavillar.shinyapps.io/icoda/")),
                                    

                                    ## LinkedIn
                                    actionButton(inputId = "linkedin_share",
                                                 label = "",
                                                 icon = icon("linkedin"),
                                                 style = "background-color:#0e76a8; border-color:#0e76a8",
                                                 onclick = sprintf("window.open('%s')", "https://www.linkedin.com/shareArticle?mini=true&url=https://jessicavillar.shinyapps.io/icoda/")),
                                    br(),
                                    img(src = '210812_Logo Lockup_IG2.jpg')
                                    )
                                    
                                  
                      ),
             ),
             
             
             tabPanel('Casos',
                      mainPanel(width = 11, 
                                style='margin-left:4%; margin-right:4%',
                                introBox(  
                                  fluidRow(column(12,
                                                  h3('Explore dados sobre os casos confirmados de COVID-19', 
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
                                         label = 'Escolha a métrica:',
                                         data = casos_colunas, 
                                         selected = 'Novos casos',
                                         multiple = TRUE),
                          
                          # criando caixa de intervalo temporal
                          dateRangeInput(inputId = 'cases_date',
                                         label = 'Intervalo de data:',
                                         start = max(cases_Brazil$date) - months(6),
                                         end = max(cases_Brazil$date),
                                         format = 'dd/mm/yy'),
                          
                          # criando botão de escolha de agrupamento
                          # radioGroupButtons(inputId = 'cases_groupby',
                          #                   label = 'Agrupar por:', 
                          #                   choices = list('Estado' = 'state',
                          #                                  'Cidade' = 'city'),
                          #                   status = 'primary'),
                          
                          # criando caixa de selecao de estados
                          selectInput(inputId = 'cases_state',
                                      label = 'Escolha o estado:',
                                      choices = estados_casos_obitos, # precisa ser um vetor com valores unicos
                                      selected = 'RJ'),
                          
                          # criando caixa de selecao de cidades
                          # selectInput(inputId = 'cases_city',
                          #             label = 'Escolha a cidade:',
                          #             choices = NULL),
                          
                          # criando caixa para cálculo com ou sem média móvel
                          selectInput(inputId = 'cases_mean',
                                      label = 'Plotar média móvel?',
                                      choices = list('Não' = 'withoutmean',
                                                     'Sim, apenas a média móvel' = 'withmean',
                                                     'Sim, média móvel + variável original' = 'both'),
                                      selected = 'withoutmean'),
                          
                          # criando caixa de selecao de periodos de media movel
                          # a caixa começa escondida quando o app é iniciado
                          hidden(sliderInput(inputId = 'cases_MA_size',
                                             label = 'Períodos de média móvel:',
                                             min = 1,
                                             max = 14,
                                             value = 7)),
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
                                                  h3('Visualização geográfica dos dados por estado/município sobre os casos confirmados de COVID-19', 
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
                                                  'Arraste para selecionar a data:',
                                                  min = as.Date(min(cases_Brazil$date),'%Y-%m-%d'),
                                                  max = as.Date(max(cases_Brazil$date),'%Y-%m-%d'),
                                                  value=as.Date(max(cases_Brazil$date)),
                                                  timeFormat='%d-%m-%Y')),
                          
                          splitLayout(cellWidths = c('50%', '50%'),
                                      # criando caixa de selecao de variavel plotada
                                      varSelectInput(inputId = 'cases_metric2',
                                                     label = 'Escolha a métrica (por Estado):',
                                                     data = casos_colunas, 
                                                     selected = 'Novos casos',
                                                     multiple = FALSE,
                                                     selectize = FALSE,
                                                     size = 3),
                                      
                                      # criando caixa de selecao de variavel plotada
                                      varSelectInput(inputId = 'demographic_metric1',
                                                     label = 'Escolha a métrica (por Município):',
                                                     data = sociodem_colunas, 
                                                     selected = 'PIB per capita',
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
             
             
             tabPanel('Óbitos',
                      mainPanel(width = 11, 
                                style='margin-left:4%; margin-right:4%',
                                introBox(  
                                  fluidRow(column(12,
                                                  h3('Explore dados sobre os óbitos confirmados de COVID-19', 
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
                                         label = 'Escolha a métrica:',
                                         data = obitos_colunas, 
                                         selected = 'Novos registros de mortes',
                                         multiple = TRUE),
                          
                          # criando caixa de intervalo temporal
                          dateRangeInput(inputId = 'deaths_date',
                                         label = 'Intervalo de data:',
                                         start = max(deaths_Brazil$date)- months(6),
                                         end = max(deaths_Brazil$date),
                                         format = 'dd/mm/yy'),
                          
                          # criando botão de escolha de agrupamento
                          # radioGroupButtons(inputId = 'deaths_groupby',
                          #                   label = 'Agrupar por:', 
                          #                   choices = list('Estado' = 'state',
                          #                                  'Cidade' = 'city'),
                          #                   status = 'primary'),
                          
                          # criando caixa de selecao de estados
                          selectInput(inputId = 'deaths_state',
                                      label = 'Escolha o estado:',
                                      choices = estados_casos_obitos, # precisa ser um vetor com valores unicos
                                      selected = 'RJ'),
                          
                          # criando caixa de selecao de cidades
                          # selectInput(inputId = 'deaths_city',
                          #             label = 'Escolha a cidade:',
                          #             choices = NULL),
                          
                          # criando caixa para cálculo com ou sem média móvel
                          selectInput(inputId = 'deaths_mean',
                                      label = 'Plotar média móvel?',
                                      choices = list('Não' = 'withoutmean',
                                                     'Sim, apenas a média móvel' = 'withmean',
                                                     'Sim, média móvel + variável original' = 'both'),
                                      selected = 'withoutmean'),
                          
                          # criando caixa de selecao de periodos de media movel
                          # a caixa começa escondida quando o app é iniciado
                          hidden(sliderInput(inputId = 'deaths_MA_size',
                                             label = 'Períodos de média móvel:',
                                             min = 1,
                                             max = 14,
                                             value = 7)),
                        ),
                        
                        # painel principal para apresentar outputs
                        mainPanel(dygraphOutput(outputId = 'deaths_plot'))
                        
                      ),
                      
                      mainPanel(width = 11, 
                                style='margin-left:4%; margin-right:4%',
                                br(),
                                
                                introBox(  
                                  fluidRow(column(12,
                                                  h3('Visualização geográfica dos dados por estado/município sobre os óbitos confirmados de COVID-19', 
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
                                                     label = 'Escolha a métrica (por Estado):',
                                                     data = obitos_colunas, 
                                                     selected = 'Novos registros de mortes',
                                                     multiple = FALSE,
                                                     selectize = FALSE,
                                                     size = 3),
                                      
                                      # criando caixa de selecao de variavel plotada
                                      varSelectInput(inputId = 'demographic_metric2',
                                                     label = 'Escolha a métrica (por Município):',
                                                     data = sociodem_colunas, 
                                                     selected = 'PIB per capita',
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
             
             tabPanel('Hospitalizações',
                      menuItem('Source code', icon = icon('file-code-o'), 
                               href = 'https://github.com/lslbastos/Bastos_Ranzani_etal_COVID19_ChangeWaves'),
                      fluidRow(
                        tags$iframe(
                          seamless = 'seamless',
                          src = 'https://lslbastos.shinyapps.io/sivep_covid_brazil/',
                          height = 800, width = 1400))
                      
                      
             ),
             
             tabPanel('Vacinação',
                      mainPanel(width = 11, 
                                style='margin-left:4%; margin-right:4%',
                                introBox(  
                                  fluidRow(column(12,
                                                  h3('Explore dados sobre a vacinação contra a COVID-19', 
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
                                         label = 'Escolha a métrica:',
                                         data = vacinacao_colunas, 
                                         selected = 'Vacinados com 1a dose',
                                         multiple = TRUE),
                          
                          # criando caixa de intervalo temporal
                          dateRangeInput(inputId = 'vaccination_date',
                                         label = 'Intervalo de data:',
                                         start = max(vaccination_Brazil$date) - months(6),
                                         end = max(vaccination_Brazil$date),
                                         format = 'dd/mm/yy'),
                          
                          # criando caixa de selecao de estados
                          selectInput(inputId = 'vaccination_state',
                                      label = 'Escolha o estado:',
                                      choices = estados_vacinacao, # precisa ser um vetor com valores unicos
                                      selected = 'RJ')
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
                                                  h3('Visualização geográfica dos dados por estado/município sobre vacinação contra COVID-19', 
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
                                                  'Arraste para selecionar a data:',
                                                  min = as.Date(min(vaccination_Brazil$date),'%Y-%m-%d'),
                                                  max = as.Date(max(vaccination_Brazil$date),'%Y-%m-%d'),
                                                  value=as.Date(max(vaccination_Brazil$date)),
                                                  timeFormat='%d-%m-%Y')),
                          
                          splitLayout(cellWidths = c('50%', '50%'),
                                     # criando caixa de selecao de variavel plotada
                                     varSelectInput(inputId = 'vaccination_metric2',
                                                    label = 'Escolha a métrica (por Estado):',
                                                    data = vacinacao_colunas, 
                                                    selected = 'Vacinados com 1a dose',
                                                    multiple = FALSE,
                                                    selectize = FALSE,
                                                    size = 3),
                                     
                                     # criando caixa de selecao de variavel plotada
                                     varSelectInput(inputId = 'demographic_metric4',
                                                    label = 'Escolha a métrica (por Município):',
                                                    data = sociodem_colunas, 
                                                    selected = 'PIB per capita',
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