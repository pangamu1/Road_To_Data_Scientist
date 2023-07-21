/* Interview Prep based on Questions from Data Lemur 
    Modified to understand the concepts and for my own practices */

-- Question 1:  Players with no direct freekicks taken by team - Difficulty Level: Easy
SELECT players.name, players.team
FROM fpl.players
JOIN fpl.stats
ON players.id = stats.id
WHERE direct_freekicks_order = 0 AND team = "Arsenal"

-- Question 2: Write a query to count players in Aston Villa and remaining as just others 
SELECT  
    COUNT (*) FILTER (WHERE team = 'Aston Villa') AS AstonVilla,
    COUNT (*) FILTER (WHERE team IN ('Arsenal','Bornemouth','Chelsea')) AS Rest
FROM 
    fpl.players

 -- Method #2:
 SELECT 
  SUM(CASE WHEN team = 'Aston Villa' THEN 1 ELSE 0 END) AS AstonVilla, 
  SUM(CASE WHEN team IN ('Arsenal', 'Chelsea') THEN 1 ELSE 0 END) AS Rest 
FROM fpl.players;

SELECT *
FROM players
WHERE team NOT IN 'Chelsea'



