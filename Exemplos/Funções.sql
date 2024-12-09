-- Como criar uma função simples:

    CREATE OR REPLACE FUNCTION HELLO_WORLD -- Nome da função => HELLO_WORLD
    RETURN VARCHAR2 IS                     -- Toda Função exige um retorno
    BEGIN
        RETURN 'HELLO WORLD!';
    END;

-- Chamando a função:

    SELECT HELLO_WORLD FROM DUAL 



CREATE OR REPLACE FUNCTION SAUDACAO_PESSOA (
	NOME IN VARCHAR2, 
	IDADE IN NUMBER
) 
RETURN VARCHAR2 IS
BEGIN
	RETURN 'OLÁ ' || NOME || ', SUA IDADE É ' || IDADE || ' ANOS.';
END;



SELECT SAUDACAO_PESSOA('ODAIR', 34) FROM DUAL

