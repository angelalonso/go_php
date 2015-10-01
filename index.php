HTML>
 <HEAD>
  <title>PHP Test</title>
 </HEAD>
 <BODY>

 <?php

$colNumber = 19;
$rowNumber = 19;

echo '<table>';
for ( $rowCounter = 0; $rowCounter < $rowNumber; $rowCounter += 1) {
  echo '<tr>';
  for ( $colCounter = 0; $colCounter < $colNumber; $colCounter += 1) {
    echo '<td>' , $colCounter , '</td>';
  }
  echo '</tr>';
}

echo '</table>';

 ?>

 </BODY>
</HTML>
