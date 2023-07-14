/* Interview Prep based on Questions from Data Lemur 
    Modified to understand the concepts and for my own practices */

-- Question 1:  Players with no direct freekicks taken by team - Difficulty Level: Easy
SELECT players.name, players.team
FROM fpl.players
JOIN fpl.stats
ON players.id = stats.id
WHERE direct_freekicks_order = 0 AND team = "Arsenal"



