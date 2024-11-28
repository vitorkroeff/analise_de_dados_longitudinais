# Trabalho de Dados Reais - Análise de Dados Longitudinais

**Universidade Federal do Paraná - Departamento de Estatística**

**CE075 - Análise de Dados Longitudinais**

**Prof. José Luiz Padilha da Silva**

**Trabalho Escrito**

Este trabalho contempla a análise de dados reais de cirurgia cardíaca. Os dados são do prof. Antônio Luiz Ribeiro (Faculdade de Medicina, UFMG) e estão disponíveis no arquivo RevivarReduzido.txt.

**Descrição:** O paciente é submetido à cirurgia cardíaca com o auxílio da circulação extracorpórea (CEC) em que o sangue heparinizado entra em contato com superfícies estranhas (oxigenador e tubos do circuito extracorpóreo). Desta forma, apresenta-se ativação de vários sistemas orgânicos do corpo. A cirurgia cardíaca com CEC provoca alterações inflamatórias no organismo conhecidas como síndrome da resposta inflamatória sistêmica (SIRS). As respostas são as dosagens de 4 citocinas (i, t, mc, mip) (marcadores de inflamação) no sangue da artéria radial ou linha arterial sanguínea da CEC nos seguintes 6 momentos: (1) após indução anestésica, (2) após despinçamento aórtico, (3) no final da cirurgia, (4) 2 horas de pós-operatório, (5) 6 horas de pós-operatório, e (6) 24 horas de pós-operatório.

As variáveis n1, n2, n3, n4, n5 e n6 registram os tempos em horas. Por exemplo, o primeiro paciente apresenta a seguinte sequência:

- n1anest: primeiro tempo após a indução anestésica foi às 9:00hs, que deve ser a linha de base 0;
- n2despin: após o despinçamento foi às 10:32hs, que deve passar a ser 1,53hs;
- n3final: final da cirurgia foi às 11:10hs, que deve passar a ser 2,17hs;
- n4hpo: 2 horas após: 13:10hs, e portanto, 4,17hs;
- n56hpo: 6 horas após: 19:10hs, e portanto, 8,17hs e, finalmente,
- n624hpo: 24horas após: 9:00hs, que deve virar 24hs.

As seguintes covariáveis foram medidas:

1. sexo (1 - homem e 2 - mulher)
2. idade (em anos)
3. peso (em quilos)
4. altura (em mts)
5. imc (peso/altura2) (deve ser usado ao invés de peso e altura).
6. nyha (classe funcional, com valores 1,2,3,4)
7. has (hipertensão arterial sistêmica: 0 - não e 1 - sim)
8. iap (insuficiência arterial periférica: 0 - não e 1 - sim)
9. ai (angina instável: 0 - não e 1 - sim)
10. eurob (Eurobeta: risco de evento cardio-vascular em percentual)
11. euroes (Euroscore: escore medido em pontos)
12. fc (frequência cardíaca)
13. creat (creatinina)

As covariáveis sexo, idade, imc, nyha e euroscore são consideradas importantes a partir de informações históricas. Os pacientes foram divididos em três grupos (variável grupo no banco):

- Grupo 0: Cirurgia de coronária usando rolete (*n* = 22);
- Grupo 1: Cirurgia de coronária usando *biopump* (*n* = 21);
- Grupo 2: Cirurgia de válvula usando rolete (*n* = 19).

Os objetivos do estudo envolvem a comparação dos grupos e avaliar a evolução das citocinas ao longo do período de acompanhamento. Neste estudo vamos somente analisar a citocina Tnf-receptor (t) As medições da citocina t aparecem no banco nas colunas t1, t2, t3, t4, t5 e t6, para os respectivos tempos.

Observações:

1. Existe um erro no banco de dados, na sexta linha, n56hpo deveria ser 1630 ao invés de 1130.
2. Pode-se ignorar peso e altura e trabalhar somente com imc.
3. Eurobeta e Euroscore medem o risco de evento cardíaco. Basta utilizar uma delas, preferencialmente Euroscore.
4. Frequência cardíaca apresenta 13 NA’s. Avalie com cuidado a necessidade de incluí-la na análise de regressão múltipla.
5. Para análise, utilize modelos marginais e modelos mistos. Discuta os resultados, suposições e diferenças na interpretação dos coeficientes estimados.


