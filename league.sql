/*naomi lambert*/

/* Create Game table*/
CREATE TABLE IF NOT EXISTS `Game` (
  `Date` DATE,
  `Venue` VARCHAR(20),
  CONSTRAINT PRIMARY KEY (`Date`)
);

/*Create Location table */
CREATE TABLE IF NOT EXISTS `Location` (
  `Town` VARCHAR(20),
  CONSTRAINT PRIMARY KEY (Town)
);

/*Create Team table*/
CREATE TABLE IF NOT EXISTS `Team` (
  `Name` VARCHAR(20),
  `Hometown` VARCHAR(20),
  CONSTRAINT PRIMARY KEY (Name),
  CONSTRAINT FOREIGN KEY (Hometown) REFERENCES Location (Town)
);

/*Create Player table*/
CREATE TABLE IF NOT EXISTS `Player` (
  `Player_ID` INT AUTO_INCREMENT,
  `Forename` VARCHAR(20) NOT NULL,
  `Surname` VARCHAR(20) NOT NULL,
  `Team` VARCHAR(20),
  `Status` VARCHAR(20),
  CONSTRAINT PRIMARY KEY (Player_ID),
  CONSTRAINT FOREIGN KEY (Team) REFERENCES Team (Name)
);

/*Create Skill table */
CREATE TABLE IF NOT EXISTS `Skill` (
  `Player` INT,
  `Skill` VARCHAR(20) NOT NULL,
  `Skill_ID` INT NOT NULL AUTO_INCREMENT,
  CONSTRAINT PRIMARY KEY (Skill_ID),
  CONSTRAINT FOREIGN KEY (Player) REFERENCES Player (Player_ID)
);

/*Create Score table */
CREATE TABLE IF NOT EXISTS `Score` (
  `Game` DATE,
  `Skill_ID` INT,
  `Points` INT NOT NULL,
  CONSTRAINT PRIMARY KEY (Game, Skill_ID),
  CONSTRAINT FOREIGN KEY (Game) REFERENCES Game (`Date`),
  CONSTRAINT FOREIGN KEY (Skill_ID) REFERENCES Skill (Skill_ID)
);

/*Create Participant table*/
CREATE TABLE IF NOT EXISTS `Participant` (
  `Team` VARCHAR(20),
  `Game` DATE,
  CONSTRAINT PRIMARY KEY (Team, Game),
  CONSTRAINT FOREIGN KEY (Team) REFERENCES Team (Name),
  CONSTRAINT FOREIGN KEY (Game) REFERENCES Game (`Date`)
);

/*create table to hold data from nohead.csv */
CREATE TABLE IF NOT EXISTS `loaddata` (
  `Player_ID` INT,
  `Forename` VARCHAR(20),
  `Surname` VARCHAR(20),
  `Team` VARCHAR(20),
  `Status` VARCHAR(20),
  `Skill` VARCHAR(20),
  `Name` VARCHAR(20),
  `Town` VARCHAR(20),
  `Venue`VARCHAR(20),
  `Date` DATE,
  `Points`INT
)

/* insert towns into town table from loaded data */
INSERT INTO `Location` (Town)
SELECT DISTINCT `Town` FROM `loaddata`
UNION SELECT DISTINCT `Town`
FROM `loaddata`
WHERE NOT EXISTS(SELECT Town
                  FROM `loaddata`);


/* populate table `Team` */
INSERT INTO `Team` (`Name`, `Hometown`) SELECT DISTINCT `Name`, `Town` FROM `loaddata`;

/* populate table `Player` */
INSERT INTO `Player` SELECT DISTINCT `Player_ID`, `Forename`, `Surname`, `Team`, `Status` FROM `loaddata`;

/* populate table `Game` */
INSERT INTO `Game` (`Date`, `Venue`) SELECT DISTINCT `Date`, `Venue` FROM `loaddata`;

/* populate table `Skill` */
INSERT INTO `Skill` (`Player`, `Skill`) SELECT DISTINCT `Player_ID`, `Skill` FROM `loaddata`;

/* populate table `Score` */
INSERT INTO `Score` (`Game`, `Skill_ID`, `Points`) SELECT DISTINCT loaddata.Date, Skill.Skill_ID, loaddata.Points FROM `loaddata`, `Skill`
WHERE loaddata.Player_ID = Skill.Player;

/* populate table `Participant` */
INSERT INTO `Participant` (`Team`, `Game`) SELECT DISTINCT `Team`, `Date` FROM `loaddata`;

/* select all from team */
SELECT * FROM `Team`;

/* select the participation count for each time along with the team name */
SELECT `Team`, Count(Team) FROM `Participant` GROUP BY `Team`;

/* select sum of all points a player has scored and output with their name */
SELECT Player.Forename, Player.Surname, Sum(Score.Points) FROM `Player`, `Score`, `Skill` WHERE Score.Skill_ID = Skill.Skill_ID AND Player.Player_ID = Skill.Player GROUP BY Player.Forename;

/* list all the games where the Rams have played the jets
SELECT DISTINCT A.Team AS Team1, B.Team AS Team2, A.Game
FROM Participant A
INNER JOIN Participant B
ON A.Game = B.Game
WHERE A.Team = 'Rams'
AND A.Team <> B.Team
AND B.Team = 'Jets';

/* select rams from the left hand table then select jets from the join table with a date that matches */
SELECT t1.Team, COUNT(t1.Game) AS GamesPlayed, t2.PointsGained, t2.PointsGained/COUNT(t1.Game) AS AveragePoints FROM Participant AS t1
LEFT JOIN
  (SELECT DISTINCT Participant.Team AS Team, SUM(Score.Points) AS PointsGained
  FROM Participant
  LEFT JOIN Score
  ON Participant.Game = Score.Game
  LEFT JOIN Skill
  ON Skill.Skill_ID = Score.Skill_ID
  LEFT JOIN Player
  ON Player.Player_ID = Skill.Player WHERE Player.Team = Participant.Team
  GROUP BY Participant.Team) AS t2
ON t1.Team = t2.Team
GROUP BY t1.Team;

/* list skills by player */
AS a
  LEFT JOIN (SELECT b.Player, GROUP_CONCAT(b.Skill_ID)
  FROM Skill
  GROUP BY b.Player) AS b
  ON a.Player_ID = b.Player
