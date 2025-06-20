-- written with PostgreSQL 17
CREATE TABLE public.station
(
    id integer,
    city text,
    state text,
    lat_n double precision,
    long_w double precision
);

ALTER TABLE IF EXISTS public.station
    OWNER to postgres;

INSERT INTO public.station (id, city, state, lat_n, long_w) VALUES
(794, 'Kissee Mills', 'MO', 139.6503652000, 73.4160988400),
(824, 'Loma Mar', 'CA', 48.6978857200, 130.5393541000),
(603, 'Sandy Hook', 'CT', 72.3374801400, 148.2400769000),
(478, 'Tipton', 'IN', 33.5479270100, 97.9428603600),
(619, 'Arlington', 'CO', 75.1799307900, 92.9461589400),
(711, 'Turner', 'AR', 50.2438053400, 101.4580163000),
(839, 'Slidell', 'LA', 85.3227030400, 151.8743276000),
(411, 'Negreet', 'LA', 98.9707194000, 105.3376115000),
(588, 'Glencoe', 'KY', 46.3873924400, 136.0427027000),
(665, 'Chelsea', 'IA', 98.7221093700, 59.6891300200),
(342, 'Chignik Lagoon', 'AK', 103.1995264000, 153.0084273000),
(733, 'Pelahatchie', 'MS', 38.5816159500, 28.1195070300),
(441, 'Hanna City', 'IL', 50.9893298700, 136.7811010000),
(811, 'Dorrance', 'KS', 102.0888316000, 121.5614372000)
(222, 'Atlanta', 'GA', 33.7658395757, 73.5440912300);

-- changes from pull request #3
ALTER TABLE weather_observation_station_five RENAME TO station;

------------------------------------------------------------------------------------------------------
-- solution for weather_observation_station_one
SELECT 
    CITY, 
    STATE 
FROM station;

-- solution for weather_observation_station_two
SELECT
	ROUND(SUM(LAT_N),2), 
	ROUND(SUM(LONG_W),2) 
FROM station;

-- solution for weather_observation_station_three
SELECT
    CITY
FROM
    station
WHERE
    MOD(ID, 2) = 0;

-- solution for weather_observation_station_four
SELECT 
    COUNT(CITY) - COUNT(DISTINCT CITY) 
FROM station;


-- solution for weather_observation_station_five
SELECT CITY, name_length
FROM (
    -- city with the shortest name and its length
    SELECT CITY, LENGTH(CITY) AS name_length
    FROM station
    ORDER BY LENGTH(CITY) ASC, CITY ASC
    LIMIT 1
) AS shortest_city_result

UNION ALL

SELECT CITY, name_length
FROM (
    -- city with the longest name and its length
    SELECT CITY, LENGTH(CITY) AS name_length
    FROM station
    ORDER BY LENGTH(CITY) DESC, CITY ASC
    LIMIT 1
) AS longest_city_result;

-- solution for weather_observation_station_six
SELECT DISTINCT CITY
FROM STATION
WHERE CITY ~* '^[aeiou]';

-- solution for weather_observation_station_seven
SELECT DISTINCT CITY
FROM STATION
WHERE CITY ~* '[aeiou]$';

-- solution for weather_observation_station_eight
SELECT DISTINCT CITY
FROM STATION
WHERE CITY ~* '^[aeiou].*[aeiou]$';

-- solution for weather_observation_station_nine
SELECT DISTINCT CITY
FROM STATION
WHERE CITY !~* '^[aeiou]';

-- solution for weather_observation_station_ten
SELECT DISTINCT CITY
FROM STATION
WHERE CITY !~* '[aeiou]$';

-- solution for weather_observation_station_eleven
SELECT DISTINCT CITY
FROM STATION
WHERE CITY !~* '^[aeiou].*[aeiou]$';

-- solution for weather_observation_station_twelve
SELECT DISTINCT CITY
FROM STATION
WHERE CITY !~* '^[aeiou]' and CITY !~* '[aeiou]$';

-- solution for weather_observation_station_thirteen

-- solution for weather_observation_station_fourteen


-- solution for weather_observation_station_twenty
-- my initial mistake, solution worked with odd numbers
WITH distributed_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY LAT_N) AS quartile -- NTILE tried to distrubute rows as evenly as possible
    FROM
        station
)
SELECT
    ROUND(MAX(LAT_N)::numeric, 4) AS north_latitude_median
FROM
    distributed_quartiles
WHERE
    quartile = 2; -- NTILE distribution works dependent on dataset numbers, 2 points close to middle

-- final solution, consider both odd and even number of numbers in the dataset
-- PERCENTILE_CONT(0.5) calculate the value at the 50th percentile
SELECT
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY LAT_N)::numeric,
        4
    ) AS north_latitude_median
FROM
    station;