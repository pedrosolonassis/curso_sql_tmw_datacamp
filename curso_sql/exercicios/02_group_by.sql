-- Quantos clientes tem email cadastrado?;
SELECT sum(flEmail)
FROM clientes;

-- Qual cliente juntou mais pontos positivos em 2025-05?;
SELECT IdCliente,
       sum (QtdePontos) AS TotalPontos
FROM transacoes
WHERE DtCriacao >= '2025-05-01'
  AND DtCriacao < '2025-06-01'
  AND QtdePontos > 0
GROUP BY IdCliente
ORDER BY TotalPontos DESC;

-- Qual cliente fez mais transações no ano de 2024?;
SELECT idCliente,
       count(*) AS TotalTransacoes
FROM transacoes
WHERE DtCriacao >= '2024-01-01'
  AND DtCriacao < '2025-01-01'
GROUP BY IdCliente
ORDER BY count(*) DESC;

-- Quantos produtos são de rpg?;
SELECT count(*)
FROM produtos
WHERE DescCategoriaProduto = 'rpg';

SELECT DescCategoriaProduto, -- Para um olhar amplo;
         count(*) AS TotalProdutos
FROM produtos
GROUP BY DescCategoriaProduto;

-- Qual o valor médio de pontos positivos por dia?;
SELECT sum(QtdePontos) AS TotalPontos,
       count(DISTINCT substr(DtCriacao, 1, 10)) AS qtdediasunicos,
       sum(QtdePontos) / count(DISTINCT substr(DtCriacao, 1, 10)) AS MediaPontosPorDia
FROM transacoes
WHERE QtdePontos > 0;

-- Qual dia da semana tem mais pedidos em 2025?;
SELECT 
       strftime('%w', substr(DtCriacao, 1, 10)) AS diaSemana,
       count(DISTINCT IdTransacao) AS TotalTransacoes
FROM transacoes
WHERE substr(DtCriacao, 1, 4) = '2025'
GROUP BY 1
ORDER BY 2 DESC;

-- Qual o produto mais transacionado?;
SELECT IdProduto,
        -- count (*)
        sum(QtdeProduto) AS TotalProdutos
FROM transacao_produto
GROUP BY 1
ORDER BY count(*) DESC;

-- Qual o produto com mais pontos transacionado?;
SELECT IdProduto,
       sum(vlProduto * QtdeProduto) AS TotalPontos,
       sum(QtdeProduto) AS Qtdevenda
FROM transacao_produto
GROUP BY 1
ORDER BY sum(vlProduto * QtdeProduto) DESC;