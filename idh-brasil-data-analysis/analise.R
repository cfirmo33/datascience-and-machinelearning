
# libs -----------------------------------
library(readxl)
library(dplyr)
library(psych)
library(corrplot)
library(rpart)
library(rpart.plot)
library(rattle)
library(RColorBrewer)
library(party)
library(cluster)
library(e1071)

# importacao xlsx -------------------------------------------
atlas2013_dadosbrutos_pt_2 <- read_excel("C:/Users/leo/Downloads/atlas2013_dadosbrutos_pt-2.xlsx")
View(atlas2013_dadosbrutos_pt_2)

dados <- atlas2013_dadosbrutos_pt_2

unique(dados$ANO)
str(dados)

dados <- dados %>% 
  dplyr::filter(dados$ANO == '2010')

dados_cba <- dados %>% 
  dplyr::filter(dados$ANO == '2010' & 
                  dados$Município == 'CUIABÁ' |
                  dados$Município == 'VÁRZEA GRANDE')

# matriz de correlacao - brasil ---------------------------------
# relacao entre o agua encanada, analfabetismo e deslocamento ao trabalho com mais de 1 hora
matriz_correlacao <- dados[c("E_ANOSESTUDO", #anos de estudo
                             "T_AGUA",# agua encanada
                             "T_OCUPDESLOC_1", #mais de 1 horas até o trabalho
                             "T_ANALF25M")] # analfabetismo >25
correlacao <- cor(matriz_correlacao, 
                  y = NULL, 
                  use = "everything", 
                  method = "pearson")
colnames(correlacao) <- c("Anos de Estudo", "Água encanada", "Percurso Trab. +1", "Analfabetismo >25")
rownames(correlacao) <- c("Anos de Estudo", "Água encanada", "Percurso Trab. +1", "Analfabetismo >25")
cor.plot(correlacao, main="Matriz de correlação (municípios do Brasil)")

# matriz_correlacao => cuiaba e VG --------------------------
matriz_correlacao <- dados_cba[c("E_ANOSESTUDO", #anos de estudo
                                 "T_AGUA",# agua encanada
                                 "T_OCUPDESLOC_1", #mais de 1 horas até o trabalho
                                 "T_ANALF25M")] # analfabetismo >25
correlacao <- cor(matriz_correlacao, 
                  y = NULL, 
                  use = "everything", 
                  method = "pearson")
colnames(correlacao) <- c("Anos de Estudo", "Água encanada", "Percurso Trab. +1", "Analfabetismo >25")
rownames(correlacao) <- c("Anos de Estudo", "Água encanada", "Percurso Trab. +1", "Analfabetismo >25")
cor.plot(correlacao, main="Matriz de correlação (Cuiabá e Várzera Grande)")

# agrupamento crisp (kmeans) ------------------------------
cl <- kmeans(dados[c("E_ANOSESTUDO", #anos de estudo
                     "T_AGUA",# agua encanada
                     "T_OCUPDESLOC_1", #mais de 1 horas até o trabalho
                     "T_ANALF25M")],4) # analfabetismo >25
plot(dados$T_AGUA,col=cl$cluster, 
     ylab="Percentual de Domicílios com Água encanada", 
     xlab="Quantidade de municípios",
     main="Agrupamento Crisp (4 clusters)")

# agrupamento (fuzzy) -----------------------
cfuzzy <- cmeans(dados[c("E_ANOSESTUDO", #anos de estudo
                         "T_AGUA",# agua encanada
                         "T_OCUPDESLOC_1", #mais de 1 horas até o trabalho
                         "T_ANALF25M")],4) # analfabetismo >25
plot(dados$T_AGUA, col=cfuzzy$cluster, 
     ylab="Percentual de Domicílios com Água encanada", 
     xlab="Quantidade de municípios",
     main="Agrupamento Fuzzy (4 clusters)")

# arvore de decisao 1 ----------------------------------
arvore <- rpart(dados$T_OCUPDESLOC_1 ~ 
                  dados$T_AGUA,
                data = dados)
fancyRpartPlot(arvore)

# arvore de decisao 2 ----------------------------------
arvore <- rpart(dados$T_OCUPDESLOC_1 ~ 
                  dados$E_ANOSESTUDO + dados$T_AGUA,
                data = dados)
fancyRpartPlot(arvore)

# parte do conjunto para treinamento
percentual <- 0.5
tamanho_suconjunto_treinamento <- percentual*length(dados$T_OCUPDESLOC_1)
vetor_treinamento <- seq(length=tamanho_suconjunto_treinamento, from=1, by=2)

arvore <- rpart(dados$T_OCUPDESLOC_1 ~ 
                  dados$T_AGUA, 
                data = dados, 
                subset = vetor_treinamento)

arvore
summary(arvore)
printcp(arvore)

plot(arvore, compress = TRUE, branch = 1, nspace = 0, uniform = TRUE, margin = 0.1)
text(arvore, use.n = TRUE)
dados_teste <- dados[-vetor_treinamento,]
table(predict(arvore, dados_teste, type = "class"), dados_teste$T_OCUPDESLOC_1)


# bayes ------------------------------------------
percentual <- 0.5
tamanho_suconjunto_treinamento <- percentual*length(dados$T_OCUPDESLOC_1)
vetor_treinamento <- seq(length=tamanho_suconjunto_treinamento, from=1, by=2)

dados <- dados %>%
  filter(!is.na(sgUF)) %>%

arvore <- rpart(dados$T_OCUPDESLOC_1 ~ 
                  dados$T_AGUA, 
                data = dados, 
                subset = vetor_treinamento)

unique(dados$T_AGUA)

model <- naiveBayes(dados$T_OCUPDESLOC_1 ~ 
                      dados$T_AGUA,
                    data = dados)

pred <- predict(model, dados)
table(pred, dados$T_OCUPDESLOC_1)

