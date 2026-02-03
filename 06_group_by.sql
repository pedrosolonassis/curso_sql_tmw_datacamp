-- Seleciona o total de pontos acumulados por cada cliente e quantas transalçoes teve no mês de julho de 2025;
SELECT IdCliente,
        sum(QtdePontos),
        count(IdTransacao)
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
GROUP BY IdCliente
HAVING sum(QtdePontos) >4000
