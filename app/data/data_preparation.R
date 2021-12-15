urlfile <- 'https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-states.csv'
mydata_Brazil <- read_csv(url(urlfile))
Dados_sociodemograficos <- read_excel('Dados_sociodemograficos_2.xlsx')

cases_Brazil = select(mydata_Brazil,
                      c('date','state','newCases','totalCases','totalCases_per_100k_inhabitants'))

colnames(cases_Brazil) = c('date','state','Novos casos','Total de casos','Total de casos/100k hab.')

casos_colunas = select(cases_Brazil, 
                       c('Novos casos','Total de casos','Total de casos/100k hab.'))

deaths_Brazil = select(mydata_Brazil,
                       c('date','state','newDeaths','deaths','deaths_per_100k_inhabitants','deaths_by_totalCases'))

colnames(deaths_Brazil) = c('date','state','Novos registros de mortes','Registros totais de mortes','Total de mortes/100k hab.','Total de mortes/Total de casos')

obitos_colunas = select(deaths_Brazil,
                        c('Novos registros de mortes','Registros totais de mortes','Total de mortes/100k hab.','Total de mortes/Total de casos'))

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

colnames(vaccination_Brazil) = c('date','state','Vacinados com 1a dose','Vacinados com 1a dose/100k hab.',
                                 'Vacinados com dose unica','Vacinados com dose unica/100k hab.',
                                 'Vacinados com 2a dose','Vacinados com 2a dose/100k hab.',
                                 'Vacinados com 3a dose','Vacinados com 3a dose/100k hab.',
                                 'Totalmente vacinados', 'Novos totalmente vacinados',
                                 'Novos vacinados com 1a dose','Novos vacinados com dose unica',
                                 'Novos vacinados com 2a dose', 'Novos vacinados com 3a dose')

vacinacao_colunas = select(vaccination_Brazil, 
                           c('Vacinados com 1a dose','Vacinados com 1a dose/100k hab.',
                             'Vacinados com dose unica','Vacinados com dose unica/100k hab.',
                             'Vacinados com 2a dose','Vacinados com 2a dose/100k hab.',
                             'Vacinados com 3a dose','Vacinados com 3a dose/100k hab.',
                             'Totalmente vacinados', 'Novos totalmente vacinados',
                             'Novos vacinados com 1a dose','Novos vacinados com dose unica',
                             'Novos vacinados com 2a dose', 'Novos vacinados com 3a dose'))

mysociodata_Brazil = select(Dados_sociodemograficos,
                            c('COD7','NOME','UF','PIB_P_CAP','GINI','DENS_DEM','PERC60MAIS',
                              'MEDICOS_100MIL','LEITOS_100MIL','PERC_POP_EDUC_SUP'))

colnames(mysociodata_Brazil) = c('codigo','municipio','state','PIB per capita','Índice de Gini da renda domiciliar per capita dos municípios',
                                 'Densidade demográfica','Percentual da população com 60 anos ou mais',
                                 'Quantidade de Médicos/100k hab.','Quantidade de Leitos/100k hab.', 
                                 'Percentual da população com escolaridade de nível superior concluído')

sociodem_colunas = select(mysociodata_Brazil,
                          c('PIB per capita','Índice de Gini da renda domiciliar per capita dos municípios',
                            'Densidade demográfica','Percentual da população com 60 anos ou mais',
                            'Quantidade de Médicos/100k hab.','Quantidade de Leitos/100k hab.', 
                            'Percentual da população com escolaridade de nível superior concluído'))

estados_sociodem = unique(mysociodata_Brazil$state)


