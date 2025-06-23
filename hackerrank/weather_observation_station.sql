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
-- solution for part 1
SELECT 
    CITY, 
    STATE 
FROM station;

-- solution for part 2
SELECT
	ROUND(SUM(LAT_N),2), 
	ROUND(SUM(LONG_W),2) 
FROM station;

-- solution for part 3
SELECT
    CITY
FROM
    station
WHERE
    MOD(ID, 2) = 0;

-- solution for part 4
SELECT 
    COUNT(CITY) - COUNT(DISTINCT CITY) 
FROM station;


-- solution for part 5
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

-- solution for part 6
SELECT DISTINCT CITY
FROM STATION
WHERE CITY ~* '^[aeiou]';

-- solution for part 7
SELECT DISTINCT CITY
FROM STATION
WHERE CITY ~* '[aeiou]$';

-- solution for part 8
SELECT DISTINCT CITY
FROM STATION
WHERE CITY ~* '^[aeiou].*[aeiou]$';

-- solution for part 9
SELECT DISTINCT CITY
FROM STATION
WHERE CITY !~* '^[aeiou]';

-- solution for part 10
SELECT DISTINCT CITY
FROM STATION
WHERE CITY !~* '[aeiou]$';

-- solution for part 11
SELECT DISTINCT CITY
FROM STATION
WHERE CITY !~* '^[aeiou].*[aeiou]$';

-- solution for part 12
SELECT DISTINCT CITY
FROM STATION
WHERE CITY !~* '^[aeiou]' and CITY !~* '[aeiou]$';

-- solution for part 13
-- Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 and less than 137.2345
SELECT ROUND(SUM(LAT_N),4) FROM STATION
WHERE LAT_N > 38.7880 AND LAT_N < 137.2345;

-- solution for part 14
-- Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345
SELECT ROUND(MAX(LAT_N),4) FROM STATION
WHERE LAT_N < 137.2345;

-- solution for part 15
-- Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345
SELECT ROUND(LONG_W,4) FROM STATION
WHERE LAT_N = (SELECT MAX(LAT_N) FROM STATION WHERE LAT_N < 137.2345);

-- solution for part 16
-- Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7780
SELECT ROUND(MIN(LAT_N),4) FROM STATION
WHERE LAT_N > 38.7880;

-- solution for part 17
-- Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 38.7780
SELECT ROUND(LONG_W,4) FROM STATION
WHERE LAT_N = (SELECT MIN(LAT_N) FROM STATION WHERE LAT_N > 38.7880);

-- solution for part 18

-- solution for part 19

-- solution for part 20
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