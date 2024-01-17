-- Overall percentage of correct
SELECT SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CountCorrect,
	ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*),2) AS PercentCorrect
FROM jeopardy_data;

-- Overall percentage of correct by Round
SELECT Round,
	COUNT(*) AS Total,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CountCorrect,
	ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*),2) AS PercentCorrect
FROM jeopardy_data
GROUP BY Round;

-- Count of questions by Metacategory
SELECT Metacategory, 
	COUNT(*) AS QuestionCount
FROM jeopardy_data
GROUP BY Metacategory
ORDER BY QuestionCount DESC;

-- Confidence & Win Rate by Metacategory
SELECT Metacategory,
	COUNT(*) AS QuestionCount,
	ROUND(100.0 * SUM(CASE WHEN Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(*), 2) AS PercentAttempt,
	ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS PercentCorrect,
	ROUND(100*(ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) / ROUND(100.0 * SUM(CASE WHEN Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(*), 2)),2) AS PercentCorrectofAttempted
FROM jeopardy_data
GROUP BY Metacategory
HAVING (ROUND(100.0 * SUM(CASE WHEN Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(*), 2)) != 0
ORDER BY QuestionCount DESC, PercentCorrectofAttempted, PercentAttempt, PercentCorrect DESC;

-- Average Coryat
SELECT ROUND(AVG(MyCoryat),0)
FROM jeopardy_coryats;

-- Performance in DDs
SELECT COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data
WHERE DD = 'True';

-- Performance in DDs by Metacategory
SELECT Metacategory, COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data
WHERE DD = 'True'
GROUP BY Metacategory
ORDER BY total DESC, percentage DESC;

-- Performance in FJ
SELECT COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data
WHERE Round = 'Final Jeopardy!';

-- Performance in FJ by Metacategory
SELECT Metacategory, COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data
WHERE Round = 'Final Jeopardy!'
GROUP BY Metacategory
ORDER BY total DESC, percentage DESC;

-- Comparisons by game type
SELECT b.GameType, 
AVG(b.MyCoryat) AS AverageCoryat
FROM jeopardy_data a
JOIN jeopardy_coryats b 
ON a.Game = b.Game
GROUP BY b.GameType;

-- Correlation Between My Coryat Score and Performance
SELECT a.Game, 
       b.MyCoryat,
       SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers
FROM jeopardy_data a
JOIN jeopardy_coryats b ON a.Game = b.Game
GROUP BY a.Game, b.MyCoryat
ORDER BY CorrectAnswers DESC;

-- My Coryat vs combined coryat
SELECT Game,
	MyCoryat,
	CombinedCoryat
FROM jeopardy_coryats

-- Correlation Between Contestant Coryat Score, FJ answer and Win
SELECT Game,
	CASE WHEN Contestant1Win = 'True' THEN Contestant1Coryat
	WHEN Contestant2Win = 'True' THEN Contestant2Coryat
	WHEN Contestant3Win = 'True' THEN Contestant3Coryat END AS WinningCoryat,
	CASE WHEN Contestant1Win = 'True' THEN Contestant1FJ
	WHEN Contestant2Win = 'True' THEN Contestant2FJ
	WHEN Contestant3Win = 'True' THEN Contestant3FJ END AS WinnerFJ
FROM jeopardy_coryats
;

-- How much am I leaving on the table in History per game?
WITH historyinc AS (
SELECT Game,
	SUM(2*Value) AS incvalue
FROM jeopardy_data
WHERE Metacategory = 'History' AND Response = 'Incorrect'
GROUP BY Game),
historydnr AS (
SELECT Game,
	SUM(Value) AS dnrvalue
FROM jeopardy_data
WHERE Metacategory = 'History' AND Response = 'Did Not Ring In'
GROUP BY Game),
historylost AS (
SELECT a.Game,
	SUM(a.incvalue + b.dnrvalue) AS PotentialLostEarnings
FROM historyinc a
JOIN historydnr b
ON a.Game = b.Game
GROUP BY a.Game)
SELECT ROUND(AVG(PotentialLostEarnings),0)
FROM historylost;

-- How much am I leaving on the table in Geography per game?
WITH geographyinc AS (
SELECT Game,
	SUM(2*Value) AS incvalue
FROM jeopardy_data
WHERE Metacategory = 'Geography' AND Response = 'Incorrect'
GROUP BY Game),
geographydnr AS (
SELECT Game,
	SUM(Value) AS dnrvalue
FROM jeopardy_data
WHERE Metacategory = 'Geography' AND Response = 'Did Not Ring In'
GROUP BY Game),
geographylost AS (
SELECT a.Game,
	SUM(a.incvalue + b.dnrvalue) AS PotentialLostEarnings
FROM geographyinc a
JOIN geographydnr b
ON a.Game = b.Game
GROUP BY a.Game)
SELECT ROUND(AVG(PotentialLostEarnings),0)
FROM geographylost;

-- How much am I leaving on the table in Words per game?
WITH wordsinc AS (
SELECT Game,
	SUM(2*Value) AS incvalue
FROM jeopardy_data
WHERE Metacategory = 'Words' AND Response = 'Incorrect'
GROUP BY Game),
wordsdnr AS (
SELECT Game,
	SUM(Value) AS dnrvalue
FROM jeopardy_data
WHERE Metacategory = 'Words' AND Response = 'Did Not Ring In'
GROUP BY Game),
wordslost AS (
SELECT a.Game,
	SUM(a.incvalue + b.dnrvalue) AS PotentialLostEarnings
FROM wordsinc a
JOIN wordsdnr b
ON a.Game = b.Game
GROUP BY a.Game)
SELECT ROUND(AVG(PotentialLostEarnings),0)
FROM wordslost;


