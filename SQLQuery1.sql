USE OnlineChessGames;

SELECT opening_shortname, COUNT(opening_shortname)
FROM OnlineChessGames..ChessGames
WHERE winner = 'White'
GROUP BY opening_shortname
ORDER BY 2 DESC;


SELECT *
FROM OnlineChessGames.dbo.ChessGames
WHERE winner = 'White'
AND white_rating < black_rating


------------------------------------------------------------------------
-- Question 1 Solution

-- Percentage of games won by white
SELECT (SELECT COUNT(DISTINCT(game_id))
FROM OnlineChessGames.dbo.ChessGames
WHERE winner='White') * 100.0/COUNT(DISTINCT(game_id)) AS WhiteWinPercentage
FROM OnlineChessGames.dbo.ChessGames

-- Percentage of games ended in draw
SELECT (SELECT COUNT(DISTINCT(game_id))
FROM OnlineChessGames.dbo.ChessGames
WHERE winner = 'Draw') * 100.0 / COUNT(DISTINCT(game_id)) AS DrawPercentage
FROM OnlineChessGames..ChessGames


------------------------------------------------------------------------
-- Question 2 Solution

-- Most frequently used opening(fullname) in which White/Black won
SELECT TOP(1) opening_fullname,
COUNT(opening_fullname)
FROM OnlineChessGames.dbo.ChessGames
WHERE winner = 'White' -- 'Black'
GROUP BY opening_fullname
ORDER BY 2 DESC;

-- Most frequently used opening(shortname) in which Black/White won
SELECT TOP(10) opening_shortname,
COUNT(opening_shortname) AS CountOfOpening
FROM OnlineChessGames..ChessGames
WHERE winner = 'White' -- 'White'
GROUP BY opening_shortname
ORDER BY 2 DESC;


------------------------------------------------------------------------
-- Question 3 Solution

-- Percentage of games won by player with the higher rating
SELECT
(SELECT COUNT(*) AS HigherRatingWin
FROM (
SELECT *
FROM OnlineChessGames..ChessGames
WHERE (white_rating > black_rating
AND winner = 'White') OR
(white_rating < black_rating
AND winner = 'Black')) AS HigherRatingWin) * 100.0 / COUNT(*) AS HigherRatingWinPercentage
FROM OnlineChessGames..ChessGames

--  Percentage of games won by player with the higher rating with Black piece
SELECT
(SELECT COUNT(*) AS HigherRatingWin
FROM (
SELECT *
FROM OnlineChessGames..ChessGames
WHERE (white_rating < black_rating
AND winner = 'Black')) AS HigherRatingWin) * 100.0 / COUNT(*) AS HigherRatingWinPercentage
FROM OnlineChessGames..ChessGames

-- Percentage of games won by player with the higher rating with White piece
SELECT
(SELECT COUNT(*) AS HigherRatingWin
FROM (
SELECT *
FROM OnlineChessGames..ChessGames
WHERE (white_rating > black_rating
AND winner = 'White')) AS HigherRatingWin) * 100.0 / COUNT(*) AS HigherRatingWinPercentage
FROM OnlineChessGames..ChessGames

---------------------------------------------------------------------------------------
/*
Question 4 : Which user won the most amount of games? In what percentage of 
			 those games was the user the higher rated player?
*/

SELECT TOP(1) white_id AS PlayerID, SUM(WinCountWithWhite) AS TotalWinCount
FROM 
(SELECT white_id, COUNT(white_id) AS WinCountWithWhite
FROM OnlineChessGames.dbo.ChessGames
WHERE winner = 'White'
GROUP BY white_id
UNION ALL
SELECT black_id, COUNT(black_id) AS WinCountWithBlack
FROM OnlineChessGames.dbo.ChessGames
WHERE winner = 'Black'
GROUP BY black_id) AS TotalPlayers
GROUP BY white_id
ORDER BY TotalWinCount DESC

SELECT TOP(1) tbl.white_id, 
			  TotalWinCount, 
			  TotalWinCountWithHigherRating * 100.0 / TotalWinCount AS PercentageOfWinWithHigherRating 
FROM
	(SELECT white_id, SUM(WinCountWithWhite) AS TotalWinCountWithHigherRating
	FROM 
	(SELECT white_id, COUNT(white_id) AS WinCountWithWhite
	FROM OnlineChessGames.dbo.ChessGames
	WHERE winner = 'White' 
	AND white_rating > black_rating
	GROUP BY white_id
	UNION ALL
	SELECT black_id, COUNT(black_id) AS WinCountWithBlack
	FROM OnlineChessGames.dbo.ChessGames
	WHERE winner = 'Black'
	AND black_rating > white_rating
	GROUP BY black_id) AS TotalPlayers
	GROUP BY white_id) AS TotalWinCountWithHigherRatingTable
JOIN	
	(SELECT  white_id, SUM(WinCountWithWhite) AS TotalWinCount
FROM 
(SELECT white_id, COUNT(white_id) AS WinCountWithWhite
FROM OnlineChessGames.dbo.ChessGames
WHERE winner = 'White'
GROUP BY white_id
UNION ALL
SELECT black_id, COUNT(black_id) AS WinCountWithBlack
FROM OnlineChessGames.dbo.ChessGames
WHERE winner = 'Black'
GROUP BY black_id) AS TotalPlayers
GROUP BY white_id) AS tbl
	ON TotalWinCountWithHigherRatingTable.white_id = tbl.white_id
ORDER BY TotalWinCount DESC





--SELECT COUNT(*)
--FROM OnlineChessGames.dbo.ChessGames
--WHERE white_id = 'taranga' 
--AND winner = 'White'


