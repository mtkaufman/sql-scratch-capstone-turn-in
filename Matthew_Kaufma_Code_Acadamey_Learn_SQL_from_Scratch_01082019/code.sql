-- Step 1

SELECT *
FROM subscriptions
LIMIT 20;

-- Step 2

SELECT MIN(subscription_start), 
MAX(subscription_end)
FROM subscriptions;

-- Step 3

WITH months AS
 (SELECT '2017-01-01' AS 'first_day',
 '2017-01-31' AS 'last_day'
 UNION
 SELECT '2017-02-01' AS 'first_day',
 '2017-02-28' AS'last_day'
 UNION
 SELECT '2017-03-01' AS 'first_day',
 '2017-03-31' AS'last_day')
 SELECT *
 FROM months;

-- Step 4 (limited to 100 becausethe screen kept crashing otherwise)

WITH months AS
 (SELECT '2017-01-01' AS 'first_day',
 '2017-01-31' AS 'last_day'
 UNION
 SELECT '2017-02-01' AS 'first_day',
 '2017-02-28' AS 'last_day'
 UNION
 SELECT '2017-03-01' AS 'first_day',
 '2017-03-31' AS 'last_day'),
 cross_join AS
 (SELECT *
 FROM subscriptions
 CROSS JOIN months)
 SELECT *
 FROM cross_join
 LIMIT 100;

-- Step 5 (limited to 100 becausethe screen kept crashing otherwise)

WITH months AS
 (SELECT '2017-01-01' AS 'first_day',
 '2017-01-31' AS 'last_day'
 UNION
 SELECT '2017-02-01' AS 'first_day',
 '2017-02-28' AS 'last_day'
 UNION
 SELECT '2017-03-01' AS 'first_day',
 '2017-03-31' AS 'last_day'),
 cross_join AS
 (SELECT *
 FROM subscriptions
 CROSS JOIN months),
 status AS
 (SELECT id, first_day as month,
CASE
 WHEN 
 (segment = 87)
 AND
 (subscription_start < first_day)
    AND 
      (subscription_end > first_day
      OR subscription_end IS NULL)
     THEN 1
  ELSE 0
END as is_active_87,
CASE
 WHEN (segment = 30)
 AND
 (subscription_start < first_day)
    AND 
      (subscription_end > first_day
      OR subscription_end IS NULL)
     THEN 1
  ELSE 0
END as is_active_30 
FROM cross_join)
SELECT *
FROM status
LIMIT 100;

-- Step 6 (limited to 100 becausethe screen kept crashing otherwise)

WITH months AS
(SELECT '2017-01-01' AS 'first_day',
 '2017-01-31' AS 'last_day'
 UNION
 SELECT '2017-02-01' AS 'first_day',
 '2017-02-28' AS 'last_day'
 UNION
 SELECT '2017-03-01' AS 'first_day',
 '2017-03-31' AS 'last_day'),
 cross_join AS
 (SELECT *
 FROM subscriptions
 CROSS JOIN months),
 status AS
(SELECT id, first_day as month,
CASE
 WHEN 
 (segment = 87)
 AND
 (subscription_start < first_day)
    AND 
      (subscription_end > first_day
      OR subscription_end IS NULL)
     THEN 1
  ELSE 0
END as is_active_87,
CASE
 WHEN (segment = 30)
 AND
 (subscription_start < first_day)
    AND 
      (subscription_end > first_day
      OR subscription_end IS NULL)
     THEN 1
  ELSE 0
END as is_active_30, 
CASE
 WHEN 
 (segment = 87)
 AND
 (subscription_end BETWEEN first_day AND last_day)
  THEN 1
  ELSE 0
END as is_canceled_87,
CASE
 WHEN (segment = 30)
 AND
 (subscription_end BETWEEN first_day AND last_day)
  THEN 1
  ELSE 0
END as is_canceled_30 
FROM cross_join)
SELECT *
FROM status
LIMIT 100;

-- Step 7

WITH months AS
(SELECT '2017-01-01' AS 'first_day',
 '2017-01-31' AS 'last_day'
 UNION
 SELECT '2017-02-01' AS 'first_day',
 '2017-02-28' AS 'last_day'
 UNION
 SELECT '2017-03-01' AS 'first_day',
 '2017-03-31' AS 'last_day'),
 cross_join AS
 (SELECT *
 FROM subscriptions
 CROSS JOIN months),
 status AS
(SELECT id, first_day as month,
CASE
 WHEN 
 (segment = 87)
 AND
 (subscription_start < first_day)
    AND 
      (subscription_end > first_day
      OR subscription_end IS NULL)
     THEN 1
  ELSE 0
END as is_active_87,
CASE
 WHEN (segment = 30)
 AND
 (subscription_start < first_day)
    AND 
      (subscription_end > first_day
      OR subscription_end IS NULL)
    THEN 1
  ELSE 0
END as is_active_30, 
CASE
 WHEN 
 (segment = 87)
 AND
 (subscription_end BETWEEN first_day AND last_day)
  THEN 1
  ELSE 0
END as is_canceled_87,
CASE
 WHEN (segment = 30)
 AND
 (subscription_end BETWEEN first_day AND last_day)
  THEN 1
  ELSE 0
END as is_canceled_30 
FROM cross_join),
status_aggregate AS
(SELECT month, 
SUM(is_active_87) AS sum_active_87, 
SUM(is_active_30) as sum_active_30, 
SUM(is_canceled_87) as sum_canceled_87, 
SUM(is_canceled_30) as sum_canceled_30
FROM status
GROUP BY 1)
SELECT *
from status_aggregate;

-- Step 8
 
WITH months AS
(SELECT '2017-01-01' AS 'first_day',
 '2017-01-31' AS 'last_day'
 UNION
 SELECT '2017-02-01' AS 'first_day',
 '2017-02-28' AS 'last_day'
 UNION
 SELECT '2017-03-01' AS 'first_day',
 '2017-03-31' AS 'last_day'),
 cross_join AS
 (SELECT *
 FROM subscriptions
 CROSS JOIN months),
 status AS
(SELECT id, first_day as month,
CASE
 WHEN 
 (segment = 87)
 AND
 (subscription_start < first_day)
    AND 
      (subscription_end > first_day
      OR subscription_end IS NULL)
  THEN 1
  ELSE 0
END as is_active_87,
CASE
 WHEN (segment = 30)
 AND
 (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) THEN 1
  ELSE 0
END as is_active_30, 
CASE
 WHEN 
 (segment = 87)
 AND
 (subscription_end BETWEEN first_day AND last_day)
  THEN 1
  ELSE 0
END as is_canceled_87,
CASE
 WHEN (segment = 30)
 AND
 (subscription_end BETWEEN first_day AND last_day)
  THEN 1
  ELSE 0
END as is_canceled_30 
FROM cross_join),
status_aggregate AS
(SELECT month, 
SUM(is_active_87) AS sum_active_87, 
SUM(is_active_30) as sum_active_30, 
SUM(is_canceled_87) as sum_canceled_87, 
SUM(is_canceled_30) as sum_canceled_30
FROM status
GROUP BY 1)
SELECT month, 
1.0 * sum_canceled_87 / sum_active_87 AS churn_rate_87, 
1.0 * sum_canceled_30 / sum_active_30 AS churn_rate_30
FROM status_aggregate; 

-- Overall churn rate per month (answer to question 2)

WITH months AS 
  (SELECT 
    '2017-01-01' AS first_day, 
    '2017-01-31' AS last_day 
  UNION 
  SELECT 
    '2017-02-01' AS first_day, 
    '2017-02-28' AS last_day 
  UNION 
  SELECT 
    '2017-03-01' AS first_day, 
    '2017-03-31' AS last_day), 
cross_join AS 
  (SELECT *
  FROM subscriptions
  CROSS JOIN months), 
status AS 
  (SELECT 
    id, 
    first_day AS month, 
    CASE
      WHEN (subscription_start < first_day) 
        AND 
          (subscription_end > first_day 
          OR subscription_end IS NULL)
         THEN 1
      ELSE 0
    END AS is_active, 
    CASE
      WHEN subscription_end BETWEEN first_day AND last_day THEN 1
      ELSE 0
    END AS is_canceled 
  FROM cross_join), 
status_aggregate AS 
  (SELECT 
    month, 
    SUM(is_active) AS active, 
    SUM(is_canceled) AS canceled 
  FROM status 
  GROUP BY month) 
SELECT
  month, 
  1.0 * canceled / active AS churn_rate 
FROM status_aggregate;

-Bonus question: remove the section of code in the churn calculation that specifies the segment ID and instead, add a column to the query for segment, and then group by segment as well as month