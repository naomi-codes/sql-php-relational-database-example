<html>
<head>
	<title>League Results (PHP)</title>

	<style> table, th, td {
		border: 1px solid black;
	}
	</style>
</head>

<body>
  <form method="post" action="assignment.php">
		Search player name:
		<input type="text" name="name">
		<input type="submit" name="go" value="Go">
  </form>

<?php
//Database variables
$servername = "localhost";
$username = "root";
$password = "password";
$db = "b3_assignment";

//Open new database connection
$db = new mysqli($servername, $username, $password, $db);
if ($db->connect_error) { die("Failed: ".$db->connect_error);}


if ($_SERVER["REQUEST_METHOD"] == "POST"){


	$name=$_POST['name'];
	$name=mysqli_real_escape_string($db,$name);
	$name=strip_tags($name);


	$stmt = $db->prepare("SELECT DISTINCT p.Player_ID, p.Forename, p.Surname, p.Team, p.Status, s1.Skills FROM Player p
		LEFT JOIN
			(SELECT DISTINCT s.Player, GROUP_CONCAT(s.Skill) AS Skills
			FROM Skill s GROUP BY s.Player) AS s1
		ON s1.Player = p.Player_ID
		WHERE p.Forename LIKE ? OR p.Surname LIKE ?");

	$param1 = $param2 = '%'."$name".'%';

	$stmt->bind_param("ss", $param1, $param2);
	$stmt->execute();

	$result2 = $stmt->get_result();

	if ($result2->num_rows > 0)
		{
			echo "<table><tr><th>ID</th><th>Forename</th><th>Surname</th><th>Team</th><th>Status</th><th>Skills</th></tr>";
			while($obj = mysqli_fetch_object($result2))
				{
					echo "<tr><td>".$obj->Player_ID."</td><td>".$obj->Forename."</td><td>".$obj->Surname."</td><td>".$obj->Team."</td><td>".$obj->Status."</td><td>".$obj->Skills. "</td></tr>";
					}
					echo "</table>";
					mysqli_free_result($result2);
				} else { echo "No matches";}
	$stmt->close();
	$db->close();

}
?>
</body>
</html>
