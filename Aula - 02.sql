SELECT  PED.SELLER_ID AS VENDEDOR,ROUND(SUM(CAST(PED.PRICE AS DECIMAL(10,2)) * PED.FREIGHT_VALUE),2) AS VALOR_TOTAL
FROM DBO.PEDIDOS_ITENS PED
GROUP BY PED.SELLER_ID 
ORDER BY 1 DESC

/*
 * Valor Total = price x freight_value
 * Valor Total do Pedido por Vendedor (seller_id) da tabela  pedidos_itens
 * */

-------------

SELECT PEDI.seller_id,
       AVG(PEDI.freight_value)
FROM DBO.pedidos_itens PEDI
GROUP BY PEDI.seller_id 
HAVING avg(PEDI.freight_value) > 50 --filtro having somente quando  tem expressãoo agrupada.

----- 
--com LEFT JOIN

SELECT PEDI.SELLER_ID, AVG(PEDI.FREIGHT_VALUE)
FROM DBO.PEDIDOS_ITENS PEDI
LEFT JOIN DBO.VENDEDORES VEND ON PEDI.SELLER_ID = VEND.SELLER_ID 
WHERE VEND.SELLER_STATE = 'RJ'
GROUP BY PEDI.SELLER_ID 
HAVING AVG(PEDI.FREIGHT_VALUE) > 50 

--com INNER JOIN

SELECT PEDI.SELLER_ID, AVG(PEDI.FREIGHT_VALUE)
FROM DBO.PEDIDOS_ITENS PEDI
INNER JOIN DBO.VENDEDORES VEND ON PEDI.SELLER_ID = VEND.SELLER_ID 
AND VEND.SELLER_STATE = 'RJ'
GROUP BY PEDI.SELLER_ID 
HAVING AVG(PEDI.FREIGHT_VALUE) > 50 

--com SUBQUERY

SELECT PEDI.SELLER_ID,
	   (SELECT SELLER_CITY
		FROM DBO.VENDEDORES VEND
		WHERE VEND.SELLER_ID = PEDI.SELLER_ID)
FROM DBO.PEDIDOS_ITENS PEDI

------

SELECT  DISTINCT
		p.order_id,
		p.order_status,
		(
		SELECT med_pedi FROM (
			SELECT qualquer_nome.order_id,
				   avg(qualquer_nome.media) med_pedi
			FROM (
				SELECT pedi.product_id,
					   pedi.order_id,
					   avg(pedi.freight_value) media
				FROM dbo.pedidos_itens pedi
				GROUP BY pedi.product_id,
						 pedi.order_id
				) as qualquer_nome
			GROUP BY
				qualquer_nome.order_id
			) as tabela
		WHERE tabela.order_id = p.order_id
		)
FROM dbo.pedidos p

------CTE

WITH prod_pedi_med (id_produto, id_pedido, media_prod_ped) AS (
SELECT pedi.product_id,
	   pedi.order_id,
	   avg(pedi.freight_value)
FROM dbo.pedidos_itens pedi
GROUP BY pedi.product_id,
		 pedi.order_id
),
ped_media (id_pedido, media_pedido) AS (
SELECT ppm.id_pedido,
	   avg(ppm.media_prod_ped)
FROM prod_pedi_med ppm
GROUP BY ppm.id_pedido
)
SELECT DISTINCT
	   p.order_id,
	   p.order_status,
	   (
	   		SELECT pm.media_pedido FROM ped_media pm WHERE pm.id_pedido = p.order_id
	   )
FROM dbo.pedidos p
 

