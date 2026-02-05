-- Novas colunas a partir de colunas existentes
SELECT IdCliente,
        DtCriacao,
        substr(DtCriacao, 1, 10) AS DtSubString, -- Substr = Extrai uma parte da string
        datetime(substr(DtCriacao, 1, 10)) AS DtCriacaoNova, -- datetime = Converte uma string em formato de data/hora
        strftime('%w', datetime(substr(DtCriacao, 1, 10))) AS DiaSemana -- saber o dia da semana
FROM clientes;
-- Tradução: Selecione a coluna IdCliente e DtCriacao e crie uma coluna nova chamada "DtSubString" que pega a data de criação e vai pegar os 10 primeiros elementos. Crie uma outra coluna chamada "dtCriacaoNova" que converte a coluna DtSubString em formato de data/hora. Crie uma outra coluna chamada "DiaSemana" que pega a coluna DtCriacaoNova e retorna o dia da semana (0 = Domingo, 1 = Segunda, ..., 6 = Sábado).
