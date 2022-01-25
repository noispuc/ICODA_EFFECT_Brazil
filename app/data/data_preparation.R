urlfile <- 'https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-states.csv'
mydata_Brazil <- read_csv(url(urlfile))
Dados_sociodemograficos <- read_excel('data/datasets/Dados_sociodemograficos_2.xlsx')
Brazil_Populations <- read_excel('data/datasets/Brazil_Populations.xlsx')

cases_Brazil = select(mydata_Brazil,
                      c('date','state','newCases','totalCases','totalCases_per_100k_inhabitants'))

colnames(cases_Brazil) = c('date','state','New cases','Total cases','Total cases per 100k inhabitants')

casos_colunas = select(cases_Brazil, 
                       c('New cases','Total cases','Total cases per 100k inhabitants'))

deaths_Brazil = select(mydata_Brazil,
                       c('date','state','newDeaths','deaths','deaths_per_100k_inhabitants','deaths_by_totalCases'))

colnames(deaths_Brazil) = c('date','state','Recent deaths registered','Number of deaths registered','Number of deaths registered per 100k inhabitants','Case fatality rate')

obitos_colunas = select(deaths_Brazil,
                        c('Recent deaths registered','Number of deaths registered','Number of deaths registered per 100k inhabitants','Case fatality rate'))

estados_casos_obitos = unique(mydata_Brazil$state)

vaccination_Brazil = select(mydata_Brazil,
                            c('date','state','vaccinated','vaccinated_per_100_inhabitants',
                              'vaccinated_single','vaccinated_single_per_100_inhabitants',
                              'vaccinated_second','vaccinated_second_per_100_inhabitants',
                              'vaccinated_third','vaccinated_third_per_100_inhabitants'))

estados_vacinacao = unique(vaccination_Brazil$state)

# criação de coluna de full_vaccinated
vaccination_Brazil$full_vaccinated = vaccination_Brazil$vaccinated_single + vaccination_Brazil$vaccinated_second
# criação de séries diárias a partir das suas respectivas acumuladas
gb_vaccination_Brazil = vaccination_Brazil %>%
  group_by(state) %>%
  mutate(new_full_vaccinated = full_vaccinated - lag(full_vaccinated),
         new_vaccinated = vaccinated - lag(vaccinated),
         new_vaccinated_single = vaccinated_single - lag(vaccinated_single),
         new_vaccinated_second = vaccinated_second - lag(vaccinated_second),
         new_vaccinated_third = vaccinated_third - lag(vaccinated_third))

vaccination_Brazil = ungroup(gb_vaccination_Brazil)

colnames(vaccination_Brazil) = c('date','state','1st dose vaccinations (except Johnson & Johnson/Janssen)','1st dose vaccinations (except Johnson & Johnson/Janssen) per 100k inhabitants',
                                 'One dose of the Johnson & Johnson/Janssen vaccinations','One dose of the Johnson & Johnson/Janssen vaccinations per 100k inhabitants',
                                 '2nd dose vaccinations','2nd dose vaccinations per 100k inhabitants',
                                 '3rd dose vaccinations','3rd dose vaccinations per 100k inhabitants',
                                 'People fully vaccinated', 'Recent people fully vaccinated',
                                 'Recent 1st dose vaccinations (except Johnson & Johnson/Janssen)','Recent one dose of the Johnson & Johnson/Janssen vaccinations',
                                 'Recent 2nd dose vaccinations', 'Recent 3rd dose vaccinations')

vacinacao_colunas = select(vaccination_Brazil, 
                           c('1st dose vaccinations (except Johnson & Johnson/Janssen)','1st dose vaccinations (except Johnson & Johnson/Janssen) per 100k inhabitants',
                             'One dose of the Johnson & Johnson/Janssen vaccinations','One dose of the Johnson & Johnson/Janssen vaccinations per 100k inhabitants',
                             '2nd dose vaccinations','2nd dose vaccinations per 100k inhabitants',
                             '3rd dose vaccinations','3rd dose vaccinations per 100k inhabitants',
                             'People fully vaccinated', 'Recent people fully vaccinated',
                             'Recent 1st dose vaccinations (except Johnson & Johnson/Janssen)','Recent one dose of the Johnson & Johnson/Janssen vaccinations',
                             'Recent 2nd dose vaccinations', 'Recent 3rd dose vaccinations'))

mysociodata_Brazil = select(Dados_sociodemograficos,
                            c('COD7','NOME','UF','PIB_P_CAP','GINI','DENS_DEM','PERC60MAIS',
                              'MEDICOS_100MIL','LEITOS_100MIL','PERC_POP_EDUC_SUP'))

colnames(mysociodata_Brazil) = c('codigo','municipio','state','Per capita GDP','Gini index of per capita household income',
                                 'Population density','Population ages 60 and above (% of total population)',
                                 'Medical doctors per 100K inhabitants','Hospital beds per 100K inhabitants', 
                                 'Percentage of population with completed tertiary education (college or another higher education)')

sociodem_colunas = select(mysociodata_Brazil,
                          c('Per capita GDP','Gini index of per capita household income',
                            'Population density','Population ages 60 and above (% of total population)',
                             'Medical doctors per 100K inhabitants','Hospital beds per 100K inhabitants', 
                             'Percentage of population with completed tertiary education (college or another higher education)'))

estados_sociodem = unique(mysociodata_Brazil$state)


