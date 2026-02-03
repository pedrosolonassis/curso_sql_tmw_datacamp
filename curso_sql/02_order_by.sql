-- Top 10 clientes com maior quantidade de pontos
SELECT *
FROM clientes
ORDER BY QtdePontos DESC
LIMIT 10;

-- Clientes mais antigos da twitch (ordem decrescente pela data de criação)
SELECT *
FROM clientes
WHERE fltwitch = 1
ORDER BY DtCriacao ASC, QtdePontos DESC;

