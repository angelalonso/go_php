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

$colNumber = 18;
$rowNumber = 18;

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
    header('Location: game.php');
    exit( );
}else{
    if (isset($_GET['newgame'])) {
        $command = "/usr/bin/ruby /var/www/html/go_php/go_ctrl.rb newgame";
        echo exec($command);
    }
    if (isset($_GET['exitgame'])) {
        setcookie('username', "");
        header('Location: index.php');
        exit( );
    }
}

echo '<div id="btn_newgame"><a href="?newgame=true">NEW GAME</a></div>';
echo '<div id="btn_exitgame"><a href="?exitgame=true">EXIT</a></div>';

echo '<TABLE id="gametable">';

$sql = "SELECT row_col, stone FROM stonetable";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
    while($entry = $result->fetch_assoc()) {
        $row = (string)str_split($entry["row_col"],2)[0];
        $col = (string)str_split($entry["row_col"],2)[1];
        if ( $col == "00" ) {echo '<TR>';}

        if ($entry["stone"] == "black") {
          echo '<TD id="stone_black" class="' , $entry["row_col"] , '" ><a href="#"></a></TD> ';
        } elseif ($entry["stone"] == "white") {
          echo '<TD id="stone_white" class="' , $entry["row_col"] , '" ><a href="#"></a></TD> ';
        } else {
          echo '<TD id="stone_empty" class="' , $entry["row_col"] , '" ><a href="?clicked=' . $entry["row_col"] . '"></a></TD> ';
        }
        if ( $col == strval($colNumber) ) {echo '</TR>';}
    }
} else {
    echo "0 results";
}
$conn->close();

echo '</TABLE>';

$turn_command = "/usr/bin/ruby /var/www/html/go_php/go_ctrl.rb getturn";
$turn = exec($turn_command);

if ($turn == "black") {
  echo '<div id="div_nextblack">Next turn: ' . $turn . '</div>';
} else {
  echo '<div id="div_nextwhite">Next turn: ' . $turn . '</div>';
}

$result = foo(40,50);
#echo $result;

function foo($arg_1, $arg_2)
{
  #echo "Example function.\n";
  return $arg_2;
}


 ?>

 </BODY>
