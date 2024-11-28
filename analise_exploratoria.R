# Pacotes
require(dplyr)
require(ggplot2)


# Carregamento da base de dados

dados <- tibble(read.table('base_de_dados.txt', header = T)) # Base do github
head(dados)

str(dados)
summary(dados)

tempos <- c(sum(is.na(dados$t1)), sum(is.na(dados$t2)), sum(is.na(dados$t3)),
            sum(is.na(dados$t4)), sum(is.na(dados$t5)), sum(is.na(dados$t6)))

tempos #mesmo número de medidas, sem perda de acompanhamento


# Tratamento dos dados

dados$sexo <- as.factor(dados$sexo)

# Análise gráfica


barplot(table(as.factor(dados$sexo))) # distribuição por genero
 

