-- Selecione o IdCliente, a quantidade de pontos e crie uma nova coluna chamada NomeGrupo que classifica os clientes em grupos com base na quantidade de pontos usando a seguinte lógica:
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