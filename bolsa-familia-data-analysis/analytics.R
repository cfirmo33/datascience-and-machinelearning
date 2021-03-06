
setClass("MyNum")
setAs("character", "MyNum", 
      function(from) as.numeric(gsub(",", "", from) ))

indata <- read.csv("C:\\Users\\leo\\Documents\\bolsa-familia-analytics\\data\\descompact\\201702_BolsaFamiliaFolhaPagamento.csv", 
                   header = TRUE, 
                   sep = "\t", 
                   dec = ".",
                   nrows = 20000,
                   colClasses=c(rep("character", 10), "MyNum", "character"))

typeof(indata$Valor.Parcela)

max(indata$Valor.Parcela)
min(indata$Valor.Parcela)

# plot da faixa de valores
# todo: aumentar faixa de valores
plot(indata$Valor.Parcela)
plot(indata$Valor.Parcela, 
     main="Dispers�o de valores",
     xlab="", 
     ylab="Faixa de valores")

# plot de valores minimos, maximas e m�dia por estado
plot1 <- data.frame(uf = c(indata$UF), valor = c(indata$Valor.Parcela) )
plot(plot1, main="Valores minimos, m�ximas e m�dia por estado",
     xlab="", ylab="Faixa de valores")

# valor total pago por uf
counts <- table(indata$UF)
barplot(counts, main="Valor pago por UF", 
        ylab="Valores (em milh�es)")

# distribuicao normal
x <- rnorm(indata$Valor.Parcela)
y <- rnorm(indata$Valor.Parcela) 
plot(x,y, main="", 
     col=rgb(0,100,0,50,maxColorValue=255))

# histograma com curva
x <- indata$Valor.Parcela
h<-hist(x, 
        breaks=10, 
        col="red", 
        xlab="M�dia dos valores pagos por pessoa",
        ylab="Frequencia de valores", 
        main="Histograma da m�dia de valores pagos") 

xfit<-seq(min(x),max(x),length=40) 
yfit<-dnorm(xfit,mean=mean(x),sd=sd(x)) 
yfit <- yfit*diff(h$mids[1:2])*length(x) 
lines(xfit, yfit, col="blue", lwd=2)
