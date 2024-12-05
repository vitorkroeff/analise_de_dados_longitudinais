# Pacotes
require(dplyr)
require(ggplot2)
require(tidyr)
require(ggplot2)
require(GGally)


# Carregamento da base de dados

dados_brutos <- tibble(read.table('base_de_dados.txt', header = T)) # Base do github

# Correção na linha 6 da variável n56hpo

dados_brutos$n56hpo[6] <- 1130

# Criação de um id para os pacientes

dados_brutos$id <- 1:length(dados_brutos$idade)



# Seleção das variáveis do estudo
## IMPORTANTE
### eurob e euros medem risco de evento cardiáco, usar apenas uma delas

dados <- dados_brutos %>% select(c(id,sexo, idade,imc, fc,
                                   nyha, has, iap, ai, grupo,
                                   euroes, fc, creat,
                                   t1, t2, t3, t4, t5, t6,
                                   n1anest, n2despin,n3final,
                                   n42hpo, n56hpo,n624hpo
                                   )) 


## GGpairs das covariáveis

dados %>% select(-c(t1, t2, t3, t4, t5, t6,
                    n1anest, n2despin,n3final,
                    n42hpo, n56hpo,n624hpo)) %>% ggpairs()

# Tratamento dos dados categoricos
dados$sexo <- as.factor(ifelse(dados$sexo== 1, 'M', 'F' ))
dados$nyha <- as.factor(dados$nyha)
dados$has <- as.factor(dados$has)
dados$iap <- as.factor(dados$iap)
dados$ai <- as.factor(dados$ai)
dados$grupo <- as.factor(dados$grupo)

# Tratamentos das variáveis de tempo em horas
## NÃO FIZ


# Descrições da base
str(dados)
summary(dados)

## Primeiras linhas da base
head(dados)


# CORRELAÇÕES

## Correlação de todos os pacientes
round(cor(dados[,13:16]),2)

## Correlação do grupo 0 

round(cor(subset(dados, grupo == 0)[,13:16]),2)

## Correlação do grupo 1

round(cor(subset(dados, grupo == 1)[,13:16]),2)

## Correlação do grupo 2

round(cor(subset(dados, grupo == 2)[,13:16]),2)

# Transformando os dados em fortmato longo
## Foram transformados em longo a resposta (t1, t2, ..., t6)
## As variáveis de tempo n1anest, ..., n62hpo foram ignoradas (NÂO SEI SE ESTÁ CORRETO)

dados_longos <- dados %>% pivot_longer(
    cols = starts_with("t"),               
    names_to = "observacao",                   
    values_to = "citocina_t",              
    names_prefix = "t"                    
)
head(dados_longos)

# Não há perda de acompanhamento no estudo
barplot(table(dados_longos$id))


# Gráficos
## Diferênça de gênero
rotulos <- c('Inducação \nAnestésica', 'Despinçamento', 'Final \n cirurgia',
             '2h após', '6h após', '24h após')

dados_longos$obs_continua <- as.numeric(dados_longos$observacao) #variável continua para gráfico

p1_sex<-ggplot(dados_longos, aes(x=obs_continua, y= citocina_t,color=sexo))+
    geom_line(aes(group=id))+ theme(legend.position="top")+
    labs(x="Observações", title = 'Efeito de Sexo na Citocina Tnf-receptor ') + theme_minimal()+
    scale_x_continuous(breaks = seq_along(rotulos), labels = rotulos )
p1_sex + geom_smooth(method = "loess", se = FALSE, size = 2)


p2_sex<-ggplot(dados_longos, aes(x=observacao,y=citocina_t,fill=sexo))+
    geom_boxplot(notch=TRUE) +theme(legend.position="top") +
    stat_summary(fun="mean",geom="point",size=2,color="white",
                 position=position_dodge(width=0.75),show.legend=FALSE) +
    labs(x="Observações") + theme_minimal() + 
    scale_x_discrete(breaks = seq_along(rotulos), labels = rotulos )
p2_sex


## Diferença de grupo
p1_grupo<-ggplot(dados_longos, aes(x=obs_continua, y= citocina_t,color=grupo))+
    geom_line(aes(group=id))+ theme(legend.position="top")+
    labs(x="Observações") + theme_minimal()+
    scale_x_continuous(breaks = seq_along(rotulos), labels = rotulos )
p1_grupo + geom_smooth(method = "loess", se = FALSE, size = 2)



p2_grupo<-ggplot(dados_longos, aes(x=observacao,y=citocina_t,fill=grupo))+
    geom_boxplot(notch=TRUE) +theme(legend.position="top") +
    stat_summary(fun="mean",geom="point",size=2,color="white",
                 position=position_dodge(width=0.75),show.legend=FALSE) +
    labs(x="Observações") + theme_minimal() + 
    scale_x_discrete(breaks = seq_along(rotulos), labels = rotulos )

p2_grupo

### excluimos da base a variável contínua
dados_longos <- dados_longos %>% select(-c(obs_continua))


# Dados Nulos e tratamentos

## Dados nulos por colunas
knitr::kable(
colSums(is.na(dados_brutos)) %>% arrange(desc(x))) # ARRUMAR

## Comentar mais sobre

# Ajuste GLS


# Ajuste GEE


# Modelo Misto

# Resíduos

# Considerações





