SELECT *
FROM survey
LIMIT 10






SELECT question, count(*)
FROM survey
GROUP BY 1;






SELECT *
FROM quiz
LIMIT 5;






SELECT *
FROM home_try_on
LIMIT 5;






SELECT *
FROM purchase
LIMIT 5;






SELECT DISTINCT q.user_id, 
h.user_id IS NOT NULL AS 'is_home_try_on', 
h.number_of_pairs, 
p.user_ID IS NOT NULL AS 'is_purchase'
FROM quiz AS q
LEFT JOIN home_try_on AS h
ON q.user_id = h.user_id
LEFT JOIN purchase AS p
ON p.user_id = q.user_id
LIMIT 10;






WITH funnel as (
  
SELECT DISTINCT q.user_id, 
h.user_id IS NOT NULL AS 'is_home_try_on', 
h.number_of_pairs, 
p.user_ID IS NOT NULL AS 'is_purchase'
FROM quiz AS q
LEFT JOIN home_try_on AS h
ON q.user_id = h.user_id
LEFT JOIN purchase AS p
ON p.user_id = q.user_id)


SELECT count(user_id) AS 'num_user_id', 


count(
CASE
  WHEN is_home_try_on = 1
  THEN user_id
  ELSE NULL
END) AS 'num_home_try_on',


count(
CASE
WHEN is_purchase = 1
  THEN user_id
  ELSE NULL
  END) AS 'num_purchase',
  
  1.0 * SUM(is_home_try_on) / count(user_id) AS 'Quiz to Try On',
  1.0 * SUM(is_purchase) / sum(is_home_try_on) AS 'Try On to Purchase',
    1.0 * SUM(is_purchase) / count(user_id) AS 'Quiz to Purchase'
  
FROM funnel;










WITH funnel as (
  
SELECT DISTINCT q.user_id, 
h.user_id IS NOT NULL AS 'is_home_try_on', 
h.number_of_pairs, 
p.user_ID IS NOT NULL AS 'is_purchase'
FROM quiz AS q
LEFT JOIN home_try_on AS h
ON q.user_id = h.user_id
LEFT JOIN purchase AS p
ON p.user_id = q.user_id)


SELECT number_of_pairs,
count(user_id) AS 'num_user_id', 


count(
CASE
  WHEN is_home_try_on = 1
  THEN user_id
  ELSE NULL
END) AS 'num_home_try_on',


count(
CASE
WHEN is_purchase = 1
  THEN user_id
  ELSE NULL
  END) AS 'num_purchase',
  
  1.0 * SUM(is_home_try_on) / count(user_id) AS 'Quiz to Try On',
  1.0 * SUM(is_purchase) / sum(is_home_try_on) AS 'Try On to Purchase',
    1.0 * SUM(is_purchase) / count(user_id) AS 'Quiz to Purchase'
  
FROM funnel
GROUP BY number_of_pairs;










WITH funnel as (
  
SELECT DISTINCT q.user_id, 
h.user_id IS NOT NULL AS 'is_home_try_on', 
h.number_of_pairs, 
p.user_ID IS NOT NULL AS 'is_purchase',
p.price
FROM quiz AS q
LEFT JOIN home_try_on AS h
ON q.user_id = h.user_id
LEFT JOIN purchase AS p
ON p.user_id = q.user_id)


SELECT number_of_pairs,


count(
CASE
WHEN is_purchase = 1
  THEN user_id
  ELSE NULL
  END) AS 'num_purchase',
  
  SUM(price) AS 'Total Orders Value',
  
1.0 * ROUND(SUM(price) /   count(
CASE
WHEN is_purchase = 1
  THEN user_id
  ELSE NULL
  END) ,2) AS 'Average Order Size'
  
FROM funnel
GROUP BY number_of_pairs;