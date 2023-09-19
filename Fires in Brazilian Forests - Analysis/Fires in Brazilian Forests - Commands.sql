/* Conferindo as colunas disponíveis na base de dados */
SELECT
    *
FROM amazon;

/*Total de ocorrências registradas por ano*/
SELECT
	`year` as ano,
	SUM(`number`) as total_ocorrencias
FROM amazon
GROUP BY 1;

/*Total de casos por mês */
SELECT
	`month` as mês,
	SUM(`number`) as total_ocorrencias
FROM amazon
GROUP BY 1;

/*Total de ocorrencias por estados do Brasil*/
SELECT
	`state` as state,
	SUM(`number`) as total_ocorrencias
FROM amazon
GROUP BY 1
ORDER BY 2 DESC;

/* Quantos casos foram reportados no estado do  Amazonas */
SELECT
	SUM(`number`) AS qtd_casos
FROM amazon
WHERE state = 'Amazonas';

/* Quantidade de casos por ano no estado do Amazonas */
SELECT
	`year` as anos,
	SUM(`number`) AS qtd_casos
FROM amazon
WHERE state = 'Amazonas'
GROUP BY 1;

/*Quantidade de casos mensais no ano de 2003 */
SELECT
	`month` as mês,
    SUM(number) as qtd_casos
FROM amazon
WHERE `year` = 2003
group by 1;

/* Média de casos por estado */
SELECT
	`state` as estado,
    AVG(number) as media_casos
FROM amazon
group by 1
order by 2 desc;

/* Quantidade de incendios relatados no mes de Julho */
SELECT 
	`state` as estado,
    SUM(number) as total_casos
FROM amazon
WHERE `month` = 'Julho'
group by 1
order by 2 desc;
