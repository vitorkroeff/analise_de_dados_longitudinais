# Pacotes
require(dplyr)
require(ggplot2)
require(tidyr)
require(ggplot2)


# Carregamento da base de dados

dados_brutos <- tibble(read.table('base_de_dados.txt', header = T)) # Base do github

# Correção na linha 6 da variável n56hpo

dados_brutos$n56hpo[6] <- 1130

# Criação de um id para os pacientes

dados_brutos$id <- 1:length(dados_brutos$idade)
View(dados_brutos)
# Seleção das variáveis do estudo

## eurob e euros medem risco de evento cardiáco, usar apenas uma delas.

dados <- dados_brutos %>% select(c(id,sexo, idade,imc, 
                                   nyha, has, iap, ai,
                                   eurob, euroes, fc, creat,
                                   t1, t2, t3, t4, t5, t6,
                                   grupo)) 


# Tratamento dos dados categoricos
dados$sexo <- as.factor(ifelse(dados$sexo== 1, 'M', 'F' ))
dados$nyha <- as.factor(dados$nyha)
dados$has <- as.factor(dados$has)
dados$iap <- as.factor(dados$iap)
dados$ai <- as.factor(dados$ai)
dados$grupo <- as.factor(dados$grupo)

str(dados)
summary(dados)

# Primeiras linhas da base
head(dados)

View(dados)

# Análise gráfica

## Evolução por gênero
View(dados)


 

# Transformando os dados em fortmato longo
# Ver se tem um id de paciente
dados_longos <- dados %>% pivot_longer(
    cols = starts_with("t"),               
    names_to = "observacao",                   
    values_to = "citocina_t",              
    names_prefix = "t"                    
)


# Não há perda de acompanhamento no estudo
barplot(table(dados_longos$id))
