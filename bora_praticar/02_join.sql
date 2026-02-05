-- Qual categoria tem mais produtos vendidos?
SELECT t2.DescCategoriaProduto,
       COUNT(DISTINCT t1.IdTransacao) AS TotalTransacoes
FROM transacao_produto AS t1
LEFT JOIN produtos AS t2
ON t1.IdProduto = t2.IdProduto
GROUP BY t2.DescCategoriaProduto
ORDER BY TotalTransacoes DESC

-- Em 2024, quantas transações de Lovers tivemos?
SELECT t3.DescCategoriaProduto,
        count (distinct t1.IdTransacao)
FROM transacoes AS t1
LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto
WHERE t1.DtCriacao >= '2024-01-01'
AND t1.DtCriacao < '2025-01-01'
AND t3.DescNomeProduto = 'lovers'
GROUP BY t3.DescNomeProduto;

-- Qual mês tivemos mais lista de presença assinada?
SELECT count (distinct t1.IdTransacao) AS TotalTransacoes,
    substr(t1.DtCriacao, 1, 7) AS AnoMes
FROM transacoes AS t1
LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto
WHERE t3.DescNomeProduto = 'Lista de presença'
GROUP BY substr(t1.DtCriacao, 1, 7)
ORDER BY TotalTransacoes DESC;

-- Quais clientes mais perderam pontos por Lover?
SELECT t1.IdCliente,
       sum(t1.QtdePontos) AS TotalPontos
FROM transacoes AS t1
LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto
WHERE t3.DescCategoriaProduto = 'lovers'
GROUP BY t1.IdCliente
ORDER BY sum(t1.QtdePontos) ASC;

-- Quais clientes assinaram a lista de presença no dia 25/08/2025?
SELECT T1.IdCliente,
        count (*)
FROM transacoes AS t1
LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto
WHERE substr(t1.DtCriacao, 1, 10) = '2025-08-25'
GROUP BY T1.IdCliente;

-- Do início ao fim do nosso curso (25//08/2025 a 29/08/2025), quantos clientes assinaram a lista de presença?
SELECT count(distinct t1.IdCliente) AS TotalClientes
FROM transacoes AS t1
LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto
WHERE t1.DtCriacao >= '2025-08-25'
AND t1.DtCriacao < '2025-08-29'
AND t3.DescNomeProduto = 'Lista de presença';

-- Clientes mais antigos, tem mais frequência de transação?
SELECT t1.IdCliente,
    CAST(julianday('now') - julianday(substr(t1.DtCriacao, 1,19)) AS INT) AS IdadeBase,
    count(distinct t2.IdTransacao) AS TotalTransacoes
FROM clientes AS t1
LEFT JOIN transacoes AS t2
ON t1.IdCliente = t2.IdCliente
GROUP BY t1.IdCliente, IdadeBase

-- Quantidade de transações acumuladas ao longo do tempo?
SELECT
    substr(t1.DtCriacao, 1,10) AS DtCriacao,
    count (distinct t1.IdTransacao) AS QtdeTransacoesDiarias,
    sum (count (distinct t1.IdTransacao)) OVER (ORDER BY substr(t1.DtCriacao, 1,10)) AS QtdeTransacoesAcumuladas
FROM transacoes AS t1
GROUP BY substr(t1.DtCriacao, 1,10)

-- Quantidade de usuários cadastrados (absoluto e acumulado) ao longo do tempo?
SELECT 
    substr(t1.DtCriacao, 1,10) AS DtCriacao,
    count (distinct t1.IdCliente) AS QtdeClientesDiarios,
    sum (count (distinct t1.IdCliente)) OVER (ORDER BY substr(t1.DtCriacao, 1,10)) AS QtdeClientesAcumulados
FROM clientes AS t1
GROUP BY substr(t1.DtCriacao, 1,10)

-- Qual o dia da semana mais ativo de cada usuário?
WITH RankingDiaAtivo AS (
    SELECT 
        t1.IdCliente,
        strftime('%w', datetime(substr(t2.DtCriacao, 1, 10))) AS DiaSemana,
        count(distinct t2.IdTransacao) AS QtdeTransacoes,
        row_number() OVER (PARTITION BY t1.IdCliente ORDER BY count(distinct t2.IdTransacao) DESC) AS rn
    FROM clientes AS t1
    LEFT JOIN transacoes AS t2
        ON t1.IdCliente = t2.IdCliente
    GROUP BY t1.IdCliente, DiaSemana
)
SELECT * FROM RankingDiaAtivo
WHERE rn = 1;

-- Saldo de pontos acumulado de cada usuário
WITH SaldoPontos AS (
    SELECT 
        t1.IdCliente,
        t1.DtCriacao,
        sum(t1.QtdePontos) OVER (PARTITION BY t1.IdCliente ORDER BY t1.DtCriacao) AS SaldoPontos
    FROM transacoes AS t1
)
SELECT * FROM SaldoPontos;
