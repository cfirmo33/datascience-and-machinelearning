# libs 
library(rpart)
library(rattle)
library(RColorBrewer)

# import datasets
treino <- read.csv("train.csv")
teste <- read.csv("test.csv")

# analysis
names(treino)
summary(treino)

#sobreviventes
treino$Survived

#Vamos começar a explorar os nossos dados. 
#Quantos passageiros sobreviveram ao desastre?
table(treino$Survived)

prop.table(table(treino$Survived))

unique(treino$Sex)
homens <- treino[treino$Sex == "male", ]
mulheres <- treino[treino$Sex == "female", ]

# 18% dos homens sobreviveram
prop.table(table(homens$Survived))

# 74% mulheres sobreviveram
prop.table(table(mulheres$Survived))

passageiros.com.idade <- treino[!is.na(treino$Age),]
idade.media <- mean(passageiros.com.idade$Age)

# Agora vamos colocar a idade média no nosso data frame 
# e selecionar os passageiros com menos de 5 anos:
treino[is.na(treino$Age), ]$Age <- idade.media
criancas <- treino[treino$Age < 5, ]

# % idosos que foram salvas?
prop.table(table(criancas$Survived))

# Agora podemos construir uma estratégia mais 
# inteligente e fazer nossa segunda submissão. 
# Uma aproximação muito mais realista seria supor que 
# todos as crianças e mulheres se salvaram. Vamos construir 
# nossa segunda submissão usando esta estratégia:
  
#2
teste[is.na(teste$Age), ]$Age <- idade.media
teste$Survived <- 0
teste[teste$Sex=="female",]$Survived <- 1
teste[teste$Age < 5,]$Survived <- 1


arvore <- rpart(Survived ~ Age + Sex + Pclass + Fare, data=treino, method="class")
print(arvore)
fancyRpartPlot(arvore)

#3
submissao = data.frame(PassengerId=teste$PassengerId, Survived=teste$Survived)
previsao = predict(arvore, teste, type="class")
submissao$Survived = previsao


#4
summary(treino$Age)
treino$Child <- 0
treino$Child[treino$Age < 18] <- 1
aggregate(Survived ~ Child + Sex, data=treino, FUN=sum)
aggregate(Survived ~ Child + Sex, data=treino, FUN=length)
aggregate(Survived ~ Child + Sex, data=treino, FUN=function(x) {sum(x)/length(x)})

treino$Fare2 <- '30+'
treino$Fare2[treino$Fare < 30 & treino$Fare >= 20] <- '20-30'
treino$Fare2[treino$Fare < 20 & train$Fare >= 10] <- '10-20'
treino$Fare2[treino$Fare < 10] <- '<10'
aggregate(Survived ~ Fare2 + Pclass + Sex, data=treino, FUN=function(x) {sum(x)/length(x)})

arvore <- rpart(Survived ~ Fare2 + Pclass + Sex, data=treino, method="class")
print(arvore)
fancyRpartPlot(arvore)

teste$Survived <- 0
teste$Survived[teste$Sex == 'female'] <- 1
teste$Survived[teste$Sex == 'female' & teste$Pclass == 3 & teste$Fare >= 20] <- 0

# result
submit <- data.frame(PassengerId = teste$PassengerId, Survived = teste$Survived)
write.csv(submit, file="submission.csv", row.names = FALSE)
