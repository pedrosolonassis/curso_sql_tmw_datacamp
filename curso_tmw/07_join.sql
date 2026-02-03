-- Left Join: Retorna todos os registros da tabela à esquerda (transacao_produto)
SELECT *
FROM transacao_produto AS t1
LEFT JOIN produtos AS t2
ON t1.IdProduto = t2.IdProduto;
