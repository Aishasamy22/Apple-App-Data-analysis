-- check the numbers of unique apps 
SELECT 
    COUNT(DISTINCT app_id) AS num_app_id
FROM
    appleappdata

-- check any missing data 
SELECT 
    COUNT(*) AS missingvalues
FROM
    appleappdata
WHERE
    app_id IS NULL OR primary_genre IS NULL 
    
    
-- overview of apps rating 
SELECT 
    MIN(average_user_rating) AS minrating ,
    Max(average_user_rating) AS maxrating ,
    AVG(average_user_rating) AS averagerating
FROM
    appleappdata

-- find numbers of application per genre
SELECT 
    primary_genre, COUNT(*) AS num_of_app
FROM
    appleappdata
GROUP BY primary_genre
order by num_of_app desc

-- Determine whether paid apps have higher ratings than free apps

SELECT 
    free, format(AVG(average_user_rating),2) AS average_rating
FROM
    appleappdata
GROUP BY free 

-- Determine whether paid apps have higher ratings than free apps ( other option)

SELECT 
    CASE
        WHEN price > 0 THEN "paid"
        ELSE "free"
    END AS app_type,
    AVG(average_user_rating) as average_rating
FROM
    appleappdata
GROUP BY app_type
 
-- check genre with high rating 
SELECT 
    primary_genre, format(AVG(average_user_rating),2) as average_rating
FROM
    appleappdata
GROUP BY primary_genre
ORDER BY AVG(average_user_rating) DESC
LIMIT 5

-- correlation between paid apps price and genre (highest price)
SELECT 
    primary_genre, format(AVG(price),2) as average_price
FROM
    appleappdata
WHERE
    price > 0
GROUP BY primary_genre
ORDER BY AVG(price) DESC
LIMIT 5

-- correlation between app Size_Bytes and genre 
SELECT 
    primary_genre, round(AVG(size_Bytes)) AS average_size
FROM
    appleappdata
GROUP BY primary_genre
ORDER BY AVG(size_Bytes) DESC
LIMIT 10

-- the top 3 rating free apps from each genre  with highest reviews no.

select App_Id, primary_genre, average_user_rating 
from (SELECT 
  primary_genre,free,  App_Id , average_user_rating , Reviews_No ,
row_number() over (partition BY primary_genre , free order by average_user_rating desc , Reviews_No desc) as app_rank 
FROM
    appleappdata ) a
    
where a.app_rank <= 3 and a.average_user_rating <> 0 and free = "true"



