# Pacotes
require(dplyr)
require(ggplot2)
require(tidyr)
require(ggplot2)


# Carregamento da base de dados

dados_brutos <- tibble(read.table('base_de_dados.txt', header = T)) # Base do github

# Seleção das variáveis do estudo

dados <- dados_brutos %>% select(c(sexo, idade,imc, 
                                   nyha, has, iap, ai,
                                   eurob, euroes, fc, creat,
                                   t1, t2, t3, t4, t5, t6))

head(dados)

# Tratamento dos dados categoricos
dados$sexo <- as.factor(ifelse(dados$sexo <2, 'M', 'F' ))
dados$nyha <- as.factor(dados$sexo)

factor()
summary(dados)



# Análise gráfica Colocar mais coisas


barplot(dados$sexo)
# distribuição por genero


 

# Transformando os dados em fortmato longo # ERRADO PRECISA PASSAR VARIOS PARA LONGO
# Ver se tem um id de paciente
dados_longos <- dados %>% pivot_longer(
    cols = starts_with("t"),               
    names_to = "tempo",                   
    values_to = "citocina_t",              
    names_prefix = "t"                    
)


table(dados_longos$tempo)
