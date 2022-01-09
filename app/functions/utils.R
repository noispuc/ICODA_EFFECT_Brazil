# funcao auxiliar de teste para duas variaveis
up_two <- function(data, mean) {
  if (length(data) > 1 & mean == 'both'){
    'Error: Choose one variable at maximum!'
  }
  else if (length(data) > 2) {
    'Error: Choose two variable at maximum!'
  }
  else if (length(data) == 0) {
    'Error: Choose at least one variable!'
  } 
  else NULL
}
