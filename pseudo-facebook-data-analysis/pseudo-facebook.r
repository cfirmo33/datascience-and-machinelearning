
### Importação pseudo-Facebook dataset
filename <- "pseudo_facebook.tsv"
pf <- read.csv(filename, sep = "\t")

### Histograma dos dias de aniversário dos usuários
install.packages('ggplot2')
library(ggplot2)
ggplot(aes(x = dob_day), data = pf) + 
  geom_histogram(binwidth = 1) + 
  scale_x_continuous(breaks = 1:31)

### Faceting
ggplot(data = pf, aes(x = dob_day)) + 
  geom_histogram(binwidth = 1) + 
  scale_x_continuous(breaks = 1:31) + 
  facet_wrap(~dob_month)

### Contador de amigos - Histograma da quantidade de amigos. O gráfico ficou com cauda longa, abaixo vamos melhorá-lo.
qplot(x = friend_count, data = pf)

### Limitando os eixos - Limitando o eixo X para diminuir a abrangência dos dados.
qplot(x = friend_count, data = pf, xlim = c(0, 1000))

### Explorando a largura dos eixos
ggplot(aes(x = friend_count), data = pf) + 
  geom_histogram(binwidth = 25) + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50))

qplot(x = friend_count, data = pf, binwidth = 25) + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50))

### Faceting Friend Count
qplot(x = friend_count, data = pf, binwidth = 10) +
  scale_x_continuous(limits = c(0, 1000),
                     breaks = seq(0, 1000, 50))

### Estatísticas por gênero
qplot(x = friend_count, data = pf) + 
  facet_grid(gender ~ .) 

ggplot(aes(x = friend_count), data = pf) + 
  geom_histogram() + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50)) + 
  facet_wrap(~gender)

### Omitindo vários NA
ggplot(aes(x = friend_count), data = subset(pf, !is.na(gender))) + 
  geom_histogram() + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50)) + 
  facet_wrap(~gender)

#### Estatísticas por gênero
by(pf$friend_count, pf$gender, summary)

### Estatística de duração e quantos dias de uso dos usuários
ggplot(aes(x = tenure), data = pf) + 
   geom_histogram(binwidth = 30, color = 'black', fill = '#099DD9')

ggplot(aes(x = tenure / 365), data = pf) + 
   geom_histogram(binwidth = .25, 
                  color = 'black', 
                  fill = '#F79420') +
  scale_x_continuous(breaks = seq(1, 7, 1), limits = c(0, 7))

### Alterando labels dos plots
ggplot(aes(x = tenure / 365), data = pf) + 
  geom_histogram(color = 'black', fill = '#F79420') + 
  scale_x_continuous(breaks = seq(1, 7, 1), limits = c(0, 7)) + 
  xlab('Number of years using Facebook') + 
  ylab('Number of users in sample')

### Idade dos usuários
qplot(x = age, data = pf, binwidth = 1,
      color = I("black"), fill = ("#5760AB"))

### Visualização de 3 plots em uma imagem
install.packages('gridExtra') 
library(gridExtra) 

p1 = qplot(x = friend_count, data = pf)
p2 = qplot(x = log10(friend_count + 1), data = pf)
p3 = qplot(x = sqrt(friend_count), data = pf)

grid.arrange(p1, p2, p3, ncol = 1)

### Frequencia de poligonos
ggplot(aes(x = friend_count, y = ..count../sum(..count..)), data = subset(pf, !is.na(gender))) + 
  geom_freqpoly(aes(color = gender), binwidth=10) + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50)) + 
  xlab('Friend Count') + 
  ylab('Percentage of users with that friend count')

### Likes por gênero
by(pf$www_likes, pf$gender, sum)

### Box Plots
qplot(x = gender, y = friend_count,
      data = subset(pf, !is.na(gender)), 
      geom="boxplot",
      ylim = c(0, 1000))

qplot(x = gender, y = friend_count,
      data = subset(pf, !is.na(gender)), 
      geom="boxplot") +
      scale_y_continuous(limits = c(0, 1000))
