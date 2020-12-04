-- START Q1 

SELECT u.user_id, ROUND(AVG(stars)::numeric) average_star_rating
FROM users u
JOIN reviews r ON r.user_id = u.user_id
GROUP BY 1
HAVING COUNT(*)>2
ORDER BY 2 DESC
LIMIT 5;

-- END Q1 


-- START Q2 
WITH cat AS (SELECT business_id, stars, review_count, unnest(string_to_array(categories,', ')) AS category
FROM businesses),

more_5 AS (SELECT category, COUNT(DISTINCT business_id) num_businesses
FROM cat
GROUP BY 1
HAVING COUNT(*) > 3),


weight AS (SELECT category, SUM(stars*review_count)/SUM(review_count) weighted_average_stars
FROM cat
WHERE category IN (SELECT category FROM more_5)
GROUP BY 1)

SELECT w.category, ROUND(weighted_average_stars::numeric, 6) weighted_average_stars , num_businesses
FROM weight w 
JOIN more_5 m ON w.category =m.category
ORDER BY 2 DESC;
-- END Q2


-- START Q3

SELECT u.name username,b.name businessname, COUNT(DISTINCT t.date) tips_left, COUNT(DISTINCT review_id) reviews_left
FROM public.tips t
JOIN public.users u ON u.user_id = t.user_id
JOIN reviews r ON r.user_id = u.user_id
JOIN public.businesses b ON b.business_id = t.business_id
GROUP BY 1,2
ORDER BY 2;

-- END Q3


-- START Q4

SELECT u.user_id, fans, u.name username, text
FROM public.users u 
JOIN public.reviews r ON r.user_id = u.user_id
WHERE fans >= 5 AND business_id IN (SELECT business_id
FROM businesses
WHERE name = 'Burlington Coat Factory');

-- END Q4



-- START Q5  

WITH no_tip AS(SELECT u.user_id, average_stars
FROM users u
LEFT JOIN tips t ON u.user_id = t.user_id
JOIN reviews r ON r.user_id = u.user_id			   
GROUP BY u.user_id
HAVING COUNT(t.date) = 0),

tip AS(SELECT u.user_id, average_stars
FROM users u
LEFT JOIN tips t ON u.user_id = t.user_id
JOIN reviews r ON r.user_id = u.user_id
GROUP BY u.user_id
HAVING COUNT(t.date) > 0)

SELECT 'Users without tips' type_of_user, ROUND(AVG(stars)::numeric,6) avg_stars 
FROM no_tip n
JOIN reviews r ON r.user_id = n.user_id
UNION
SELECT 'Users with tips' type_of_user, ROUND(AVG(stars)::numeric,6)
FROM tip t
JOIN reviews r ON r.user_id = t.user_id;

-- END Q5


-- START Q6 

SELECT COALESCE(attributes::JSON ->> 'BusinessAcceptsCreditCards', 'False') accepts_credit_cards, 
COALESCE(attributes::JSON ->> 'RestaurantsTakeOut', 'False') offers_takeout, ROUND(AVG(stars)::numeric, 6) average_stars
FROM businesses
GROUP BY 1,2;

-- END Q6


-- START Q7

WITH ord AS(SELECT e.entertainerid, engagementnumber, COUNT(*) OVER(PARTITION BY e.entertainerid ORDER BY en.startdate) engs
FROM entertainers e 
JOIN engagements en ON en.entertainerid = e.entertainerid),

first_five AS (SELECT entertainerid, engagementnumber
FROM ord 
WHERE engs <= 5),

avg_5 AS (SELECT 'First Five Engagements' engagement_category, ROUND(AVG(contractprice)::numeric,3)
FROM engagements 
WHERE engagementnumber IN (SELECT engagementnumber FROM first_five) ),

avg_rest AS (SELECT '6th and Beyond Engagements' engagement_category, ROUND(AVG(contractprice)::numeric,3) avg
FROM engagements 
WHERE engagementnumber NOT IN (SELECT engagementnumber FROM first_five))

SELECT* FROM avg_rest
UNION
SELECT*FROM avg_5;

-- END Q7


-- START Q8

WITH above_avg AS(SELECT*
FROM engagements
WHERE contractprice > (SELECT AVG(contractprice)
FROM engagements))

SELECT ROUND(AVG(contractprice)::numeric,3) avg_contract_price, MAX(startdate) most_recent_start_date, COUNT(*) num_engagements
FROM above_avg;


-- END Q8


-- START Q9 

SELECT gender, stylename, COUNT(DISTINCT em.memberid) num_members
FROM public.entertainer_members em
JOIN public.members m ON m.memberid = em.memberid
JOIN public.entertainer_styles es ON es.entertainerid = em.entertainerid
JOIN public.musical_styles ms ON ms.styleid = es.styleid
GROUP BY 1,2
HAVING COUNT(DISTINCT em.memberid) >4
ORDER BY 3 DESC;

-- END Q9







