-- Quantidade de transações acumladas ao longo do tempo (diário)?

WITH tb_diario AS (
    SELECT substr(dtCriacao,1,10) AS dtDia,
        count (distinct IdTransacao) AS qtdeTransacao
    FROM transacoes
    GROUP BY dtDia
    ORDER BY dtDia
)

SELECT *,
        sum(qtdeTransacao) OVER (ORDER BY dtDia) AS qtdeTransacaoAcumu
FROM tb_diario;

-- Quantidade de usuários cadastrados (absoluto e acumulado) ao longo do tempo?

WITH tb_dia_clientes AS (
    SELECT substr(dtCriacao,1,10) AS dtDia,
        count (distinct IdCliente) AS qtdeCliente
    FROM clientes
    GROUP BY dtDia
)

SELECT *,
       sum(qtdeCliente) OVER (ORDER BY dtDia) AS qtdeClienteAcumu
FROM tb_dia_clientes;

-- Qual o dia da semana mais ativo de cada usuário?

WITH tb_cliente_semana AS (
    SELECT IdCliente,
        strftime('%w', substr(dtCriacao,1,10)) AS diaSemana,
        count (distinct IdTransacao) AS qtdeTransacao
    FROM transacoes
    GROUP BY IdCliente, diaSemana
),

tb_rn AS (
    SELECT *,
        CASE
            WHEN diaSemana = '0' THEN 'Domingo'
            WHEN diaSemana = '1' THEN 'Segunda-feira'
            WHEN diaSemana = '2' THEN 'Terça-feira'
            WHEN diaSemana = '3' THEN 'Quarta-feira'
            WHEN diaSemana = '4' THEN 'Quinta-feira'
            WHEN diaSemana = '5' THEN 'Sexta-feira'
            WHEN diaSemana = '6' THEN 'Sábado'
            END AS nomeDiaSemana,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtdeTransacao DESC) AS rn
    FROM tb_cliente_semana
)

SELECT *
FROM tb_rn
WHERE rn = 1;

-- Saldo de pontos acumulado de cada usuário

WITH tb_cliente_dia AS (
SELECT IdCliente,
       substr(DtCriacao,1,10) AS dtDia,
       sum(QtdePontos) AS totalPontos
FROM transacoes
GROUP BY IdCliente, dtDia
)

SELECT *,
         sum(totalPontos) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS saldoPontos
FROM tb_cliente_dia;