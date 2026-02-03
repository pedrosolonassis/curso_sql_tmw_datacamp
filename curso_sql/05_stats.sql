-- Estatísticas da tabela clientes;
SELECT round (avg (QtdePontos), 2) AS MediaCarteira,
       1. * sum(QtdePontos) / count(IdCliente) AS MediaCarteiraRoots,
       min(QtdePontos) AS MinCarteira,
       max(QtdePontos) AS MaxCarteira,
       sum(flTwitch),
       sum(flEmail)
FROM clientes