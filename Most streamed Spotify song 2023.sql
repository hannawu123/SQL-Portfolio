

SELECT * FROM spotify.`spotify-2023`;

--  1. What is the average number of streams across all songs?
SELECT avg(streams) as avg_streams
FROM spotify.`spotify-2023`;

-- 2. What is the average danceability of the top 12 most streamed songs?
SELECT avg(`danceability_%`) as avg_danceability
FROM spotify.`spotify-2023`
order by streams desc
limit 12;

-- 3. What are the top 10 most-streamed songs
SELECT streams, `released_year`, track_name
FROM spotify.`spotify-2023`
ORDER BY streams desc
limit 10;

-- 4. How many songs were released in each year
SELECT released_year, COUNT(*) AS song_count
FROM spotify.`spotify-2023`
group by released_year
ORDER BY released_year desc;

-- 5. Who are the top 10 artists with the highest average streaming statistics
SELECT `artist(s)_name`, AVG(streams) AS avg_streaming
FROM spotify.`spotify-2023`
GROUP BY `artist(s)_name`
ORDER BY avg_streaming DESC
limit 10;

-- 6. What is the average stream count per month across all songs in the dataset?
SELECT CONCAT(released_year, '-' , released_month) AS release_month, AVG(streams) AS avg_streaming
FROM spotify.`spotify-2023`
GROUP BY release_month
ORDER BY release_month;

-- 7. Which songs appear in Spotify charts, and what is their average ranking?
-- returns a list of songs that appear in spotify charts
/*SELECT track_name, `artist(s)_name`, in_spotify_charts AS chart_rank
FROM spotify.`spotify-2023`
WHERE in_spotify_charts <> 0
ORDER BY in_spotify_charts; */

SELECT AVG(chart_rank) AS average_ranking
FROM ( 
SELECT track_name, `artist(s)_name`, in_spotify_charts AS chart_rank
FROM spotify.`spotify-2023`
WHERE in_spotify_charts <> 0
ORDER BY in_spotify_charts
) AS chart_songs;

-- 8. How many songs are ranked on Apple Music, spotify, Deezer, and Shazam charts, respectively?

SELECT
    'Apple Music' AS platform_type,
    COUNT(*) AS Number_of_Songs_ranked
FROM spotify.`spotify-2023`
WHERE
    in_apple_charts <> 0

UNION ALL

SELECT
    'Spotify' AS platform_type,
    COUNT(*) AS Number_of_Songs_ranked
FROM spotify.`spotify-2023`
WHERE
    in_spotify_charts <> 0

union all 

SELECT
    'Deezer' AS platform_type,
    COUNT(*) AS Number_of_Songs_ranked
FROM spotify.`spotify-2023`
WHERE
    in_deezer_charts <> 0

UNION ALL

SELECT
    'Shazam' AS platform_type,
    COUNT(*) AS Number_of_Songs_ranked
FROM spotify.`spotify-2023`
WHERE
    in_shazam_charts <> 0;
    
    
    -- 9. How have the average danceability and energy % of the most popular songs on Spotify changed over the past decade, and are there any significant shifts in music preferences?
   
   -- dataset filtered to include only songs from past decade. 
    /*SELECT track_name, released_year, `danceability_%`, `energy_%`
    FROM spotify.`spotify-2023`
    WHERE released_year >= 2013; */ 
    
SELECT released_year,
    avg(`danceability_%`) AS avg_danceability,
    avg(`energy_%`) AS avg_energy
FROM (
	SELECT track_name, released_year, `danceability_%`, `energy_%`
    FROM spotify.`spotify-2023`
    WHERE released_year >= 2013
    )  AS past_decade
GROUP BY released_year
ORDER BY released_year;
    
    
    -- 10. Which songs are consistently popular across Spotify, Apple Music, and Shazam, and what insights can be drawn from their cross-platform presence?
/*LECT
    track_name,
    `artist(s)_name`
FROM spotify.`spotify-2023`
WHERE
    in_spotify_charts = 1 ;
    
SELECT
    track_name,
    `artist(s)_name`
FROM spotify.`spotify-2023`
WHERE
    in_apple_charts = 1 ;
    
SELECT
	track_name,
	`artist(s)_name`
FROM spotify.`spotify-2023`
WHERE
    in_shazam_charts = 1; */
    
SELECT
    track_name,
    `artist(s)_name`,
    'Spotify' AS platform
FROM
    spotify.`spotify-2023`
WHERE
    in_spotify_charts = 1
UNION ALL
SELECT
    track_name,
    `artist(s)_name`,
    'Apple Music' AS platform
FROM
    spotify.`spotify-2023`
WHERE
    in_apple_charts = 1
UNION ALL
SELECT
    track_name,
    `artist(s)_name`,
    'Shazam' AS platform
FROM
    spotify.`spotify-2023`
WHERE
    in_shazam_charts = 1;

