
/* How many campaigns and sources does CoolTShirts use? Which source is used for each campaign?

Use three queries:
one for the number of distinct campaigns,
one for the number of distinct sources,
one to find how they are related.*/

SELECT COUNT (DISTINCT utm_campaign) AS '# of Campaigns'
FROM page_visits;

SELECT COUNT (DISTINCT utm_source) AS '# of Sources'
FROM page_visits;

SELECT DISTINCT utm_campaign AS "Campaign", utm_source AS "Source"
FROM page_visits
GROUP BY 1;

/* What pages are on the CoolTShirts website? Find the distinct values of the page_name column.*/

SELECT DISTINCT page_name AS "Pages"
FROM page_visits;

/*How many first touches is each campaign responsible for?*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS 'first_touch_at'
    FROM page_visits
    GROUP BY 1
),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch AS 'ft'
  JOIN page_visits AS 'pv'
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)
SELECT ft_attr.utm_campaign AS "Campaign",
       COUNT(*) AS "First Touch Count"
FROM ft_attr
GROUP BY 1
ORDER BY 2 DESC;

/*How many last touches is each campaign responsible for?*/

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    GROUP BY 1
),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch AS 'lt'
  JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_campaign AS "Campaign",
       COUNT(*) AS "Last Touch Count"
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;

/*How many visitors make a purchase?*/

SELECT COUNT (DISTINCT user_id)
FROM page_visits
WHERE page_name = "4 - purchase";

/*How many last touches on the purchase page is each campaign responsible for?*/

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY 1
),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch AS 'lt'
  JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_campaign AS "Campaign",
       COUNT(*) AS "Last Touch Count"
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;
