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



# Seleção das variáveis do estudo
## eurob e euros medem risco de evento cardiáco, usar apenas uma delas.
dados <- dados_brutos %>% select(c(id,sexo, idade,imc, 
                                   nyha, has, iap, ai,
                                   eurob, euroes, fc, creat,
                                   t1, t2, t3, t4, t5, t6,
                                   grupo, n1anest, n2despin,
                                   n3final, n42hpo, n56hpo,
                                   n624hpo)) 


# Tratamento dos dados categoricos
dados$sexo <- as.factor(ifelse(dados$sexo== 1, 'M', 'F' ))
dados$nyha <- as.factor(dados$nyha)
dados$has <- as.factor(dados$has)
dados$iap <- as.factor(dados$iap)
dados$ai <- as.factor(dados$ai)
dados$grupo <- as.factor(dados$grupo)

# Tratamentos das variáveis de tempo em horas



# Descrições da base
str(dados)
summary(dados)

## Primeiras linhas da base
head(dados)


 

# Transformando os dados em fortmato longo
## Foram transformados em longo a resposta (t1, t2, ..., t6)
## As variáveis de tempo n1anest, ..., n62hpo foram ignoradas (NÂO SEI SE ESTÁ CORRETO)

dados_longos <- dados %>% pivot_longer(
    cols = starts_with("t"),               
    names_to = "observacao",                   
    values_to = "citocina_t",              
    names_prefix = "t"                    
)


# Não há perda de acompanhamento no estudo
barplot(table(dados_longos$id))
