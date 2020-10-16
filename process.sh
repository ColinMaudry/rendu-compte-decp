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
export xml=$csv.xml

# Préparation du fichier

export step="Préparation"
message "+ + + + + + + +"

message "Conversion ISO8859-1 vers UTF-8..."
iconv -f ISO8859-1 -t UTF-8 $oriCSV -o $csv

message "Normalisation des en-têtes de colonnes..."
head -n 1  $csv | tr -d " ()/" | tr "é" "e" | tr "ô" "o" > temp
head -n 1 temp
tail -n +2 $csv >> temp
mv temp $csv

export step="Conversion"
message "+ + + + + + + +"

message "Conversion du CSV vers un XML basique..."

echo '<?xml version="1.0" encoding="UTF-8"?>' > $xml
echo '<csv>' >> $xml

while IFS=";" read -r Annee Iddumarche Nomacheteur SIRETacheteur Nature Objetmarche CodeCPV LiblelleCPV Procedure Lieuexecution Dureemois Datenotification Datepublicationdesdonnees MontantinitialHt MontantmodifieHt Montantprevu Typeprix TitulaireMandataire Role CodePostal_Titulaire CodeInsee_Titulaire Commune_Titulaire Siret_Titulaire siren_Titualire Avance Nbavenantscptables Delaismoyenmandatementjours
do
    if [[ ! $Annee = "Annee" ]]
    then
        echo "  <marche>" >> $xml
        echo "    <Annee>${Annee}</Annee>" >> $xml
        echo "    <Iddumarche>$Iddumarche</Iddumarche>" >> $xml
        echo "    <Nomacheteur>$Nomacheteur</Nomacheteur>" >> $xml
        echo "    <SIRETacheteur>$SIRETacheteur</SIRETacheteur>" | tr -d " " >> $xml
        echo "    <Nature>$Nature</Nature>" >> $xml
        echo "    <Objetmarche>$Objetmarche</Objetmarche>" | sed 's/&/&amp;/g' >> $xml
        echo "    <CodeCPV>$CodeCPV</CodeCPV>" >> $xml
        echo "    <LiblelleCPV>$LiblelleCPV</LiblelleCPV>" >> $xml
        echo "    <Procedure>$Procedure</Procedure>" >> $xml
        echo "    <Lieuexecution>$Lieuexecution</Lieuexecution>" >> $xml
        echo "    <Dureemois>$Dureemois</Dureemois>" >> $xml
        echo "    <Datenotification>$Datenotification</Datenotification>" >> $xml
        echo "    <Datepublicationdesdonnees>$Datepublicationdesdonnees</Datepublicationdesdonnees>" >> $xml
        echo "    <MontantinitialHt>$MontantinitialHt</MontantinitialHt>" | tr -d ", " >> $xml
        echo "    <MontantmodifieHt>$MontantmodifieHt</MontantmodifieHt>" | tr -d ", " >> $xml
        echo "    <Montantprevu>$Montantprevu</Montantprevu>" | tr -d ", " >> $xml
        echo "    <Typeprix>$Typeprix</Typeprix>" >> $xml
        echo "    <TitulairMandataire>$TitulairMandataire</TitulairMandataire>" >> $xml
        echo "    <Role>$Role</Role>" >> $xml
        echo "    <CodePostal_Titulaire>$CodePostal_Titulaire</CodePostal_Titulaire>" >> $xml
        echo "    <CodeInsee_Titulaire>$CodeInsee_Titulaire</CodeInsee_Titulaire>" >> $xml
        echo "    <Commune_Titulaire>$Commune_Titulaire</Commune_Titulaire>" >> $xml
        echo "    <Siret_Titulaire>$Siret_Titulaire</Siret_Titulaire>" >> $xml
        echo "    <siren_Titualire>$siren_Titualire</siren_Titualire>" >> $xml
        echo "    <Avance>$Avance</Avance>" >> $xml
        echo "    <Nbavenantscptables>$Nbavenantscptables</Nbavenantscptables>" >> $xml
        echo "    <Delaismoyenmandatementjours>$Delaismoyenmandatementjours
        </Delaismoyenmandatementjours>" >> $xml
        echo "  </marche>" >> $xml
    fi
done < $csv
echo "</csv>" >> $xml
