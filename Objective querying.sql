/* Objective 1
1. Listing all students, who play for a particular department (i.e. Cohort 4 group). */

/*
Lets join the Player details table with Group table. Maybe create a CTE with that. */


SELECT *
FROM "Player Details", "Group"
WHERE "Player Details"."Group ID" = "Group"."Group ID";  
/* Joined the tables. Did inner join to exclude ppl that didnt have groups */


with "Groups" AS (
	SELECT *
	FROM 
		"Player Details", "Group"
	WHERE 
		"Player Details"."Group ID" = "Group"."Group ID"  )

SELECT 
	"Groups"."Player Name",
	"Groups"."Group Name"
FROM 
	"Groups"
WHERE
	"Groups"."Group Name" = 'Cohort 4';
-- We can do the same for the other groups.



/* OBJECTIVE 3 */

SELECT *
FROM "Event Details";


--Filter In 'Scored'

SELECT *
FROM "Event Details"
WHERE "Event Descp ID" = 'Scored';

--Create this table as a VIEW called "Goals"

CREATE VIEW "Goals" AS 
SELECT *
FROM "Event Details"
WHERE "Event Descp ID" = 'Scored';

--Count number of Scored occurences 

SELECT 
	"Goals"."Player ID",
	COUNT("Event Descp ID") AS "Number of Goals"
FROM "Goals"
GROUP BY "Goals"."Player ID";


--Order the 'number of goals' from highest to lowest

SELECT 
	"Goals"."Player ID",
	COUNT("Event Descp ID") AS "Number of Goals"
FROM "Goals"
GROUP BY "Goals"."Player ID"
ORDER BY COUNT("Event Descp ID") DESC; 


--Filter just to get No of goals more than 2

SELECT 
	"Goals"."Player ID",
	COUNT("Event Descp ID") AS "Number of Goals"
FROM "Goals"
GROUP BY "Goals"."Player ID"
HAVING COUNT("Event Descp ID") > '2'
ORDER BY COUNT("Event Descp ID") DESC;


--Join with Player Details table to get Player Names

SELECT 
	"Goals"."Player ID",
	COUNT("Event Descp ID") AS "Number of Goals",
	"Player Details"."Player Name"
FROM "Goals"
LEFT JOIN "Player Details" ON 
	"Player Details"."Player ID" = "Goals"."Player ID"
GROUP BY "Goals"."Player ID", "Player Details"."Player Name"
HAVING COUNT("Event Descp ID") > '2'
ORDER BY COUNT("Event Descp ID") DESC;


/* OBJECTIVE 5
5. Listing the number of cards (yellow and red) per team. */


--Count the number of red cards per player
--Count number of yellow card per player
--Could create a view showing the number of yellow cards and number of red card per player
--Call this view 'No of Cards per player'
--Join 'No of Card per player' with player details table to get the team id of each player via playerid
--Then join this table with team table to get the team name of each player via team id
--Then group by team name to show number of red cards and no of yellow cards per team.


--Count number of red cards per player

SELECT *,
	CASE
		WHEN "Event Descp ID" = 'Red' THEN '1'
		ELSE '0' 
	END AS "No of Red Cards",
	CASE
		WHEN "Event Descp ID" = 'Yellow' THEN '1'
		ELSE '0'  
	END AS "No of Yellow Cards"
FROM "Event Details";



--No of red cards/yellow card per player
 
SELECT "Player ID",
	SUM(CASE
		WHEN "Event Descp ID" = 'Red' THEN 1
		ELSE 0 
	END) AS "Total Red Cards",
	SUM(CASE
		WHEN "Event Descp ID" = 'Yellow' THEN 1
		ELSE 0  
	END) AS "Total Yellow Cards"
FROM "Event Details"
GROUP BY "Player ID";


--Create a view called "No of cards per player"

CREATE VIEW "No of cards perp" AS 
	SELECT 
		"Player ID",
		SUM(CASE
				WHEN "Event Descp ID" = 'Red' THEN 1
				ELSE 0 
			END) AS "Total Red Cards",
		SUM(CASE
				WHEN "Event Descp ID" = 'Yellow' THEN 1
				ELSE 0  
			END) AS "Total Yellow Cards"
	FROM 
		"Event Details"
	GROUP BY 
		"Player ID";

--Join "No of cards perp" with player details

--Nested subq to join 'No of Card per player' with player details table to get the team id of 
--each player via playerid
--Then join this table with team table to get the team name of each player via team id


SELECT *
FROM
	(SELECT *
	FROM 
		(SELECT * 
		 FROM "Player Details") AS "Player Details"
	JOIN 
		(SELECT *
		 FROM "No of cards perp") AS "No of cards perp" ON
	 	"Player Details"."Player ID" = "No of cards perp"."Player ID"
	) AS "Player Name Cards"
JOIN
	"Team" ON
	"Player Name Cards"."Team ID" = "Team"."Team ID";


/* Now lets filter to show Team Name, "Total Red Cards", "Total Yellow Cards" */


SELECT
	"Team"."Team Name", 
	"Player Name Cards"."Total Red Cards", 
	"Player Name Cards"."Total Yellow Cards"
FROM "No of cards perp",
	(SELECT *
	FROM 
		(SELECT * 
		 FROM "Player Details") AS "Player Details"
	JOIN 
		(SELECT *
		 FROM "No of cards perp") AS "No of cards perp" ON
	 	"Player Details"."Player ID" = "No of cards perp"."Player ID"
	) AS "Player Name Cards"
JOIN
	"Team" ON
	"Player Name Cards"."Team ID" = "Team"."Team ID";
	


-- Group by Team Name and add SUM to no of red/yellow cards


SELECT
	"Team"."Team Name", 
	SUM("Player Name Cards"."Total Red Cards") AS "Total Red Cards", 
	SUM("Player Name Cards"."Total Yellow Cards") AS "Total Yellow Cards"
FROM
	(SELECT *
	FROM 
		(SELECT * 
		 FROM "Player Details") AS "Player Details"
	JOIN 
		(SELECT * 
		 FROM "No of cards perp") AS "No of cards perp" ON
	 	"Player Details"."Player ID" = "No of cards perp"."Player ID"
	) AS "Player Name Cards"
JOIN
	"Team" ON
	"Player Name Cards"."Team ID" = "Team"."Team ID"
GROUP BY 
	"Team"."Team Name";

