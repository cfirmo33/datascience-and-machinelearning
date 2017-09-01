
# importacao do csv para o R -----------------------------------------------------
indata <- list()
filename = paste(".\datasets\deputados.csv", sep = ";")

indata <- read.csv(filename, 
                   header = TRUE, 
                   sep = ";", 
                   dec = ".")

# correcao das casas decimais -----------------------------------------------------
indata$vlrLiquido <- sub(",",".",indata$vlrLiquido)
indata$vlrLiquido <- as.numeric(indata$vlrLiquido)

# analise inicial dos dados --------------------------------
is(indata)
str(indata)
head(indata[,c("genero","vlrLiquido","sgPartido","sgUF")])

unique(indata$sgUF)
indata$vlrLiquido
is(indata$vlrLiquido)
max(indata$vlrLiquido)
min(indata$vlrLiquido)
summary(indata$vlrLiquido)
unique(indata$numAno)

# importacao das libs ------------------------------------------
library(dplyr)
library(ggplot2)
library(gridExtra) 
library(plotly)
library(tidyverse)
library(lubridate)
library(ggmap)
library(viridisLite)
library(viridis)

# filtro dos dados --------------------------------------
#deputados <- indata %>% 
#  filter(indata$numAno == '2016')
deputados <- indata

# reordenacao das colunas ------------------------------
reorder_factor <- function(x) {
  ordered(x, levels = x)
}

new_tema <- theme_classic() +
  theme(
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.title = element_blank(),
    legend.position = "bottom"
  )

# summary para cada um dos deputados
deputados_summ <- deputados %>%
  filter(!is.na(sgUF)) %>%
  group_by(txNomeParlamentar) %>%
  summarise(
    reembolso_cnt = n(),
    reembolso_media = mean(vlrLiquido),
    reembolso_total = sum(vlrLiquido),
    estado = sgUF[1],
    partido = sgPartido[1]
  ) %>%
  ungroup()

# summary por dia
mes_summ <- deputados %>%
  filter(!is.na(sgUF)) %>%
  mutate(reembolso_mes = numMes) %>%
  group_by(reembolso_mes) %>%
  summarise(
    reembolso_cnt = n(),
    reembolso_media = mean(vlrLiquido),
    reembolso_total = sum(vlrLiquido)
  ) %>%
  ungroup()

# summary por tipo de despesa
tipo_summ <- deputados %>%
  group_by(txtDescricao) %>%
  summarise(
    reembolso_cnt = n(),
    reembolso_media = mean(vlrLiquido),
    reembolso_total = sum(vlrLiquido)
  ) %>%
  ungroup()

# summary das passagens 
passagem_summ <- deputados %>%
  filter(txtDescricao == "Emissão Bilhete Aéreo") %>%
  group_by(numMes) %>%
  summarise(
    reembolso_cnt = n(),
    reembolso_media = mean(vlrLiquido),
    reembolso_total = sum(vlrLiquido)
  ) %>%
  ungroup()

# summary das passagens por partido
passagem_partido_summ <- deputados %>%
  filter(txtDescricao == "Emissão Bilhete Aéreo") %>%
  group_by(sgPartido) %>%
  summarise(
    reembolso_cnt = n(),
    reembolso_media = mean(vlrLiquido),
    reembolso_total = sum(vlrLiquido)
  ) %>%
  ungroup()

# summary das passagens por uf
passagem_uf_summ <- deputados %>%
  filter(txtDescricao == "Emissão Bilhete Aéreo") %>%
  group_by(sgUF) %>%
  summarise(
    reembolso_cnt = n(),
    reembolso_media = mean(vlrLiquido),
    reembolso_total = sum(vlrLiquido)
  ) %>%
  ungroup()

# plots iniciais --------------------------------

deputados_summ %>%
  arrange(reembolso_cnt) %>%
  mutate(txNomeParlamentar = reorder_factor(txNomeParlamentar)) %>%
  ggplot(aes(txNomeParlamentar, reembolso_cnt, color = partido)) +
  geom_point() +
  new_tema + 
  guides(col = guide_legend(ncol = 20))

# media de reembolso
deputados_summ %>%
  arrange(reembolso_media) %>%
  mutate(txNomeParlamentar = reorder_factor(txNomeParlamentar)) %>%
  ggplot(aes(txNomeParlamentar, reembolso_media, color = partido)) +
  geom_point() +
  new_tema + 
  guides(col = guide_legend(ncol = 20))

# total reembolso
deputados_summ %>%
  arrange(reembolso_total) %>%
  mutate(txNomeParlamentar = reorder_factor(txNomeParlamentar)) %>%
  ggplot(aes(txNomeParlamentar, reembolso_total, color = partido)) +
  geom_point() +
  new_tema + 
  guides(col = guide_legend(ncol = 20))

# dispersao de valores -----------------------------------------------------
p1 = qplot(y = deputados$vlrLiquido, data = deputados) +
  ggtitle('Dispersao de valores') +
  xlab('') +
  ylab('Faixa de valores')
grid.arrange(p1, ncol = 1)

qplot(y = deputados$vlrLiquido, data = deputados) +
  ggtitle('Dispersao de valores (acima de R$ 50.000) ') +
  xlab('') +
  ylab('Faixa de valores') +
  scale_y_continuous(limits = c(50000, 200000))

plot_ly(x = deputados, 
        y = deputados$vlrLiquido, 
        mode = "lines", 
        fill = "tozeroy")

# densidade 
t <- deputados %>%
  select(vlrLiquido)
t <- density(mes_summ$reembolso_media)
plot_ly(x = t$x, y = t$y, mode = "lines", fill = "tozeroy")

# parcelas reembolso X media reembolso
deputados_summ %>%
  arrange(reembolso_cnt) %>%
  mutate(txNomeParlamentar = reorder_factor(txNomeParlamentar)) %>%
  ggplot(aes(reembolso_cnt, reembolso_media, color = partido)) +
  geom_point() +
  theme_classic() +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom"
  ) +
  guides(col = guide_legend(ncol = 20))


# parcelas reembolso X total reembolso
deputados_summ %>%
  arrange(reembolso_cnt) %>%
  mutate(txNomeParlamentar = reorder_factor(txNomeParlamentar)) %>%
  ggplot(aes(reembolso_cnt, reembolso_total, color = partido)) +
  geom_point() +
  theme_classic() +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom"
  ) +
  guides(col = guide_legend(ncol = 10))

# media reembolso X total reembolso
deputados_summ %>%
  arrange(reembolso_media) %>%
  mutate(txNomeParlamentar = reorder_factor(txNomeParlamentar)) %>%
  ggplot(aes(reembolso_media, reembolso_total, color = partido)) +
  geom_point() +
  theme_classic() +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom"
  ) +
  guides(col = guide_legend(ncol = 20))


#kmeans
str(deputados$sgPartido)
head(deputados[,c("txtDescricao","sgPartido")])
tt <- data.frame(is.na(deputados$vlrLiquido))

set.seed(20)
deputados %>%
  


# quantidade de reembolsos total
#data_summ %>%
#  plot_ly(
#    x = ~reembolso_mes,
#    y = ~reembolso_cnt,
#    type = 'bar'
#  )

# media de reembolso total
#data_summ %>%
#  plot_ly(
#   x = ~reembolso_mes,
#    y = ~reembolso_total,
#    type = 'bar'
#  )

# quantidade de reembolsos de passagens aereas por mes
passagem_summ %>%
  plot_ly(
    x = ~numMes,
    y = ~reembolso_total,
    type = 'bar'
  )

# media de reembolsos de passagens aereas
passagem_summ %>%
  plot_ly(
    x = ~numMes,
    y = ~reembolso_media,
    type = 'bar'
  )

# quantidade de reembolsos de passagens aereas por uf
passagem_uf_summ %>%
  plot_ly(
    x = ~sgUF,
    y = ~reembolso_total,
    type = 'bar'
  )

# media de reembolsos de passagens aereas por uf
passagem_uf_summ %>%
  plot_ly(
    x = ~sgUF,
    y = ~reembolso_media,
    type = 'bar'
  )



# media de reembolsos de passagens aereas por partido
#passagem_partido_summ %>%
#  plot_ly(
#    y = ~reembolso_media,
#    color = ~sgPartido,
#    type = "box"
#  )

# reembolso medio (box) por partido
deputados_summ %>%
  plot_ly(
    y = ~reembolso_media,
    color = ~partido,
    type = "box"
  )

# reembolso medio (box) por estado
deputados_summ %>%
  plot_ly(
    y = ~reembolso_media,
    color = ~estado,
    type = "box"
  )

passagem_summ %>%
  plot_ly(
    x = ~txtDescricao,
    y = ~reembolso_cnt,
    type = "bar"
  )

tipo_summ %>%
  plot_ly(
    x = ~txtDescricao,
    y = ~reembolso_media,
    type = "bar"
  )

# valor total por tipo de reembolso
tipo_summ %>%
  plot_ly(
    x = ~txtDescricao,
    y = ~reembolso_total,
    type = "bar",
    color = ~txtDescricao
  ) %>%
  layout(legend = list(orientation = 'h'), xaxis = list(
    showticklabels = FALSE,
    title = ""
  ))

t <- deputados %>%
  group_by(deputados$txtDescricao) %>%
  summarise(med = median(vlrLiquido)) %>%
  arrange(med) %>%
  select(txtDescricao)
  txtDescricao <- ordered(
    deputados$txtDescricao,
    levels = t$txtDescricao
)

# boxplot por tipo de despesa
deputados %>%
  plot_ly(
    x = ~txtDescricao,
    y = ~vlrLiquido,
    type = "box",
    color = ~txtDescricao
  ) %>%
  layout(legend = list(orientation = 'h'), xaxis = list(
    showticklabels = FALSE,
    title = ""
  ))

# correlacao
matrix_relacao <- deputados_summ[c("reembolso_total", "reembolso_media")]
m <- cor(matrix_relacao)
cor(, c("reembolso_medio", "reembolso_medio"))

# afinidade
matrix = data.frame(deputados)
s <- sample(matrix, 10)
a <- affinity(s)

# arvore de decisao
deputados_summ$gastador <- 1000
formula <- 
tree <- ctree(formula, data = deputados_summ)



# classificacao
dep_cluster <- kmeans(deputados_summ[c("reembolso_total", "partido")], 5)
is(depCluster)

deputados
deputados_summ

# algoritmo apriori
library(arules);
library(arulesViz);
matrix = data.frame(deputados_summ$estado, deputados_summ$partido)
assoc = apriori(matrix, parameter=list(support=0.01, confidence=0.01))
plot(assoc, measure=c("support","lift"), shading="confidence")


