<!DOCTYPE html>
 <HEAD>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>GO Game - User Registration</title>
  <meta name="description" content="">

  <link rel="stylesheet" href="css/main.css">
 </HEAD>
 <BODY>

<?php

$username = $_COOKIE['username'];
if ($username == "") {
  $username = "nothing found";
  setcookie('username', $username);
} else {
  header('Location: game.php');
  exit( );
}

echo '<div id="top_menu">User Registration</div>';
echo '<div id="main_area">';
echo 'Enter a user name: <input type="text" name="username" /><br />';
echo 'Enter a password: <input type="password" name="password" /><br />';
echo 'New or existing game? <input type="text" name="whichgame" /><br />';
echo 'Choose game ID: <input type="text" name="gameid" /><br />';
echo 'Choose side: <input type="text" name="stonecolor" /><br />';
echo '<a href="game.php">GO!</a><br />';
echo '</div>';
?>
  
 </BODY
