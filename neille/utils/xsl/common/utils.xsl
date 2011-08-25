<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

  <xsl:output encoding="UTF-8" method="text"/>

  <xsl:param name="tab" select="'  '"/>
  <xsl:param name="spc" select="' '"/>
  <xsl:param name="opr">(</xsl:param>
  <xsl:param name="cpr">)</xsl:param>
  <xsl:param name="smc">;</xsl:param>
  <xsl:param name="cln">:</xsl:param>
  <xsl:param name="nwl" select="'&#10;'"/>
  <xsl:param name="ind-1" select="$tab"/>

  <xsl:template name="replace-in-string">
    <xsl:param name="str"/>
    <xsl:param name="old"/>
    <xsl:param name="new"/>
    <xsl:choose>
      <xsl:when test="contains($str, $old)">
	<xsl:value-of select="concat(substring-before($str, $old), $new)"/>
	<xsl:call-template name="replace-in-string">
	  <xsl:with-param name="str" select="substring-after($str, $old)"/>
	  <xsl:with-param name="old" select="$old"/>
	  <xsl:with-param name="new" select="$new"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="margin">
    <xsl:call-template name="newline"/>
    <xsl:call-template name="newline"/>
  </xsl:template>

  <xsl:template name="indent-1">
    <xsl:value-of select="$ind-1"/>
  </xsl:template>

  <xsl:template name="newline">
    <xsl:value-of select="$nwl"/>
  </xsl:template>

  <xsl:template name="space">
    <xsl:value-of select="$spc"/>
  </xsl:template>

  <xsl:template name="tab">
    <xsl:value-of select="$tab"/>
  </xsl:template>

  <xsl:template name="newline-indent-1">
    <xsl:call-template name="newline"/>
    <xsl:call-template name="tab"/>
  </xsl:template>

  <xsl:template name="newline-indent-2">
    <xsl:call-template name="newline-indent-1"/>
    <xsl:call-template name="tab"/>
  </xsl:template>

  <xsl:template name="newline-indent-3">
    <xsl:call-template name="newline-indent-2"/>
    <xsl:call-template name="tab"/>
  </xsl:template>

</xsl:stylesheet>
