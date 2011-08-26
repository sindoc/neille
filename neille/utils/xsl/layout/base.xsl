<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:l="http://sina.khakbaz.com/2010/neille/ns/layout"
    exclude-result-prefixes="l"
    version="1.0">

  <xsl:import href="../common/racket.xsl"/>
  <xsl:import href="../common/utils.xsl"/>
  <xsl:import href="custom.xsl"/>

  <xsl:output 
      encoding="UTF-8" 
      method="text" 
      standalone="yes"
      indent="no"
      omit-xml-declaration="yes"
      media-type="text/plain"/>

  <xsl:strip-space elements="l:*"/>

  <xsl:variable name="default-width">
    <xsl:choose>
      <xsl:when test="/l:*/@default-width">
	<xsl:value-of select="/l:*/@default-width"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$col.default.width"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="default-height">
    <xsl:choose>
      <xsl:when test="/l:*/@default-height">
	<xsl:value-of select="/l:*/@default-height"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$row.default.height"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="onbx">
    <xsl:choose>
      <xsl:when test="/l:*/@onbx">
	<xsl:value-of select="/l:*/@onbx"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$orthonormal.basis.x.default"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="onby">
    <xsl:choose>
      <xsl:when test="/l:*/@onby">
	<xsl:value-of select="/l:*/@onby"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$orthonormal.basis.y.default"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="table-width" select="/l:*/@width"/>
  <xsl:variable name="table-height" select="/l:*/@height"/>
  <xsl:variable name="table-width-" select="$table-width * $onbx"/>
  <xsl:variable name="table-height-" select="$table-height * $onby"/>

  <xsl:template name="output.head.content">
    <xsl:call-template name="racket.common.head.content"/>
    <xsl:call-template name="racket.require">
      <xsl:with-param name="specs">
	<xsl:call-template name="newline-indent-1"/>
	<xsl:value-of select="$racket.require.games.cards"/>
	<xsl:call-template name="newline-indent-1"/>
	<xsl:call-template name="require.view"/>
	<xsl:call-template name="newline-indent-1"/>
	<xsl:call-template name="require.model"/>
	<xsl:if test="/l:*/l:config/l:param">
	  <xsl:call-template name="newline-indent-1"/>
	  <xsl:call-template name="require.config"/>
	</xsl:if>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="margin"/>
    <xsl:call-template name="racket.provide">
      <xsl:with-param name="specs">
	<xsl:call-template name="racket.all-defined-out"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="margin"/>
    <xsl:call-template name="racket.define">
      <xsl:with-param name="id" select="$card.table.instance.id"/>
      <xsl:with-param name="value">
	<xsl:call-template name="racket.games.cards.make-table">
	  <xsl:with-param name="w" select="$table-width"/>
	  <xsl:with-param name="h" select="$table-height"/>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="margin"/>
  </xsl:template>

  <xsl:template match="/">
    <xsl:call-template name="output.head.content"/>
    <xsl:apply-templates/>
    <xsl:call-template name="output.foot.content"/>
  </xsl:template>

  <xsl:template match="l:layout">
    <xsl:apply-templates/>
    <xsl:call-template name="margin"/>
    <xsl:apply-templates mode="add-to-table"/>
    <xsl:call-template name="margin"/>
    <xsl:apply-templates mode="define-models"/>
    <xsl:call-template name="margin"/>
    <xsl:apply-templates mode="define-views"/>
    <xsl:call-template name="margin"/>
    <xsl:call-template name="init"/>
    <xsl:call-template name="margin"/>
  </xsl:template>

  <xsl:template name="init">
    <xsl:call-template name="racket.define.proc">
      <xsl:with-param name="name" select="$init.proc.id"/>
      <xsl:with-param name="body">
	<xsl:apply-templates mode="register-views"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="l:config"></xsl:template>
  
  <xsl:template name="construct-param-name">
    <xsl:value-of select="concat(@name, '-')"/>
  </xsl:template>

  <xsl:template match="l:row">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="calculate-region-x">
    <xsl:variable 
	name="relative-origin"
	select="$onbx * sum(../../preceding-sibling::l:col/@width)
		+
		$onbx * $default-width
		      * count(../../preceding-sibling::l:col[not(@width)])
		      "/>
    <xsl:variable 
	name="relative-offset"
	select="$onbx * sum(preceding-sibling::l:col/@width) 
		+ 
		$onbx * $default-width
		      * count(preceding-sibling::l:col[not(@width)])
		      "/>
    <xsl:value-of select="number($relative-origin + $relative-offset)"/>
  </xsl:template>

  <xsl:template name="calculate-region-y">
    <xsl:variable 
	name="relative-origin"
	select="$onby * sum(../../../preceding-sibling::l:row/@height)
		+
		$onby * $default-height
		      * count(../../../preceding-sibling::l:row[not(@height)])
		      "/>
    <xsl:variable 
	name="relative-offset"
	select="$onby * sum(../preceding-sibling::l:row/@height) 
		+ 
		$onby * $default-height  
		      * count(../preceding-sibling::l:row[not(@height)]) 
		      "/>
    <xsl:value-of select="number($relative-origin + $relative-offset)"/>
  </xsl:template>

  <xsl:template name="derive-width">
    <xsl:param name="node" select="."/>
    <xsl:choose>
      <xsl:when test="local-name($node) = 'col'">
	<xsl:choose>
	  <xsl:when test="$node/@width">
	    <xsl:value-of select="number($onbx * $node/@width)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of 
		select="number($onbx * $default-width)"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="number(0)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="derive-height">
    <xsl:param name="node" select="."/>
    <xsl:choose>
      <xsl:when test="local-name($node/..) = 'row'">
	<xsl:choose>
	  <xsl:when test="$node/../../../@height">
	    <xsl:value-of select="number($onby * $node/../../../@height)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:choose>
	      <xsl:when test="$node/../@height">
		<xsl:value-of select="number($onby * $node/../@height)"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of 
		    select="number($onby * $default-height)"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="number(0)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="calculate-region-w">
    <xsl:call-template name="derive-width"/>
  </xsl:template>

  <xsl:template name="calculate-region-h">
    <xsl:call-template name="derive-height"/>
  </xsl:template>

  <xsl:template match="l:col[@id]|l:col/l:row/l:col">
    <xsl:variable name="x">
      <xsl:call-template name="calculate-region-x"/>
    </xsl:variable>
    <xsl:variable name="y">
      <xsl:call-template name="calculate-region-y"/>
    </xsl:variable>
    <xsl:variable name="label">
      <xsl:call-template name="format-racket-value">
	<xsl:with-param name="type">string</xsl:with-param>
	<xsl:with-param name="value">
	  <xsl:choose>
	    <xsl:when test="@label">
	      <xsl:value-of select="@label"/>
	    </xsl:when>
	    <xsl:otherwise></xsl:otherwise>
	  </xsl:choose>
	</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="w">
      <xsl:call-template name="calculate-region-w">
	<xsl:with-param name="x" select="$x"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="h">
      <xsl:call-template name="calculate-region-h">
	<xsl:with-param name="y" select="$y"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="racket.define">
      <xsl:with-param name="id">
	<xsl:call-template name="construct-region-id"/>
      </xsl:with-param>
      <xsl:with-param name="value">
	<xsl:choose>
	  <xsl:when test="@constructor = 
			  $racket.games.cards.make-background-region-">
	    <xsl:call-template 
		name="racket.games.cards.make-background-region">
	      <xsl:with-param name="x" select="$x"/>
	      <xsl:with-param name="y" select="$y"/>
	      <xsl:with-param name="w" select="$w"/>
	      <xsl:with-param name="h" select="$h"/>
	      <xsl:with-param name="paint-callback">
		<xsl:call-template name="eval-reference">
		  <xsl:with-param name="datum" select="@callback"/>
		</xsl:call-template>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:call-template name="racket.games.cards.make-region">
	      <xsl:with-param name="label" select="$label"/>
	      <xsl:with-param name="x" select="$x"/>
	      <xsl:with-param name="y" select="$y"/>
	      <xsl:with-param name="w" select="$w"/>
	      <xsl:with-param name="h" select="$h"/>
	    </xsl:call-template>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="newline"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="send-message-to-table">
    <xsl:param name="message"/>
    <xsl:param name="args"/>
    <xsl:call-template name="racket.send">
      <xsl:with-param name="object" select="$card.table.instance.id"/>
      <xsl:with-param name="message" select="$message"/>
      <xsl:with-param name="args" select="$args"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="add-region-to-table">
    <xsl:param name="region-id"/>
    <xsl:call-template name="send-message-to-table">
      <xsl:with-param name="message">add-region</xsl:with-param>
      <xsl:with-param name="args" select="$region-id"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="l:col[@id]|l:col/l:row/l:col" mode="add-to-table">
    <xsl:call-template name="add-region-to-table">
      <xsl:with-param name="region-id">
	<xsl:call-template name="construct-region-id"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="newline"/>
    <xsl:apply-templates mode="add-to-table"/>
  </xsl:template>

  <xsl:template match="l:col[@id]" mode="define-models">
    <xsl:call-template name="racket.define">
      <xsl:with-param name="id">
	<xsl:call-template name="construct-model-id"/>
      </xsl:with-param>
      <xsl:with-param name="value">
	<xsl:call-template name="eval-reference">
	  <xsl:with-param name="datum" select="@model"/>
	  <xsl:with-param name="alternative">
	    <xsl:call-template name="racket.new">
	      <xsl:with-param name="class">
		<xsl:call-template name="construct-model-class-name"/>
	      </xsl:with-param>
	      <xsl:with-param name="args">
		<xsl:call-template name="racket.make-named-arg">
		  <xsl:with-param name="argname">cards</xsl:with-param>
		  <xsl:with-param name="arg" select="$racket.null"/>
		</xsl:call-template>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="newline"/>
  </xsl:template>

  <xsl:template match="l:col[@id]" mode="define-views">
    <xsl:call-template name="racket.define">
      <xsl:with-param name="id">
	<xsl:call-template name="construct-view-id"/>
      </xsl:with-param>
      <xsl:with-param name="value">
	<xsl:call-template name="racket.new">
	  <xsl:with-param name="class">
	    <xsl:call-template name="construct-view-class-name"/>
	  </xsl:with-param>
	  <xsl:with-param name="args">
	    <xsl:call-template name="newline-indent-1"/>
	    <xsl:call-template name="racket.make-named-arg">
	      <xsl:with-param name="argname">root</xsl:with-param>
	      <xsl:with-param name="arg" select="$card.table.instance.id"/>
	    </xsl:call-template>
	    <xsl:call-template name="newline-indent-1"/>
	    <xsl:call-template name="racket.make-named-arg">
	      <xsl:with-param name="argname">region</xsl:with-param>
	      <xsl:with-param name="arg">
		<xsl:call-template name="construct-region-id"/>
	      </xsl:with-param>
	    </xsl:call-template>
	    <xsl:call-template name="newline-indent-1"/>
	    <xsl:call-template name="racket.make-named-arg">
	      <xsl:with-param name="argname">model</xsl:with-param>
	      <xsl:with-param name="arg">
		<xsl:call-template name="construct-model-id"/>
	      </xsl:with-param>
	    </xsl:call-template>
	    <xsl:call-template name="newline-indent-1"/>
	    <xsl:call-template name="racket.make-named-arg">
	      <xsl:with-param name="argname">children</xsl:with-param>
	      <xsl:with-param name="arg">
		<xsl:choose>
		  <xsl:when test="l:row/l:col">
		    <xsl:call-template name="newline-indent-2"/>
		    <xsl:call-template name="racket.list">
		      <xsl:with-param name="elements">
			<xsl:for-each select="l:row/l:col">
			  <xsl:call-template name="construct-region-id"/>
			  <xsl:call-template name="newline-indent-3"/>
			</xsl:for-each>
		      </xsl:with-param>
		    </xsl:call-template>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="$racket.null"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="newline"/>
  </xsl:template>

  <xsl:template match="l:col[@id]" mode="register-views">
    <xsl:call-template name="racket.send">
      <xsl:with-param name="object">
	<xsl:call-template name="construct-model-id"/>
      </xsl:with-param>
      <xsl:with-param name="message">add-observer</xsl:with-param>
      <xsl:with-param name="args">
	<xsl:call-template name="construct-view-id"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="newline"/>
  </xsl:template>
  
  <xsl:template name="show-table">
    <xsl:call-template name="send-message-to-table">
      <xsl:with-param name="message">show</xsl:with-param>
      <xsl:with-param name="args" select="$racket.true.value"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="eval-reference">
    <xsl:param name="datum"/>
    <xsl:param name="alternative" select="$datum"/>
    <xsl:choose>
      <xsl:when test="starts-with($datum, $global.param.prefix)">
	<xsl:value-of select="substring-after($datum, $global.param.prefix)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$alternative"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
