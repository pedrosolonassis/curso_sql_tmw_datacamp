-- Total de gols por temporada para o Barcelona
SELECT season,
     sum(CASE WHEN hometeam_id = 8560 THEN home_goal END) AS home_goals,
     sum(CASE WHEN awayteam_id = 8560 THEN away_goal END) AS away_goals
FROM match
GROUP BY season

-- Resultados dos jogos entre Barcelona e Real Madrid
SELECT 
	date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as home,
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as away,
	CASE WHEN home_goal > away_goal AND hometeam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal < away_goal AND awayteam_id = 8633 THEN 'Real Madrid win!'
        ELSE 'Tie!' END AS outcome
FROM match
WHERE country_id = '21518' AND hometeam_id = 8634 AND awayteam_id = 8633;

-- Resultados dos jogos do Barcelona como visitante
SELECT 
    t1.date,
    CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
         ELSE t2.team_long_name END AS opponent,
    CASE WHEN home_goal < away_goal THEN 'Barcelona win!'
        WHEN home_goal > away_goal THEN 'Barcelona loss :(' 
        ELSE 'Tie' END AS outcome
FROM match AS t1
LEFT JOIN team AS t2
ON t1.hometeam_id = t2.team_api_id
WHERE t1.country_id = '21518' AND t1.awayteam_id = 8634;

-- Número de partidas por país em duas temporadas diferentes
SELECT 
	t1.name AS country,
	COUNT (CASE WHEN t2.season = '2012/2013' THEN t2.id END) AS matches_2012_2013,
	COUNT (CASE WHEN t2.season = '2013/2014' THEN t2.id END) AS matches_2013_2014
FROM country AS t1
LEFT JOIN match AS t2
ON t1.id = t2.country_id
GROUP BY country;

-- Jogos vencidos pelo Bologna na Itália
SELECT 
    season,
    date,
    home_goal,
    away_goal,
    CASE 
        WHEN hometeam_id = 9857 THEN awayteam_id 
        ELSE hometeam_id 
    END AS opponent_id,
    -- Identifica o resultado
    CASE 
        WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
        WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win'
        WHEN home_goal = away_goal THEN 'Draw'
        ELSE 'Bologna Loss'
    END AS outcome
FROM match
WHERE hometeam_id = 9857 OR awayteam_id = 9857;

-- Número de partidas em casa para Schalke 04 e Bayern Munich na Alemanha
SELECT 
    CASE WHEN hometeam_id = 10189 THEN 'FC Schalke 04'
         WHEN hometeam_id = 9823 THEN 'FC Bayern Munich'
         ELSE 'Other' END AS home_team,
    COUNT(id) AS total_matches
FROM match
WHERE hometeam_id IN (10189, 9823) 
GROUP BY home_team;

-- Fração de jogos empatados por país em duas temporadas diferentes
SELECT 
    t1.name AS country,
    AVG (CASE WHEN t2.season ='2012/2013' AND t2.home_goal = t2.away_goal THEN 1
            WHEN t2.season='2012/2013' AND t2.home_goal != t2.away_goal THEN 0
            END) AS ties_2012_2013,
    AVG (CASE WHEN t2.season='2013/2014' AND t2.away_goal = t2.home_goal THEN 1
            WHEN t2.season='2013/2014' AND t2.home_goal != t2.away_goal THEN 0
            END) AS ties_2013_2014
FROM country AS t1
LEFT JOIN match AS t2
ON t1.id = t2.country_id
GROUP BY country;