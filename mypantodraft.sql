CREATE TABLE IF NOT EXISTS `Dates`
  (period INT PRIMARY KEY)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS `Stars`
  (star_id INT PRIMARY KEY,
  star_name VARCHAR(20) NOT NULL,
  role VARCHAR(20))ENGINE=INNODB;
--
--

CREATE TABLE IF NOT EXISTS `Pantomimes`
  (title VARCHAR(20) PRIMARY KEY)ENGINE=INNODB;
--

CREATE TABLE IF NOT EXISTS `Agents`
  (agent_id INT PRIMARY KEY,
  agent_name VARCHAR(20) NOT NULL,
  agent_town VARCHAR(20))ENGINE=INNODB;
--
--
CREATE TABLE IF NOT EXISTS `Directors`
  (director_id INT PRIMARY KEY,
  director_name VARCHAR(20) NOT NULL,
  director_home VARCHAR(20)) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS `Seasons`
  (period INT,
  title VARCHAR(20),
  star_id INT,
  director_id INT) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS `Contracts`
  (period INT,
  agent_id INT,
  star_id INT)ENGINE=INNODB;;


INSERT INTO `Stars` (star_id, star_name, role)
SELECT DISTINCT StarID, StarName, Role
FROM `panto`;

INSERT INTO `Pantomimes`
SELECT DISTINCT title
FROM `panto`;

INSERT INTO `Agents` (agent_id, agent_name, agent_town)
SELECT DISTINCT AgentID, AgentName, AgentTown
FROM `panto`;

INSERT INTO `Directors` (director_id, director_name, director_home)
SELECT DISTINCT DirectorID, DirectorName, Home
FROM `panto`;

INSERT INTO `Dates`
SELECT DISTINCT Year
FROM `panto`;

ALTER TABLE Seasons ADD FOREIGN KEY(period) REFERENCES Dates(period) ON DELETE SET NULL;

ALTER TABLE Seasons ADD FOREIGN KEY(title) REFERENCES Pantomimes(title) ON DELETE SET NULL;

ALTER TABLE Seasons ADD FOREIGN KEY(star_id) REFERENCES Stars(star_id) ON DELETE SET NULL;

ALTER TABLE Seasons ADD FOREIGN KEY(director_id) REFERENCES Directors(director_id) ON DELETE SET NULL;

INSERT INTO `Seasons` (period, title, star_id, director_id)
SELECT DISTINCT Year, Title, StarID, DirectorID
FROM `panto`;

ALTER TABLE Contracts ADD FOREIGN KEY(period) REFERENCES Dates(period) ON DELETE SET NULL;

ALTER TABLE Contracts ADD FOREIGN KEY(agent_id) REFERENCES Agents(agent_id) ON DELETE CASCADE;

ALTER TABLE Contracts ADD FOREIGN KEY(star_id) REFERENCES Stars(star_id) ON DELETE set NULL;

INSERT INTO `Contracts` (period, agent_id, star_id)
SELECT DISTINCT Year, AgentID, StarID
FROM `panto`;
