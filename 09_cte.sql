-- Análise de taxa de conversão de clientes entre o primeiro e o último dia de uma semana específica

WITH tb_cliente_primeiro_dia AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-25'
),

tb_cliente_ultimo_dia AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-29'
),

tb_join AS (
    SELECT t1.IdCliente AS primCliente,
           t2.IdCliente AS ultCliente
    FROM tb_cliente_primeiro_dia AS t1
    LEFT JOIN tb_cliente_ultimo_dia AS t2
    ON t1.IdCliente = t2.IdCliente
)

SELECT count (primCliente),
       count (ultCliente),
       1.* count(ultCliente) / count(primCliente) AS taxa_conversao
FROM tb_join;

-- Quem iniciou o curso no primeiro dia, em média, assistiu quantas aulas?
SELECT AVG(qtdeDias) AS media_dias_curso
FROM (
    WITH tb_prim_dia AS (
        SELECT DISTINCT IdCliente
        FROM transacoes
        WHERE substr(DtCriacao, 1, 10) = '2025-08-25'
    ),

    tb_dias_curso AS (
        SELECT DISTINCT IdCliente, substr(DtCriacao, 1, 10) AS presenteDia
        FROM transacoes
        WHERE DtCriacao >= '2025-08-25'
        AND DtCriacao < '2025-08-30'
        ORDER BY IdCliente, presenteDia
    ),
    tb_cliente_dias AS (
        SELECT t1.IdCliente,
            count (DISTINCT t2.presenteDia) AS qtdeDias
        FROM tb_prim_dia AS t1
        LEFT JOIN tb_dias_curso AS t2
        ON t1.IdCliente = t2.IdCliente
        GROUP BY t1.IdCliente
    )
    SELECT qtdeDias
    FROM tb_cliente_dias
);

-- Quem participou da 1a aula:
WITH tb_prim_dia AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-25'
),

-- Quem Participou do curso inteiro
tb_dias_curso AS (
    SELECT DISTINCT IdCliente, substr(DtCriacao, 1, 10) AS presenteDia
    FROM transacoes
    WHERE DtCriacao >= '2025-08-25' 
    AND DtCriacao < '2025-08-30'
    ORDER BY IdCliente, presenteDia
),

-- Contando quantas vezes quem participou do primeiro dia e voltou
tb_cliente_dias AS (
    SELECT t1.IdCliente,
        count (DISTINCT t2.presenteDia) AS qtdeDias
    FROM tb_prim_dia AS t1
    LEFT JOIN tb_dias_curso AS t2
    ON t1.IdCliente = t2.IdCliente
    GROUP BY t1.IdCliente
)

-- Calcula a média
SELECT AVG (qtdeDias) AS media_dias_curso
FROM tb_cliente_dias;

-- Como foi a curva de Churn do curso de SQL?

WITH tb_clientes_d1 AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE  DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-26'
),

tb_join AS (

    SELECT 
        substr(t2.DtCriacao,1,10) AS dtDia,
        count(DISTINCT t1.IdCliente) AS qtdeCliente,
        1. * count(DISTINCT t1.IdCliente) / (select count(DISTINCT IdCliente) from tb_clientes_d1) AS pctRetencao,
        1 - 1. * count(DISTINCT t1.IdCliente) / (select count(DISTINCT IdCliente) from tb_clientes_d1) AS pctChurn
    FROM tb_clientes_d1 AS t1
    LEFT JOIN  transacoes AS t2
    ON t1.IdCliente = t2.IdCliente
    WHERE t2.DtCriacao >= '2025-08-25'
    AND t2.DtCriacao < '2025-08-30'
    GROUP BY dtDia
)
SELECT * FROM tb_join

-- Dentre os clientes de janeiro/2025, quantos assistiram o curso de sql?
-- Mais direto
WITH tb_clientes_janeiro AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE DtCriacao >= '2025-01-01'
    AND DtCriacao < '2025-02-01'
)
SELECT count (DISTINCT t1.IdCliente) AS clienteJaneiro,
       count (DISTINCT t2.IdCliente) AS clienteCurso
FROM tb_clientes_janeiro AS t1
LEFT JOIN transacoes AS t2
ON t1.IdCliente = t2.IdCliente
AND t2.DtCriacao >= '2025-08-25'
AND t2.DtCriacao < '2025-08-30';
-- Passo a passo
WITH tb_clientes_janeiro AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE dtCriacao >= '2025-01-01'
    AND dtCriacao < '2025-02-01'
),
tb_clientes_curso AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'
)
SELECT count(t1.IdCliente) AS clienteJaneiro,
       count(t2.IdCliente) AS clienteCurso
FROM tb_clientes_janeiro AS t1
LEFT JOIN tb_clientes_curso AS t2
ON t1.IdCliente = t2.IdCliente;