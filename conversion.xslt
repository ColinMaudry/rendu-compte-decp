<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:cm="https://colin.maudry.fr/xslt/" xmlns:xslt="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="cm fn xs">
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="csv">
        <marches>
            <xsl:for-each-group select="marche" group-by="id">
                <marche>
                    <xsl:apply-templates/>
                    <acheteur>
                        <id><xsl:value-of select="acheteur_id"/></id>
                        <nom><xsl:value-of select="acheteur_nom"/></nom>
                    </acheteur>
                    <titulaires>
                        <xsl:for-each select="current-group()">
                            <titulaire>
                                <id><xsl:value-of select="titulaires_id"/></id>
                                <denominationSociale><xsl:value-of select="titulaires_denominationLegale"/></denominationSociale>
                                <typeIdentifiant>SIRET</typeIdentifiant>
                            </titulaire>
                        </xsl:for-each>
                    </titulaires>
                    <lieuExecution>
                        <code><xsl:value-of select="lieuExecution_code"/></code>
                        <typeCode><xsl:value-of select="lieuExecution_typeCode"/></typeCode>
                        <nom><xsl:value-of select="lieuExecution_nom"/></nom>
                    </lieuExecution>
                    <modifications/>
                </marche>
            </xsl:for-each-group>
        </marches>
    </xsl:template>

    <!-- <xsl:template match="marche">
        <marche>
            <xsl:apply-templates/>
            <acheteur>
                <id><xsl:value-of select="SIRETacheteur"/></id>
                <nom><xsl:value-of select="Nomacheteur"/></nom>
            </acheteur>
            <titulaires>
                <titulaire>
                    <id><xsl:value-of select="Siret_Titulaire"/></id>
                    <denominationSociale><xsl:value-of select="TitulaireMandataire"/></denominationSociale>
                    <typeIdentifiant>SIRET</typeIdentifiant>
                </titulaire>
            </titulaires>
            <modifications/>
        </marche>
    </xsl:template> -->

    <xsl:template match="id">

        <id>
            <xsl:value-of select="concat(replace(../Datenotification,'^.+(\d\d\d\d)$','$1'),text())"/>
        </id>
    </xsl:template>

    <xsl:template match="objet">
        <objet><xsl:value-of select="."/></objet>
    </xsl:template>

    <xsl:template match="codeCPV">
        <codeCPV><xsl:value-of select="."/></codeCPV>
    </xsl:template>

    <xsl:template match="dureeMois">
        <dureeMois><xsl:value-of select="."/></dureeMois>
    </xsl:template>

    <xsl:template match="montant">
        <montant><xsl:value-of select="."/></montant>
    </xsl:template>

    <!-- Demander un mapping des valeurs au client -->
    <xsl:template match="procedure">
        <procedure><xsl:value-of select="."/></procedure>
    </xsl:template>

    <xsl:template match="formePrix[text()]">
        <formePrix>
            <xsl:choose>
              <xsl:when test=". = 'Fermes'">
                  <xsl:text>Ferme</xsl:text>
              </xsl:when>
              <xsl:when test=". = 'Fermes actualisables'">
                  <xsl:text>Ferme et actualisable</xsl:text>
              </xsl:when>
              <xsl:when test=". = 'Révisables'">
                  <xsl:text>Révisable</xsl:text>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
        </formePrix>
    </xsl:template>


    <xsl:function name="cm:processDate" as="xs:string">
        <xsl:param name="date" as="xs:string"/>
        <xsl:value-of select="replace($date,'(\d\d)/(\d\d)/(\d\d\d\d)','$3-$2-$1')"/>
    </xsl:function>

    <xsl:template match="dateNotification">
        <dateNotification>
            <xsl:choose>
                <xsl:when test="text() != ''">
                    <xsl:value-of select="cm:processDate(text())"/><xsl:value-of/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </dateNotification>
    </xsl:template>

    <xsl:template match="datePublicationDonnees">
        <datePublicationDonnees>
            <xsl:choose>
                <xsl:when test="text() != ''">
                    <xsl:value-of select="cm:processDate(text())"/><xsl:value-of/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose></datePublicationDonnees>
    </xsl:template>

    <xsl:template match="nature">
        <nature>
            <xsl:choose>
                <xsl:when test="text() = 'Accord cadre'">
                    <xsl:text>Accord-cadre</xsl:text>
                </xsl:when>
                <xsl:when test="text() = 'Marché simple'">
                    <xsl:text>Marché</xsl:text>
                </xsl:when>
                <xsl:when test="text() = 'Marché fractionné à tranches'">
                    <xsl:text>Marché</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </nature>
    </xsl:template>


    <!-- Pas de conversion
    <xsl:template match="Annee | LiblelleCPV | Datepublicationdesdonnees | Role | Commune_Titulaire | siren_Titualire | Avance | Nbavenantscptables | Delaismoyenmandatementjours | SIRETacheteur | Siret_Titulaire | Nomacheteur | MontantinitialHt | MontantmodifieHt"/>
 -->
    <xsl:template match="text()" priority="-1">
        <!-- <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy> -->
    </xsl:template>
</xsl:stylesheet>
