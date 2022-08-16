use cap05;

#Quantidade de clientes por cidade
SELECT COUNT(id_cliente) quantidade_clientes, cidade_cliente
FROM TB_CLIENTES
GROUP BY cidade_cliente
ORDER BY 1 DESC;

#Média do valor dos pedidos
SELECT AVG(valor_pedido) media_valor
FROM TB_PEDIDOS;

#Media do valor dos pedidos por cidade
SELECT 	
CASE 
	WHEN ROUND(AVG(valor_pedido),2) IS NULL THEN 0
	ELSE ROUND(AVG(valor_pedido),2)
END media_valor, cidade_cliente
FROM TB_PEDIDOS P
RIGHT JOIN TB_CLIENTES C
ON P.id_cliente = C.id_cliente
GROUP BY cidade_cliente
ORDER BY media_valor DESC;

#Soma do valor dos pedidos
SELECT SUM(valor_pedido) AS total_pedidos
FROM TB_PEDIDOS;

#Soma do valor dos pedidos por cidade
SELECT 
CASE 
	WHEN ROUND(SUM(valor_pedido),2) IS NULL THEN 0
	ELSE ROUND(SUM(valor_pedido),2)
END valor_total, cidade_cliente
FROM TB_PEDIDOS P
RIGHT JOIN TB_CLIENTES C
ON P.id_cliente = C.id_cliente
GROUP BY cidade_cliente 
ORDER BY valor_total DESC;

#Soma do valor dos pedidos por cidade e estado
SELECT 
	CASE 
		WHEN FLOOR(SUM(valor_pedido)) IS NULL THEN 0
		ELSE FLOOR(SUM(valor_pedido))
	END total_pedidos, cidade_cliente, estado_cliente
FROM TB_PEDIDOS P 
RIGHT JOIN TB_CLIENTES C
ON P.id_cliente = C.id_cliente
GROUP BY cidade_cliente, estado_cliente
ORDER BY total_pedidos DESC;

#Supondo que a comissão de cada vendedor seja de 10%, quanto cada vendendor ganhou de comissão nas vendas no estado do Ceará?
#Retorne 0 se não houve ganho de comissão
SELECT nome_vendedor, estado_cliente, 
	CASE
		WHEN ROUND(sum(valor_pedido * .10),2) IS NULL THEN 0
        ELSE ROUND(sum(valor_pedido * .10),2)
	END comissao
FROM tb_pedidos p
JOIN tb_clientes c
ON p.id_cliente = c.id_cliente
RIGHT JOIN tb_vendedor v
ON p.id_vendedor = v.id_vendedor
WHERE estado_cliente = 'CE'
GROUP BY nome_vendedor, estado_cliente;

#Valor maior
SELECT MAX(valor_pedido) pedido, nome_cliente cliente, nome_vendedor vendedor
FROM TB_PEDIDOS p
LEFT JOIN TB_CLIENTES c
ON c.id_cliente = p.id_cliente
LEFT JOIN TB_VENDEDOR v
ON p.id_vendedor = v.id_vendedor;

#Menor maior
SELECT MIN(valor_pedido) pedido, nome_cliente cliente, nome_vendedor vendedor
FROM TB_PEDIDOS p
LEFT JOIN TB_CLIENTES c
ON c.id_cliente = p.id_cliente
LEFT JOIN TB_VENDEDOR v
ON p.id_vendedor = v.id_vendedor;

#Número de pedidos
SELECT COUNT(DISTINCT(id_cliente)) qtd_pedidos
FROM TB_PEDIDOS; 

#Número de pedidos do Ceará
SELECT COUNT(DISTINCT(p.id_cliente)) qtd_pedidos
FROM TB_PEDIDOS p
LEFT JOIN TB_CLIENTES c
ON p.id_cliente = c.id_cliente
WHERE c.estado_cliente = 'CE'; 

#Algum vendedor participou de vendas cujo o valor tenha sido superior a 600 no estado de São Paulo?
SELECT valor_pedido, data_pedido , nome_cliente cliente, nome_vendedor vendedor, cidade_cliente, estado_cliente
FROM TB_PEDIDOS p
LEFT JOIN TB_CLIENTES c
ON c.id_cliente = p.id_cliente
LEFT JOIN TB_VENDEDOR v
ON p.id_vendedor = v.id_vendedor
WHERE valor_pedido > 600
AND estado_cliente = 'SP';

#Algum vendedor participou de vendas em que a média do valor do pedido por estado do cliente tenha sido superior a 800?
SELECT nome_vendedor, ROUND(AVG(valor_pedido),2) media, estado_cliente
FROM TB_PEDIDOS p
LEFT JOIN TB_CLIENTES c
ON p.id_cliente = c.id_cliente
LEFT JOIN TB_VENDEDOR v
ON p.id_vendedor = v.id_vendedor
GROUP BY nome_vendedor, estado_cliente
HAVING media > 800
ORDER BY nome_vendedor DESC;

#Qual estado teve mais de 5 pedidos
SELECT count(id_pedido) pedidos, estado_cliente
FROM TB_CLIENTES c
LEFT JOIN TB_PEDIDOS p
ON c.id_cliente = p.id_cliente
GROUP BY estado_cliente
HAVING pedidos > 5
ORDER BY estado_cliente;

#Faturamento por ano
SELECT SUM(faturamento) faturamento, ano
FROM TB_VENDAS
GROUP BY ano;

#Faturamento por ano e total geral
SELECT SUM(faturamento) faturamento, ano
FROM TB_VENDAS
GROUP BY ano
WITH ROLLUP;

#Faturamento por ano e total geral ordenando por ano
SELECT SUM(faturamento) faturamento, ano
FROM TB_VENDAS
GROUP BY ano
WITH ROLLUP
ORDER BY ano;

#Faturamento total por ano e país e total geral com agrupamento do resultado
SELECT
	IF(GROUPING(ano), 'Total de Anos', ano) ano,
	IF(GROUPING(pais), 'Total de Países', pais) pais,
	IF(GROUPING(produto), 'Total de Produtos', produto) produto,
	SUM(faturamento) faturamento 
FROM TB_VENDAS
GROUP BY ano, pais, produto WITH ROLLUP;
