#!/bin/bash

# Fonction courantes

function message {
  message=$1
  date=`date +%Y-%m-%d`
  time=`date +%H:%M:%S`

  echo "$date $time | $step > $message"
}

export base=`pwd`
export now=`date +%Y-%m-%dT%H:%M:%S`
export oriCSV="$1"
export csv="$base/marches-$now.csv"

# Préparation du fichier

export step="Préparation"
message "+ + + + + + + +"

message "Conversion ISO8859-1 vers UTF-8..."
iconv -f ISO8859-1 -t UTF-8 $oriCSV -o $csv

message "Normalisation des en-têtes de colonnes..."
head -n 1  $csv | tr -d " " | tr -d "()" > temp
head -n 1 temp
tail -n +2 $csv >> temp
mv temp $csv
