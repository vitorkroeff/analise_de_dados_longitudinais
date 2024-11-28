# Pacotes
require(dplyr)
require(ggplot2)


# Carregamento da base de dados

dados <- tibble(read.table('base_de_dados.txt', header = T)) # Base do github

View(dados)
tempos <- c(length(dados$t1),length(dados$t2), length(dados$t3),
            length(dados$t4), length(dados$t5), length(dados$t6))
tempos
