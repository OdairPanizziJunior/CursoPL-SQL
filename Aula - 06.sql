-- TRIGGFER

-- ACIONADO, ELE É ATIVADO QUANDO ACONTECE ALGO.

CREATE TABLE VENDEDORES (
    ID NUMBER(2),
    NOME VARCHAR(100)
);

COMMIT;

CREATE TABLE LOG_TABELAS (
    ACAO VARCHAR(100),
    TABELA VARCHAR(100),
    DATA_HORA DATE
);

COMMIT;

CREATE OR REPLACE TRIGGER TGG_AUDITORIA_VENDEDORES 
AFTER INSERT ON ODAIR.VENDEDORES
FOR EACH ROW 
BEGIN
    INSERT INTO LOG_TABELAS (ACAO, TABELA, DATA_HORA)
    VALUES ('Insert de Vendedores', 'odair.vendedores', SYSDATE);
END;


INSERT INTO VENDEDORES (ID, NOME) VALUES (1, 'Odair Júnior');

---------

CREATE TABLE PRODUTOS (
    ID NUMBER(2),
    NOME VARCHAR(100),
    DATA_MOD DATE
);

INSERT INTO PRODUTOS (ID, NOME, DATA_MOD) VALUES (1, 'Barra de Cereal', SYSDATE);
INSERT INTO PRODUTOS (ID, NOME, DATA_MOD) VALUES (2, 'Barra de Chocolate', SYSDATE);
COMMIT;

SELECT * FROM PRODUTOS


CREATE OR REPLACE TRIGGER TGG_ATUALIZA_PRODUTOS
BEFORE UPDATE ON ODAIR.PRODUTOS
FOR EACH ROW
BEGIN
    :NEW.DATA_MOD := SYSDATE; 
    INSERT INTO ODAIR.LOG_TABELAS (ACAO, TABELA, DATA_HORA)
    VALUES ('Update na tabela', 'odair.produtos', SYSDATE);
END;

UPDATE PRODUTOS
SET NOME = 'Barra de Proteina'
WHERE ID = 1;

SELECT * FROM LOG_TABELAS



--**--**--**--** TCC **--**--**--**--
-- TABELA
CREATE TABLE VENDAS (
    ID NUMBER(3), 
    ID_PRODUTO NUMBER(3),
    QUANTIDADE INTEGER,
    VALOR_UNITARIO NUMBER(20,2),
    VALOR_TOTAL NUMBER(20,2),
    ID_DEPARTAMENTO NUMBER(3)
); 

COMMIT;

-- PROCEDURE ADICIONAR
CREATE OR REPLACE PROCEDURE ADICIONAR_VENDA
(
    ID IN NUMBER, 
    ID_PRODUTO IN NUMBER, 
    QUANTIDADE IN NUMBER, 
    VALOR_UNITARIO IN NUMBER, 
    ID_DEPARTAMENTO IN NUMBER) AS 
BEGIN
    INSERT INTO VENDAS(ID, ID_PRODUTO, QUANTIDADE, VALOR_UNITARIO, ID_DEPARTAMENTO)
    VALUES (ID, ID_PRODUTO, QUANTIDADE, VALOR_UNITARIO, ID_DEPARTAMENTO);
END ADICIONAR_VENDA;
COMMIT;

-- EDITAR QTD VENDAS
CREATE OR REPLACE PROCEDURE EDITA_QTD_VENDA (ID_VENDA IN NUMBER,
                           NOVA_QTD IN NUMBER) AS 
BEGIN
    UPDATE VENDAS 
    SET QUANTIDADE = NOVA_QTD
    WHERE ID = ID_VENDA;
END EDITA_QTD_VENDA;

--DELETA A VEDA
CREATE OR REPLACE PROCEDURE DELETE_VENDA (ID_VENDA IN NUMBER) AS
BEGIN
    DELETE FROM VENDAS WHERE ID = ID_VENDA;
END DELETE_VENDA;

COMMIT;

--PACKAGE
CREATE OR REPLACE PACKAGE VENDEDOR_PACKAGE AS 
-- PROCEDURE PARA ADICIONAR UMA VENDA
PROCEDURE ADICIONAR_VENDA (ID IN NUMBER, 
                           ID_PRODUTO IN NUMBER, 
                           QUANTIDADE IN NUMBER, 
                           VALOR_UNITARIO IN NUMBER, 
                           ID_DEPARTAMENTO IN NUMBER);
-- PROCEDURE PARA EDITAR A QUANDIDADE DA VENDA
PROCEDURE EDITA_QTD_VENDA (ID_VENDA IN NUMBER,
                           NOVA_QTD IN NUMBER);
-- PROCEDURE PARA EXCLUIR UMA VENDA
PROCEDURE DELETE_VENDA(
                       ID_VENDA IN NUMBER);
-- FUNÇÃO PARA CALCULAR O VALOR TOTAL
FUNCTION CALC_TOTAL_PROD (ID_PRODUTO IN NUMBER) RETURN NUMBER 
AS 
    VALOR_TOTAL NUMBER; 
BEGIN
    SELECT SUM(VALOR_TOTAL) INTO VALOR_TOTAL
    FROM VENDAS
    WHERE ID_PRODUTO = ID_PRODUTO;
    RETURN VALOR_TOTAL;
END CALC_TOTAL_PROD;
-- PROCEDURE PARA MOSTRAR O TOTAL POR DEPARTAMENTO
END VENDEDOR_PACKAGE;

COMMIT;

CREATE OR REPLACE PACKAGE BODY VENDEDOR_PACKAGE AS 
-- ADICIONAR VENDA
PROCEDURE ADICIONAR_VENDA (ID IN NUMBER, 
                           ID_PRODUTO IN NUMBER, 
                           QUANTIDADE IN NUMBER, 
                           VALOR_UNITARIO IN NUMBER, 
                           ID_DEPARTAMENTO IN NUMBER) IS
BEGIN
    INSERT INTO VENDAS(ID, ID_PRODUTO, QUANTIDADE, VALOR_UNITARIO, ID_DEPARTAMENTO)
    VALUES (ID, ID_PRODUTO, QUANTIDADE, VALOR_UNITARIO, ID_DEPARTAMENTO);
END ADICIONAR_VENDA;
PROCEDURE EDITA_QTD_VENDA (ID_VENDA IN NUMBER,
                           NOVA_QTD IN NUMBER) IS 
BEGIN
    UPDATE VENDAS 
    SET QUANTIDADE = NOVA_QTD
    WHERE ID = ID_VENDA;
END EDITA_QTD_VENDA;
PROCEDURE DELETE_VENDA (ID_VENDA IN NUMBER) IS
BEGIN
    DELETE FROM VENDAS WHERE ID = ID_VENDA;
END DELETE_VENDA;
END VENDEDOR_PACKAGE;
COMMIT;

--TRIGGER CALCULAR VALOR TOTAL
CREATE OR REPLACE TRIGGER TGG_CALCULA_TOTAL
BEFORE INSERT OR UPDATE ON VENDAS
FOR EACH ROW
BEGIN
    :NEW.VALOR_TOTAL := :NEW.QUANTIDADE * :NEW.VALOR_UNITARIO;
END;

COMMIT;

DECLARE
    ID NUMBER := 2;
    ID_PRODUTO NUMBER := 2;
    QUANTIDADE NUMBER := 10;
    VALOR_UNITARIO NUMBER := 1.75;
    ID_DEPARTAMENTO NUMBER := 3;
BEGIN 
    VENDEDOR_PACKAGE.ADICIONAR_VENDA(ID, ID_PRODUTO, QUANTIDADE, VALOR_UNITARIO, ID_DEPARTAMENTO);
END;

DECLARE --EDITA 
    ID_VENDA NUMBER := 1;
    NOVA_QTD NUMBER := 10;
BEGIN 
    VENDEDOR_PACKAGE.EDITA_QTD_VENDA(ID_VENDA, NOVA_QTD);
END;

-- DELETE VENDA
DECLARE
    ID_VENDA NUMBER := 1; 
BEGIN
    VENDEDOR_PACKAGE.DELETE_VENDA(ID_VENDA);
END;


SELECT * FROM VENDAS