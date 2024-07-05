CREATE TABLE "Player Details" (
	"Player ID" TEXT PRIMARY KEY,
	"Player Name" TEXT,
	"Consultant ID" INTEGER,
	"Group ID" TEXT,
	"Team ID" TEXT,
	--Defining foreign key
	FOREIGN KEY ("Group ID") REFERENCES "Group"("Group ID"),
	FOREIGN KEY ("Team ID") REFERENCES "Team"("Team ID"));
	

--Creating Fixture table

CREATE TABLE "Fixture" (
	"Fixture ID" TEXT PRIMARY KEY,
	"Home Team" TEXT,
	"Away Team" TEXT,
	"Venue ID" TEXT,
	"Date/Time" TIMESTAMP,
	"Week Played" INTEGER,
	--Defining foreign key
	FOREIGN KEY ("Home Team") REFERENCES "Team"("Team ID"),
	FOREIGN KEY ("Away Team") REFERENCES "Team"("Team ID"),
	FOREIGN KEY ("Venue ID") REFERENCES "Venue"("Venue ID")); 
	
	
-- Create results table

CREATE TABLE "Results" (
	"Result ID" TEXT PRIMARY KEY,
	"Fixture ID" TEXT,
	"Points Awarded to Home Team" INTEGER,
	"Points Awarded to Away Team" INTEGER,
	--Defining foreign key
	FOREIGN KEY ("Fixture ID") REFERENCES "Fixture"("Fixture ID"));
	

-- Adding Event Details table

CREATE TABLE "Event Details" (
	"Event ID" TEXT PRIMARY KEY,
	"Player ID" TEXT,
	"Fixture ID" TEXT,
	"Event Descp ID" TEXT,
	--Defining foreign key
	FOREIGN KEY ("Fixture ID") REFERENCES "Fixture"("Fixture ID"),
	FOREIGN KEY ("Player ID") REFERENCES "Player Details"("Player ID"),
	FOREIGN KEY ("Event Descp ID") REFERENCES "Event"("Event Descp ID")); 


/* for the tables, venue, event description, team and group, i created those table manunally by right clicking on the
object explorer and clicking create table. */


