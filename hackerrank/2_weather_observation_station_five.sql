-- written with PostgreSQL 17
CREATE TABLE public.weather_observation_station_five
(
    id integer,
    city text,
    state text,
    lat_n double precision,
    long_w double precision
);

ALTER TABLE IF EXISTS public.weather_observation_station_five
    OWNER to postgres;

INSERT INTO public.weather_observation_station_five (id, city, state, lat_n, long_w) VALUES
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
(811, 'Dorrance', 'KS', 102.0888316000, 121.5614372000);

SELECT CITY, name_length
FROM (
    -- city with the shortest name and its length
    SELECT CITY, LENGTH(CITY) AS name_length
    FROM weather_observation_station_five
    ORDER BY LENGTH(CITY) ASC, CITY ASC
    LIMIT 1
) AS shortest_city_result

UNION ALL

SELECT CITY, name_length
FROM (
    -- city with the longest name and its length
    SELECT CITY, LENGTH(CITY) AS name_length
    FROM weather_observation_station_five
    ORDER BY LENGTH(CITY) DESC, CITY ASC
    LIMIT 1
) AS longest_city_result;

-- the MySQL solution