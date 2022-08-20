USE exec4;

UPDATE HUBS SET hub_city = 'SAO PAULO' WHERE hub_city = 'S';

SELECT * FROM HUBS;

#Qual o número de hubs por cidade?
SELECT COUNT(hub_id) quantidade, hub_city 
FROM HUBS
GROUP BY hub_city
ORDER BY quantidade DESC;

#Qual o numero de pedidos por status
SELECT COUNT(order_id) pedidos, order_status
FROM ORDERS
GROUP BY order_status;

#Qual o numero de stores por cidade dos hubs
SELECT COUNT(store_id) lojas, hub_city 
FROM STORES s
JOIN HUBS h
ON s.hub_id = h.hub_id
GROUP BY hub_city
ORDER BY lojas DESC;

#Qual o maior e menor valor de pagamento registrado?
SELECT MAX(payment_amount) maior,  MIN(payment_amount) menor 
FROM PAYMENTS;

#Qual tipo de drivers fez o maior numero de entregas
SELECT count(delivery_id) entregas, driver_type
FROM DELIVERIES de
JOIN DRIVERS dr
ON de.driver_id = dr.driver_id
GROUP BY driver_type
ORDER BY entregas DESC;

#Qual a distancia media das entregas por modo de driver?
SELECT AVG(delivery_distance_meters) distancia_media, driver_modal
FROM deliveries de
JOIN drivers dr
ON de.driver_id = dr.driver_id
GROUP BY driver_modal;

#Qual a média do valor de pedido por loja, em ordem decrescente
SELECT round(AVG(order_amount),2) media_pedido, store_name
FROM orders o
JOIN stores s
ON o.store_id = s.store_id
GROUP BY store_name
ORDER BY media_pedido DESC;

#Existe pedidos que não estão associados a lojas? se positivo quantos?
SELECT COUNT(order_id) pedidos FROM orders WHERE store_id IS NULL;

#Qual o valor total de pedidos no canal food place?
SELECT ROUND(SUM(order_amount),2) total_pedidos, channel_id
FROM ORDERS
WHERE channel_id = 5;

#Quantos pagamentos foram cancelados
SELECT payment_status, count(payment_id) total_cancelados 
FROM payments
where payment_status = 'CHARGEBACK';

#Qual a média dos pagamentos cancelados
SELECT payment_status, round(AVG(payment_amount),2) media_cancelados
FROM payments
where payment_status = 'CHARGEBACK';

#Qual a média do valor de pagamento em ordem decrescente
SELECT round(AVG(payment_amount),2) media_pagamento, payment_method 
FROM payments
GROUP BY payment_method
ORDER BY media_pagamento DESC;

#Quais metodos de pagamento tiveram valor médio superior a 100?
SELECT round(AVG(payment_amount),2) media_pagamento, payment_method 
FROM payments
GROUP BY payment_method
HAVING media_pagamento > 100
ORDER BY media_pagamento DESC;

#Qual a média de valor de pedido por estado do hub, segmento da loja e tipo de canal
SELECT ROUND(AVG(order_amount),2) media_valor, h.hub_state, store_segment,  channel_type
FROM HUBS h
JOIN STORES s
ON h.hub_id = s.hub_id
JOIN ORDERS o
ON s.store_id = o.store_id
JOIN CHANNELS c
ON o.channel_id = c.channel_id
GROUP BY h.hub_state, store_segment, channel_type
ORDER BY media_valor DESC;

#Qual estado do Hub, segmento da loja e tipo de canal teve média de valor de pedido maior que 450
SELECT ROUND(AVG(order_amount),2) media_valor, h.hub_state, store_segment,  channel_type
FROM HUBS h
JOIN STORES s
ON h.hub_id = s.hub_id
JOIN ORDERS o
ON s.store_id = o.store_id
JOIN CHANNELS c
ON o.channel_id = c.channel_id
GROUP BY h.hub_state, store_segment, channel_type
HAVING media_valor > 450
ORDER BY media_valor DESC;

#Qual o valor total de pedido por estado do hub, segmento da loja e tipo de canal
#Demostre os totais intermediarios e formate o resultado
SELECT 
	IF(GROUPING(hub_state), 'Total Hub State', hub_state) AS hub_state,
    IF(GROUPING(store_segment), 'Total Segmento', store_segment) AS store_segment,
    IF(GROUPING(channel_type), 'Total Tipo de Canal', channel_type) AS channel_type,
    ROUND(SUM(order_amount),2) total_pedido
FROM ORDERS o
JOIN STORES s
ON o.store_id = s.store_id
JOIN CHANNELS c
ON o.channel_id = c.channel_id
JOIN HUBS h
ON s.hub_id = h.hub_id
GROUP BY hub_state, store_segment, channel_type WITH ROLLUP;

#Quando o pedido era do Hub do Rio de Janeiro, segmento de loja 'FOOD', tipo de canal Marketplace e foi cancelado, qual foi a média de valor do pedido?
SELECT hub_state, store_segment, channel_type, ROUND(AVG(order_amount),2) AS media_pedido
FROM orders o 
JOIN stores s
ON s.store_id = o.store_id
JOIN channels c
ON c.channel_id = o.channel_id
JOIN hubs h
ON h.hub_id = s.hub_id
WHERE order_status = 'CANCELED'
AND store_segment = 'FOOD'
AND channel_type = 'MARKETPLACE'
AND hub_state = 'RJ'
GROUP BY hub_state, store_segment, channel_type;

#Quando o pedido era do segmento de loja 'GOOD', tipo de canal Marketplace e foi cancelado, algum hub_state teve total de valor do pedido superior a 100.000?
SELECT hub_state, store_segment, channel_type, ROUND(SUM(order_amount),2) AS total_pedido
FROM orders o 
JOIN stores s 
ON s.store_id = o.store_id
JOIN channels c
ON c.channel_id = o.channel_id
JOIN hubs h
ON h.hub_id = s.hub_id
WHERE order_status = 'CANCELED'
AND store_segment = 'GOOD'
AND channel_type = 'MARKETPLACE'
GROUP BY hub_state, store_segment, channel_type
HAVING total_pedido > 100000;

#Em que data houve a maior média de valor do pedido?
SELECT SUBSTRING(order_moment_created, 1, 9) AS data_pedido, ROUND(AVG(order_amount),2) AS media_pedido
FROM orders
GROUP BY data_pedido
ORDER BY media_pedido DESC;

#Em quais datas o valor do pedido foi igual a zero?
SELECT SUBSTRING(order_moment_created, 1, 9) AS data_pedido, MIN(order_amount) AS min_pedido
FROM orders
GROUP BY data_pedido
HAVING min_pedido = 0
ORDER BY data_pedido ASC;

use cap06;

SELECT * FROM tb_vendas;

#Total de vendas
SELECT sum(valor_venda) total_venda 
FROM tb_vendas;

#Total de vendas por ano fiscal
SELECT sum(valor_venda) total_venda, ano_fiscal 
FROM tb_vendas
GROUP BY ano_fiscal;

#Total de vendas por funcionario
SELECT sum(valor_venda) total_venda, nome_funcionario 
FROM tb_vendas
GROUP BY nome_funcionario
ORDER BY nome_funcionario;

#Total de vendas por funcionario e ano
SELECT sum(valor_venda) total_venda, nome_funcionario, ano_fiscal
FROM tb_vendas
GROUP BY nome_funcionario, ano_fiscal
ORDER BY ano_fiscal DESC;

#Total de vendas por funcionario, ano e total de vendas por ano
SELECT valor_venda, nome_funcionario, ano_fiscal,
SUM(valor_venda) OVER (PARTITION BY ano_fiscal) total_vendas_ano
FROM tb_vendas
ORDER BY ano_fiscal DESC;

#Total de vendas por ano, por funcionário e total de vendas do funcionário
SELECT 
    nome_funcionario,
    valor_venda,
	ano_fiscal, 
    SUM(valor_venda) OVER (PARTITION BY nome_funcionario) total_vendas_func
FROM TB_VENDAS
ORDER BY ano_fiscal;

#Total de vendas por ano, por funcionário e total de vendas geral
SELECT 
    ano_fiscal, 
    nome_funcionario,
    valor_venda,
    SUM(valor_venda) OVER() total_vendas_geral
FROM TB_VENDAS
ORDER BY ano_fiscal;

#Número de vendas por ano, por funcionário e número total de vendas em todos os anos
SELECT 
    ano_fiscal, 
    nome_funcionario,
    COUNT(*) num_vendas_ano,
    COUNT(*) OVER() num_vendas_geral
FROM TB_VENDAS
GROUP BY ano_fiscal, nome_funcionario
ORDER BY ano_fiscal;

#Reescrevendo a query anterior usando subquery
SELECT ano_fiscal, nome_funcionario, COUNT(*) num_vendas_ano,
(SELECT COUNT(*) FROM TB_VENDAS) as num_vendas_geral
FROM TB_VENDAS
GROUP BY ano_fiscal, nome_funcionario
ORDER BY ano_fiscal;




