-- Qual o dia com maior engajamento de cada aluno que iniciou o curso no dia 01?

WITH alunos_dia01 AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE  substr(DtCriacao,1,10) = '2025-08-25'
),

tb_dia_cliente AS (
    SELECT t1.IdCliente,
        substr(t2.DtCriacao, 1,10) AS dtDia,
        count(*) AS qtdeInteracoes
    FROM alunos_dia01 AS t1
    LEFT JOIN transacoes AS t2
    ON t1.IdCliente = t2.IdCliente
    AND t2.DtCriacao >= '2025-08-25'
    AND t2.DtCriacao < '2025-08-30'
    GROUP BY t1.IdCliente, substr(t2.DtCriacao, 1,10)
    ORDER BY t1.IdCliente, dtDia
),

tb_rn AS (
    SELECT *,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtdeInteracoes DESC, dtDia) AS rn
    FROM tb_dia_cliente
)

SELECT *
FROM tb_rn
WHERE rn = 1

-- Qual a variação diária do número de transações por cliente ao longo do curso?

WITH tb_cliente_dia AS (

SELECT IdCliente,
        substr(DtCriacao, 1,10) AS dtDia,
        count(distinct IdTransacao) AS qtdeTransacao
    FROM transacoes
    WHERE dtCriacao >= '2025-08-25'
    AND dtCriacao < '2025-08-30'
    GROUP BY IdCliente, dtDia
),

tb_lag AS (
    SELECT *,
        sum(qtdeTransacao) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS acum,
        lag(qtdeTransacao) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS lagTransacao
    FROM tb_cliente_dia
)

SELECT *,
        1.* qtdeTransacao / lagTransacao AS variação_diária
FROM tb_lag

-- De quanto em quanto tempo demoram para assistir os vídeos do canal?

WITH cliente_dia AS (
    SELECT 
        DISTINCT
        IdCliente,
        substr(DtCriacao,1,10) AS dtDia
    FROM transacoes
    WHERE substr(DtCriacao,1,4) = '2025'
    ORDER BY IdCliente, dtDia
),

tb_lag AS (

    SELECT *,
        lag(dtDia) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS lagDia
    FROM cliente_dia
),

tb_diff_dt AS (
    SELECT *,
        julianday(dtDia) - julianday(lagDia) AS DtDiff
    FROM tb_lag
),

avg_cliente AS (
    SELECT IdCliente,
           avg(DtDiff) AS avgDia
    FROM tb_diff_dt
    GROUP BY IdCliente
)

SELECT avg(avgDia)
FROM avg_cliente