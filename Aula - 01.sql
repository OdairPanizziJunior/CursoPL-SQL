SELECT 'ola mundo' -- string/texto

SELECT 10 --integer

SELECT 10.5 -- float

SELECT 
	LEN(CLI.customer_state)   AS UF, 
	UPPER(CLI.CUSTOMER_CITY) 	AS CIDADE
FROM DBO.CLIENTES AS CLI


SELECT 
	CLI.CUSTOMER_STATE   AS UF, 
	CLI.CUSTOMER_CITY 	 AS CIDADE
FROM 
	DBO.CLIENTES AS CLI
WHERE
	-- CLI.customer_state = 'RS' AND customer_city LIKE '%SUL'
	-- CLI.customer_state <> 'RS' AND CLI.customer_state <> 'SC'
    -- CLI.customer_state NOT IN ('RS','SC')
    -- CLI.customer_CITY LIKE '%SUL%' -- CONTEM "SUL"
	

SELECT * FROM dbo.pedidos PED
WHERE PED.order_purchase_timestamp BETWEEN '2017-01-01-' AND '2017-12-31'
--ORDER BY PED.order_purchase_timestamp 
ORDER BY 4 DESC  -- QUARTA COLUNA 


SELECT 
	pedi.price 			            PRECO, 
	pedi.freight_value 	            FRETE,
	pedi.price * pedi.freight_value MULTIPLOS 
FROM 
	dbo.pedidos_itens pedi
	
/*
        +     -> adição
        -     -> subtração
        *     -> multiplicação
        /     -> resto da divisão 
        %     -> resto da divisão
*/

	
-- CTE - subquerys / tabelas virtuais
	
	
-- fazer média simples ---	
SELECT 
	ROUND(SUM(CAST(PEDI.PRICE AS DECIMAL(10,2)) * PEDI.FREIGHT_VALUE) / COUNT(1) ,2)  AS MULTIPLOS
FROM 
	DBO.PEDIDOS_ITENS PEDI
---------------------------

	
SELECT count(*) --> conta todas as linhas não nulas
FROM dbo.pedidos_itens pedi


SELECT COUNT(*) from dbo.pedidos p;
SELECT COUNT(order_delivered_carrier_date) from dbo.pedidos p; 

SELECT COUNT(1) from dbo.pedidos_itens pi2  



-- outra forma de fazer a media ---
SELECT 
	ROUND(AVG(CAST(PEDI.PRICE AS DECIMAL(10,2)) * PEDI.FREIGHT_VALUE),2)  AS MULTIPLOS
FROM 
	DBO.PEDIDOS_ITENS PEDI	
---------------------------------

SELECT MIN(cast(pedi.price as decimal (10,2))) FROM dbo.pedidos_itens pedi;
SELECT MAX(cast(pedi.price as decimal (10,2))) FROM dbo.pedidos_itens pedi;


SELECT * FROM dbo.pedidos_itens pedi

----- GROUP BY -------
SELECT 
product_id, 
sum(CAST(pedi.PRICE AS DECIMAL(10,2)) * pedi.FREIGHT_VALUE)
FROM dbo.pedidos_itens pedi
group by pedi.product_id 

SELECT * FROM dbo.itens i 




-- Funções Agregadoras: SUM, AVG, MIN, MAX, COUNT, STR ...




SELECT 
	vendfat.idProduto, 
	sum(vendfat.Quantidade * vendfat.ValorUnitario) VEN_VALOR
FROM vendas.faturamento vendfat
group by vendfat.idProduto 
--having sum(vendfat.Quantidade * vendfat.ValorUnitario) > 500
ORDER by 2 DESC 

-- having = where de agrupado --> tem que passar a expressão
-- Funções Agregadoras: SUM, AVG, MIN, MAX, COUNT, STR ...