SELECT * FROM DB_FLEXXO.LIVROS

DECLARE
    avg_preco NUMBER := 0;
    sum_preco NUMBER := 0;
    qtd_preco NUMBER := 0;
BEGIN
     -- IMPLICITA
     -- LÓGICA DE REPETIÇÃO PURA
     -- FOR .... LOOP
     FOR r_livro IN (SELECT * FROM DB_FLEXXO.LIVROS) LOOP
        --DBMS_OUTPUT.PUT_LINE(r_livro.preco);
        sum_preco := r_livro.preco + sum_preco;
        qtd_preco := 1 + qtd_preco;
     END LOOP;
        avg_preco :=  sum_preco / qtd_preco;
        avg_preco := ROUND(avg_preco);
        DBMS_OUTPUT.PUT_LINE(avg_preco);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Seu burro, estás dividindo por zero!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;


----------

-- CRUSOR EXPLÍCITO
-- MAIOR FLEXIBILIDADE

DECLARE
    avg_preco NUMBER := 0;
    sum_preco NUMBER := 0;
    qtd_preco NUMBER := 0;

    CURSOR c_livros IS
        SELECT * FROM DB_FLEXXO.LIVROS;

    r_livros DB_FLEXXO.LIVROS%ROWTYPE; -- coluna livros

BEGIN
    OPEN c_livros;
    LOOP
        FETCH c_livros INTO r_livros;
        EXIT WHEN c_livros%NOTFOUND;
        --DBMS_OUTPUT.PUT_LINE(r_livros.preco);
        sum_preco := r_livros.preco + sum_preco;
        qtd_preco := 1 + qtd_preco;
    END LOOP;
        IF qtd_preco > 0 THEN
        avg_preco :=  ROUND(sum_preco / qtd_preco);
            DBMS_OUTPUT.PUT_LINE('A média dos preços é: ' || avg_preco);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Não existe livros na bases.');
        END IF;

    CLOSE c_livros;
EXCEPTION
WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

---------------



COMMIT;


SELECT * FROM DB_FLEXXO.LIVROS

------------

CREATE OR REPLACE PACKAGE Gerente_Livraria AS 
    PROCEDURE ATT_PRECO (v_id IN INT, v_percent_var IN NUMBER);
END Gerente_Livraria;

/

CREATE OR REPLACE PACKAGE BODY Gerente_Livraria AS
PROCEDURE ATT_PRECO (v_id IN INT, v_percent_var IN NUMBER) AS 
BEGIN
    UPDATE DB_FLEXXO.LIVROS 
    SET preco = preco + (preco*v_percent_var) / 100
    WHERE id_livro = v_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum livro foi encontrado no ID :' || v_id);
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('O preço do livro ID: ' || v_id || 'foi alterado em ' || v_percent_var || '%');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao aumentar o preço do Livro ' || SQLERRM);
END ATT_PRECO;
END Gerente_Livraria;


-- chamando o package

BEGIN
    Gerente_Livraria.ATT_PRECO(1, -30);
END;