use excap04;
#Retornar id do pedido e nome do cliente
#Inner Join
SELECT p.id_pedido, c.nome_cliente
FROM TB_PEDIDOS p
JOIN TB_CLIENTES c
USING (id_cliente);

#Retornar id do pedido, nome do cliente e nome do vendedor
#Inner Join 3 tabelas
SELECT p.id_pedido, c.nome_cliente, v.nome_vendedor
FROM TB_PEDIDOS p
JOIN TB_CLIENTES c
ON p.id_cliente = c.id_cliente
JOIN TB_VENDEDOR v
USING (id_vendedor);

#Retornar todos os clientes, com ou sem pedido associado
SELECT c.nome_cliente, p.id_pedido
FROM TB_CLIENTES c
LEFT JOIN TB_PEDIDOS p
USING (id_cliente);

#Retorne a data do pedido, nome do cliente, todos os vendedores, com ou sem pedido associado e ordenar pelo nome do cliente
SELECT 
CASE WHEN p.data_pedido IS NULL THEN 'Sem Pedido' ELSE p.data_pedido END data_pedido, 
CASE WHEN c.nome_cliente IS NULL THEN 'Sem Pedido' ELSE c.nome_cliente END nome_cliente, v.nome_vendedor
FROM TB_VENDEDOR v
LEFT JOIN TB_PEDIDOS p
USING (id_vendedor)
LEFT JOIN TB_CLIENTES c
USING (id_cliente)
ORDER BY c.nome_cliente;

#Retornar clientes que sejam da mesma cidade
SELECT a.nome_cliente, a.cidade_cliente 
FROM TB_CLIENTES a, TB_CLIENTES b
WHERE a.id_cliente != b.id_cliente
AND a.cidade_cliente = b.cidade_cliente;
