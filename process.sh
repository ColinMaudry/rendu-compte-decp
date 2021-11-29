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
#export csv="$base/marches-$now.csv"
#export csv="$base/marches-temp.csv"
csv=$1
export xml=$csv.xml

# Préparation du fichier

export step="Préparation"
message "+ + + + + + + +"

message "Conversion ISO8859-1 vers UTF-8..."

# N'activer iconv que pour un CSV encodé en ISO8859-1
# iconv -f ISO8859-1 -t UTF-8 $oriCSV -o $csv.utf8
# mv $csv.utf8 $csv

message "Normalisation des en-têtes de colonnes..."
head -n 1  $csv | tr -d " ()/" | sed 's/é/e/g'| tr "ô" "o" | tr "." "_" > temp
head -n 1 temp
tail -n +2 $csv >> temp
mv temp $csv

export step="Conversion"
message "+ + + + + + + +"

message "Conversion du CSV vers un XML basique..."

echo '<?xml version="1.0" encoding="UTF-8"?>' > $xml
echo '<csv>' >> $xml

while IFS="|" read -r Annee id acheteur_id acheteur_nom nature objet codeCPV procedure LieuExecution_code LieuExecution_typeCode lieuExecution_nom DureeMois dateNotification datePublicationDonnees montant formePrix titulaires_id titulaires_typeIdentifianttype_identifiant titulaires_denominationSociale

do
    if [[ ! $id = "id" ]]
    then
        echo "  <marche>" >> $xml
        echo "    <Annee>${Annee}</Annee>" >> $xml
        echo "    <id>${id}</id>" >> $xml
        echo "    <acheteur_id>${acheteur_id}</acheteur_id>" | tr -d " " >> $xml
        echo "    <acheteur_nom>${acheteur_nom}</acheteur_nom>" >> $xml
        echo "    <nature>${nature}</nature>" >> $xml
        echo "    <objet>${objet}</objet>" | sed 's/&/&amp;/g' >> $xml
        echo "    <codeCPV>${codeCPV}</codeCPV>" >> $xml
        echo "    <procedure>${procedure}</procedure>" >> $xml
        echo "    <lieuExecution_code>${LieuExecution_code}</lieuExecution_code>" >> $xml
        echo "    <lieuExecution_typeCode>${lieuExecution_typeCode}</lieuExecution_typeCode>" >> $xml
        echo "    <lieuExecution_nom>${lieuExecution_nom}</lieuExecution_nom>" >> $xml
        echo "    <dureeMois>${DureeMois}</dureeMois>" >> $xml
        echo "    <dateNotification>${dateNotification}</dateNotification>" >> $xml
        echo "    <datePublicationDonnees>${datePublicationDonnees}</datePublicationDonnees>" >> $xml
        # Le sed ci-dessous supprime les espaces insécables (non-breaking spaces, NBSP) des montants
        echo "    <montant>${montant}</montant>" | sed 's/ //g' | sed 's/,/./' >> $xml
        echo "    <formePrix>${formePrix}</formePrix>" >> $xml
        echo "    <titulaires_id>${titulaires_id}</titulaires_id>" >> $xml
        echo "    <titulaires_typeIdentifiant>${titulaires_typeIdentifiant}</titulaires_typeIdentifiant>" >> $xml
        echo "    <titulaires_denominationLegale>${titulaires_denominationSociale}</titulaires_denominationLegale>" >> $xml
        echo "  </marche>" >> $xml
    fi
done < $csv
echo "</csv>" >> $xml

message "Conversion du XML basique vers le format DECP..."

mv $xml $xml.simple
jar=`ls -1 lib | grep "saxon"`
java -jar lib/$jar -s:$xml.simple -xsl:conversion.xslt -o:$xml
#xmllint --format $xml.unformatted > $xml
#rm $xml.unformatted

head -n 40 $xml

message "Fin de de la conversion"
