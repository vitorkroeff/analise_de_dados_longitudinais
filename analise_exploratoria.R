# Pacotes
require(dplyr)
require(ggplot2)
require(tidyr)


# Carregamento da base de dados

dados <- tibble(read.table('base_de_dados.txt', header = T)) # Base do github
head(dados)

str(dados)
summary(dados)

tempos <- c(sum(is.na(dados$t1)), sum(is.na(dados$t2)), sum(is.na(dados$t3)),
            sum(is.na(dados$t4)), sum(is.na(dados$t5)), sum(is.na(dados$t6)))

# correlacão

View(dados)


# Tratamento dos dados

dados$sexo <- as.factor(dados$sexo)

# Análise gráfica Colocar mais coisas


barplot(table(as.factor(dados$sexo))) # distribuição por genero
 

# Transformando os dados em fortmato longo
# Ver se tem um id de paciente
dados_longos <- dados %>% pivot_longer(
    cols = starts_with("t"),               
    names_to = "tempo",                   
    values_to = "citocina_t",              
    names_prefix = "t"                    
)
