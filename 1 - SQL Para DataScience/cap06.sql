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

