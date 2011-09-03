<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://sina.khakbaz.com/2010/neille/ns/card"
    exclude-result-prefixes="c"
    version="1.0">

  <xsl:import href="../common/racket.xsl"/>
  <xsl:import href="custom.xsl"/>

  <xsl:output 
      encoding="UTF-8" 
      method="text" 
      standalone="yes"
      indent="no"
      omit-xml-declaration="yes"
      media-type="text/plain"/>

  <xsl:strip-space elements="c:*"/>

  <xsl:template match="/">
    <xsl:call-template name="racket.common.head.content"/>
    <xsl:call-template name="racket.provide">
      <xsl:with-param name="specs">
	<xsl:call-template name="racket.all-defined-out"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="margin"/>
    <xsl:call-template name="racket.define">
      <xsl:with-param name="id" select="$card.struct.field.list.id"/>
      <xsl:with-param name="value">
	<xsl:call-template name="racket.quote">
	  <xsl:with-param name="datum">
	    <xsl:call-template name="racket.s-exp">
	      <xsl:with-param name="content">
		<xsl:apply-templates 
		    select="//c:default/c:card" 
		    mode="generate-card-fields"/>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="generate-card-field-list">
    <xsl:apply-templates 
	select="//c:default/c:card" 
	mode="generate-card-fields"/>
  </xsl:template>

  <xsl:template match="//c:default/c:card" mode="generate-card-fields">
    <xsl:apply-imports/>
  </xsl:template>

  <xsl:template match="c:*|@*" mode="generate-card-fields">
    <xsl:apply-imports/>
  </xsl:template>

</xsl:stylesheet>