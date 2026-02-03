-- Contagem de transações distintas em julho;
SELECT count (*),
       count (DISTINCT IdCliente)
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
ORDER BY DtCriacao DESC;

-- Soma de pontos positivos em julho;
SELECT sum (QtdePontos)
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
AND QtdePontos > 0;

-- Criação de colunas para pontos positivos e negativos em julho;
SELECT IdTransacao,
         QtdePontos,
         CASE
            WHEN QtdePontos > 0 THEN QtdePontos
         END AS QtdePontosPositivos,
         CASE
            WHEN QtdePontos < 0 THEN QtdePontos
        END AS QtdePontosNegativos
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
ORDER BY QtdePontos;

-- Soma total de pontos e transações positivos e negativos em julho;
SELECT sum(QtdePontos),
         sum(CASE
                WHEN QtdePontos > 0 THEN QtdePontos
                END) AS QtdePontosPositivos,
         sum(CASE
                WHEN QtdePontos < 0 THEN QtdePontos
                END) AS QtdePontosNegativos,
         count(CASE
                WHEN QtdePontos > 0 THEN QtdePontos
                END) AS QtdeTransacoesPositivas,
         count(CASE
                WHEN QtdePontos < 0 THEN QtdePontos
                END) AS QtdeTransacoesNegativas
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01';