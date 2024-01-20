-- Overall percentage of correct
SELECT SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CountCorrect,
	ROUND(100 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*),2) AS PercentCorrect
FROM jeopardy_data;

-- Average Responses Overall
WITH AnswerBreakdown AS
(SELECT Game,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount
FROM jeopardy_data
GROUP BY Game
ORDER BY Game)
SELECT ROUND(AVG(CorrectCount),0) AS AverageCorrect,
	ROUND(AVG(IncorrectCount),0) AS AverageIncorrect,
	ROUND(AVG(DNRCount),0) AS AverageDNR
FROM AnswerBreakdown;

-- Overall percentage of correct by Round
SELECT Round,
	COUNT(*) AS Total,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CountCorrect,
	ROUND(100 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*),2) AS PercentCorrect
FROM jeopardy_data
GROUP BY Round;

-- Average Responses By Round
WITH AnswerBreakdown AS
(SELECT Game, Round,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount
FROM jeopardy_data
WHERE Round != 'Final Jeopardy!'
GROUP BY Game, Round
ORDER BY Game)
SELECT Round,
	ROUND(AVG(CorrectCount),0) AS AverageCorrect,
	ROUND(AVG(IncorrectCount),0) AS AverageIncorrect,
	ROUND(AVG(DNRCount),0) AS AverageDNR
FROM AnswerBreakdown
GROUP BY Round
ORDER BY Round DESC;

-- Count of questions by Metacategory
SELECT Metacategory, 
	COUNT(*) AS QuestionCount
FROM jeopardy_data
GROUP BY Metacategory
ORDER BY QuestionCount DESC;

-- Confidence & Win Rate by Metacategory
SELECT Metacategory,
	COUNT(*) AS QuestionCount,
	ROUND(100 * SUM(CASE WHEN Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(*), 2) AS PercentAttempt,
	ROUND(100 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS TotalPercentCorrect,
	ROUND(100*(ROUND(100 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) / ROUND(100 * SUM(CASE WHEN Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(*), 2)),2) AS PercentCorrectofAttempted
FROM jeopardy_data
GROUP BY Metacategory
HAVING (ROUND(100 * SUM(CASE WHEN Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(*), 2)) != 0
ORDER BY QuestionCount DESC, PercentAttempt, TotalPercentCorrect DESC;

-- Coryat Average and Ranges
SELECT ROUND(AVG(MyCoryat),0) AS AverageCoryat,
	MIN(MyCoryat) AS MinCoryat,
	MAX(MyCoryat) AS MaxCoryat
FROM jeopardy_coryats;

-- Performance in DDs
SELECT COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data
WHERE DD = 'True';

-- Performance in DDs by Metacategory
SELECT Metacategory, COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data
WHERE DD = 'True'
GROUP BY Metacategory
ORDER BY total DESC, percentage;

-- Performance in FJ
SELECT COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data
WHERE Round = 'Final Jeopardy!';

-- Performance in FJ by Metacategory
SELECT Metacategory, COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data
WHERE Round = 'Final Jeopardy!'
GROUP BY Metacategory
ORDER BY total DESC, percentage;

-- Correlation Between My Coryat Score and Performance
SELECT a.Game, 
       b.MyCoryat,
       SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers
FROM jeopardy_data a
JOIN jeopardy_coryats b ON a.Game = b.Game
GROUP BY a.Game, b.MyCoryat
ORDER BY CorrectAnswers DESC;

---Metacategory breakdown by game
SELECT Game,
	Metacategory,
	COUNT(Response) AS TotalResponse,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN Response = 'Correct' THEN Value ELSE 0 END) AS CorrectValue,
	SUM(CASE WHEN Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN Response = 'Incorrect' THEN 2*Value ELSE 0 END) AS IncorrectValue,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN Value ELSE 0 END) AS DNRValue
FROM jeopardy_data
GROUP BY Game, Metacategory
ORDER BY Game, totalresponse DESC;

--Average total amount left on table per game
WITH MetaValues AS (SELECT Game,
	COUNT(Response) AS TotalResponse,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN Response = 'Correct' THEN Value ELSE 0 END) AS CorrectValue,
	SUM(CASE WHEN Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN Response = 'Incorrect' THEN 2*Value ELSE 0 END) AS IncorrectValue,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN Value ELSE 0 END) AS DNRValue
FROM jeopardy_data
GROUP BY Game)
SELECT ROUND(sum((IncorrectValue+DNRValue)/80),0) AS TotalLeft
FROM MetaValues
;

-- Average amount left on table in History, Geography, Words?
WITH MetaValuesTop3 AS (SELECT Game, Metacategory,
	COUNT(Response) AS TotalResponse,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN Response = 'Correct' THEN Value ELSE 0 END) AS CorrectValue,
	SUM(CASE WHEN Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN Response = 'Incorrect' THEN 2*Value ELSE 0 END) AS IncorrectValue,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN Value ELSE 0 END) AS DNRValue
FROM jeopardy_data
WHERE Metacategory IN ('Words', 'History', 'Geography')
GROUP BY Game, Metacategory)
SELECT Metacategory, ROUND(SUM(IncorrectValue+DNRValue)/80,0) AS TotalLeft
FROM MetaValuesTop3
GROUP BY Metacategory
;

-- Average number of questions going unanswered or incorrectly answered per game (Words, History, Geography)
WITH MetaValuesTop3 AS 
	(SELECT Game, 
	Metacategory,
	COUNT(Response) AS TotalResponse,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN Response = 'Correct' THEN Value ELSE 0 END) AS CorrectValue,
	SUM(CASE WHEN Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN Response = 'Incorrect' THEN 2*Value ELSE 0 END) AS IncorrectValue,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN Value ELSE 0 END) AS DNRValue
FROM jeopardy_data
WHERE Metacategory IN ('Words', 'History', 'Geography')
GROUP BY Game, Metacategory)
SELECT Metacategory,
ROUND(SUM(IncorrectCount+DNRCount)/80,0) AS TotalLeft
FROM MetaValuesTop3
GROUP BY Metacategory
;
