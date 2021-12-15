# funcao auxiliar de teste para duas variaveis
up_two <- function(data, mean) {
  if (length(data) > 1 & mean == 'both'){
    'Erro: Escolha no máximo uma variável para plotar esse tipo de gráfico!'
  }
  else if (length(data) > 2) {
    'Erro: Escolha no máximo duas variáveis para plotar esse tipo de gráfico!'
  }
  else if (length(data) == 0) {
    'Erro: Escolha no mínimo uma variável para plotar esse tipo de gráfico!'
  } 
  else NULL
}