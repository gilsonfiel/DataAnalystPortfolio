/*10 Filmes mais Rentáveis*/
select 
     f.titulo,
     round(sum(f.preco_aluguel),2) as rentabilidade
from alugueis as a
inner join filmes as f on (a.id_filme=f.id_filme)
group by f.titulo
order by 2 desc
limit 10;

/*Gêneros mais Populares*/
select
	f.genero,
	count(*)
from alugueis as a
inner join filmes as f on (f.id_filme = a.id_filme)
group by 1
order by 2 desc;

/*Quantidade de aluguéis/Nota média/Receita total por filme*/
select
	titulo,
    count(*) as num_alugueis,
    round(avg(nota), 2) as media_nota,
    round(sum(preco_aluguel), 2)  as receita_total
from alugueis as a
inner join filmes as f on (a.id_filme=f.id_filme)
group by titulo
order by media_nota desc
limit 10;
/*Gêneros preferidos por região*/
SELECT 
	c.regiao, 
	f.genero, 
	COUNT(*) as total_preferencias
FROM clientes as c
JOIN alugueis as a on (c.id_cliente = a.id_cliente)
JOIN filmes as f on (a.id_filme = f.id_filme)
GROUP BY c.regiao, f.genero
ORDER BY c.regiao, total_preferencias desc;

