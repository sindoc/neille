<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://sina.khakbaz.com/2010/neille/ns/card"
    exclude-result-prefixes="c"
    version="1.0">

  <xsl:import href="generate-card-fields.xsl"/>
  <xsl:import href="custom.xsl"/>

  <xsl:import href="../common/racket.xsl"/>
  <xsl:import href="../common/utils.xsl"/>

  <xsl:output 
      encoding="UTF-8" 
      method="text" 
      standalone="yes"
      indent="no"
      omit-xml-declaration="yes"
      media-type="text/plain"/>

  <xsl:strip-space elements="c:*"/>

  <xsl:variable name="card-struct-fields">
    <xsl:call-template name="generate-card-field-list"/>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:call-template name="output.head.content"/>
    <xsl:call-template name="define-card-collection"/>
    <xsl:call-template name="define-card-struct"/>
    <xsl:if test="$card.image != ''">
      <xsl:call-template name="define-card-image-struct"/>
      <xsl:call-template name="define-meta-image-struct"/>
    </xsl:if>
    <xsl:apply-templates select="//c:default" mode="registrar"/>
    <xsl:call-template name="margin"/>
    <xsl:apply-templates/>
    <xsl:call-template name="output.foot.content"/>
  </xsl:template>

  <xsl:template name="define-card-collection">
    <xsl:call-template name="racket.define">
      <xsl:with-param name="id" select="$card.collection.name"/>
      <xsl:with-param name="value" select="$racket.null"/>
    </xsl:call-template>
    <xsl:call-template name="margin"/>
  </xsl:template>

  <xsl:template name="define-card-struct">
    <xsl:call-template name="racket.define-struct">
      <xsl:with-param name="id" select="$card.struct.id"/>
      <xsl:with-param name="fields" select="$card-struct-fields"/>
      <xsl:with-param name="options" select="$card.struct.options"/>
    </xsl:call-template>
    <xsl:call-template name="margin"/>
  </xsl:template>

  <xsl:template name="registrar-body">
    <xsl:call-template name="racket.assign">
      <xsl:with-param name="id" select="$card.collection.name"/>
      <xsl:with-param name="value">
	<xsl:call-template name="racket.cons">
	  <xsl:with-param name="car">
	    <xsl:call-template name="racket.apply">
	      <xsl:with-param name="proc" select="$card.struct.constructor.id"/>
	      <xsl:with-param name="args" select="$card-struct-fields"/>
	    </xsl:call-template>
	  </xsl:with-param>
	  <xsl:with-param name="cdr" select="$card.collection.name"/>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="c:card">
    <xsl:call-template name="racket.apply">
      <xsl:with-param name="proc" select="$card.registrar.name"/>
      <xsl:with-param name="args">
	<xsl:call-template name="card-id"/>
	<xsl:apply-templates select="c:*|@*"/>
	<xsl:if test="$card.image != ''">
	  <xsl:call-template name="make-card-image"/>
	</xsl:if>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="margin"/>
  </xsl:template>  

  <xsl:template match="c:default" mode="registrar">
    <xsl:call-template name="racket.define.proc">
      <xsl:with-param name="name" select="$card.registrar.name"/>
      <xsl:with-param name="formal-params">
	<xsl:call-template name="define-card-id"/>
	<xsl:apply-templates select="c:card/c:*|c:card/@*" mode="registrar"/>
	<xsl:if test="$card.image != ''">
	  <xsl:call-template name="format-formal-param">
	    <xsl:with-param name="keyword" select="$card.image.param.name"/>
	    <xsl:with-param name="default-value" select="$racket.null"/>
	  </xsl:call-template>
	</xsl:if>
      </xsl:with-param>
      <xsl:with-param name="body">
	<xsl:call-template name="registrar-body"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="c:name|c:type|c:faction|c:squadrole" mode="registrar">
    <xsl:call-template name="format-formal-param"/>
  </xsl:template>

  <xsl:template match="@ready|@health|@attack|@units|@artifacts|@spells|c:specials|c:note" mode="registrar">
    <xsl:call-template name="format-formal-param">
      <xsl:with-param name="default-value" select="$racket.null"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="define-card-image-struct">
    <xsl:call-template name="racket.define-struct">
      <xsl:with-param name="id" 
		      select="$card.image.struct.id"/>
      <xsl:with-param name="fields" 
		      select="$card.image.struct.ordered.fields"/>
      <xsl:with-param name="options" 
		      select="$card.image.struct.options"/>
    </xsl:call-template>
    <xsl:call-template name="margin"/>
  </xsl:template>

  <xsl:template name="define-meta-image-struct">
    <xsl:call-template name="racket.define-struct">
      <xsl:with-param name="id" 
		      select="$meta.image.struct.id"/>
      <xsl:with-param name="fields" 
		      select="$meta.image.struct.ordered.fields"/>
      <xsl:with-param name="options" 
		      select="$meta.image.struct.options"/>
    </xsl:call-template>
    <xsl:call-template name="margin"/>
  </xsl:template>

  <xsl:template name="define-card-id">
    <xsl:call-template name="format-formal-param">
      <xsl:with-param name="keyword" select="$card.id.param.name"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="generate-card-id">
    <xsl:param name="card-node" select="."/>
    <xsl:variable name="name">
      <xsl:call-template name="replace-in-string">
	<xsl:with-param name="str" select="$card-node/c:name"/>
	<xsl:with-param name="old" select="' '"/>
	<xsl:with-param name="new" select="'-'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat('T', $card-node/@tier, '-', $name)"/>
  </xsl:template>

  <xsl:template name="card-id">
    <xsl:param name="card-node" select="."/>
    <xsl:call-template name="format-argument">
      <xsl:with-param name="type">symbol</xsl:with-param>
      <xsl:with-param name="keyword" select="$card.id.param.name"/>
      <xsl:with-param name="value">
	<xsl:call-template name="generate-card-id"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@ready|@attack|@health|@units|@artifacts|@spells">
    <xsl:call-template name="format-argument"/>
  </xsl:template>

  <xsl:template match="c:name">
    <xsl:call-template name="format-argument">
      <xsl:with-param name="type">string</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="c:squadrole|c:faction">
    <xsl:call-template name="format-argument">
      <xsl:with-param name="type">symbol</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="c:type">
    <xsl:call-template name="format-argument">
      <xsl:with-param name="type">symbol</xsl:with-param>
    </xsl:call-template>
    <xsl:if test="not(../c:squadrole)">
      <xsl:call-template name="format-argument">
	<xsl:with-param name="keyword" select="'squadrole'"/>
	<xsl:with-param name="type">symbol</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="c:specials">
    <xsl:call-template name="format-argument">
      <xsl:with-param name="value">
	<xsl:call-template name="racket.list">
	  <xsl:with-param name="elements">
	    <xsl:for-each select="c:ability">
	      <xsl:call-template name="format-racket-value">
		<xsl:with-param name="type">string</xsl:with-param>
	      </xsl:call-template>
	      <xsl:call-template name="space"/>
	    </xsl:for-each>
	  </xsl:with-param>
	</xsl:call-template>	
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="c:note">
    <xsl:call-template name="format-argument">
      <xsl:with-param name="value">
	<xsl:call-template name="racket.list">
	  <xsl:with-param name="elements">
	    <xsl:for-each select="c:phrase">
	      <xsl:call-template name="format-racket-value">
		<xsl:with-param name="type">string</xsl:with-param>
	      </xsl:call-template>
	      <xsl:call-template name="space"/>
	    </xsl:for-each>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="c:faction" mode="card-image">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="c:name" mode="card-image">
    <xsl:call-template name="replace-in-string">
      <xsl:with-param name="str" select="."/>
      <xsl:with-param name="old" select="' '"/>
      <xsl:with-param name="new" select="'-'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="c:type" mode="card-image">
    <xsl:choose>
      <xsl:when test="../c:squadrole">
	<xsl:value-of select="../c:squadrole"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 
  <xsl:template name="make-card-image">
    <xsl:variable name="basename">
      <xsl:value-of select="$card.image.basename.prefix"/>
      <xsl:apply-templates select="c:type" mode="card-image"/>
      <xsl:text>-</xsl:text>
      <xsl:apply-templates select="c:faction" mode="card-image"/>
      <xsl:text>-</xsl:text>
      <xsl:apply-templates select="c:name" mode="card-image"/>
      <xsl:value-of select="$card.image.basename.suffix"/>
    </xsl:variable>
    <xsl:call-template name="format-argument">
      <xsl:with-param name="keyword" select="$card.image.param.name"/>
      <xsl:with-param name="value">
	<xsl:call-template name="racket.apply">
	  <xsl:with-param name="proc" 
			  select="$card.image.struct.constructor.id"/>
	  <xsl:with-param name="args">
	    <xsl:call-template name="format-racket-value">
	      <xsl:with-param name="type">symbol</xsl:with-param>
	      <xsl:with-param name="value" select="$card.image.type"/>
	    </xsl:call-template>
	    <xsl:text> </xsl:text>
	    <xsl:call-template name="format-racket-value">
	      <xsl:with-param name="type">string</xsl:with-param>
	      <xsl:with-param name="value" select="$basename"/>
	    </xsl:call-template>
	    <xsl:text> </xsl:text>
	    <xsl:call-template name="format-racket-value">
	      <xsl:with-param name="type">string</xsl:with-param>
	      <xsl:with-param name="value" select="$card.image.path.prefix"/>
	    </xsl:call-template>
	    <xsl:text> </xsl:text>
	    <xsl:call-template name="format-racket-value">
	      <xsl:with-param name="type">string</xsl:with-param>
	      <xsl:with-param name="value" select="$card.image.path.suffix"/>
	    </xsl:call-template>
	    <xsl:text> </xsl:text>
	    <xsl:call-template name="make-bitmap-foreach-scale">
	      <xsl:with-param name="basename" select="$basename"/>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="construct-card-image-dirname">
    <xsl:param name="scale"/>
    <xsl:value-of select="$card.image.path.prefix"/>
    <xsl:value-of select="$card.image.type"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="$scale"/>
    <xsl:text>/</xsl:text>
  </xsl:template>

  <xsl:template name="construct-card-image-filename">
    <xsl:param name="basename"/>
    <xsl:value-of select="$basename"/>
    <xsl:value-of select="$card.image.path.suffix"/>
  </xsl:template>

  <xsl:template name="make-meta-image">
    <xsl:param name="dirname"/>
    <xsl:param name="filename"/>
    <xsl:param name="type"/>
    <xsl:call-template name="racket.apply">
      <xsl:with-param name="proc" 
		      select="$meta.image.struct.constructor.id"/>
      <xsl:with-param name="args">
	<xsl:call-template name="format-racket-value">
	  <xsl:with-param name="type">string</xsl:with-param>
	  <xsl:with-param name="value" select="$dirname"/>
	</xsl:call-template>
	<xsl:call-template name="space"/>
	<xsl:call-template name="format-racket-value">
	  <xsl:with-param name="type">string</xsl:with-param>
	  <xsl:with-param name="value" select="$filename"/>
	</xsl:call-template>
	<xsl:call-template name="space"/>
	<xsl:call-template name="format-racket-value">
	  <xsl:with-param name="type">symbol</xsl:with-param>
	  <xsl:with-param name="value" select="$type"/>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="make-bitmap-foreach-scale">
    <xsl:param name="basename"/>
    <xsl:call-template name="make-bitmap-foreach-scale-rec">
      <xsl:with-param name="basename" select="$basename"/>
      <xsl:with-param name="scales" select="$card.image.scales"/>
    </xsl:call-template>
  </xsl:template>  

  <xsl:template name="make-bitmap-foreach-scale-rec">
    <xsl:param name="scales"/>
    <xsl:param name="basename"/>
    <xsl:choose>
      <xsl:when test="$scales = ''">
	<xsl:value-of select="$racket.null"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="scale">
	  <xsl:choose>
	    <xsl:when test="contains($scales, $card.image.scale.separator)">
	      <xsl:value-of 
		  select="substring-before($scales, 
			  $card.image.scale.separator)"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$scales"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:call-template name="racket.cons">
	  <xsl:with-param name="car">
	    <xsl:call-template name="make-meta-image">
	      <xsl:with-param name="dirname">
		<xsl:call-template name="construct-card-image-dirname">
		  <xsl:with-param name="scale" select="$scale"/>
		</xsl:call-template>
	      </xsl:with-param>
	      <xsl:with-param name="filename">
		<xsl:call-template name="construct-card-image-filename">
		  <xsl:with-param name="basename" select="$basename"/>
		</xsl:call-template>
	      </xsl:with-param>
	      <xsl:with-param name="type" select="$card.image.type"/>
	    </xsl:call-template>
	  </xsl:with-param>
	  <xsl:with-param name="cdr">
	    <xsl:call-template name="make-bitmap-foreach-scale-rec">
	      <xsl:with-param name="scales" 
			      select="substring-after($scales, $spc)"/>
	      <xsl:with-param name="basename" select="$basename"/>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@tier|c:set|c:default"></xsl:template>
  <xsl:template match="@tier|c:set" mode="registrar"></xsl:template>

</xsl:stylesheet>
