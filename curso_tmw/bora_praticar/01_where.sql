-- Selecione produtos que contêm 'churn' no nome
SELECT *
FROM produtos
WHERE DescNomeProduto = 'Churn_10pp'
    OR DescNomeProduto = 'Churn_2pp'
    OR DescNomeProduto = 'Churn_5pp';

-- Outra forma de fazer a mesma consulta usando IN
SELECT *
FROM produtos
WHERE DescNomeProduto IN ('Churn_10pp', 'Churn_2pp', 'Churn_5pp');

-- Outra forma de fazer a mesma consulta usando LIKE
SELECT *
FROM produtos
WHERE DescNomeProduto LIKE 'Churn%';

-- Melhor forma de escrever essa Query
SELECT *
FROM produtos
WHERE DescCategoriaProduto = 'churn_model';