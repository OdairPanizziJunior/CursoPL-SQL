/*
Usando JOINS!
Calcule o Valor Total (frete * unitário)  [pedidos_itens]
por tipo de pagamento (pedidos_pagamentos.payment_type)
emitidos em 2018
*/

SELECT PP.payment_type AS TIPO, 
       ROUND(SUM(CAST(PI.price AS DECIMAL(10,2)) * CAST(PI.freight_value AS DECIMAL(10,2))),2) AS VALOR
FROM dbo.pedidos_itens PI
INNER JOIN dbo.pedidos_pagamentos PP ON PI.order_id = PP.order_id 
WHERE YEAR(PI.shipping_limit_date) = 2018
GROUP BY payment_type


SELECT * FROM dbo.pedidos_itens PI 

SELECT * FROM dbo.pedidos_pagamentos PP 

------------------------------------------------------

/*
Calcular média do Valor Total por Ano/Mês
*/


SELECT YEAR(PI.shipping_limit_date) AS ANO,
       MONTH(PI.shipping_limit_date) AS MES,
       ROUND(AVG(CAST(PI.price AS DECIMAL(10,2))),2) AS MEDIA_MENSAL,
       SUM(CAST(PI.price AS DECIMAL(10,2))) AS VALOR,
       COUNT(PI.price) QUANTIDADE 
FROM dbo.pedidos_itens PI
GROUP BY YEAR(PI.shipping_limit_date), MONTH(PI.shipping_limit_date)
ORDER BY ANO;

SELECT * FROM dbo.pedidos_itens PI 

-------------------------------------------------------

DECLARE -- opcional
-- variáveis
---- v_nome_variavel type := default_value

    v_meu_nome VARCHAR2(50) := 'Odair'
    v_idade NUMBER := 34
    v_data_nascimento DATE
    v_empregado BOOLEAN
    v_char CHAR 
    v_clob CLOB := 'Grande bloco de Texto'
    v_blob BLOB := 'Arquivos binários (JPEG, PNG, CSV, MP4...)'

-- constantes

    PI CONSTANT NUMBER := 3,14
BEGIN
-- instruções dos blocos
EXCEPTION 
-- Tratamento de Erros/Exceções
END;


---------------------------


DECLARE
V_MEU_NOME VARCHAR2(50) := 'ODAIR';
BEGIN
    DBMS_OUTPUT.PUT_LINE('O MEU NOME É: ' || V_MEU_NOME);
END;


------------------------------

-- Escopo das Variáveis
DECLARE
nome VARCHAR2(50) := 'Odair';
BEGIN
    DECLARE
            nome VARCHAR2(50) := 'Daniel';
        BEGIN
            DBMS_OUTPUT.PUT_LINE('O MEU NOME É: ' || nome);
        END;
    DBMS_OUTPUT.PUT_LINE('O MEU NOME É: ' || nome);
END;

------------------------------

--- Calculadora de Área do Retângulo
DECLARE
    v_base number := 5 ;
    v_altura number := 2;
    v_area number;
BEGIN
    v_area := v_base * v_altura;
    DBMS_OUTPUT.PUT_LINE( 'O valor da área do retângulo é: ' || v_area);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocorreu um erro ao calcular a área');
END;
 
------------------------------

-- CRIAR PROCEDURE AREA_RETANGULO
CREATE OR REPLACE PROCEDURE p_area_retangulo ( v_base NUMBER, v_altura  NUMBER)
AS
-- DECLARE
    v_area NUMBER;
BEGIN
    v_area := v_base * v_altura;
    DBMS_OUTPUT.PUT_LINE('A área do retângulo é: ' || v_area );
END p_area_retangulo;
 
--
COMMIT;
 
------------------------------
--chamando a procedure

 DECLARE
v_altura number := 10;
v_base number := 10;
BEGIN
    p_area_retangulo(v_altura, v_base);
END;


-- CRIAR PROCEDURE MEDIA DE DOIS VALORES
CREATE OR REPLACE PROCEDURE p_calcular_media_dois_valores ( v_valor1 NUMBER, v_valor2  NUMBER)
AS
-- DECLARE
    v_resultado NUMBER;
BEGIN
    v_resultado := (v_valor1 + v_valor2) / 2;
    DBMS_OUTPUT.PUT_LINE('A media de' || v_valor1 || ' + ' || v_valor2 || ' é: ' || v_resultado );
END p_calcular_media_dois_valores;
 
--
COMMIT;


------------------------------
--chamando a procedure

 DECLARE
v_valor1 number := 10;
v_valor2 number := 5;
BEGIN
    p_calcular_media_dois_valores(v_valor1, v_valor2);
END;


------------------------------

-- Criar uma Função
CREATE OR REPLACE FUNCTION f_calcular_imc (v_peso IN NUMBER , v_altura IN NUMBER) RETURN NUMBER AS
    v_imc number;
    v_daniel char;
    -- Todas as variáveis
BEGIN
    v_imc:= v_peso / (v_altura * v_altura);
    v_imc:= round(v_imc,2);
    RETURN v_imc;
END f_calcular_imc;
 
DECLARE
    v_p number := 85;
    v_a number := 1.81;
    v_r number;
BEGIN
    v_r := f_calcular_imc(v_p, v_a) ;
    DBMS_OUTPUT.PUT_LINE('O imc é: ' || v_r) ;
END;



