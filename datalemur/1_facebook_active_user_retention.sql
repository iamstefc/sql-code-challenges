-- written with PostgreSQL 17
CREATE TABLE public.user_actions
(
    user_id integer,
    event_id integer,
    event_type text,
    event_date timestamp without time zone
);

ALTER TABLE IF EXISTS public.user_actions
    OWNER to postgres;

INSERT INTO user_actions (user_id, event_id, event_type, event_date) VALUES
(445, 7765, 'sign-in', '2022-05-31 12:00:00'),
(742, 6458, 'sign-in', '2022-06-03 12:00:00'),
(445, 3634, 'like',    '2022-06-05 12:00:00'),
(742, 1374, 'comment', '2022-06-05 12:00:00'),
(648, 3124, 'like',    '2022-06-18 12:00:00'),
(445, 8888, 'sign-in', '2022-06-25 10:00:00'),
(445, 9999, 'like',    '2022-07-01 09:00:00'),
(742, 1111, 'sign-in', '2022-07-10 11:00:00'),
(123, 2222, 'comment', '2022-07-15 14:00:00');

WITH user_actions AS (
    SELECT
        EXTRACT(MONTH FROM event_date) AS month_number,
        user_id
    FROM
        user_actions
    WHERE
        event_type IN ('sign-in', 'like', 'comment')
    GROUP BY
        EXTRACT(MONTH FROM event_date),
        user_id
),
user_monthly_activity AS (
    SELECT
        user_id,
        month_number,
        -- Get the next month the user was active.
        LEAD(month_number, 1) OVER (PARTITION BY user_id ORDER BY month_number) AS next_active_month
    FROM
        user_actions
)
SELECT
    next_active_month AS month,
    COUNT(DISTINCT user_id) AS monthly_active_users
FROM
    user_monthly_activity
WHERE
    next_active_month = 7
GROUP BY
    next_active_month;