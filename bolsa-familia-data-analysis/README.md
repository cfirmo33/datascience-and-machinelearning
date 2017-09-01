# Análise de dados do programa "Bolsa Família"

# Objetivo
Projeto acadêmico com a intenção de estudar conceitos de ciência de dados e big data com a linguagem de programação R (https://www.r-project.org) para gerar informação a partir de um grande de número de dados não estruturados.

Foi escolhido o dataset público do programa "Bolsa Família" do Governo Federal do Brasil sem nenhum intuito político, partidário ou juízo de valor sobre o programa.

O estudo se limita aos dados disponíveis nos datasets do programa e não faz nenhuma correlação com outros datasets.  

# O que é o programa "Bolsa Família"
De acordo com o site da Caixa Econômica Federal: "É um programa de transferência direta de renda, direcionado às famílias em situação de pobreza e de extrema pobreza em todo o País, de modo que consigam superar a situação de vulnerabilidade e pobreza. O programa busca garantir a essas famílias o direito à alimentação e o acesso à educação e à saúde. Em todo o Brasil, mais de 13,9 milhões de famílias são atendidas pelo Bolsa Família."

# Fonte dos dados
Fonte dos dados do Portal da Transparência do Governo Federal do Brasil (http://www.portaldatransparencia.gov.br/downloads/mensal.asp?c=BolsaFamiliaFolhaPagamento).

Para a obtenção automatizada dos dados foi realizado o scraping em Python executando o script "bolsa_familia.py" e os dados são gravados em ./data

```shell
$ python bolsa_familia.py
Downloading file bolsa_familia_201101.zip ...
File bolsa_familia_201101.zip downloaded!
Downloading file bolsa_familia_201102.zip ...
File bolsa_familia_201102.zip downloaded!
```

O arquivo mensal é gravado no formato zip com o nome bolsa_familia_{year}{month}.zip e contém, em média, 350 KB compactados e 1,7 GB descompactados por mês.

## Dataset
  * Informações: 
    UF; 
    Código SIAFI Município; 
    Nome Município; 
    Código Função; 
    Código Subfunção; 
    Código Programa; 
    Código Ação; 
    NIS Favorecido; 
    Nome Favorecido; 
    Fonte-Finalidade; 
    Valor Parcela 
    Mês Competência.

# Requisitos
  * Linguagem de programação Python versão >= 3.4: https://www.python.org
  * Linguagem de programação R: https://www.r-project.org/

# Perguntas a responder
  O estudo quer responder os seguintes questionamentos:
  
  * Quanto é o gasto mensal no país (plot em colunas verticais).
  * Quanto é o gasto mensal por região (plot em gráfico pizza).
  * Quanto é o gasto mensal por estado (plot em colunas horizontais).
  * Quanto é o número de pessoas beneficiadas por ano por estado (plot em colunas verticais).
  * Quanto é a média mensal de pagamento por pessoa no país e por estado.
  * Qual o menor valor pago no país e por estado.
  * Qual o maior valor pago no país e por estado.
  * Do valor médio recebido por pessoa quais e quantas pessoas recebem 50% a mais, no país e por estado. 

# Licença de uso
  [The MIT License](LICENSE).
    
  Based on a work at https://github.com/leogregianin.
    
