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
ajuste_misto <-glmer(
    formula = y ~ month + trt*month + (1|id), 
    family = binomial(link = "logit"),         
    data = dados)

