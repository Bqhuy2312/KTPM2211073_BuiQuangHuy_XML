<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" encoding="UTF-8" />

    <xsl:template match="/"> [ <xsl:apply-templates select="school/student" mode="json" /> ] </xsl:template>

    <xsl:template match="student" mode="json"> {
        "mã":"<xsl:value-of select="normalize-space(id)" />",
        "họ tên":"<xsl:value-of select="normalize-space(name)" />", 
        "ngày sinh":"<xsl:value-of select="normalize-space(date)" />"
    }<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:template>

</xsl:stylesheet>