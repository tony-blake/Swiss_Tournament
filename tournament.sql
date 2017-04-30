-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.
-- meaningless comment to make new commit

CREATE TABLE players ( id SERIAL,
                       name TEXT );

CREATE TABLE matches ( matchid SERIAL,
                       competition INTEGER,
                       winner INTEGER,
                       loser INTEGER,
                       draw BOOLEAN );

CREATE TABLE competitions ( id SERIAL,
                           name TEXT );

CREATE TABLE scoreboard ( competition INTEGER,
                          player INTEGER,
                          bye INTEGER );


--  Make view to show the winners and the scores that reflect the 3 points for a winning match
CREATE VIEW makestandings AS
SELECT DISTINCT winner, 3*COUNT(winner) AS score FROM matches GROUP BY winner;

-- Rename winner column so that it says player column
ALTER TABLE makestandings RENAME COLUMN winner TO player;

-- Make view that shows the losers and the scores they get from a losing match (also shows that a match was played)
CREATE VIEW losers AS
SELECT DISTINCT loser, COUNT(loser) AS matches FROM matches GROUP BY loser;

-- Rename loser column so that it says player column
ALTER TABLE losers RENAME COLUMN loser TO player;

--Make view to show the winners and a unit scores which is evident of having played a match
CREATE VIEW winners AS
SELECT DISTINCT winner, COUNT(winner) AS matches FROM matches GROUP BY winner;

-- Rename winners column so that it says player column
ALTER TABLE winners RENAME COLUMN winner TO player;

-- Combine winners and losers table into single stacked table
CREATE VIEW allthegames AS
SELECT player, matches FROM winners GROUP BY player, matches UNION ALL SELECT player, matches FROM losers GROUP BY player, matches;


-- Sum rows for multiple values of each player (this will show the number of matches played for each player)
CREATE VIEW numberofmatches AS
SELECT
   player,
   SUM(matches) AS matches
FROM allthegames
GROUP BY player;

-- Combine the number of matches view with scores for each player 
CREATE VIEW matchesandscores AS
SELECT nofm.player, nofm.matches, mkstd.score FROM makestandings AS mkstd RIGHT JOIN numberofmatches AS nofm ON nofm.player=mkstd.player ORDER BY nofm.player;

-- replace empty spaces with zero
create VIEW matchesandscores2 AS
SELECT player, matches, coalesce(score, 0) from matchesandscores;

-- Rename coalesce column so that it says score column
ALTER TABLE matchesandscores2 RENAME COLUMN coalesce TO score;


-- Combine matches and scores view with empty scoreboard table (this scoreboard table only show competion number, player and bye status) 
CREATE VIEW scoreboard2 AS
SELECT s.competition, ms.player, ms.score, ms.matches, s.bye FROM scoreboard AS s JOIN matchesandscores2 AS ms ON s.player=ms.player ORDER BY ms.player; 

-- Convert scoreboard into table so it can be updated when running "tournament_test.py" script
CREATE TABLE scoreboard3 AS SELECT * FROM scoreboard2;








--CREATE TRIGGER_trig matchesandscores2 INSTEAD OF INSERT OR UPDATE OR DELETE ON matchesandscores2 matchesandscores2 FOR EACH ROW EXECUTE PROCEDURE matchesandscore2();
