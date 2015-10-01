<!DOCTYPE html>
 <HEAD>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>GO Game</title>
  <meta name="description" content="">

  <link rel="stylesheet" href="css/main.css">
 </HEAD>
 <BODY>

 <?php
$servername = "localhost";
## YES, I KNOW! (this code is being tested in an isolated VM nevertheless)
$username = "root";
$password = "root 123";
$dbname = "goDB";

$colNumber = 19;
$rowNumber = 19;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

if (isset($_GET['clicked'])) {
    $position = $_GET['clicked'];
    $command = "/usr/bin/ruby /var/www/html/go_php/go_ctrl.rb ". $position;
    echo exec($command);
}else{
    // Fallback behaviour goes here
}

echo '<TABLE id="gametable">';

$sql = "SELECT col_row, stone FROM stonetable_empty";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
    while($entry = $result->fetch_assoc()) {
        $col = (string)str_split($entry["col_row"],2)[0];
        $row = (string)str_split($entry["col_row"],2)[1];
        if ( $row == "00" ) {echo '<TR>';}
        if ( $row == strval($colNumber) ) {echo '</TR>';}

        if ($entry["stone"] == "black") {
          echo '<TD id="stone_black" ></TD>';
        } elseif ($entry["stone"] == "white") {
          echo '<TD id="stone_white" ></TD>';
        } else {
          echo '<TD id="stone_empty" ><a href="?clicked=' , $entry["col_row"] , '"></a></TD>';
        }
    }
} else {
    echo "0 results";
}
$conn->close();

echo '</TABLE>';

$result = foo(40,50);
echo $result;

function foo($arg_1, $arg_2)
{
    echo "Example function.\n";
    return $arg_2;
}


 ?>

 </BODY>
