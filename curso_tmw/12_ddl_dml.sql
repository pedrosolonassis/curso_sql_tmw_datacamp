-- DROP: Excluir a tabela relatorio_diario se ela já existir / CREATE: Criar a tabela relatorio_diario com os dados agregados

DROP TABLE IF EXISTS relatorio_diario;

CREATE TABLE IF NOT EXISTS relatorio_diario AS

WITH tb_diario AS (
    
    SELECT substr(DtCriacao,1,10) AS dtDia,
           count(distinct IdTransacao) AS qtdTransacao

    FROM transacoes
    GROUP BY dtDia
    ORDER BY dtDia
),

tb_acum AS (
    SELECT *,
            sum(qtdTransacao) OVER (ORDER BY dtDia) AS qtdeTransacaoAcum

    FROM tb_diario
)

SELECT *
FROM tb_acum
;

select * from relatorio_diario;

-- DELETE: Apaga os dados existentes na tabela relatorio_diario / INSERT: Insere os dados agregados na tabela relatorio_diario

DELETE FROM relatorio_diario;

WITH tb_diario AS (
    
    SELECT substr(DtCriacao,1,10) AS dtDia,
           count(distinct IdTransacao) AS qtdTransacao

    FROM transacoes
    GROUP BY dtDia
    ORDER BY dtDia
),

tb_acum AS (
    SELECT *,
            sum(qtdTransacao) OVER (ORDER BY dtDia) AS qtdeTransacaoAcum

    FROM tb_diario
)

INSERT INTO relatorio_diario

SELECT *
FROM tb_acum;

SELECT * FROM relatorio_diario;

-- Deletar os registros referentes aos domingos da tabela relatorio_diario;
DELETE FROM relatorio_diario
WHERE strftime('%w', substr(dtDia,1,10)) = '0';

SELECT * FROM relatorio_diario;

-- UPDATE: Atualizar / SET: Definir a quantidade de transações para 10000 / WHERE: Apenas para os dias a partir de 2025-08-25
UPDATE relatorio_diario
SET qtdTransacao = 10000
WHERE dtDia >= '2025-08-25'
;

SELECT *
FROM relatorio_diario;