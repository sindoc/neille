<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:l="http://sina.khakbaz.com/2010/neille/ns/layout"
    exclude-result-prefixes="l"
    version="1.0">

  <xsl:output encoding="UTF-8" method="text" indent="no"/>

  <xsl:param name="global.param.prefix">$</xsl:param>
  <xsl:param name="card.table.instance.id">table-</xsl:param>
  <xsl:param name="card.table.width" select="10"/>
  <xsl:param name="card.table.height" select="4.5"/>
  <xsl:param name="margin.default" select="10"/>
  <xsl:param name="margin.between" select="$margin.default"/>
  <xsl:param name="margin.top" select="$margin.default"/>
  <xsl:param name="margin.left" select="$margin.default"/>
  <xsl:param name="orthonormal.basis.x.default" select="1"/>
  <xsl:param name="orthonormal.basis.y.default" select="1"/>
  <xsl:param name="region.default.width" select="1"/>
  <xsl:param name="region.default.height" select="1"/>
  <xsl:param name="region.default.constructor">make-region</xsl:param>
  <xsl:param name="region.default.callback" select="$racket.false.value"/>
  <xsl:param name="init.proc.id">init-layout</xsl:param>
  <xsl:param name="generate.models"></xsl:param>

  <xsl:template name="construct-model-id">
    <xsl:param name="stem" select="@id"/>
    <xsl:choose>
      <xsl:when test="starts-with(@model, $global.param.prefix)">
	<xsl:call-template name="eval-reference">
	  <xsl:with-param name="datum" select="@model"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="common-construct-id">
	  <xsl:with-param name="stem" select="$stem"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="construct-view-id">
    <xsl:param name="stem" select="@id"/>
    <xsl:call-template name="common-construct-id">
      <xsl:with-param name="stem" select="$stem"/>
      <xsl:with-param name="suffix">-view</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="construct-region-id">
    <xsl:param name="stem" select="@id"/>
    <xsl:variable name="stem-">
      <xsl:choose>
	<xsl:when test="$stem != ''">
	  <xsl:value-of select="$stem"/>
	</xsl:when>
	<xsl:when test="../parent::l:col/@id">
	  <xsl:value-of select="concat(../../@id, '-', generate-id())"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message terminate="yes">not cool</xsl:message>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="common-construct-id">
      <xsl:with-param name="stem" select="$stem-"/>
      <xsl:with-param name="suffix">-region</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="common-construct-id">
    <xsl:param name="stem"/>
    <xsl:param name="prefix" select="''"/>
    <xsl:param name="suffix" select="''"/>
    <xsl:value-of select="concat($prefix, $stem, $suffix)"/>
  </xsl:template>

  <xsl:template name="normalize-stem">
    <xsl:param name="stem"/>
    <xsl:variable name="discr">-</xsl:variable>
    <xsl:choose>
      <xsl:when test="substring($stem, 1, 1) = $discr">
	<xsl:value-of select="substring-after($stem, $discr)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$stem"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="construct-model-class-name">
    <xsl:param name="stem" select="@id"/>
    <xsl:choose>
      <xsl:when test="@model">
	<xsl:value-of select="@model"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="stem-">
	  <xsl:call-template name="normalize-stem">
	    <xsl:with-param name="stem" select="$stem"/>
	  </xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="concat($stem-, '%')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="construct-view-class-name">
    <xsl:param name="stem" select="@id"/>
    <xsl:variable name="suffix">-view%</xsl:variable>
    <xsl:choose>
      <xsl:when test="@view">
	<xsl:value-of select="@view"/>
      </xsl:when>
      <xsl:when test="@model and 
		      not(starts-with(@model, $global.param.prefix))">
	<xsl:value-of 
	    select="concat(substring-before(@model, '%'), $suffix)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="stem-">
	  <xsl:call-template name="normalize-stem">
	    <xsl:with-param name="stem" select="$stem"/>
	  </xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="concat($stem-, $suffix)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="require.view">
    <xsl:text>neille/common/view-classes/base</xsl:text>
  </xsl:template>

  <xsl:template name="require.model">
    <xsl:text>neille/common/model-classes/base</xsl:text>
  </xsl:template>

  <xsl:template name="require.config">
    <xsl:call-template name="format-racket-value">
      <xsl:with-param name="value">config.rkt</xsl:with-param>
      <xsl:with-param name="type">string</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="output.foot.content">
    <xsl:call-template name="racket.apply">
      <xsl:with-param name="proc" select="$init.proc.id"/>
    </xsl:call-template>
<!--
    <xsl:call-template name="newline"/>
    <xsl:call-template name="show-table"/>
-->
  </xsl:template>

</xsl:stylesheet>
