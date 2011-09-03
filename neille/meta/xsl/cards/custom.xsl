<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://sina.khakbaz.com/2010/neille/ns/card"
    exclude-result-prefixes="c"
    version="1.0">

  <xsl:import href="../common/racket.xsl"/>
  <xsl:import href="../common/utils.xsl"/>

  <xsl:output encoding="UTF-8" method="text" indent="no"/>

  <xsl:template match="@tier|c:set" mode="generate-card-fields"></xsl:template>

  <xsl:template match="//c:default/c:card" mode="generate-card-fields">
    <xsl:text>id </xsl:text>
    <xsl:apply-templates mode="generate-card-fields"/>
    <xsl:apply-templates select="@*" mode="generate-card-fields"/>
    <xsl:text>image</xsl:text>
  </xsl:template>

  <xsl:template match="c:*|@*" mode="generate-card-fields">
    <xsl:value-of select="concat(local-name(.), ' ')"/>
  </xsl:template>

  <xsl:param name="card.image">1</xsl:param>
  <xsl:param name="card.image.basename.prefix">WS-</xsl:param>
  <xsl:param name="card.image.basename.suffix"></xsl:param>
  <xsl:param name="card.image.path.prefix">neille/cards/img/</xsl:param>
  <xsl:param name="card.image.path.suffix">.jpg</xsl:param>
  <xsl:param name="card.image.param.name">image</xsl:param>
  <xsl:param name="card.image.type">jpeg</xsl:param>
  <xsl:param name="card.image.scales">108x150 orig</xsl:param>
  <xsl:param name="card.image.scale.separator" select="$spc"/>
  <xsl:param name="card.image.struct.id">ws-card-graphic</xsl:param>
  <xsl:param name="card.image.struct.constructor.id"
	     select="concat('make-', $card.image.struct.id)"/>
  <xsl:param name="card.image.struct.options" 
	     select="$racket.default.struct.options"/>
  <xsl:param name="card.image.struct.ordered.fields">type basename path-prefix 
  path-suffix scales</xsl:param>

  <xsl:param name="meta.image.struct.id">meta-image</xsl:param>
  <xsl:param name="meta.image.struct.options" 
	     select="$racket.default.struct.options"/>
  <xsl:param name="meta.image.struct.ordered.fields">dirname filename 
  type</xsl:param>
  <xsl:param name="meta.image.struct.constructor.id"
	     select="concat('make-', $meta.image.struct.id)"/>

  <xsl:param name="card.registrar.name">register-card</xsl:param>
  <xsl:param name="card.id.param.name">id</xsl:param>
  <xsl:param name="card.struct.id">ws-card</xsl:param>
  <xsl:param name="card.struct.constructor.id"
	     select="concat('make-', $card.struct.id)"/>
  <xsl:param name="card.struct.options" 
	     select="$racket.default.struct.options"/>
  <xsl:param name="card.struct.field.list.id" 
	     select="concat($card.struct.id, '-fields')"/>
  <xsl:param name="card.collection.name">ws-cards</xsl:param>

  <xsl:template name="call.struct.generate.fields"/>

  <xsl:template name="output.head.content">
    <xsl:call-template name="racket.common.head.content"/>
    <xsl:call-template name="racket.provide">
      <xsl:with-param name="specs">
	<xsl:call-template name="racket.all-defined-out"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="margin"/>
  </xsl:template>

  <xsl:template name="output.foot.content"></xsl:template>

</xsl:stylesheet>