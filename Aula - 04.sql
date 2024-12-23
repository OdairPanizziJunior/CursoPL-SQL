/*OPERADORES DE COMPARAÇÕES IGUAIS AO SQL*/

DECLARE --BLOCO DAS VARIÁVEIS 
V_NOME VARCHAR2(200) := 'júnior';
V_IDADE NUMBER := 17;
BEGIN -- BLOCO DA EXECUÇÃO
    V_NOME := UPPER(V_NOME); /*DEIXA O TEXO EM LETRA MAÍUSCULA*/
    IF V_IDADE >= 18 THEN
        DBMS_OUTPUT.PUT_LINE('O ' || V_NOME || ' É MAIOR DE IDADE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O ' || V_NOME || ' É MENOR DE IDADE');
    END IF;
END; --DECLARA O FIM DA ESTRUTURA


----------------------

/* SE O ALUNO TIROU 10 - A 
                    9  - B
                    6  - C
                    5  - D
*/
DECLARE 
    V_NOTA NUMBER := 10; 
    V_RESULTADO VARCHAR2(200);
BEGIN 
    IF V_NOTA <= 5 THEN
        V_RESULTADO := 'NOTA DO ALUNO : D';
ELSIF
    V_NOTA <= 6 THEN
    V_RESULTADO := 'NOTA DO ALUNO : C';
ELSIF
    V_NOTA <= 9 THEN
    V_RESULTADO := 'NOTA DO ALUNO : B';
ELSE
    V_RESULTADO := 'NOTA DO ALUNO : A';
END IF;
DBMS_OUTPUT.PUT_LINE(V_RESULTADO);
END;

/*
    IF condição THEN 
        -- se a condição for verdadeira
    ELSEIF outra condição
        -- se a condição for falsa e a outra condição for verdadeira
    ELSE
        -- se todas as condições anteriores forem falsas.
*/

----------------------

DECLARE 
    V_NOTA NUMBER := 7.5; 
    V_RESULTADO VARCHAR2(200);
BEGIN 
    CASE 
        WHEN V_NOTA <= 5 THEN V_RESULTADO := 'D';
        WHEN V_NOTA <= 6 THEN V_RESULTADO := 'C';
        WHEN V_NOTA <= 9 THEN V_RESULTADO := 'B';
        ELSE V_RESULTADO := 'A';
        END CASE;
        DBMS_OUTPUT.PUT_LINE('CLASSICAÇÃO ' || V_RESULTADO);
END;

/*
CASE expressão
    WHEN valor1 THEN
        executa se a expressão é = valor1
    WHEN valor2 THEN
        executa se a expressão é = valor2
    ELSE
        excuta se todos acima forem falsos
    END CASE;
*/


DECLARE
    V_DIA_SEMANA NUMBER := 7;
    V_RESULTADO VARCHAR2(100);
BEGIN 
    CASE V_DIA_SEMANA
        WHEN 1 THEN V_RESULTADO := 'DOMINGO';
        WHEN 7 THEN V_RESULTADO := 'SÁBADO';
        ELSE V_RESULTADO := 'DIA ÚTIL';
    END CASE;
    DBMS_OUTPUT.PUT_LINE('HOJE É UM ' || V_RESULTADO);
END;

--------------------------
DECLARE
V_I NUMBER := 1;
BEGIN
    WHILE V_I <= 10 LOOP  
        DBMS_OUTPUT.PUT_LINE('NUMERO ' || V_I);
        V_I := V_I + 1;
        END LOOP;
END;

/*USANDO A ESTRUTURA FOR*/

DECLARE 
    V_SOMA NUMBER := 0; -- DECLARA VARIÁVEL
BEGIN 
    FOR ID IN  1..100 LOOP -- LOOPING QUE ITERA OS VALORES SEQUENCIAIS DE 1 ATÉ 100
        V_SOMA := V_SOMA + ID; -- ADICIONA O VALOR ITERANTE À VARIÁVEL SOMA
        DBMS_OUTPUT.PUT_LINE('A SOMA É ' || V_SOMA); --PRINTA A VARIÁVEL
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('A SOMA TOTAL É ' || V_SOMA); --PRINTA O TOTAL
END;

------------------------------
/*
C --> CREATE/INSERT  INTO
R --> SELECT FROM
U --> UPDATE SET
D --> DELETE/DROP
*/

CREATE TABLE FUNCIONARIOS_SALARIOS (
    ID NUMBER,
    NOME VARCHAR2(200),
    SALARIO NUMBER
);

--*--

SELECT * FROM FUNCIONARIOS_SALARIOS

--*--

INSERT INTO FUNCIONARIOS_SALARIOS VALUES (1, 'DANIEL', 50000);

--*--

UPDATE FUNCIONARIOS_SALARIOS SET NOME 'ODAIR'
WHERE ID = 2;

----------------------

CREATE OR REPLACE PROCEDURE NOVO_FUNC (ID IN NUMBER, NOME IN VARCHAR2, SALARIO IN NUMBER)
AS
BEGIN
    INSERT INTO FUNCIONARIOS_SALARIOS VALUES (ID, NOME, SALARIO);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('NOVO FUNCIONÁRIO ADICIONADO');
END NOVO_FUNC;

COMMIT;

BEGIN 
    NOVO_FUNC(4, 'MARIA', 4000);
END;

----------------

CREATE OR REPLACE PROCEDURE ATUALIZA_SALARIO (
    V_ID IN NUMBER, 
    V_NOVO_SALARIO IN NUMBER
)
AS 
BEGIN
    UPDATE FUNCIONARIOS_SALARIOS 
    SET SALARIO = V_NOVO_SALARIO
    WHERE ID = V_ID;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('O SALÁRIO DO FUNCIONÁRIO ' || V_ID || ' FOI ATUALIZADO');
END;

BEGIN
    ATUALIZA_SALARIO(1, 60000);
END;

/*
CURSOR PERMITE CONTROLE DO FLUXO DENTRO DE UMA TABELA
ITERA AS LINHAS DA TABELA
*/

--CURSOR IMPLÍCITO
DECLARE 
    V_TOTAL_SALARIOS NUMBER := 0;
    V_QTD_FUNCIONARIO NUMBER :=0;
    V_MEDIA_SALARIO NUMBER :=0;
BEGIN
    FOR FUNCIONARIO IN (SELECT SALARIO FROM FUNCIONARIOS_SALARIOS) LOOP
        V_TOTAL_SALARIOS := V_TOTAL_SALARIOS + FUNCIONARIO.SALARIO;
        V_QTD_FUNCIONARIO := V_QTD_FUNCIONARIO + 1;
    END LOOP;
        V_MEDIA_SALARIO :=  V_TOTAL_SALARIOS/V_QTD_FUNCIONARIO;
    DBMS_OUTPUT.PUT_LINE('O TOTAL DE SALARIO É: ' || V_TOTAL_SALARIOS);
    DBMS_OUTPUT.PUT_LINE('A MEDIA DE SALÁRIOS É: ' || V_MEDIA_SALARIO);
  END;



--CURSOR EXPLÍCITO
DECLARE 
    V_TOTAL_SALARIOS NUMBER := 0;
    V_QTD_FUNCIONARIO NUMBER :=0;
    V_MEDIA_SALARIO NUMBER :=0;
    
    CURSOR C_FUNCIONARIO IS 
        SELECT SALARIO FROM FUNCIONARIOS_SALARIOS;

    R_FUNCIONARIO C_FUNCIONARIO%ROWTYPE; 

BEGIN
    OPEN C_FUNCIONARIO;

    LOOP
        FETCH C_FUNCIONARIO INTO R_FUNCIONARIO;
    EXIT WHEN C_FUNCIONARIO%NOTFOUND;
        V_TOTAL_SALARIOS := V_TOTAL_SALARIOS + R_FUNCIONARIO.SALARIO;
        V_QTD_FUNCIONARIO := V_QTD_FUNCIONARIO + 1;
    END LOOP;
 
    CLOSE C_FUNCIONARIO;

    IF V_QTD_FUNCIONARIO > 0 THEN 
        V_MEDIA_SALARIO :=  V_TOTAL_SALARIOS/V_QTD_FUNCIONARIO;
    END IF;
    DBMS_OUTPUT.PUT_LINE('O TOTAL DE SALARIO É: ' || V_TOTAL_SALARIOS);
    DBMS_OUTPUT.PUT_LINE('A MEDIA DE SALÁRIOS É: ' || V_MEDIA_SALARIO);
    DBMS_OUTPUT.PUT_LINE('A QUANTIDADE DE FUNCIONARIOS É: ' || V_QTD_FUNCIONARIO);
END;

/*TRUNC LITERALMENTE VAI CORTAR O NÚMERO/DATA NO PONTO QUE EU QUISER*/