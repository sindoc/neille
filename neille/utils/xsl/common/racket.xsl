<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

  <xsl:output encoding="UTF-8" method="text"/>

  <xsl:param name="racket.null">null</xsl:param>
  <xsl:param name="racket.true.value">#t</xsl:param>
  <xsl:param name="racket.false.value">#f</xsl:param>
  <xsl:param name="racket.bitmap.class.name">bitmap%</xsl:param>
  <xsl:param name="racket.require.gui">racket/gui/base</xsl:param>
  <xsl:param name="racket.require.games.cards">games/cards</xsl:param>
  <xsl:param name="racket.default.struct.options">#:transparent 
  #:mutable</xsl:param>
  <xsl:param name="racket.games.cards.make-background-region-"
	     select="'make-background-region'"/>

  <xsl:template name="format-racket-value">
    <xsl:param name="value" select="normalize-space(.)"/>
    <xsl:param name="type" select="''"/>
    <xsl:choose>
      <xsl:when test="$type = 'string'">
	<xsl:text>"</xsl:text>
	<xsl:value-of select="$value"/>
	<xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="$type = 'symbol'">
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$value"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>

  <xsl:template name="format-argument">
    <xsl:param name="keyword" select="local-name(.)"/>
    <xsl:param name="value" select="normalize-space(.)"/>
    <xsl:param name="type" select="''"/>
    <xsl:variable name="formatted-value">
      <xsl:call-template name="format-racket-value">
	<xsl:with-param name="value" select="$value"/>
	<xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="newline-indent-1"/>
    <xsl:value-of select="concat('#:', $keyword, ' ', $formatted-value, ' ')"/>
  </xsl:template>

  <xsl:template name="format-formal-param">
    <xsl:param name="keyword" select="local-name(.)"/>
    <xsl:param name="name" select="$keyword"/>
    <xsl:param name="default-value" select="''"/>
    <xsl:call-template name="newline"/>
    <xsl:call-template name="indent-1"/>
    <xsl:value-of select="concat('#:', $keyword, ' ')"/>
    <xsl:choose>
      <xsl:when test="$default-value != ''">
	<xsl:value-of select="concat('[', $name, ' ', $default-value, ']')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$name"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template name="racket.make-named-arg">
    <xsl:param name="argname"/>
    <xsl:param name="arg"/>
    <xsl:call-template name="racket.s-exp">
      <xsl:with-param name="content" select="concat($argname, $spc, $arg)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="postfix">
    <xsl:param name="operator"/>
    <xsl:param name="operands" select="''"/>
    <xsl:call-template name="racket.s-exp">
      <xsl:with-param name="content">
	<xsl:value-of select="$operator"/>
	<xsl:if test="$operands != ''">
	  <xsl:value-of select="concat($spc, $operands)"/>
	</xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.define">
    <xsl:param name="id"/>
    <xsl:param name="value"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">define</xsl:with-param>
      <xsl:with-param 
	  name="operands" 
	  select="concat($id, $nwl, $tab, $value)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.define-for-syntax">
    <xsl:param name="id"/>
    <xsl:param name="value"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">define-for-syntax</xsl:with-param>
      <xsl:with-param name="operands" select="concat($id, $spc, $value)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.assign">
    <xsl:param name="id"/>
    <xsl:param name="value"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">set!</xsl:with-param>
      <xsl:with-param name="operands" select="concat($id, $spc, $value)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.require">
    <xsl:param name="specs"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">require</xsl:with-param>
      <xsl:with-param name="operands" select="$specs"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.provide">
    <xsl:param name="specs"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">provide</xsl:with-param>
      <xsl:with-param name="operands" select="$specs"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.declare.language">
    <xsl:param name="lang-name">racket</xsl:param>
    <xsl:value-of select="concat('#lang ', $lang-name)"/>
  </xsl:template>

  <xsl:template name="racket.comment.line">
    <xsl:param name="content"/>
    <xsl:value-of select="concat($smc, $smc, $spc, $content)"/>
  </xsl:template>

  <xsl:template name="racket.apply">
    <xsl:param name="proc"/>
    <xsl:param name="args"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator" select="$proc"/>
      <xsl:with-param name="operands" select="$args"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.cons">
    <xsl:param name="car"/>
    <xsl:param name="cdr"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">cons</xsl:with-param>
      <xsl:with-param name="operands" select="concat($car, $spc, $cdr)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.define-struct">
    <xsl:param name="id"/>
    <xsl:param name="fields"/>
    <xsl:param name="options"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">define-struct</xsl:with-param>
      <xsl:with-param 
	  name="operands" 
	  select="concat($id, $spc, $opr, $fields, $cpr, $spc, $options)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.make-object">
    <xsl:param name="class"/>
    <xsl:param name="args"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">make-object</xsl:with-param>
      <xsl:with-param name="operands" select="concat($class, $spc, $args)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.new">
    <xsl:param name="class"/>
    <xsl:param name="args"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">new</xsl:with-param>
      <xsl:with-param name="operands" select="concat($class, $spc, $args)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.list">
    <xsl:param name="elements"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">list</xsl:with-param>
      <xsl:with-param name="operands" select="$elements"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.all-defined-out">
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">all-defined-out</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.all-from-out">
    <xsl:param name="module-paths"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">all-from-out</xsl:with-param>
      <xsl:with-param name="operands" select="$module-paths"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.collection-path">
    <xsl:param name="collection"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">collection-path</xsl:with-param>
      <xsl:with-param name="operands" select="$collection"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.collection-file-path">
    <xsl:param name="file"/>
    <xsl:param name="collection"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">collection-file-path</xsl:with-param>
      <xsl:with-param name="operands" 
		      select="concat($file, $spc, $collection)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.define.proc">
    <xsl:param name="name"/>
    <xsl:param name="formal-params" select="''"/>
    <xsl:param name="body"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">define</xsl:with-param>
      <xsl:with-param 
	  name="operands" 
	  select="concat($opr, $name, $formal-params, $cpr, $nwl, 
		  $ind-1, $body)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.games.cards.dispatch-region-maker">
    <xsl:param name="maker"/>
    <xsl:param name="x"/>
    <xsl:param name="y"/>
    <xsl:param name="w"/>
    <xsl:param name="h"/>
    <xsl:param name="label" select="$racket.false.value"/>
    <xsl:param name="callback" select="$racket.false.value"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator" select="$maker"/>
      <xsl:with-param name="operands">
	<xsl:value-of select="$x"/>
	<xsl:call-template name="space"/>
	<xsl:value-of select="$y"/>
	<xsl:call-template name="space"/>
	<xsl:value-of select="$w"/>
	<xsl:call-template name="space"/>
	<xsl:value-of select="$h"/>
	<xsl:if test="$maker != $racket.games.cards.make-background-region-">
	  <xsl:call-template name="space"/>
	  <xsl:value-of select="$label"/>
	</xsl:if>
	<xsl:call-template name="space"/>
	<xsl:value-of select="$callback"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.games.cards.make-table">
    <xsl:param name="w" select="''"/>
    <xsl:param name="h" select="''"/>
    <xsl:param name="title">"Cards Table"</xsl:param>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">make-table</xsl:with-param>
      <xsl:with-param name="operands">
	<!-- FIXME: clean whitespace for optional args -->
	<xsl:value-of select="concat($title, $spc, $w, $spc, $h)"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.send">
    <xsl:param name="object"/>
    <xsl:param name="message"/>
    <xsl:param name="args"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">send</xsl:with-param>
      <xsl:with-param name="operands">
	<xsl:value-of select="concat($object, $spc, $message)"/>
	<xsl:if test="$args != ''">
	  <xsl:value-of select="concat($spc, $args)"/>
	</xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="racket.s-exp">
    <xsl:param name="content" select="''"/>
    <xsl:value-of select="concat($opr, $content, $cpr)"/>
  </xsl:template>

  <xsl:template name="racket.quote">
    <xsl:param name="datum"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">quote</xsl:with-param>
      <xsl:with-param name="operands" select="$datum"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="racket.common.head.content">
    <xsl:call-template name="racket.declare.language"/>
    <xsl:call-template name="margin"/>
    <xsl:call-template name="racket.comment.line">
      <xsl:with-param name="content">DO NOT EDIT THIS FILE</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="newline"/>
    <xsl:call-template name="racket.comment.line">
      <xsl:with-param name="content">
	<xsl:text>This file is automatically generated.</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="margin"/>    
  </xsl:template>

  <xsl:template name="racket.lambda">
    <xsl:param name="args" select="''"/>
    <xsl:param name="body"/>
    <xsl:call-template name="postfix">
      <xsl:with-param name="operator">lambda</xsl:with-param>
      <xsl:with-param name="operands">
	<xsl:call-template name="racket.s-exp">
	  <xsl:with-param name="content" select="$args"/>
	</xsl:call-template>
	<xsl:call-template name="space"/>
	<xsl:value-of select="$body"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
