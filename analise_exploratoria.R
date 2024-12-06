# Pacotes
pacman::p_load(reshape, plyr, ggplot2, gridExtra, mice, geepack, nlme,
               dplyr, GGally, tidyr, modelsummary)

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
                                   #n1anest, n2despin,n3final,
                                   #n42hpo, n56hpo,n624hpo
                                   )) 


## GGpairs das covariáveis

#dados %>% select(-c(t1, t2, t3, t4, t5, t6,
 #                   n1anest, n2despin,n3final,
  #                  n42hpo, n56hpo,n624hpo)) %>% ggpairs()

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
    names_to = "tempo",                   
    values_to = "citocina_t",              
    names_prefix = "t"                    
)
head(dados_longos)

# Não há perda de acompanhamento no estudo
barplot(table(dados_longos$id))


# Gráficos
rotulos <- c('1', '2', '3',
             '4', '5', '6')

grafico1 <- ggplot(dados_longos, aes(x = tempo, y = citocina_t, group = grupo, shape = grupo, color = grupo)) +
    stat_summary(fun = "mean", geom = "line", linewidth = 1.1) +
    theme(legend.position = "top") +
    labs(x = "Tempo") +
    theme_light()

grafico2 <- ggplot(dados_longos, aes(x = tempo, y = citocina_t, group = nyha, shape = nyha, color = nyha)) +
    stat_summary(fun = "mean", geom = "line", linewidth = 1.1) +
    theme(legend.position = "top") +
    labs(x = "Tempo") +
    theme_light()

grid.arrange(grafico1, grafico2, ncol = 1)

grafico3 <-
    ggplot(dados_longos, aes(x = tempo, y = citocina_t, fill = has)) +
    geom_boxplot(notch = TRUE) + theme(legend.position = "top") +
    stat_summary(
        fun = "mean",
        geom = "point",
        size = 2,
        color = "white",
        position = position_dodge(width = 0.75),
        show.legend = FALSE
    ) +
    labs(x = "Tempo") + theme_light() +
    scale_x_discrete(breaks = seq_along(rotulos), labels = rotulos)+theme(plot.title = element_text(hjust = 0.5))


grafico4 <-
    ggplot(dados_longos, aes(x = tempo, y = citocina_t, fill = iap)) +
    geom_boxplot(notch = TRUE) + theme(legend.position = "top") +
    stat_summary(
        fun = "mean",
        geom = "point",
        size = 2,
        color = "white",
        position = position_dodge(width = 0.75),
        show.legend = FALSE
    ) +
    labs(x = "Tempo") + theme_light() +
    scale_x_discrete(breaks = seq_along(rotulos), labels = rotulos)+theme(plot.title = element_text(hjust = 0.5))



grafico5 <-
    ggplot(dados_longos, aes(x = tempo, y = citocina_t, fill = ai)) +
    geom_boxplot(notch = TRUE) + theme(legend.position = "top") +
    stat_summary(
        fun = "mean",
        geom = "point",
        size = 2,
        color = "white",
        position = position_dodge(width = 0.75),
        show.legend = FALSE
    ) +
    labs(x = "Tempo") + theme_light() +
    scale_x_discrete(breaks = seq_along(rotulos), labels = rotulos)+theme(plot.title = element_text(hjust = 0.5))

grid.arrange(grafico3, grafico4, grafico5, ncol = 1)



dados_longos$obs_continua <- as.numeric(dados_longos$tempo) #Criando tempo continuo
grafico6 <-ggplot(dados_longos, aes(x=obs_continua, y= citocina_t, color=sexo))+
    geom_point()+
    geom_line(aes(group=id))+ theme(legend.position="top")+facet_wrap(~grupo) +
    labs(x="Tempo") + theme_light()+
    scale_x_continuous(breaks = seq_along(rotulos), labels = rotulos) + theme(plot.title = element_text(hjust = 0.5))
grafico6 + geom_smooth(method = "loess", se = FALSE, size = 2)


### excluimos da base a variável contínua
dados_longos <- dados_longos %>% select(-c(obs_continua))

length(colnames(dados_longos))
# Dados Nulos e tratamentos

## Dados nulos por colunas
knitr::kable(
colSums(is.na(dados_longos)) %>% arrange(desc(x))) # ARRUMAR

## Comentar mais sobre

### Ver variável FC

#### TIREI FC DO MODELO

colnames(dados_longos)
# Ajuste GEE


## Independente

ajuste_gee_indep <- geeglm(citocina_t ~ tempo + ai + sexo + nyha + grupo + idade + has + euroes + imc + iap,
                           data = dados_longos,corstr = 'independence', id = id, family = 'gaussian')

round(coef(summary(ajuste_gee_indep)),3)

## Simetria composta
ajuste_gee_simetria <- geeglm(citocina_t ~ tempo + ai + sexo + nyha + grupo + idade + has + euroes + imc + iap,
                              data = dados_longos,corstr = 'exchangeable', id = id, family = 'gaussian')

round(coef(summary(ajuste_gee_simetria)),3)


## AR(1)
ajuste_gee_ar1 <- geeglm(citocina_t ~ tempo + ai + sexo + nyha + grupo + idade + has + euroes + imc + iap,
                         data = dados_longos,corstr = 'ar1', id = id, family = 'gaussian')
round(coef(summary(ajuste_gee_ar1)),3)

## Não estruturada
ajuste_gee_unstructured <- geeglm(citocina_t ~ tempo + ai + sexo + nyha + grupo + idade + has + euroes + imc + iap,
                                  data = dados_longos,corstr = 'unstructured', id = id, family = 'gaussian')

round(coef(summary(ajuste_gee_unstructured)),3)

### GEE AR(1) aparenta ser a estrutura correta por conta da matriz de correlação

#### Vamos considerar apenas as variáveis significativas a um nível de 5% e testar a interação de grupo e tempo
#### E com variáveis clinicamente significativas
#### Interação grupo e tempo
ajuste_gee_ar1_grupotempo <- geeglm(citocina_t ~ tempo*grupo +sexo +  imc + nyha + idade + euroes,
                         data = dados_longos,corstr = 'ar1', id = id, family = 'gaussian')
summary(ajuste_gee_ar1_grupotempo)

#### interação entre sexo e grupo
ajuste_gee_ar1_sexgrup <- geeglm(citocina_t ~ tempo+grupo*sexo+ imc + nyha + idade + euroes,
                                 data = dados_longos,corstr = 'ar1', id = id, family = 'gaussian')

summary(ajuste_gee_ar1_sexgrup) # Comentar

modelsummary(ajuste_gee_ar1_sexgrup)

# Modelo Misto
## Intercepto aleatório




# Resíduos

# Considerações





