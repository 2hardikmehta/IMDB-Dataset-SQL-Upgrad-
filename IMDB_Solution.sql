USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) from movie;  -- 7997
select count(*) from director_mapping;  -- 3867
select count(*) from genre;  -- 14662
select count(*) from names;  -- 25735
select count(*) from ratings;  -- 7997
select count(*) from role_mapping;  -- 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select 
      SUM(case when ID is null then 1 else 0 end) as ID_NULL,
      SUM(case when title is null then 1 else 0 end) as title_NULL,
      SUM(case when year is null then 1 else 0 end) as year_NULL,
      SUM(case when date_published is null then 1 else 0 end) as date_published_NULL,
      SUM(case when duration is null then 1 else 0 end) as duration_NULL,
      SUM(case when country is null then 1 else 0 end) as country_NULL,
      SUM(case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income_NULL,
      SUM(case when languages is null then 1 else 0 end) as languages_NULL,
      SUM(case when production_company is null then 1 else 0 end) as production_company_NULL
      
from movie;


-- The 4 columns: country , worldwide_gross_income,languages,production_company have null values .



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944			|
|	2019		|	2001			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-----------------------+
|	month_num	|	number_of_movies    |
+---------------+------------------------
|	1.			|		804.		    |
|	2.			|		640.		    |
|	3.			|		824.			|
|	4.			|		680.			|
|	5.			|		625.			|
|	6.			|		580.			|
|	7.			|		493.			|
|	8.			|		678.			|
|	9.			|		809.			|
|	10.			|		801.			|
|	11.			|		625.			|
|	12.			|		438.			|
+---------------+-----------------------+ */
-- Type your code below:
SELECT year, COUNT(id) as Number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

SELECT month(date_published) as month_num, COUNT(id) as Number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(id) AS number_of_movies, year
FROM movie
WHERE country = 'USA' OR country = 'India'
GROUP BY country
HAVING year = 2019;


-- 1007 movies were produced in the USA or India in the year 2019.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre
ORDER BY genre;

-- the unique list of the genres present in the data set are:
-- Action
-- Adventure
-- Comedy
-- Crime
-- Drama
-- Family
-- Fantasy
-- Horror
-- Mystery
-- Others
-- Romance
-- Sci-Fi
-- Thriller


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre,COUNT(id) as movie_count
FROM genre as g
INNER JOIN movie as m
ON g.movie_id = m.id
WHERE year = 2019
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 1;

-- Drama has the highest number of movies produced overall i.e. 1078.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(movie_id) as Total_movies_with_1_genre
FROM
(SELECT movie_id,COUNT(genre) as genre_count
FROM genre
GROUP BY movie_id
HAVING genre_count = 1) As genre_count;


-- Movies with 1 genre is 3289.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	Action  	|		112.88		|
|	Romance		|		109.53		|
|	Crime.		|		107.05		|
|	Drama.		|		106.77		|
|	Fantasy.	|		105.14		|
|	Comedy.		|		102.62		|
|	Adeventure.	|		101.87		|
|	Mystery.	|		101.80.		|
|	Thriller.	|		101.58		|
|	Family.		|		100.97		|
|	Others.		|		100.1.		|
|	Sci-Fi.		|		97.94		|
|	Horror.		|		92.72		|
+---------------+-------------------+ */
-- Type your code below:
SELECT DISTINCT genre,
       ROUND(avg(duration),2) as avg_duration
FROM genre as g
INNER JOIN movie as m
ON m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|Thriller		|	1484			|			3		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH genre_wise_moviecount AS
(SELECT DISTINCT g.genre,COUNT(m.id) as movie_count
FROM genre as g
INNER JOIN movie as m
ON g.movie_id = m.id
GROUP BY genre),
genre_ranks as
(SELECT genre,movie_count,
       RANK() OVER(ORDER BY movie_count DESC) as genre_rank
FROM genre_wise_moviecount)
SELECT * FROM genre_ranks
WHERE genre = 'thriller';


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1		|			10		|	       100		  |	   725138    		 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT ROUND(MIN(avg_rating),0) AS min_avg_rating,
       ROUND(MAX(avg_rating),0) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes,
       MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title		           	  |  	avg_rating	|movie_rank   |
+---------------+-------------------+---------------------+
| Kirket			      |		10.0		|		1	  |
|Love in Kilnerry	      |		10.0		|		1	  |
|Gini Helida Kathe        |		9.8			|		2	  |
|Runam				      |		9.7			|		3	  |
|Fan				      |		9.6			|		4	  |
|Android Kunjappan	      |		9.6			|		4	  |
|Yeh Suhaagraat Impossible|		9.5			|		5	  |
|Safe				      |		9.5			|		5	  |
|The Brighton Miracle     |		9.5			|   	5	  |
|Shibu				      |		9.4			|		6	  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)
SELECT m.title, r.avg_rating,
       DENSE_RANK() OVER(ORDER BY r.avg_rating DESC) AS movie_rank
FROM ratings as r
INNER JOIN movie as m
ON r.movie_id = m.id
LIMIT 10;







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	7			|		2257		|
|	6			|		1975		|
|	8			|		1030		|
|	5			|		985			|
|	4			|		479			|
|	9			|		429			|
|	10			|		346			|
|	3			|		283			|
|	2			|		119			|
|	1			|		94			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,COUNT(movie_id) As movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+--------------------------+-------------------+---------------------+
|production_company        |movie_count	       |	prod_company_rank|
+--------------------------+-------------------+---------------------+
|Dream Warrior Pictures	   |		3		   |			1	  	 |
|National Theatre Live	   |		3		   |			1	  	 |
+--------------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_company_hit_movie_summary
     AS (SELECT production_company,
		Count(movie_id) AS MOVIE_COUNT,
		Rank()
		OVER(ORDER BY Count(movie_id) DESC ) AS PROD_COMPANY_RANK
         FROM   ratings AS R
                INNER JOIN movie AS M
                        ON M.id = R.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_company_hit_movie_summary
WHERE  prod_company_rank = 1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	Drama	    |		16			|
|	Comedy		|		8			|
|	Crime		|		5			|
|	Horror		|		5			|
|	Action	    |		4			|
|	Sci-Fi		|		4			|
|	Thriller	|		4			|
|	Romance		|		3			|
|	Fantacy		|		2			|
|	Mystery		|		2			|
|	Family		|		1			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre, COUNT(id) as movie_count
FROM genre as g
INNER JOIN movie as m
ON m.id = g.movie_id
INNER JOIN ratings as r
ON r.movie_id = m.id
WHERE r.total_votes > 1000 AND country = 'USA' AND year = 2017 AND month(date_published) = 03
GROUP BY genre
ORDER BY movie_count DESC;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+-----------------------------------+-------------------+---------------------+
| title		                     	|	average_rating	|		genre	      |
+-----------------------------------+-------------------+---------------------+
|The Brighton Miracle	        	|		9.5			|		  Drama 	  |
|The Colour of Darkness 		    |		9.1			|		  Drama		  |
|The Blue Elephant 2			    |		8.8			|		  Drama		  |
|The Blue Elephant 2			    |		8.8			|		  Horror	  |
|The Blue Elephant 2		     	|		8.8			|		  Mystery	  |
|The Irishman			            |		8.7			|		  Crime		  |
|The Irishman		                |		8.7		    |	      Drama    	  |
|The Mystery of Godliness: TheSequel|		8.5			|		  Drama		  |
|The Gambinos		            	|		8.4			|	      Crime	      |
|The Gambinos			            |		8.4			|		  Drama		  |
|Theeran Adhigaaram Ondru			|		8.3			|		  Action	  |
|Theeran Adhigaaram Ondru			|		8.3			|		  Crime	      |
|Theeran Adhigaaram Ondru			|		8.3			|		  Thriller    |
|The King and I		                |		8.2			|		  Drama 	  |
|The King and I		             	|		8.2			|	   	  Romance	  |
+-----------------------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT title,avg_rating,genre
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
INNER JOIN genre as g
ON g.movie_id = m.id
WHERE title LIKE "The%" AND avg_rating > 8
ORDER BY avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
SELECT title,median_rating,genre
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
INNER JOIN genre as g
ON g.movie_id = m.id
WHERE title LIKE "The%" AND median_rating > 8
ORDER BY median_rating DESC;

/* Output format:
+-----------------------------------+-------------------+---------------------+
| title		                     	|	median_rating	|		genre	      |
+-----------------------------------+-------------------+---------------------+
|The Blue Elephant 2                |        10         |      Drama          | 
|The Blue Elephant 2                |        10         |      Horror         |                     
|The Blue Elephant 2                |        10         |      Mystery        |
|The Brighton Miracle               |        10         |      Drama          |
|The Eagle Path                     |        10         |      Action         |
|The Eagle Path                     |        10         |      Crime          |
|The Eagle Path                     |        10         |      Drama          |
|The Answer                         |        10         |      Family         |
|The Garden Left Behind             |        10         |      Drama          |
|The Black Prince                   |        10         |      Drama          |
|The Sounding                       |        10         |      Drama          |
|The Sounding                       |        10         |      Mystery        |
|The Last Fiction                   |        10         |      Adventure      |
|The Last Fiction                   |        10         |      Drama          |
|The Promise                        |        10         |      Action         |
|The Promise                        |        10         |      Adventure      |
|The Promise                        |        10         |      Drama          |
|The Colour of Darkness             |        10         |      Drama          |
|The Pugilist                       |        10         |      Crime          |
|The Pugilist                       |        10         |      Drama          |
|The Wanderers: The Quest of The De |        10         |      Drama          |
|The Wanderers: The Quest of The De |        10         |      Fantasy        |
|The Wanderers: The Quest of The De |        10         |      Horror         |
|The Transcendents                  |        10         |     Mystery        |
|The Transcendents                  |        10         |      Thriller       |
|The Great Father                   |        10         |      Action         |
|The Great Father                   |        10         |      Crime          |
|The Great Father                   |        10         |      Drama          |
|The Misguided                      |        10         |      Comedy         |
|The Misguided                      |        10         |      Drama          |
|The Books of Knjige: Slucajevi Pra |        10         |      Comedy         |
|The Books of Knjige: Slucajevi Pra |        10         |      Drama          |
|The Final Scream                   |        10         |      Horror         |
|The Rally                          |        10         |      Action         |
|The Rally                          |        10         |      Drama          |
|The Rally                          |        10         |      Romance        |
|The Theta Girl                     |        10         |      Action         |
|The Theta Girl                     |        10         |      Horror         |
|The Theta Girl                     |        10         |      Sci-Fi         |
|The Carmilla Movie                 |        10         |      Comedy         |
|The Carmilla Movie                 |        10         |      Horror         |
|The Carmilla Movie                 |        10         |      Romance        |
|The Farm: En Veettu Thottathil     |        10         |      Thriller       |
|The Watcher                        |        10         |      Horror         |
|The Watcher                        |        10         |      Mystery        |
|The Watcher                        |        10         |      Thriller       |
|The Tashkent Files                 |        10         |      Drama          |
|The Tashkent Files                 |        10         |      Mystery        |
|The Tashkent Files                 |        10         |      Thriller       |
|The Last Guest                     |        10         |      Adventure      |
|The Last Guest                     |        10         |      Comedy         |
|The Last Guest                     |        10         |      Crime          |
|The Gambinos                       |        10         |      Crime          |
|The Gambinos                       |        10         |      Drama          |
|The Hows of Us                     |        10         |      Drama          |
|The Hows of Us                     |        10         |      Romance        |
|The Dark Side of Life: Mumbai City |        10         |      Drama          |
|The Donkey King                    |        10         |      Comedy         |
|The Donkey King                    |        10         |      Family         |
|The Least of These: The Graham Sta |        10         |      Drama          |
|The Mummy Rebirth                  |         9         |      Action         |
|The Mummy Rebirth                  |         9         |      Horror         |
|The Irishman                       |         9         |      Crime          |
|The Irishman                       |         9         |      Drama          |
|The Bang Bang Brokers              |         9         |      Action         |
|The Bang Bang Brokers              |         9         |      Comedy         |
|The Bang Bang Brokers              |         9         |      Crim           |
|The Lotus                          |         9         |      Action         |
|The Lotus                          |         9         |      Horror         |
|The Lotus                          |         9         |      Sci-Fi         |
|The Last Boy                       |         9         |      Drama          |
|The Last Boy                       |         9         |      Sci-Fi         |
|The Evangelist                     |         9         |      Horror         |
|The Evangelist                     |         9         |      Thriller       |
|The Texture of Falling             |         9         |      Drama          |
|The Limit Of                       |         9         |      Drama          |
|The Storyteller                    |         9         |      Drama          |
|The Storyteller                    |         9         |      Family         |
|The Storyteller                    |         9         |      Fantasy        |
|The Lurking Man                    |         9         |      Drama          |
|The Lurking Man                    |         9         |      Fantasy        |
|The Lurking Man                    |         9         |      Horror         |
|The Mason Brothers                 |         9         |      Crime          |
|The Mason Brothers                 |         9         |      Drama          |
|The Mason Brothers                 |         9         |      Thriller       |
|The Nursery                        |         9         |      Horror         |
|The Nursery                        |         9         |      Mystery        |
|The Nursery                        |         9         |      Thriller       |
|The Book of Secrets                |         9         |      Horror         |
|The Axiom                          |         9         |      Horror         |
|The Reliant                        |         9         |      Action         |
|The Villain                        |         9         |      Action         |
|The Villain                        |         9         |      Thriller       |
|The Drummer and the Keeper         |         9         |      Drama          |
|The Favorite                       |         9         |      Drama          |
|Theeran Adhigaaram Ondru           |         9         |      Action         |
|Theeran Adhigaaram Ondru           |         9         |      Crime          |
|Theeran Adhigaaram Ondru           |         9         |      Thriller       |
|The Elf                            |         9         |      Horror         |
|The Mystery of Godliness: The Sequ |         9         |      Drama          |
|The Rising Hawk                    |         9         |      Action         |
|The Rising Hawk                    |         9         |      Drama          |
|The Huntress: Rune of the Dead     |         9         |      Action         |
|The Huntress: Rune of the Dead     |         9         |      Horror         |
|The Huntress: Rune of the Dead     |         9         |      Thriller       |
+-----------------------------------+-------------------+---------------------+*/


-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT median_rating,COUNT(id) as movie_count
FROM ratings as r
INNER JOIN movie as m
ON m.id = r.movie_id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01' AND median_rating = 8
GROUP BY median_rating;


-- Total Movie Count= 361
-- Median Rating= 8


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT languages,total_votes 
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
WHERE languages LIKE 'German' OR languages LIKE 'Italian'
GROUP BY languages
ORDER BY total_votes DESC;


-- Yes, German movies get more votes than Italian movies


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|		17335		|	      13431		  |	   15226	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
		
FROM names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|Anthony Russo	|		3			|
|Soubin Shahir	|		3			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres AS
(SELECT genre,Count(m.id) AS movie_count ,
		Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
		FROM movie  AS m
		INNER JOIN genre AS g
		ON g.movie_id = m.id
		INNER JOIN ratings AS r
		ON r.movie_id = m.id
		WHERE avg_rating > 8
		GROUP BY genre limit 3 )
SELECT n.NAME AS director_name , Count(d.movie_id) AS movie_count
FROM director_mapping  AS d
INNER JOIN genre G
using     (movie_id)
INNER JOIN names AS n
ON n.id = d.name_id
INNER JOIN top_3_genres
using (genre)
INNER JOIN ratings
using (movie_id)
WHERE avg_rating > 8
GROUP BY NAME
ORDER BY movie_count DESC limit 3 ;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Mammootty	    |		8			|
|Mohanlal		|		5			|
+---------------+-------------------+ */
-- Type your code below:
SELECT DISTINCT name as actor_name,COUNT(r.movie_id) as movie_count
FROM names as n
INNER JOIN role_mapping as rm
ON n.id = rm.name_id
INNER JOIN ratings as r
ON rm.movie_id = r.movie_id
WHERE median_rating >=8 AND rm.category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+-----------------------+---------------+----------------------+
|production_company     |vote_count		|		prod_comp_rank |
+-----------------------+--------------------+-----------------+
| Marvel Studios		|	2656967		|		1	  		   |
|Twentieth Century Fox	|	2411163		|		2	    	   |
|Warner Bros.			|	2396057		|		3		       |
+-------------------+-------------------+----------------------+*/
-- Type your code below:
SELECT production_company, SUM(total_votes) AS vote_count,
DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
GROUP BY production_company
LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
Vijay Sethupathi	23114	5	8.42	1
Fahadh Faasil	13557	5	7.99	2
Yogi Babu	8500	11	7.83	3
Joju George	3926	5	7.58	4
Ammy Virk	2504	6	7.55	5
Dileesh Pothan	6235	5	7.52	6
Kunchacko Boban	5628	6	7.48	7
Pankaj Tripathi	40728	5	7.44	8
Rajkummar Rao	42560	6	7.37	9
Dulquer Salmaan	17666	5	7.30	10
Amit Sadh	13355	5	7.21	11
Tovino Thomas	11596	8	7.15	12
Mammootty	12613	8	7.04	13
Nassar	4016	5	7.03	14
Karamjit Anmol	1970	6	6.91	15
Hareesh Kanaran	3196	5	6.58	16
Naseeruddin Shah	12604	5	6.54	17
Anandraj	2750	6	6.54	18
Mohanlal	17622	7	6.47	19
Siddique	5953	7	6.43	20
Aju Varghese	2237	5	6.43	21
Prakash Raj	8548	6	6.37	22
Jimmy Sheirgill	3826	6	6.29	23
Mahesh Achanta	2716	6	6.21	24
Biju Menon	1916	5	6.21	25
Suraj Venjaramoodu	4284	6	6.19	26
Abir Chatterjee	1413	5	5.80	27
Sunny Deol	4594	5	5.71	28
Radha Ravi	1483	5	5.70	29
Prabhu Deva	2044	5	5.68	30
Atul Sharma	9604	5	4.78	31
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH ACTORS
AS
  (
             SELECT     NAME                                                       AS actor_name ,
                        SUM(TOTAL_VOTES)                                           AS total_votes,
                        COUNT(NAME)                                                AS movie_count,
                        ROUND(SUM(AVG_RATING * TOTAL_VOTES) / SUM(TOTAL_VOTES), 2) AS actor_avg_rating
             FROM       NAMES N
             INNER JOIN ROLE_MAPPING RO
             ON         N.ID = RO.NAME_ID
             INNER JOIN MOVIE M
             ON         RO.MOVIE_ID = M.ID
             INNER JOIN RATINGS RA
             ON         M.ID = RA.MOVIE_ID
             WHERE      COUNTRY REGEXP 'india'
             AND        CATEGORY = 'actor'
             GROUP BY   NAME
             HAVING     MOVIE_COUNT >= 5)
  SELECT   *,
           DENSE_RANK() OVER ( ORDER BY ACTOR_AVG_RATING DESC, TOTAL_VOTES DESC) AS actor_rank
  FROM     ACTORS;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH ACTRESS
AS
  (SELECT NAME AS actress_name, total_votes, COUNT(NAME) AS movie_count, ROUND(SUM(AVG_RATING*TOTAL_VOTES)/SUM(TOTAL_VOTES),2) AS actress_avg_rating
             FROM       NAMES N
             INNER JOIN ROLE_MAPPING RO
             ON         N.ID=RO.NAME_ID
             INNER JOIN MOVIE M
             ON         RO.MOVIE_ID=M.ID
             INNER JOIN RATINGS RA
             USING     (MOVIE_ID)
             WHERE      LANGUAGES REGEXP 'hindi'
             AND        COUNTRY REGEXP 'india'
             AND        CATEGORY = 'actress'
             GROUP BY   ACTRESS_NAME
             HAVING     COUNT(ACTRESS_NAME)>=3 )
  SELECT*,
           DENSE_RANK() OVER(ORDER BY ACTRESS_AVG_RATING DESC, TOTAL_VOTES DESC) AS actress_rank FROM     ACTRESS
  LIMIT    5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+------------------------------+
| movie_name	|	Ratings/ movie_category    |
+---------------+------------------------------+
Der müde Tod	7.7	Hit movies
Fahrenheit 451	4.9	flop movies
Pet Sematary	5.8	One-time-watch-movies
Dukun	        6.9	One-time-watch-movies
Back Roads	    7.0	Hit movies
Countdown	    5.4	One-time-watch-movies
Staged Killer	3.3	flop movies
Vellaipookal	7.3	Hit movies
Uriyadi 2	    7.3	Hit movies
Incitement	    7.5	Hit movies
Rakshasudu	    8.4	Superhit movies
Trois jours et 	6.6	One-time-watch-movies
Killer in Law	5.1	One-time-watch-movies
Kalki	        7.3	Hit movies
Milliard	    2.7	flop movies
Vinci Da	    7.2	Hit movies
Gunned Down	    5.1	One-time-watch-movies
Deviant Love	3.5	flop movies
Storozh       	6.3	One-time-watch-movies
Sivappu Manjal  7.2	Hit movies
Magamuni	    8.1	Superhit movies
Hometown Killer	5.8	One-time-watch-movies
ECCO	        5.0	One-time-watch-movies
Baaji	        7.1	Hit movies
Kasablanka	    6.7	One-time-watch-movies
Annabellum: The	2.9	flop movies
Zuo jia de huan 5.8	One-time-watch-movies
Evaru	        8.3	Superhit movies
Saja	        6.2	One-time-watch-movies
Jiivi	        7.9	Hit movies
Ai-naki Mori de 6.4	One-time-watch-movies
Ne Zha zhi mo 	7.7	Hit movies
Bornoporichoy: 	5.1	One-time-watch-movies
Ratu Ilmu Hitam	7.4	Hit movies
Barot House	    7.2	Hit movies
La llorona	    7.1	Hit movies
Tekst	        6.8	One-time-watch-movies
Byeonshin	    5.3	One-time-watch-movies
Fanxiao	        7.6	Hit movies
The Belko Exper	6.1	One-time-watch-movies
Safe	        9.5	Superhit movies
Chanakya	    5.4	One-time-watch-movies
Raju Gari Gadhi	8.8	Superhit movies
Shapludu	    7.7	Hit movies
2:22	        5.8	One-time-watch-movies
Rambo: Last Blo 6.7	One-time-watch-movies
Retina	        5.6	One-time-watch-movies
Caller ID	    4.1	flop movies
I See You	    2.6	flop movies
Venom	        6.7	One-time-watch-movies
London Fields	4.3	flop movies
xXx: Return of 	5.2	One-time-watch-movies
Infection: The 	2.3	flop movies
Truth	        7.3	Hit movies
Kidnap	        5.9	One-time-watch-movies
Mute	        5.4	One-time-watch-movies
Halloween	    6.6	One-time-watch-movies
Voice from the 	5.2	One-time-watch-movies
Simple Creature	3.9	flop movies
The Commuter	6.3	One-time-watch-movies
The Foreigner	7.0	Hit movies
Scary Story Slu	2.8	flop movies
Jasmine	        5.7	One-time-watch-movies
The Entitled	6.1	One-time-watch-movies
Message from th	6.4	One-time-watch-movies
59 Seconds	    7.1	Hit movies
Trafficked	    5.6	One-time-watch-movies
Identical	    3.4	flop movies
Art of Deceptio 4.0	flop movies
Mara	        5.1	One-time-watch-movies
Teenage Cocktai 5.8	One-time-watch-movies
Catskill Park	3.7	flop movies
Seberg	        5.4	One-time-watch-movies
An Ordinary Man	5.4	One-time-watch-movies
Operation Ragn	3.8	flop movies
Demonic	        5.3	One-time-watch-movies
Hunter Killer	6.6	One-time-watch-movies
Insomnium	    5.5	One-time-watch-movies
7 Splinters in	3.3	flop movies
Brimstone	    7.1	Hit movies
True Crimes	    5.1	One-time-watch-movies
Overdrive	    5.4	One-time-watch-movies
Amityville: The	4.8	flop movies
American Assass 6.2	One-time-watch-movies
City of Tiny Li	5.5	One-time-watch-movies
Beyond White Sp	4.5	flop movies
Geostorm	    5.3	One-time-watch-movies
Whispers	    4.4	flop movies
Would You Rathe 5.7	One-time-watch-movies
Nobel Chor	    6.7	One-time-watch-movies
The Outsider	6.3	One-time-watch-movies
Redcon-1	    4.2	flop movies
Never Here	    4.2	flop movies
The Unseen	    4.2	flop movies
Sanctuary; Qui	5.4	One-time-watch-movies
Delirium	    5.7	One-time-watch-movies
Sleepless	    5.6	One-time-watch-movies
This Is Your D  5.6	One-time-watch-movies
Black Butterfly	6.1	One-time-watch-movies
The Garlock In	4.6	flop movies
Arizona	        5.7	One-time-watch-movies
Found	        5.8	One-time-watch-movies
Nightmare Box	3.0	flop movies
I Still See You	5.8	One-time-watch-movies
A Life Not to   7.3	Hit movies
A Patch of Fog	6.5	One-time-watch-movies
The Elevator	4.6	flop movies
Bent	        5.4	One-time-watch-movies
The Forgiven	5.9	One-time-watch-movies
Dark Cove	    5.6	One-time-watch-movies
100 Ghost Stree	3.9	flop movies
Gali Guleiyan	7.1	Hit movies
Inspiration	    7.1	Hit movies
Lost Angelas	8.8	Superhit movies
Alien: Covenant	6.4	One-time-watch-movies
Bottom of the 	5.4	One-time-watch-movies
Gas Light	    4.1	flop movies
Five Fingers fo	6.2	One-time-watch-movies
Atomic Blonde	6.7	One-time-watch-movies
The Forbidden 	1.6	flop movies
The Guest House	3.7	flop movies
The Ghost and   4.3	flop movies
Primrose Lane	3.6	flop movies
Deep Burial	    4.1	flop movies
The Church	    2.8	flop movies
The Answer	    4.1	flop movies
Division 19	    5.8	One-time-watch-movies
Point Blank	    5.6	One-time-watch-movies
Needlestick	    3.5	flop movies
Keep Watching	4.3	flop movies
Blowtorch	    4.2	flop movies
Skybound	    5.9	One-time-watch-movies
Krampus: The C  1.6	flop movies
Sweet Virginia	6.2	One-time-watch-movies
Caretakers	    7.5	Hit movies
The Big Take	7.0	Hit movies
Leatherface	    5.0	One-time-watch-movies
The Ascent	    5.7	One-time-watch-movies
Greta	        6.0	One-time-watch-movies
Vishwaroopam 2	5.9	One-time-watch-movies
Displacement	4.5	flop movies
The Harrowing	4.1	flop movies
Angelica	    4.9	flop movies
Dassehra	    3.8	flop movies
Circus of the D	6.0	One-time-watch-movies
Message Man	    6.7	One-time-watch-movies
Ascent to Hell	4.4	flop movies
Mississippi Mu	3.5	flop movies
Strange But Tr	5.7	One-time-watch-movies
Red Sparrow	    6.6	One-time-watch-movies
Higher Power	5.4	One-time-watch-movies
The Snare	    3.5	flop movies
Money	        6.6	One-time-watch-movies
The Circle	    5.3	One-time-watch-movies
Corbin Nash	    5.2	One-time-watch-movies
Wild for the N	4.1	flop movies
Alcoholist	    5.0	One-time-watch-movies
Voyoucratie	    5.8	One-time-watch-movies
Cruel Summer	5.3	One-time-watch-movies
The Man Who Was	5.0	One-time-watch-movies
Two Down	    7.2	Hit movies
Where the Devil 4.7	flop movies
Stockholm	    4.9	flop movies
Beacon Point	5.9	One-time-watch-movies
Delirium	    3.2	flop movies
The Perfect Hos	4.2	flop movies
Convergence	    4.3	flop movies
Capps Crossing	4.3	flop movies
Billy Boy	    4.3	flop movies
The Birdcatcher	4.7	flop movies
5th Passenger	3.1	flop movies
A Violent Separ	5.5	One-time-watch-movies
Be My Cat: A Fi	6.3	One-time-watch-movies
Verónica	    5.8	One-time-watch-movies
Call of the Wo  5.9	One-time-watch-movies
Neckan	        6.0	One-time-watch-movies
Bad Samaritan	6.4	One-time-watch-movies
The Dinner	    4.5	flop movies
Among Us	    4.3	flop movies
Valley of the S	3.6	flop movies
Anabolic Life	6.0	One-time-watch-movies
As Worlds Colli	7.7	Hit movies
Domino	        4.4	flop movies
Benzin	        5.3	One-time-watch-movies
Asylum of Fear	3.4	flop movies
The Autopsy of 	6.8	One-time-watch-movies
Mientras el Lo  7.7	Hit movies
HHhH         	6.4	One-time-watch-movies
Jekyll Island	4.2	flop movies
Den 12. mann	7.4	Hit movies
The Hollow One	3.8	flop movies
Be Afraid	    4.7	flop movies
Accident    	3.3	flop movies
White Orchid	5.1	One-time-watch-movies
Above Ground	4.0	flop movies
Burning Kiss	3.6	flop movies
Slender     	3.1	flop movies
Diverge      	4.5	flop movies
No Way to Live	5.5	One-time-watch-movies
Jigsaw      	5.8	One-time-watch-movies
Bad Kids of Cre	6.2	One-time-watch-movies
Bad Frank	    5.0	One-time-watch-movies
Scary Stories t	6.2	One-time-watch-movies
Xian yi ren X d 6.2	One-time-watch-movies
Puriyaadha Pud	6.6	One-time-watch-movies
Adios Vaya Con	8.4	Superhit movies
Painless	    6.3	One-time-watch-movies
Rabbit	        5.1	One-time-watch-movies
A Place in Hell	3.0	flop movies
One Less God	5.6	One-time-watch-movies
Land of Smiles	4.5	flop movies
Havenhurst    	4.8	flop movies
Grinder     	4.0	flop movies
Land of the Lit	6.5	One-time-watch-movies
Investigation	4.6	flop movies
Deadly Sanctuar	3.7	flop movies
Abduct       	4.8	flop movies
The Drownsman	4.1	flop movies
Damascus Cover	5.1	One-time-watch-movies
Unforgettable	5.1	One-time-watch-movies
Inconceivable	5.2	One-time-watch-movies
Relentless	    4.6	flop movies
Your Move	    3.8	flop movies
Security	    5.7	One-time-watch-movies
Furthest Witnes 4.1	flop movies
Welcome to Curi	5.4	One-time-watch-movies
The Ballerina	4.5	flop movies
The Lighthouse	5.1	One-time-watch-movies
The Tank	    4.0	flop movies
Haunted	        4.6	flop movies
Retribution	    6.0	One-time-watch-movies
Submergence	    5.4	One-time-watch-movies
Arise from Dark	7.6	Hit movies
Stratton	    4.8	flop movies
She Who Must B	4.7	flop movies
The Dark Below	4.2	flop movies
Us and Them	    5.1	One-time-watch-movies
Bad Girl	    5.6	One-time-watch-movies
Bank Chor	    5.9	One-time-watch-movies
The Ghoul	    5.5	One-time-watch-movies
Tell Me Your N	3.9	flop movies
Candiland	    4.3	flop movies
MindGamers	    3.8	flop movies
The Inherited	4.3	flop movies
Glass Jaw	    7.2	Hit movies
Body of Deceit	4.2	flop movies
Creep 2	        6.4	One-time-watch-movies
Madtown	        6.3	One-time-watch-movies
Beyond the Sky	5.8	One-time-watch-movies
Eloise	        4.6	flop movies
The Harvesting	3.7	flop movies
Vincent N Roxxy	5.5	One-time-watch-movies
Face of Evil	2.8	flop movies
Quarries	    4.4	flop movies
The Last Witne  5.5	One-time-watch-movies
Elle	        7.1	Hit movies
The Wicked One	3.6	flop movies
Cuando los ánge	5.4	One-time-watch-movies
I Before Thee	3.5	flop movies
Besetment	    3.5	flop movies
Recall	        2.8	flop movies
Jungle	        6.7	One-time-watch-movies
Blood Money	    4.5	flop movies
Ladyworld	    3.2	flop movies
The Evil Inside	3.5	flop movies
The Equalizer 2	6.7	One-time-watch-movies
Body Keepers	2.8	flop movies
Dead Awake	    4.6	flop movies
The Grinn	    4.1	flop movies
House of Afflic 2.5	flop movies
Clowntergeist	2.9	flop movies
Against the Clo 2.6	flop movies
Hank Boyd Is D	4.6	flop movies
Slasher.com	    3.3	flop movies
Blood Stripe	6.1	One-time-watch-movies
Infinity Chamb  6.2	One-time-watch-movies
Viktorville	    6.8	One-time-watch-movies
Dangerous Compa	4.7	flop movies
Strangers With  4.0	flop movies
Dark Beacon	    6.4	One-time-watch-movies
Seeds	        3.6	flop movies
Hounds of Love	6.5	One-time-watch-movies
Savageland	    5.9	One-time-watch-movies
We Go On	    5.8	One-time-watch-movies
The Neighbor	5.3	One-time-watch-movies
Deadly Crush	6.3	One-time-watch-movies
Hell of a Night	3.3	flop movies
The Nth Ward	3.5	flop movies
Ánimas	        4.7	flop movies
Hebbuli	        7.2	Hit movies
House by the La	3.6	flop movies
Legionario	    6.5	One-time-watch-movies
Level 16	    5.9	One-time-watch-movies
Lost Solace	    4.1	flop movies
The Tale	    7.3	Hit movies
Braxton	        3.6	flop movies
Ah-ga-ssi	    8.1	Superhit movies
The Honor Farm	3.6	flop movies
The Man in the 	5.9	One-time-watch-movies
Lycan	        6.4	One-time-watch-movies
Cut to the Chas 4.7	flop movies
Ultimate Justi  4.2	flop movies
Blood Bound	    4.2	flop movies
I Spit on Your  2.4	flop movies
The Nightingale	7.2	Hit movies
Monochrome	    5.0	One-time-watch-movies
In Extremis	    4.3	flop movies
Dark Sense	    4.3	flop movies
O Rastro	    5.8	One-time-watch-movies
Alterscape	    5.8	One-time-watch-movies
Darling	        5.5	One-time-watch-movies
Demon House	    5.2	One-time-watch-movies
But Deliver Us 	2.7	flop movies
The Tracker	    3.2	flop movies
Replicas	    5.5	One-time-watch-movies
Boar	        5.1	One-time-watch-movies
Live Cargo	    4.6	flop movies
Restraint	    3.9	flop movies
The Redeeming	4.2	flop movies
A Room to Die 	3.4	flop movies
Valley of Bones	4.1	flop movies
The Crucifixion	5.1	One-time-watch-movies
Sleepwalker	    5.1	One-time-watch-movies
Norman: The Mod	6.1	One-time-watch-movies
Del Playa	    3.7	flop movies
Chimera Strain	5.4	One-time-watch-movies
We Are Monsters	3.4	flop movies
Widows	        6.9	One-time-watch-movies
The Wall	    6.2	One-time-watch-movies
Inhumane	    2.9	flop movies
Virus of the D	2.8	flop movies
Wrecker	        3.4	flop movies
Tangent Room	4.6	flop movies
Bloodlands	    5.8	One-time-watch-movies
La nuit a dévo	6.0	One-time-watch-movies
Sum1	        4.0	flop movies
Terrifier	    5.6	One-time-watch-movies
Broken Star	    4.2	flop movies
The Circle	    5.3	One-time-watch-movies
Mirror Game	    6.1	One-time-watch-movies
The Evangelist	6.3	One-time-watch-movies
Sugar Daddies	5.0	One-time-watch-movies
Fractured	    6.3	One-time-watch-movies
Bonded by Bloo	5.8	One-time-watch-movies
My Birthday So	5.5	One-time-watch-movies
3 Lives	        3.2	flop movies
Tau	            5.8	One-time-watch-movies
Blackmark	    4.4	flop movies
The Man in the 	3.3	flop movies
Ghost House	    4.7	flop movies
Hide in the Li	3.7	flop movies
Blood Vow	    6.4	One-time-watch-movies
Detour	        6.2	One-time-watch-movies
Los Angeles Ove	6.2	One-time-watch-movies
Enclosure	    4.1	flop movies
Rock, Paper, Sc	4.2	flop movies
Lies We Tell	4.0	flop movies
7 Witches	    3.5	flop movies
John Wick: Chap	7.5	Hit movies
Innuendo	    5.5	One-time-watch-movies
Aux	            4.2	flop movies
Desolation	    5.8	One-time-watch-movies
The Playground	4.7	flop movies
The Marker	    5.5	One-time-watch-movies
Terminal	    5.3	One-time-watch-movies
Bodysnatch	    3.1	flop movies
Fifty Shades Fr	4.5	flop movies
My Pure Land	6.3	One-time-watch-movies
Cyber Case	    5.0	One-time-watch-movies
Gehenna: Where	5.0	One-time-watch-movies
Maze Runner: Th	6.2	One-time-watch-movies
The Prodigy	    5.9	One-time-watch-movies
The Wasting	    4.1	flop movies
Check Point	    3.2	flop movies
Defective	    3.5	flop movies
Robin Hood	    5.3	One-time-watch-movies
Zhui bu	        5.2	One-time-watch-movies
Miss Sloane	    7.5	Hit movies
Project Eden:   3.2	flop movies
I Kill Giants	6.2	One-time-watch-movies
Altitude	    4.0	flop movies
Armed Response	3.7	flop movies
Mile          	6.1	One-time-watch-movies
The Haunted	    3.6	flop movies
The Book of He	6.6	One-time-watch-movies
Beneath the Le	4.5	flop movies
2036 Origin Unk	4.6	flop movies
Rupture	        4.8	flop movies
The Witch Files	4.4	flop movies
Aftermath	    5.7	One-time-watch-movies
The Body Tree	3.8	flop movies
Darc	        5.8	One-time-watch-movies
Haze	        6.0	One-time-watch-movies
Paralytic	    4.9	flop movies
The Fate of the	6.7	One-time-watch-movies
Bloody Crayons	5.6	One-time-watch-movies
Shot Caller	    7.3	Hit movies
Braid	        5.4	One-time-watch-movies
Night Pulse	    4.9	flop movies
Razbudi menya	5.9	One-time-watch-movies
Drifter	        3.6	flop movies
The Broken Key	2.2	flop movies
Beirut	        6.4	One-time-watch-movies
The Sound	    3.6	flop movies
Wolves at the D	4.5	flop movies
American Fable	6.2	One-time-watch-movies
Woodshock	    4.2	flop movies
Dark Iris	    4.1	flop movies
Lavender	    5.3	One-time-watch-movies
Josie	        5.5	One-time-watch-movies
1 Buck         	6.0	One-time-watch-movies
Discarnate	    4.2	flop movies
In the Tall Gr	5.5	One-time-watch-movies
Parasites	    4.0	flop movies
Shuddhi	        8.1	Superhit movies
Gurgaon	        6.6	One-time-watch-movies
El Complot Mong	5.7	One-time-watch-movies
Mountain Fever	3.5	flop movies
Monolith	    4.7	flop movies
Cold November	4.5	flop movies
Money	        5.5	One-time-watch-movies
Curvature	    5.0	One-time-watch-movies
Killing Ground	5.8	One-time-watch-movies
Fantasma	    4.2	flop movies
The Limehouse G	6.3	One-time-watch-movies
CTRL	        3.0	flop movies
Unfriended: Dar	5.9	One-time-watch-movies
200 Degrees	    4.4	flop movies
The Summoning	3.9	flop movies
Negative	    4.4	flop movies
Fighting the Sk	3.0	flop movies
Central Park	3.7	flop movies
Unhinged	    4.1	flop movies
Larceny	        3.4	flop movies
Countrycide	    2.0	flop movies
Rough Night	    5.2	One-time-watch-movies
Ruin Me	        5.2	One-time-watch-movies
Lens	        7.0	Hit movies
Bang jia zhe	5.1	One-time-watch-movies
Armed	        3.3	flop movies
The Parts Yo	5.3	One-time-watch-movies
Hush Money   	6.0	One-time-watch-movies
Together For E	5.8	One-time-watch-movies
Black Wake	    2.1	flop movies
Good Time	    7.3	Hit movies
Buckout Road	4.0	flop movies
Contratiempo	8.1	Superhit movies
Rapid Eye Movem	4.2	flop movies
The Holly Kane  5.1	One-time-watch-movies
Hollow in the 	5.6	One-time-watch-movies
Mind and Machi  3.0	flop movies
Most Beautiful  5.7	One-time-watch-movies
Out of the Shad	3.5	flop movies
Ridge Runners	3.9	flop movies
Die, My Dear	5.3	One-time-watch-movies
The Spearhead E	4.7	flop movies
Strip Club Mass	6.4	One-time-watch-movies
Death Pool	    3.0	flop movies
Digbhayam	    9.2	Superhit movies
Baadshaho    	4.9	flop movies
Lyst        	3.9	flop movies
Mission: Imposs	7.8	Hit movies
The Curse of La	5.4	One-time-watch-movies
9/11	        4.1	flop movies
Parallel	    6.4	One-time-watch-movies
El guardián in	6.3	One-time-watch-movies
Tomato Red	    5.9	One-time-watch-movies
Las tinieblas	5.7	One-time-watch-movies
The Worthy	    5.2	One-time-watch-movies
Demonios tus o	5.5	One-time-watch-movies
Fixeur	        6.7	One-time-watch-movies
From a House on 5.0	One-time-watch-movies
Awaken the Shad 4.3	flop movies
Rondo	        4.0	flop movies
Axis	        4.0	flop movies
Split	        7.3	Hit movies
Zombies Have F	6.5	One-time-watch-movies
A martfüi rém	7.0	Hit movies
Daas Dev	    5.1	One-time-watch-movies
Unwritten	    3.1	flop movies
They Remain	    4.2	flop movies
Life in the Ho	6.4	One-time-watch-movies
Operation Brot	6.5	One-time-watch-movies
Presumed	    5.0	One-time-watch-movies
Cage	        3.6	flop movies
Breakdown Fores	7.5	Hit movies
Residue	        5.4	One-time-watch-movies
Prodigy	        6.1	One-time-watch-movies
Goodland	    5.1	One-time-watch-movies
Kings Bay	    5.8	One-time-watch-movies
American Gothic	3.7	flop movies
Soul to Keep	4.3	flop movies
Fare	        4.3	flop movies
Trench 11	    5.3	One-time-watch-movies
Incontrol	    4.2	flop movies
The Assignment	4.6	flop movies
Dismissed	    5.7	One-time-watch-movies
Last Seen in I	5.1	One-time-watch-movies
Muse	        5.4	One-time-watch-movies
Desolation	    4.5	flop movies
Nereus	        3.6	flop movies
Get Out	        7.7	Hit movies
The Village in  6.6	One-time-watch-movies
Body of Sin	    4.7	flop movies
Easy Living	    4.8	flop movies
Altered Hours	4.7	flop movies
Transfert	    7.4	Hit movies
The Butler	    7.6	Hit movies
The Isle	    6.1	One-time-watch-movies
Kundschafter de 5.8	One-time-watch-movies
El ataúd de cr  5.3	One-time-watch-movies
Luna	        5.5	One-time-watch-movies
Jasper Jones	6.6	One-time-watch-movies
O lyubvi	    5.1	One-time-watch-movies
M.F.A.	        6.1	One-time-watch-movies
Beneath Us	    5.1	One-time-watch-movies
Ghost Note	    5.8	One-time-watch-movies
Noctem	        4.2	flop movies
Khaneye dokhtar	5.3	One-time-watch-movies
Warning Shot	5.1	One-time-watch-movies
Coyote Lake	    4.8	flop movies
Perfect sãnãtos	4.9	flop movies
Red Christmas	4.3	flop movies
El bar	        6.3	One-time-watch-movies
O Animal Cordia 6.5	One-time-watch-movies
Ira	            5.6	One-time-watch-movies
Lover	        5.7	One-time-watch-movies
Annabelle: Crea	6.5	One-time-watch-movies
12 Feet Deep	5.6	One-time-watch-movies
Liebmann	    5.3	One-time-watch-movies
Illicit	        4.7	flop movies
Shortwave	    4.8	flop movies
Nightworld     	4.4	flop movies
Nibunan	        6.6	One-time-watch-movies
Escape Room	    4.2	flop movies
Mean Dreams	    6.3	One-time-watch-movies
In Darkness	    5.8	One-time-watch-movies
Another Soul	2.0	flop movies
The Chamber	    4.4	flop movies
Inside       	5.1	One-time-watch-movies
Billionaire Boy 5.6	One-time-watch-movies
Forushande	    7.8	Hit movies
Beach House	    6.8	One-time-watch-movies
The Mason Brot	5.6	One-time-watch-movies
Ravenswood	    6.2	One-time-watch-movies
Volt	        5.1	One-time-watch-movies
Juzni vetar	    8.3	Superhit movies
Pray for Rain	5.1	One-time-watch-movies
Rosy	        4.7	flop movies
3 ting	        5.5	One-time-watch-movies
The Rake	    3.5	flop movies
Intensive Care	3.8	flop movies
Despair	        7.8	Hit movies
Assimilate	    5.7	One-time-watch-movies
Final Score	    5.7	One-time-watch-movies
B&B	            5.3	One-time-watch-movies
Enigma	        8.8	Superhit movies
Chappaquiddick	6.5	One-time-watch-movies
The Terrible Tw	2.3	flop movies
Berlin Falling	6.2	One-time-watch-movies
Immigration Gam	3.3	flop movies
Videomannen	    5.7	One-time-watch-movies
Le serpent aux 	6.0	One-time-watch-movies
The Standoff at	6.2	One-time-watch-movies
Happy Death Day	6.5	One-time-watch-movies
Is This Now	    7.8	Hit movies
Close	        5.6	One-time-watch-movies
Singam 3	    6.3	One-time-watch-movies
Hate Story IV	3.3	flop movies
Pirmdzimtais	5.7	One-time-watch-movies
Kaygi	        6.6	One-time-watch-movies
Ryde	        5.9	One-time-watch-movies
The Wolf Hour	4.8	flop movies
The Child Remai	4.9	flop movies
A Young Man wit	5.6	One-time-watch-movies
The Hatton Gard	5.8	One-time-watch-movies
Drone	        5.3	One-time-watch-movies
The Midnight Ma	3.6	flop movies
Magellan	    5.1	One-time-watch-movies
Callback	    6.6	One-time-watch-movies
The Job	        6.0	One-time-watch-movies
The Martyr Make	3.9	flop movies
Gatta Cenerento	6.8	One-time-watch-movies
Tilt	        5.0	One-time-watch-movies
Life	        6.6	One-time-watch-movies
24 Hours to Liv	5.7	One-time-watch-movies
American Satan	5.5	One-time-watch-movies
The Men	        5.5	One-time-watch-movies
Trendy	        5.5	One-time-watch-movies
Zona hostil	    6.3	One-time-watch-movies
Blood Child	    7.8	Hit movies
Break-Up Nightm	4.5	flop movies
Kaabil	        7.1	Hit movies
Corporate	    6.4	One-time-watch-movies
Hotel Mumbai	7.6	Hit movies
Mom and Dad	    5.5	One-time-watch-movies
Kill Switch	    4.8	flop movies
Havana Darkness	3.9	flop movies
Contract to Kil	3.4	flop movies
Dagenham	    3.0	flop movies
Vargur	        6.1	One-time-watch-movies
Shattered	    5.4	One-time-watch-movies
The Samaritans	4.1	flop movies
Apotheosis	    5.3	One-time-watch-movies
Lazarat	        5.3	One-time-watch-movies
Two Pigeons	    5.4	One-time-watch-movies
Dhaka Attack	8.0	Hit movies
Raasta	        3.9	flop movies
Maatr	        4.5	flop movies
The Music Box	5.8	One-time-watch-movies
Maanagaram	    8.1	Superhit movies
The Good Liar	6.5	One-time-watch-movies
Replace	        4.6	flop movies
Lucid	        6.2	One-time-watch-movies
Wetlands	    4.3	flop movies
Mu ji zhe	    7.1	Hit movies
Clinical	    5.1	One-time-watch-movies
The Mad Whale	5.8	One-time-watch-movies
Arsenal	        4.0	flop movies
Harmony	        5.3	One-time-watch-movies
Die Hölle	    6.5	One-time-watch-movies
Extracurricular	6.2	One-time-watch-movies
The Beguiled	6.3	One-time-watch-movies
Driven	        6.2	One-time-watch-movies
Polaroid	    5.1	One-time-watch-movies
Eshtebak	    7.5	Hit movies
Ambition	    3.1	flop movies
Deadman Standi	4.8	flop movies
Cabaret	        3.5	flop movies
Boyne Falls	    6.8	One-time-watch-movies
Spinning Man	5.6	One-time-watch-movies
Webcast	        5.7	One-time-watch-movies
3	            4.2	flop movies
Cardinals	    5.5	One-time-watch-movies
Black Water	    4.6	flop movies
Kaleidoscope	5.7	One-time-watch-movies
Antisocial.app	2.6	flop movies
The Second	    4.8	flop movies
Wraith	        3.4	flop movies
The Ritual	    6.3	One-time-watch-movies
BNB Hell	    5.5	One-time-watch-movies
8 Remains	    4.0	flop movies
Thoroughbreds	6.7	One-time-watch-movies
5 Frauen	    4.7	flop movies
Camera Obscura	4.6	flop movies
Bad Day for the	6.5	One-time-watch-movies
Den enda vägen	5.9	One-time-watch-movies
Barracuda	    5.5	One-time-watch-movies
Fashionista	    5.5	One-time-watch-movies
Cut Shoot Kill	4.4	flop movies
Charmøren	    6.7	One-time-watch-movies
The Recall	    4.5	flop movies
Frazier Park Re 5.1	One-time-watch-movies
Agent	        3.9	flop movies
Breaking Point	2.7	flop movies
Coffin 2	    5.5	One-time-watch-movies
La Misma Sangre	6.0	One-time-watch-movies
The Corrupted	5.7	One-time-watch-movies
Killing Gunther	4.7	flop movies
Mom	            7.3	Hit movies
Slender Man	    3.2	flop movies
ExPatriot	    4.1	flop movies
Darkness Visibl 5.5	One-time-watch-movies
American Crimin	7.6	Hit movies
The Changeover	5.3	One-time-watch-movies
Dark River	    5.8	One-time-watch-movies
Everfall	    3.5	flop movies
Heartthrob   	5.5	One-time-watch-movies
Madre       	5.6	One-time-watch-movies
Carnivore: Were	3.3	flop movies
The Killing of 	7.0	Hit movies
Thumper	        5.8	One-time-watch-movies
Small Crimes	5.8	One-time-watch-movies
Never Hike Alo	6.9	One-time-watch-movies
Aus dem Nichts	7.1	Hit movies
Insidious: The	5.7	One-time-watch-movies
The Stranger In	4.7	flop movies
Salinjaui gieok	7.1	Hit movies
Involution	    3.6	flop movies
The Possession 	5.2	One-time-watch-movies
Sam Was Here	4.8	flop movies
Midnighters	    5.3	One-time-watch-movies
Red Room	    3.3	flop movies
Il permesso - 4 6.0	One-time-watch-movies
Small Town Crim 6.6	One-time-watch-movies
Skyscraper	    5.8	One-time-watch-movies
Kung Fu Travele 5.4	One-time-watch-movies
Freddy/Eddy	    6.4	One-time-watch-movies
Tiyaan	        6.7	One-time-watch-movies
Bad Blood	    4.3	flop movies
Voidfinder	    5.9	One-time-watch-movies
Tera Intezaar	1.7	flop movies
The Institute	4.1	flop movies
The Cutlass	    4.3	flop movies
Running with th	5.4	One-time-watch-movies
Dementia 13	    4.3	flop movies
The Archer	    5.1	One-time-watch-movies
Let Her Out	    4.4	flop movies
Ji qi zhi xue	5.2	One-time-watch-movies
Christmas Crime	4.3	flop movies
The Nun	        5.3	One-time-watch-movies
Close Calls	    5.0	One-time-watch-movies
Tout nous sépar	5.0	One-time-watch-movies
Laissez bronzer	6.2	One-time-watch-movies
What Death Leav	8.3	Superhit movies
Look Away	    6.2	One-time-watch-movies
Devil in the Da	4.7	flop movies
River Runs Red	4.8	flop movies
Dark Meridian	4.7	flop movies
Chai dan zhuan	6.3	One-time-watch-movies
American Violen 4.5	flop movies
Lasso	        4.6	flop movies
The Atoning	    4.1	flop movies
The Poison Rose	4.6	flop movies
The Capture	    5.1	One-time-watch-movies
Silencer	    3.8	flop movies
Created Equal	5.1	One-time-watch-movies
The Student	    4.4	flop movies
Serpent	        4.5	flop movies
22-nenme no kok	6.8	One-time-watch-movies
First Kill	    5.0	One-time-watch-movies
The Super	    6.0	One-time-watch-movies
Ghatel-e ahli	4.4	flop movies
Cain Hill   	3.5	flop movies
Ezra        	6.7	One-time-watch-movies
Project Ghazi	5.8	One-time-watch-movies
Avenge the Cro	5.2	One-time-watch-movies
Dead on Arrival	6.1	One-time-watch-movies
The Nursery  	5.5	One-time-watch-movies
Ana de día   	5.6	One-time-watch-movies
Thondimuthalum 	8.2	Superhit movies
Beyond the Nig	5.2	One-time-watch-movies
Hongo       	6.3	One-time-watch-movies
A Death in the 	7.5	Hit movies
A Crooked Someb	6.2	One-time-watch-movies
Marlina si Pemb	7.0	Hit movies
The Pale Man	4.4	flop movies
Stay	        5.1	One-time-watch-movies
Steel Country	6.1	One-time-watch-movies
BuyBust	        5.8	One-time-watch-movies
We Have Always	5.6	One-time-watch-movies
Commando 2	    5.2	One-time-watch-movies
Tiger Zinda Hai	6.0	One-time-watch-movies
Motorrad	    4.7	flop movies
The Cabin	    3.0	flop movies
Zavod       	7.0	Hit movies
The Angel   	6.6	One-time-watch-movies
Captive State	6.0	One-time-watch-movies
Lost Fare	    4.5	flop movies
The Transcenden	7.8	Hit movies
Bad Match	5.5	One-time-watch-movies
La niebla y la doncella	5.4	One-time-watch-movies
First Light	5.5	One-time-watch-movies
The 13th Friday	3.0	flop movies
Roman J. Israel, Esq.	6.4	One-time-watch-movies
What Lies Ahead	3.4	flop movies
Oru Mexican Aparatha	6.0	One-time-watch-movies
Extracurricular Activities	6.1	One-time-watch-movies
What Still Remains	4.6	flop movies
S.W.A.T.: Under Siege	4.5	flop movies
The Strange Ones	5.0	One-time-watch-movies
Sawoleuiggeut	5.6	One-time-watch-movies
Obsession	4.6	flop movies
All Light Will End	4.3	flop movies
The Wrong Mother	5.5	One-time-watch-movies
Mal Nosso	5.4	One-time-watch-movies
La Cordillera	6.0	One-time-watch-movies
Welcome to Acapulco	4.2	flop movies
Die Vierhändige	6.4	One-time-watch-movies
First Reformed	7.1	Hit movies
The Toybox	3.7	flop movies
Monos	7.5	Hit movies
Acrimony	5.8	One-time-watch-movies
[Cargo]	2.5	flop movies
Bitch	5.0	One-time-watch-movies
The School	3.8	flop movies
Possum	5.5	One-time-watch-movies
Looking Glass	4.5	flop movies
Still/Born	5.4	One-time-watch-movies
Hitsuji no ki	6.4	One-time-watch-movies
M/M	4.9	flop movies
Romina	2.2	flop movies
Mona_Darling	5.2	One-time-watch-movies
Point of no Return	4.0	flop movies
Khoj	6.8	One-time-watch-movies
Radius	6.2	One-time-watch-movies
Isabelle	4.3	flop movies
A Thought of Ecstasy	4.1	flop movies
Kaalakaandi	6.2	One-time-watch-movies
Jackals	5.4	One-time-watch-movies
Ramaleela	7.4	Hit movies
Aadhi	6.7	One-time-watch-movies
The Young Cannibals	3.6	flop movies
The Night Comes for Us	7.0	Hit movies
Jahr des Tigers	5.6	One-time-watch-movies
Paradise Hills	6.1	One-time-watch-movies
Blood Prism	2.6	flop movies
Araña	6.7	One-time-watch-movies
Asher	5.4	One-time-watch-movies
The Line	6.8	One-time-watch-movies
Girl Followed	4.9	flop movies
Downrange	5.4	One-time-watch-movies
Bullitt County	4.9	flop movies
The Black String	5.2	One-time-watch-movies
Skin in the Game	4.3	flop movies
Hex	4.9	flop movies
Distorted	5.3	One-time-watch-movies
John Wick: Chapter 3 - Parabellum	7.6	Hit movies
Vikram Vedha	8.7	Superhit movies
K.O.	5.4	One-time-watch-movies
Best F(r)iends: Volume 1	5.5	One-time-watch-movies
Perdidos	4.8	flop movies
Astro	2.1	flop movies
The Nanny	4.1	flop movies
A Violent Man	5.8	One-time-watch-movies
Angamaly Diaries	8.0	Hit movies
Naam Shabana	6.3	One-time-watch-movies
Paint It Red	4.1	flop movies
Feedback	7.4	Hit movies
Nur Gott kann mich richten	6.7	One-time-watch-movies
St. Agatha	5.1	One-time-watch-movies
Canal Street	3.9	flop movies
Carbone	6.6	One-time-watch-movies
The Executioners	3.8	flop movies
Angel Has Fallen	6.5	One-time-watch-movies
X.	6.5	One-time-watch-movies
Gremlin	3.8	flop movies
Berserk	3.6	flop movies
Zero 3	6.6	One-time-watch-movies
The Kill Team	5.9	One-time-watch-movies
Malicious	5.0	One-time-watch-movies
Bairavaa	5.9	One-time-watch-movies
The Villain	5.8	One-time-watch-movies
Urvi	7.0	Hit movies
Bullet Head	5.4	One-time-watch-movies
The Crossbreed	2.3	flop movies
Trapped	7.5	Hit movies
Funôhan	5.3	One-time-watch-movies
No Date, No Signature	7.2	Hit movies
Loverboy	5.8	One-time-watch-movies
10x10	5.0	One-time-watch-movies
Öteki Taraf	6.2	One-time-watch-movies
The Journey	6.1	One-time-watch-movies
The Russian Bride	6.0	One-time-watch-movies
Allure	4.9	flop movies
Cereyan	4.5	flop movies
Calibre	6.7	One-time-watch-movies
Pledge	5.4	One-time-watch-movies
Occidental	5.4	One-time-watch-movies
Halt: The Motion Picture	3.7	flop movies
Ride	5.5	One-time-watch-movies
Accident Man	6.2	One-time-watch-movies
Shelter	5.4	One-time-watch-movies
Followers	3.7	flop movies
Sarvann	5.9	One-time-watch-movies
#Selfi	5.1	One-time-watch-movies
Candy Corn	3.8	flop movies
Konvert	5.5	One-time-watch-movies
In This Gray Place	6.9	One-time-watch-movies
Door in the Woods	3.4	flop movies
Abstruse	9.0	Superhit movies
Vodka Diaries	5.6	One-time-watch-movies
Raju Gari Gadhi 2	5.3	One-time-watch-movies
Love Me Not	6.1	One-time-watch-movies
Kolaiyuthir Kaalam	2.7	flop movies
Knuckleball	5.7	One-time-watch-movies
Acts of Vengeance	5.7	One-time-watch-movies
Mon garçon	5.8	One-time-watch-movies
Witch-Hunt	5.5	One-time-watch-movies
Hong yi xiao nu hai 2	5.5	One-time-watch-movies
The Ghazi Attack	7.6	Hit movies
Broken Ghost	5.0	One-time-watch-movies
Matriarch	5.7	One-time-watch-movies
Perfect Skin	5.1	One-time-watch-movies
Yeo-gyo-sa	5.9	One-time-watch-movies
Game of Death	5.9	One-time-watch-movies
Take Off	8.3	Superhit movies
Empathy, Inc.	4.3	flop movies
Deadly Expose	3.3	flop movies
Bogan	6.4	One-time-watch-movies
Inuyashiki	6.7	One-time-watch-movies
Burn Out	6.1	One-time-watch-movies
Keshava	6.4	One-time-watch-movies
Where the Skin Lies	4.0	flop movies
Adhe Kangal	7.3	Hit movies
Sniper: Ultimate Kill	5.6	One-time-watch-movies
The Guardian Angel	5.3	One-time-watch-movies
Last Ferry	7.2	Hit movies
Edge of Isolation	3.4	flop movies
Una especie de familia	6.3	One-time-watch-movies
Aake	6.0	One-time-watch-movies
Spell	6.2	One-time-watch-movies
Naa Panta Kano	4.3	flop movies
Simran	5.3	One-time-watch-movies
Beautiful Manasugalu	7.8	Hit movies
The Doll 2	5.3	One-time-watch-movies
Anonymous 616	5.3	One-time-watch-movies
V.I.P.	6.3	One-time-watch-movies
Ten	4.6	flop movies
Fast Color	5.8	One-time-watch-movies
Konwój	5.9	One-time-watch-movies
Puthan Panam	6.0	One-time-watch-movies
Patser	6.7	One-time-watch-movies
Brothers in Arms	5.5	One-time-watch-movies
Las grietas de Jara	5.7	One-time-watch-movies
The Coldest Game	6.2	One-time-watch-movies
The Hurt	3.2	flop movies
End Trip	7.3	Hit movies
Housewife	4.8	flop movies
Irada	6.2	One-time-watch-movies
Tempus Tormentum	3.8	flop movies
Polícia Federal: A Lei é para Todos	6.8	One-time-watch-movies
Serenity	5.3	One-time-watch-movies
Mersal	7.7	Hit movies
Gol-deun seul-leom-beo	5.8	One-time-watch-movies
Kääntöpiste	6.1	One-time-watch-movies
Project Ithaca	3.9	flop movies
Siberia	4.3	flop movies
Rideshare	5.2	One-time-watch-movies
Armomurhaaja	6.8	One-time-watch-movies
Mata Batin	5.1	One-time-watch-movies
Tiere	6.7	One-time-watch-movies
Haseena Parkar	4.2	flop movies
Baazaar	6.6	One-time-watch-movies
Piercing	5.6	One-time-watch-movies
Spyder	6.7	One-time-watch-movies
El otro hermano	6.5	One-time-watch-movies
Jagveld	5.9	One-time-watch-movies
Skjelvet	6.2	One-time-watch-movies
The Wicked Gift	5.6	One-time-watch-movies
Frères ennemis	6.3	One-time-watch-movies
Nomis	5.8	One-time-watch-movies
Haunt	6.3	One-time-watch-movies
#SquadGoals	4.0	flop movies
Reprisal	4.2	flop movies
Life Like	5.4	One-time-watch-movies
Siew Lup	6.8	One-time-watch-movies
Monster Party	5.4	One-time-watch-movies
American Pets	4.5	flop movies
Sweetheart	5.5	One-time-watch-movies
Cutterhead	6.1	One-time-watch-movies
Yaman	6.3	One-time-watch-movies
Death Game	6.6	One-time-watch-movies
Tamaroz	6.6	One-time-watch-movies
Night Bus	7.2	Hit movies
The Fast and the Fierce	2.3	flop movies
Adam Joan	6.5	One-time-watch-movies
Sathya	2.6	flop movies
Strategy and Pursuit	7.4	Hit movies
Hesperia	4.1	flop movies
Drive	2.3	flop movies
Kuttram 23	7.3	Hit movies
Mai mee Samui samrab ter	6.1	One-time-watch-movies
Haebing	6.4	One-time-watch-movies
Rust Creek	5.8	One-time-watch-movies
Solo	7.1	Hit movies
Manu	8.0	Hit movies
Villain	6.4	One-time-watch-movies
Lakshyam	5.6	One-time-watch-movies
Indu Sarkar	6.0	One-time-watch-movies
The House of Violent Desire	3.2	flop movies
A Good Woman Is Hard to Find	6.1	One-time-watch-movies
The Wrong Nanny	4.8	flop movies
Triple Threat	5.5	One-time-watch-movies
Yuddham Sharanam	6.0	One-time-watch-movies
Maracaibo	6.3	One-time-watch-movies
Carbon	6.9	One-time-watch-movies
Fantasten	6.2	One-time-watch-movies
Every Time I Die	4.7	flop movies
Nabab	7.7	Hit movies
Amok	5.8	One-time-watch-movies
Two Graves	4.2	flop movies
Incoming	3.2	flop movies
Off the Rails	4.9	flop movies
Street Lights	6.6	One-time-watch-movies
Rapurasu no majo	5.3	One-time-watch-movies
Steig. Nicht. Aus!	5.6	One-time-watch-movies
Ittefaq	7.2	Hit movies
The Riot Act	4.4	flop movies
Babumoshai Bandookbaaz	6.9	One-time-watch-movies
Kavan	7.1	Hit movies
Dead Water	3.2	flop movies
Playing with Dolls: Havoc	3.8	flop movies
Bhaagamathie	7.0	Hit movies
Oxygen	5.5	One-time-watch-movies
Revenge	6.3	One-time-watch-movies
Numéro une	6.0	One-time-watch-movies
Den skyldige	7.5	Hit movies
8 Thottakkal	7.6	Hit movies
Room for Rent	5.8	One-time-watch-movies
Saab Bahadar	7.2	Hit movies
High Heel Homicide	3.6	flop movies
Dogman	7.3	Hit movies
American Dreamer	5.6	One-time-watch-movies
Escape Plan: The Extractors	4.4	flop movies
Truth or Dare	5.1	One-time-watch-movies
Diwanji Moola Grand Prix	4.8	flop movies
Aiyaary	5.2	One-time-watch-movies
Aala Kaf Ifrit	7.0	Hit movies
Totem	4.5	flop movies
+-------------------------------------------------------+*/

-- Type your code below:
SELECT title,avg_rating,
       CASE WHEN avg_rating>8 THEN 'Superhit movies'
            WHEN avg_rating BETWEEN 7 and 8 THEN 'Hit movies'
            WHEN avg_rating BETWEEN 5 and 7 THEN 'One-time-watch-movies'
            ELSE 'flop movies'
            END AS rating_category
FROM movie as m
INNER JOIN genre as g
ON g.movie_id = m.id
INNER JOIN ratings as r
ON r.movie_id = g.movie_id
WHERE genre = 'thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|Action		    |		112.88	    |	       112.88	  |	   112.880	    	 |
|Adventure		|		101.87		|	       214.75	  |	   107.375	   		 |
|Comedy		    |	    102.62		|	       317.37	  |	   105.790	   		 |
|Crime		    |	    107.05		|	       424.42	  |	   106.105	   		 |
|Drama  		|		106.77		|	       531.19	  |	   106.238	   		 |
|Family	    	|		100.97		|	       632.16	  |	   105.360	   		 |
|Fantasy		|		105.14		|	       737.30 	  |	   105.328	    	 |
|Horror		    |		 92.72		|	       830.02	  |	   103.752	    	 |
|Mystery		|		101.80		|	       931.82	  |	   103.535	    	 |
|Others		    |		100.16		|	      1031.98 	  |	   103.198	    	 |
|Romance		|		109.53		|	      1141.51 	  |	   103.773	    	 |
|Sci-Fi			|		 97.94		|	      1239.45 	  |	   102.415	    	 |
|Thriller		|		101.58		|	      1341.03  	  |	   102.389  	   	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre, 
       ROUND(AVG(duration),2) AS avg_duration,
       SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
       AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM genre as g
INNER JOIN movie as m
ON m.id = g.movie_id
GROUP BY genre
ORDER BY genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
Thriller	2017	The Fate of the Furious	1236005118	1
Comedy	2017	Despicable Me 3	1034799409	2
Comedy	2017	Jumanji: Welcome to the Jungle	962102237	3
Drama	2017	Zhan lang II	870325439	4
Thriller	2017	Zhan lang II	870325439	5
Drama	2018	Bohemian Rhapsody	903655259	1
Thriller	2018	Venom	856085151	2
Thriller	2018	Mission: Impossible - Fallout	791115104	3
Comedy	2018	Deadpool 2	785046920	4
Comedy	2018	Ant-Man and the Wasp	622674139	5
Drama	2019	Avengers: Endgame	2797800564	1
Drama	2019	The Lion King	1655156910	2
Comedy	2019	Toy Story 4	1073168585	3
Drama	2019	Joker	995064593	4
Thriller	2019	Joker	995064593	5
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH TOP_3_GENRE
AS
  (
           SELECT   GENRE
           FROM     GENRE
           GROUP BY GENRE
           ORDER BY COUNT(GENRE) DESC
           LIMIT    3 ),
  TOP_MOVIES
AS
  (
             SELECT     genre,
                        year,
                        TITLE                                                                                                                     AS movie_name,
                        CAST(REPLACE(IFNULL(WORLWIDE_GROSS_INCOME,0),'$ ','') AS DECIMAL(10))                                                     AS worldwide_gross_income_$,
                        ROW_NUMBER() OVER (PARTITION BY YEAR ORDER BY CAST(REPLACE(IFNULL(WORLWIDE_GROSS_INCOME,0),'$ ','') AS DECIMAL(10)) DESC) AS movie_rank
             FROM       MOVIE M
             INNER JOIN GENRE G
             ON         M.ID = G.MOVIE_ID
             WHERE      GENRE IN
                        (
                               SELECT *
                               FROM   TOP_3_GENRE) )
  SELECT *
  FROM   TOP_MOVIES
  WHERE  MOVIE_RANK<=5;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+----------------------+--------------------+----------------------+
|production_company    |   movie_count	    |		prod_comp_rank |
+-------------------+-----------------------+----------------------+
|Star Cinema		   |		7			|		    1	       |
|Twentieth Century Fox |		4			|			2		   |
+----------------------+--------------------+----------------------+*/
-- Type your code below:
WITH production_company_summary
     AS (SELECT production_company, Count(*) AS movie_count
         FROM   movie AS m
		 inner join ratings AS r
		 ON r.movie_id = m.id
         WHERE  median_rating >= 8
		 AND production_company IS NOT NULL
		 AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
       Rank()over(ORDER BY movie_count DESC) AS prod_comp_rank
FROM   production_company_summary
LIMIT 2; 


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+-----------------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	        |	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+-----------------------+-------------------+---------------------+----------------------+-----------------+
|Parvathy Thiruvothu	|       4974	    |	       2		  |	   8.25		         |		1	       |
|Susan Brown		    |        656		|	       2		  |	   8.94	    		 |		1	       |
|Amanda Lawrence		|        656		|	       2		  |	   8.94	    		 |		1	       |
+-----------------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
WITH actress_summary AS
(SELECT n.NAME AS actress_name,
		SUM(total_votes) AS total_votes,
		Count(r.movie_id) AS movie_count,
		Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM movie AS m
           INNER JOIN ratings AS r
           ON m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON m.id = rm.movie_id
           INNER JOIN names AS n
           ON rm.name_id = n.id
           INNER JOIN GENRE AS g
           ON g.movie_id = m.id
           WHERE category = 'ACTRESS'
           AND avg_rating>8
           AND genre = "Drama"
           GROUP BY   NAME )
SELECT   *,Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
           FROM actress_summary LIMIT 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm2096009		|Andrew Jones		|			5		  |	       190.75		 |	   3.02	    |	1989	   |	2.7		|	3.2		 |		432		  |
|nm1777967		|A.L. Vijay			|			5		  |	       176.75		 |	   5.42	    |	1754	   |	3.7		|	6.9		 |		613		  |
|nm0814469		|Sion Sono   		|			4		  |	       331.00		 |	   6.03	    |	2972	   |	5.4		|	6.4		 |		502		  |
|nm0831321		|Chris Stokes		|			4		  |	       198.33		 |	   4.33	    |	3664	   |	4.0		|	4.6		 |		352		  |
|nm0515005		|Sam Liu			|			4		  |	       260.33		 |	   6.23	    |	28557	   |	5.8		|	6.7		 |		312		  |
|nm0001752		|Steven Soderbergh	|			4		  |	       254.33		 |	   6.48	    |	171684	   |	6.2		|	7.0		 |		401		  |
|nm0425364		|Jesse V. Johnson	|			4		  |	       299.00		 |	   5.45	    |	14778	   |	4.2		|	6.5		 |		383		  |
|nm2691863		|Justin Price		|			4		  |	       315.00		 |	   4.50	    |	5343	   |	3.0		|	5.8		 |		346		  |
|nm6356309		|Özgür Bakar		|			4		  |	       112.00		 |	   3.75	    |	1092	   |	3.1		|	4.9		 |		374		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)               AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;






