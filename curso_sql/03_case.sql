SELECT IdCliente,
       QtdePontos,
       CASE
              WHEN QtdePontos <= 500 THEN 'pônei'
              WHEN QtdePontos <= 1000 THEN 'pônei premium'
              WHEN QtdePontos <= 5000 THEN 'mago aprendiz'
              WHEN QtdePontos <= 10000 THEN 'mago mestre'
              ELSE 'mago supremo'
         END AS NomeGrupo
FROM clientes
ORDER BY QtdePontos DESC