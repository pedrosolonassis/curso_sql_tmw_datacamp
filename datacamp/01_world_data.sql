-- Find the country name, fertility rate, unemployment rate, and year for all countries where this data is available.
SELECT 
    t1.country_name, 
    t3.year, 
    t2.fertility_rate, 
    t3.unemployment_rate
FROM countries AS t1
INNER JOIN populations AS t2
    ON t1.code = t2.country_code
INNER JOIN economies AS t3
    ON t1.code = t3.code
    AND t3.year = t2.year;

-- Find all countries in the 'Mesia' region along with their languages and currencies.
SELECT 
	t1.country_name AS country, 
    t1.region, 
    t2.name AS language,
	t3.basic_unit, 
    t3.frac_unit
FROM countries as t1 
FULL JOIN languages AS t2
USING (code)
FULL JOIN currencies AS t3
USING (code)
WHERE t1.region LIKE 'M%esia';

-- 5 countries with the lowest life expectancy in 2010.
SELECT 
	t1.country_name AS country,
    t1.region,
    t2.life_expectancy AS life_exp
FROM countries AS t1
INNER JOIN populations AS t2
ON t1.code = t2.country_code
WHERE year = 2010
ORDER BY life_exp
LIMIT 5;

-- Find top nine countries with the most cities
SELECT t1.country_name AS country, 
        COUNT(*) AS cities_num
FROM countries AS t1
LEFT JOIN cities AS t2
ON t1.code = t2.country_code
GROUP BY country
ORDER BY cities_num DESC, country
LIMIT 9;

-- Find the top 10 cities with the highest percentage of city proper population to metro area population in Europe and America.
SELECT t1.name, t1.country_code, t1.city_proper_pop, t1.metroarea_pop,
        (city_proper_pop / metroarea_pop * 100) AS city_perc
FROM cities AS t1
WHERE name IN (
    SELECT t2.capital
    FROM countries AS t2
    WHERE continent LIKE '%Europe%'
    OR continent LIKE '%America%')
AND metroarea_pop IS NOT NULL
ORDER BY city_perc DESC
LIMIT 10;

-- Find the inflation and unemployment rates for the year 2015 for countries with a government form that includes 'Republic' or 'Monarchy'.
SELECT code, inflation_rate, unemployment_rate
FROM economies
WHERE year = 2015 
  AND code IN
	(SELECT code
  FROM countries
  WHERE gov_form LIKE '%Republic%'
  OR gov_form LIKE '%Monarchy%')
ORDER BY inflation_rate;