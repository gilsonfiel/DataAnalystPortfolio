--Tratamento dos dados
--Conferindo se há registros duplicados
SELECT
  invoice_and_item_number AS id,
  COUNT(*) AS total
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY id
HAVING total > 1;
--Verificando se há vendas sem valor registrado
SELECT
  *
FROM `bigquery-public-data.iowa_liquor_sales.sales`
WHERE sale_dollars IS NULL;



--Visão geral do conjunto de dados
--Colunas disponíveis
SELECT
  *
FROM `bigquery-public-data.iowa_liquor_sales.sales`
LIMIT 1000;

--Quantidade de registros no conjunto de dados
SELECT
  COUNT(*) AS total_de_registros
FROM `bigquery-public-data.iowa_liquor_sales.sales`;


--Escolhendo as colunas que serão utilizadas em um primeiro momento
SELECT  
  date AS data,
  city AS cidade,
  category_name AS categoria,
  item_description AS bebida,
  pack AS pacote,
  bottles_sold AS garrafas_vendidas,
  sale_dollars AS vendas_dolar
FROM `bigquery-public-data.iowa_liquor_sales.sales`
LIMIT 1000;

--Buscando respostas
--Como estão as vendas ao passar dos anos?
SELECT 
  EXTRACT(year from date) AS ano,
  ROUND(SUM(sale_dollars), 2) AS total_vendas
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY ano
ORDER BY ano;

--Quais categorias de bebidas e marcas mais vendidas durante esses anos?
--Categorias
SELECT
  category_name AS categoria,
  COUNT(*) AS qtd_vendas
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY categoria
ORDER BY qtd_vendas DESC
LIMIT 10;
--Marcas
SELECT
  item_description AS bebida,
  COUNT(*) AS qtd_vendas
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY bebida
ORDER BY qtd_vendas DESC
LIMIT 10;

--Como a popularidade das marcas mudou ao longo do tempo?
WITH Temp_table AS (
  SELECT 
    EXTRACT (YEAR FROM date) AS ano,
    item_description,
    COUNT(*) AS num
  FROM `bigquery-public-data.iowa_liquor_sales.sales`
  GROUP BY ano, item_description

)
SELECT *
FROM (
  SELECT *,
  DENSE_RANK() OVER(PARTITION BY ano ORDER BY num DESC) AS rank
  FROM Temp_table
) AS ranked
WHERE rank <= 10
ORDER BY ano, rank;

--Conferindo as vendas em cada mês do ano
SELECT
  EXTRACT(MONTH from date) AS mes,
  CASE 
    WHEN EXTRACT(MONTH from date) = 1 THEN 'Janeiro'
    WHEN EXTRACT(MONTH from date) = 2 THEN 'Fevereiro'
    WHEN EXTRACT(MONTH from date) = 3 THEN 'Março'
    WHEN EXTRACT(MONTH from date) = 4 THEN 'Abril'
    WHEN EXTRACT(MONTH from date) = 5 THEN 'Maio'
    WHEN EXTRACT(MONTH from date) = 6 THEN 'Junho'
    WHEN EXTRACT(MONTH from date) = 7 THEN 'Julho'
    WHEN EXTRACT(MONTH from date) = 8 THEN 'Agosto'
    WHEN EXTRACT(MONTH from date) = 9 THEN 'Setembro'
    WHEN EXTRACT(MONTH from date) = 10 THEN 'Outubro'
    WHEN EXTRACT(MONTH from date) = 11 THEN 'Novembro'
    WHEN EXTRACT(MONTH from date) = 12 THEN 'Dezembro'
    ELSE 'Mês indefinido'
  END AS nome_mes,
  ROUND(SUM(sale_dollars),2) AS total_vendas
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY mes, nome_mes
ORDER BY mes;

--Quais cidades tiveram mais vendas?
SELECT 
  city AS cidade,
  SUM(sale_dollars) AS total_vendas
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY cidade
ORDER BY total_vendas DESC
LIMIT 10;

--Qual a média de preços para os clientes nas bebidas alcoolicas por categoria?
SELECT
  category_name AS categoria,
  COUNT(*) AS qtd_bebidas,
  ROUND(AVG(state_bottle_retail), 2) AS media_preco
FROM `bigquery-public-data.iowa_liquor_sales.sales`
WHERE bottles_sold <> 0
GROUP BY categoria
ORDER BY media_preco DESC
LIMIT 10;

--Quais marcas de bebidas têm a maior margem de lucro para os varejistas?
SELECT
  item_description AS bebida,
  COUNT(*) AS qtd_bebidas_vendidas,
  ROUND(AVG(state_bottle_cost),2) AS media_custo,
  ROUND(AVG(state_bottle_retail),2) AS media_valor_venda,
  ROUND(AVG(state_bottle_retail) - AVG(state_bottle_cost), 2) AS lucro_medio,
  ROUND(((AVG(state_bottle_retail) - AVG(state_bottle_cost)) / AVG(state_bottle_retail)) * 100, 2) AS margem
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY bebida
HAVING qtd_bebidas_vendidas >= 10
ORDER BY margem DESC
LIMIT 5;

--Quais fornecedores são mais frequentes? E quais realizaram mais vendas?
SELECT 
  vendor_name AS fornecedor,
  COUNT(*) AS qtd_vendas,
  SUM(sale_dollars) AS total_vendas
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY fornecedor
ORDER BY qtd_vendas DESC, total_vendas DESC
LIMIT 10;

-- No cidade de Des Moines, quais marcas e fornecedores tiveram mais saída ao longo dos anos?
SELECT
  vendor_name as fornecedor,
  item_description as bebida,
  COUNT(*) AS qtd_vendas
FROM `bigquery-public-data.iowa_liquor_sales.sales`
WHERE city = 'DES MOINES'
GROUP BY fornecedor, bebida
ORDER BY qtd_vendas DESC
LIMIT 10;

--Quais lojas obtiveram um total de vendas maior durante o tempo?
SELECT
  store_name AS loja,
  SUM(sale_dollars) AS total_vendas
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY loja
ORDER BY total_vendas DESC
LIMIT 10;

--Total de volume (L) vendido ao longo dos anos.
SELECT
  EXTRACT(year from date) AS year,
  ROUND(SUM(volume_sold_liters), 2) AS total_volume_vendido_L
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY year
ORDER BY year;

--Buscando as 10 bebidas, e suas respectivas categorias, com maior quantidade de vendas.
SELECT
  item_description AS bebida,
  category_name AS categoria,
  COUNT(*) AS qtd_vendas
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY bebida, categoria
ORDER BY qtd_vendas DESC
LIMIT 10;
