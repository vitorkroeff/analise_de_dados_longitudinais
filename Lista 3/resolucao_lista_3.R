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
require(dplyr)
pacman::p_load(reshape, plyr, ggplot2, gridExtra, mice, geepack, nlme, lme4, Matrix, janitor)
dados_rats <- janitor::clean_names(
    tibble(xlsx::read.xlsx("Lista 3/rats.xlsx", sheetIndex = 1)))
dados_rats <- na.omit(dados_rats)
ajuste_gee_ind <- geeglm(response ~ group * time,data = dados_rats,
                         id = subject,corstr = "independence")

ajuste_gee_simetria <- geeglm(response ~ group * time,data = dados_rats,
                              id = subject,corstr = "exchangeable")

ajuste_gee_ar1 <- geeglm(response ~ group * time,data = dados_rats,
                         id = subject,corstr = "ar1")

ajuste_gee_unstructured <- geeglm(response ~ group * time,data = dados_rats,
                                  id = subject,corstr = "unstructured")

dados_largo <- reshape::cast(dados_rats, subject ~ time, value = "response")
dados_largo <- na.omit(dados_largo)
round(cor(dados_largo[,2:7]),2)


# Questão 3

ajuste_misto_intercept <- lme4::lmer(response ~ group*time + (1|subject), data = dados_rats)

ajuste_misto_tempo <- lme4::lmer(response ~ group * time + (1 + time | subject), data = dados_rats)



ajuste_gee_ar1$a
knitr::kable(aic_values)

AIC(ajuste_gee_ar1)
