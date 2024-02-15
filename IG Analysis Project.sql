/* 
Instagram Users Analysis

products : software or mobil application

Skills used: CTE, Join, subquery, Aggregate Functions.

*/


USE ig_users;

# Task 1: Marketing

# 1. Find out the 5 oldest users 

SELECT user_id,
	   username,
	   created_at
FROM users
ORDER BY created_at 
LIMIT 5;


# 2. Send reminding emails to inactive users to star posting their first photo on Instagram

SELECT u.user_id,
	   u.username,
       COUNT(p.photo_id) AS "no_post"
FROM users u
LEFT JOIN photos p USING(user_id)
GROUP BY u.user_id
HAVING COUNT(p.photo_id) = 0;


# 3. Identify the winner of the most liked photo

WITH Photo_likes AS
	(SELECT photo_id,
		   count(photo_id) as total_like
	FROM likes 
	GROUP BY photo_id
	ORDER BY total_like DESC LIMIT 1)
SELECT u.user_id, u.username,
		p.photo_id, Photo_likes.total_like
FROM Photo_likes 
JOIN photos p USING(photo_id)
JOIN users u USING(user_id);


# 4. Find out the top 5 most commonly used hashtages 
#    - content exposure, brand awareness and competitors analysis

SELECT t.tag_id, 
	   t.tag_name,
       COUNT(pt.tag_id) AS total_hashtages
FROM tags t
JOIN photo_tags pt USING(tag_id)
GROUP BY t.tag_id, t.tag_name
ORDER BY total_hashtages DESC LIMIT 5;


#5. For ad campaign launch schedule: What day of the week has the highest number of new registered users.

SELECT date_format(created_at, "%W") AS week_day,
		COUNT(user_id) AS New_registered
FROM users
GROUP BY week_day
ORDER BY New_registered DESC;


# Task 2: Performance Metrics

# 1. User Engagement 

SELECT 
(SELECT COUNT(photo_id) FROM photos) / (SELECT COUNT(DISTINCT user_id) FROM photos) AS avg_active_userpost,
(SELECT COUNT(photo_id) FROM photos) / (SELECT COUNT(user_id) FROM users) AS avg_userpost;


# 2. Bots and Fake accounts

SELECT u.user_id, 
	   u.username,
       COUNT(*) AS num_like
FROM users u
JOIN likes l USING(user_id)
GROUP BY l.user_id
HAVING num_like = (SELECT COUNT(*) FROM photos);