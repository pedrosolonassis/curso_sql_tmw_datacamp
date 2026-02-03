-- Lista de transações com apenas 1 ponto;
SELECT IdTransacao, 
        QtdePontos
FROM transacoes
WHERE QtdePontos = 1;

-- Lista de pedidos realizados no fim de semana;
SELECT IdTransacao,
        DtCriacao,
        strftime('%w', datetime(substr(DtCriacao, 1, 10)))
        AS DiaSemana
FROM transacoes
WHERE DiaSemana IN ('0', '6');

-- Lista de clientes com 0 pontos;
SELECT IdCliente,
        QtdePontos
FROM clientes
WHERE QtdePontos = 0;

-- Lista de clientes com 100 a 200 pontos (inclusive ambos);
SELECT IdCliente,
        QtdePontos
FROM clientes
WHERE QtdePontos >= 100
  AND QtdePontos <= 200;

-- Lista de produtos com nome que começa com "Venda de";
SELECT IdProduto,
        DescNomeProduto
FROM produtos
WHERE DescNomeProduto LIKE 'Venda de%';

-- Lista de produtos com nome que termina com "Lover";
SELECT IdProduto,
        DescNomeProduto
FROM produtos
WHERE DescNomeProduto LIKE '%Lover';

-- Lista de produtos que são "chapéu";
SELECT IdProduto,
        DescNomeProduto
FROM produtos
WHERE DescNomeProduto LIKE '%chapéu%';

-- LIsta de transações com o produto "Resgatar Ponei";
SELECT IdTransacao,
        IdProduto
FROM transacao_produto
WHERE IdProduto = 15;

-- LIstar todas as transações adicionando uma coluna nova sinalizando "alto", "médio" e "baixo" para o valor dos pontos [<10; <500; >=500]
SELECT IdTransacao,
        QtdePontos,
CASE 
    WHEN QtdePontos < 10 THEN 'baixo'
    WHEN QtdePontos < 500 THEN 'médio'
    ELSE 'alto'
END AS NivelPontos
FROM transacoes
ORDER BY QtdePontos DESC;