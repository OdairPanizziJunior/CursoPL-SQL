-- Como criar uma função simples:

    CREATE OR REPLACE FUNCTION HELLO_WORLD
    RETURN VARCHAR2 IS
    BEGIN
        RETURN 'HELLO WORLD!';
    END;

-- Chamando a função:

    SELECT HELLO_WORLD 
    FROM DUAL 

-- Explicação:

--      CREATE OR REPLACE FUNCTION    =>  Cria a função, substituindo-a se já existir.
--      RETURN VARCHAR2               =>  Declara que o valor de retorno da função será do tipo VARCHAR2.
--      IS                            =>  Inicia a definição do corpo da função.
--      BEGIN...END;                  =>  Define o bloco executável da função.
--      RETURN 'HELLO WORLD!';        =>  Retorna o valor desejado.




-- Como criar uma função com parâmetros:

CREATE OR REPLACE FUNCTION SAUDACAO_PESSOA (
	NOME IN VARCHAR2, 
	IDADE IN NUMBER
) 
RETURN VARCHAR2 IS
BEGIN
	RETURN 'OLÁ ' || NOME || ', SUA IDADE É ' || IDADE || ' ANOS.';
END;

-- Chamando a função:

    SELECT SAUDACAO_PESSOA('ODAIR', 34) 
    FROM DUAL

-- Explicação:

--      CREATE OR REPLACE FUNCTION                  =>  Cria a função, substituindo-a se já existir.
--      RETURN VARCHAR2                             =>  Declara que o valor de retorno da função será do tipo VARCHAR2 (não precisa retornar os dois).
--      IS                                          =>  Inicia a definição do corpo da função.
--      BEGIN...END;                                =>  Define o bloco executável da função.
--      RETURN 'OLÁ Odair, SUA IDADE É 34 ANOS.';   =>  Retorna o valor desejado, só que agora com os parâmetros. " Preferia 18 :( " 


-- Como criar uma função com parâmetros que executam algo:

CREATE OR REPLACE FUNCTION CALCULO_SOMA (
	VALOR1 IN NUMBER, 
	VALOR2 IN NUMBER
) 
RETURN VARCHAR IS
BEGIN 
	RETURN 'SOMA DE  ' || VALOR1 || ' + ' || VALOR2 || ' = ' || (VALOR1 + VALOR2);
END;

-- Chamando a função:

    SELECT CALCULO_SOMA(4, 3) 
    FROM DUAL


