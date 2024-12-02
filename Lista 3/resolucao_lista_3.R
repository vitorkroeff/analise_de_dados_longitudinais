# Pacotes
require(dplyr)
pacman::p_load(reshape, plyr, ggplot2, gridExtra, mice, geepack, nlme)


################### Questão 1 ######################################

#A)

## Lendo os dados
dados <- tibble(foreign::read.dta("Lista 3/toenail.dta"))

plot(table(dados$id)) # Existem dados Faltantes

ajuste_gee <-geeglm(y ~ trt * month - trt,family = binomial(link = "logit"),
                    data = dados,id = id,corstr = "exchangeable")
summary(ajuste_gee)

# B)

exp(ajuste_gee$coefficients)



# C) 

exp(ajuste_gee$coefficients)

# D)
dados$id
require(lme4)
require(Matrix)
ajuste_misto <-lme4::glmer(
    formula = y ~ month + trt*month + (1|id), 
    family = binomial(link = "logit"),         
    data = dados)

summary(ajuste_misto)
knitr::kable(
lme4::VarCorr(ajuste_misto))

var_bi <- lme4::VarCorr(ajuste_misto)
var_bi <- sqrt(as.numeric(var_bi))
fator <- sqrt(1 + (16*sqrt(3)/(15*pi)*var_bi))
fator

b.gee <- summary(ajuste_gee)$coef[,1]
b.lme <- summary(ajuste_misto)$coef[,1]
p.gee <- summary(ajuste_gee)$coef[,4]
p.lme <- summary(ajuste_misto)$coef[,4]
round(cbind(b.gee, or.gee = exp(b.gee), p.gee, b.lme, or.lme = exp(b.lme), p.lme,
            razao.b = b.lme/b.gee), 3)
exp(summary(ajuste_misto)$coef)


# Questão 2

dados_rats <- janitor::clean_names(
    tibble(xlsx::read.xlsx("Lista 3/rats.xlsx", sheetIndex = 1)))

## a)

table(dados_rats$subject)

ajuste_gee_ind <- geeglm(response ~ group * time,
                         data = dados_rats,
                         id = subject,
                         corstr = "independence")



