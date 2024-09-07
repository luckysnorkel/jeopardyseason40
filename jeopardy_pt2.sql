-- Overall percentage of correct
SELECT SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CountCorrect,
	ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*),2) AS PercentCorrect
FROM jeopardy_data_complete ;

-- Overall percentage of correct, by game type
SELECT b.GameType, SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CountCorrect,
	ROUND(100.0 * SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(a.*),2) AS PercentCorrect
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b
ON a.game = b.game
GROUP BY b.GameType;

-- Overall percentage of correct by Round
SELECT Round, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CountCorrect,
	ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*),2) AS PercentCorrect
FROM jeopardy_data_complete 
GROUP BY Round;

-- Overall percentage of correct, by game type
SELECT b.GameType, a.round, SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CountCorrect,
	ROUND(100.0 * SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(a.*),2) AS PercentCorrect
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b
ON a.game = b.game
GROUP BY b.GameType, a.round
ORDER BY b.gametype, a.round;

-- Coryat Average and Ranges
SELECT GameType,
ROUND(AVG(MyCoryat),0) AS AverageCoryat,
	STDDEV(MyCoryat) AS stddev_coryat,
	MIN(MyCoryat) AS MinCoryat,
	MAX(MyCoryat) AS MaxCoryat
FROM jeopardy_coryats_complete
GROUP BY GameType;

-- Overall Performance in DDs
SELECT COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data_complete
WHERE DD = 'True';

-- Overall Performance in DDs by Metacategory
SELECT Metacategory, COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data_complete
WHERE DD = 'True'
GROUP BY Metacategory
ORDER BY total DESC, percentage;

-- Performance in DDs by Game Type
SELECT b.GameType, COUNT(a.*) AS Total, SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b
ON a.game = b.game
WHERE a.DD = 'True'
GROUP BY b.gametype;

-- Performance in DDs by Metacategory, Regular Season Play
SELECT a.Metacategory, COUNT(a.*) AS Total, SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(a.*), 2) AS percentage
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b
ON a.game = b.game
WHERE a.DD = 'True' AND b.gametype = 'Regular Season Play'
GROUP BY a.Metacategory
ORDER BY total DESC, percentage;

-- Overall Performance in FJ
SELECT COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data_complete
WHERE Round = 'Final Jeopardy!';

-- Overall Performance in FJ by Metacategory
SELECT Metacategory, COUNT(*) AS Total, SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data_complete
WHERE Round = 'Final Jeopardy!'
GROUP BY Metacategory
ORDER BY total DESC, percentage;

-- Performance in FJ by Game Type
SELECT b.gametype, COUNT(a.*) AS Total, SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b
ON a.game = b.game
WHERE a.Round = 'Final Jeopardy!'
GROUP BY b.gametype;

-- Performance in FJ by Metacategory, Regular Season Play
SELECT a.Metacategory, COUNT(a.*) AS Total, SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers,
ROUND(100.0 * SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(a.*), 2) AS percentage
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b
ON a.game = b.game
WHERE a.Round = 'Final Jeopardy!' AND b.gametype = 'Regular Season Play'
GROUP BY a.Metacategory
ORDER BY total DESC, percentage;

-- Correlation Between My Coryat Score and Performance
SELECT
CORR(MyCoryat, CorrectAnswers) AS coryatcorrect
FROM
(SELECT a.Game, 
       b.MyCoryat,
       SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b ON a.Game = b.Game
GROUP BY a.Game, b.MyCoryat);
;

-- Correlation Between My Coryat Score and Performance, by game type
SELECT
gametype, CORR(MyCoryat, CorrectAnswers) AS coryatcorrect
FROM
(SELECT a.Game, 
 		b.gametype,
       b.MyCoryat,
       SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectAnswers
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b ON a.Game = b.Game
GROUP BY a.Game, b.gametype, b.MyCoryat)
GROUP BY gametype;

-- Average Responses Overall
WITH AnswerBreakdown AS
(SELECT Game,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount,
 	SUM(CASE WHEN Response = 'Not Revealed' THEN 1 ELSE 0 END) AS NRCount
FROM jeopardy_data_complete
GROUP BY Game
ORDER BY Game)
SELECT ROUND(AVG(CorrectCount),0) AS AverageCorrect,
	STDDEV(CorrectCount) AS stddev_correct,
	ROUND(AVG(IncorrectCount),0) AS AverageIncorrect,
	STDDEV(IncorrectCount) AS stddev_incorrect,
	ROUND(AVG(DNRCount),0) AS AverageDNR,
	STDDEV(DNRCount) AS stddev_dnr
FROM AnswerBreakdown;

-- Average Responses by Game Type
WITH AnswerBreakdown AS
(SELECT Game,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount,
 	SUM(CASE WHEN Response = 'Not Revealed' THEN 1 ELSE 0 END) AS NRCount
FROM jeopardy_data_complete
GROUP BY Game
ORDER BY Game)
SELECT b.gametype, ROUND(AVG(a.CorrectCount),0) AS AverageCorrect,
	STDDEV(a.CorrectCount) AS stddev_correct,
	ROUND(AVG(a.IncorrectCount),0) AS AverageIncorrect,
	STDDEV(a.IncorrectCount) AS stddev_incorrect,
	ROUND(AVG(a.DNRCount),0) AS AverageDNR,
	STDDEV(a.DNRCount) AS stddev_dnr
FROM AnswerBreakdown a
JOIN jeopardy_coryats_complete b
ON a.game = b.game
GROUP BY b.gametype;

-- Overall percentage of correct by Game Type, Regular Season Play
SELECT a.Round,
	COUNT(a.*) AS Total,
	SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CountCorrect,
	ROUND(100.0 * SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*),2) AS PercentCorrect
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b
ON a.game = b.game
WHERE b.gametype = 'Regular Season Play'
GROUP BY a.Round;

-- Average Responses By Round
WITH AnswerBreakdown AS
(SELECT Game, Round,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount
FROM jeopardy_data_complete
WHERE Round != 'Final Jeopardy!'
GROUP BY Game, Round
ORDER BY Game)
SELECT Round,
	ROUND(AVG(CorrectCount),0) AS AverageCorrect,
	STDDEV(CorrectCount) AS stddev_correct,
	ROUND(AVG(IncorrectCount),0) AS AverageIncorrect,
	STDDEV(IncorrectCount) AS stddev_incorrect,
	ROUND(AVG(DNRCount),0) AS AverageDNR,
	STDDEV(DNRCOUNT) AS stddev_dnr
FROM AnswerBreakdown
GROUP BY Round
ORDER BY Round DESC;

-- Count of questions by Metacategory
SELECT Metacategory, 
	COUNT(*) AS QuestionCount
FROM jeopardy_data_complete
GROUP BY Metacategory
ORDER BY QuestionCount DESC;

-- Count of questions by Metacategory, Regular Season Play
SELECT a.Metacategory, 
	COUNT(a.*) AS QuestionCount
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b
ON a.game = b.game
WHERE b.gametype = 'Regular Season Play'
GROUP BY a.Metacategory
ORDER BY QuestionCount DESC;

-- Confidence & Win Rate by Metacategory
SELECT Metacategory,
	COUNT(*) AS QuestionCount,
	ROUND(100.0 * SUM(CASE WHEN Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(*), 2) AS PercentAttempt,
	ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) AS TotalPercentCorrect,
	ROUND(100.0 *(ROUND(100.0 * SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(*), 2) / ROUND(100.0 * SUM(CASE WHEN Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(*), 2)),2) AS PercentCorrectofAttempted
FROM jeopardy_data_complete
GROUP BY Metacategory
HAVING (ROUND(100.0 * SUM(CASE WHEN Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(*), 2)) != 0
ORDER BY QuestionCount DESC, PercentAttempt, TotalPercentCorrect DESC;

-- Confidence & Win Rate by Metacategory, Regular Season Play
SELECT a.Metacategory,
	COUNT(a.*) AS QuestionCount,
	ROUND(100.0 * SUM(CASE WHEN a.Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(a.*), 2) AS PercentAttempt,
	ROUND(100.0 * SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(a.*), 2) AS TotalPercentCorrect,
	ROUND(100.0 *(ROUND(100.0 * SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) / COUNT(a.*), 2) / ROUND(100.0 * SUM(CASE WHEN a.Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(a.*), 2)),2) AS PercentCorrectofAttempted
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b
ON a.game = b.game
WHERE b.gametype = 'Regular Season Play'
GROUP BY a.Metacategory
HAVING (ROUND(100.0 * SUM(CASE WHEN a.Response = 'Did Not Ring In' THEN 0 ELSE 1 END) / COUNT(a.*), 2)) != 0
ORDER BY QuestionCount DESC, PercentAttempt, TotalPercentCorrect DESC;

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
FROM jeopardy_data_complete
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
FROM jeopardy_data_complete
GROUP BY Game)
SELECT ROUND(sum((IncorrectValue+DNRValue)/230),0) AS TotalLeft
FROM MetaValues
;

--Average total amount left on table per game, Regular Season Play
WITH MetaValues AS (SELECT b.gametype, a.Game,
	COUNT(a.Response) AS TotalResponse,
	SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN a.Response = 'Correct' THEN Value ELSE 0 END) AS CorrectValue,
	SUM(CASE WHEN a.Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN a.Response = 'Incorrect' THEN 2*Value ELSE 0 END) AS IncorrectValue,
	SUM(CASE WHEN a.Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount,
	SUM(CASE WHEN a.Response = 'Did Not Ring In' THEN Value ELSE 0 END) AS DNRValue
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b
ON a.game = b.game
GROUP BY b.gametype, a.Game)
SELECT ROUND(sum((IncorrectValue+DNRValue)/78),0) AS TotalLeft
FROM MetaValues
WHERE gametype = 'Regular Season Play';

--Average total amount left on table per game by Metacategory
WITH MetaValues AS 
	(SELECT Game, 
	Metacategory,
	COUNT(Response) AS TotalResponse,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN Response = 'Correct' THEN Value ELSE 0 END) AS CorrectValue,
	SUM(CASE WHEN Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN Response = 'Incorrect' THEN 2*Value ELSE 0 END) AS IncorrectValue,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN Value ELSE 0 END) AS DNRValue
FROM jeopardy_data_complete
GROUP BY Game, Metacategory)
SELECT Metacategory,
ROUND(sum((IncorrectValue+DNRValue)/230),0) AS TotalLeft
FROM MetaValues
GROUP BY Metacategory
ORDER BY TotalLeft DESC
;	

--Average total amount left on table per game by Metacategory, Regular Season Play
WITH MetaValues AS 
	(SELECT b.gametype, a.Game, 
	a.Metacategory,
	COUNT(a.Response) AS TotalResponse,
	SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN a.Response = 'Correct' THEN Value ELSE 0 END) AS CorrectValue,
	SUM(CASE WHEN a.Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN a.Response = 'Incorrect' THEN 2*Value ELSE 0 END) AS IncorrectValue,
	SUM(CASE WHEN a.Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount,
	SUM(CASE WHEN a.Response = 'Did Not Ring In' THEN Value ELSE 0 END) AS DNRValue
FROM jeopardy_data_complete a
JOIN jeopardy_coryats_complete b
	 ON a.game = b.game
GROUP BY b.gametype, a.Game, a.Metacategory)
SELECT Metacategory,
ROUND(sum((IncorrectValue+DNRValue)/78),0) AS TotalLeft
FROM MetaValues
WHERE gametype = 'Regular Season Play'
GROUP BY Metacategory
ORDER BY TotalLeft DESC
;	

-- Average number of questions going unanswered or incorrectly answered per game, by Metacategory
WITH MetaValues AS 
	(SELECT Game, 
	Metacategory,
	COUNT(Response) AS TotalResponse,
	SUM(CASE WHEN Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN Response = 'Correct' THEN Value ELSE 0 END) AS CorrectValue,
	SUM(CASE WHEN Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN Response = 'Incorrect' THEN 2*Value ELSE 0 END) AS IncorrectValue,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount,
	SUM(CASE WHEN Response = 'Did Not Ring In' THEN Value ELSE 0 END) AS DNRValue
FROM jeopardy_data_complete
GROUP BY Game, Metacategory)
SELECT Metacategory,
ROUND(SUM(IncorrectCount+DNRCount)/230,0) AS TotalLeft
FROM MetaValues
GROUP BY Metacategory
ORDER BY TotalLeft DESC
;

-- Average number of questions going unanswered or incorrectly answered per game, by Metacategory, Regular Season Play
WITH MetaValues AS 
	(SELECT b.gametype, a.Game, 
	a. Metacategory,
	COUNT(a.Response) AS TotalResponse,
	SUM(CASE WHEN a.Response = 'Correct' THEN 1 ELSE 0 END) AS CorrectCount,
	SUM(CASE WHEN a.Response = 'Correct' THEN Value ELSE 0 END) AS CorrectValue,
	SUM(CASE WHEN a.Response = 'Incorrect' THEN 1 ELSE 0 END) AS IncorrectCount,
	SUM(CASE WHEN a.Response = 'Incorrect' THEN 2*Value ELSE 0 END) AS IncorrectValue,
	SUM(CASE WHEN a.Response = 'Did Not Ring In' THEN 1 ELSE 0 END) AS DNRCount,
	SUM(CASE WHEN a.Response = 'Did Not Ring In' THEN Value ELSE 0 END) AS DNRValue
FROM jeopardy_data_complete a
	 JOIN jeopardy_coryats_complete b
	 ON a.game = b.game
GROUP BY b.gametype, a.Game, a.Metacategory)
SELECT Metacategory,
ROUND(SUM(IncorrectCount+DNRCount)/78,0) AS TotalLeft
FROM MetaValues
WHERE gametype = 'Regular Season Play'
GROUP BY Metacategory
ORDER BY TotalLeft DESC
;

-- Coryat spread
SELECT avg(mycoryat) AS avgcoryatme, avg(combinedcoryat) as avgcoryatcontestant
FROM jeopardy_coryats_complete
WHERE gametype = 'Regular Season Play';

SELECT avg(mycoryat) AS avgcoryatme, 
avg(contestant1coryat) as avgcoryat1, 
avg(contestant2coryat) as avgcoryat2, 
avg(contestant3coryat) as avgcoryat3
FROM jeopardy_coryats_complete
WHERE gametype = 'Regular Season Play';

-- Number of games where my Coryat surpassed the combined score, first 80 games
SELECT count(*)
FROM jeopardy_coryats
WHERE mycoryat >= combinedcoryat;

-- Number of games where my Coryat surpassed the combined score, full season
SELECT count(*)
FROM jeopardy_coryats_complete
WHERE mycoryat >= combinedcoryat;

-- Number of games scored over 25000
SELECT COUNT(*)
FROM jeopardy_coryats_complete
WHERE mycoryat >= 25000;

SELECT AVG(CASE WHEN Contestant1FJ = 'T' THEN 1 ELSE 0 END) AS Contestant1FJavg,
AVG(CASE WHEN Contestant2FJ = 'T' THEN 1 ELSE 0 END) AS Contestant2FJavg,
AVG(CASE WHEN Contestant3FJ = 'T' THEN 1 ELSE 0 END) AS Contestant3FJavg
FROM jeopardy_coryats_complete;

SELECT AVG(CASE WHEN Contestant1Win = 'T' THEN 1 ELSE 0 END) AS Contestant1winavg,
AVG(CASE WHEN Contestant2Win = 'T' THEN 1 ELSE 0 END) AS Contestant2winavg,
AVG(CASE WHEN Contestant3Win = 'T' THEN 1 ELSE 0 END) AS Contestant3winavg
FROM jeopardy_coryats_complete;