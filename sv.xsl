<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" encoding="UTF-8" indent="yes" />

	<xsl:template match="/">
		<html>
			<head>
				<title>Kết quả truy vấn sinh viên</title>
				<style>
					body { font-family: Arial; margin: 20px; }
					table { border-collapse: collapse; width: 80%; margin-bottom: 40px; }
					th, td { border: 1px solid #444; padding: 6px; text-align: left; }
					th { background-color: #e6e6e6; }
					h2 { color: #003366; }
				</style>
			</head>
			<body>
				<h1>Kết quả truy vấn từ file sv.xml</h1>

				<!-- 1 -->
				<h2>1. Liệt kê thông tin của tất cả sinh viên (Mã, Họ tên)</h2>
				<table>
					<tr>
						<th>Mã SV</th>
						<th>Họ tên</th>
					</tr>
					<xsl:apply-templates select="school/student" mode="listAll" />
				</table>

				<!-- 2 -->
				<h2>2. Danh sách sinh viên (Mã, Tên, Điểm) - Điểm từ cao đến thấp</h2>
				<table>
					<tr>
						<th>Mã SV</th>
						<th>Họ tên</th>
						<th>Điểm</th>
					</tr>
					<xsl:apply-templates select="school/student">
						<xsl:sort select="grade" data-type="number" order="descending" />
					</xsl:apply-templates>
				</table>

				<!-- 3 -->
				<h2>3. Danh sách sinh viên (STT, Họ tên, Ngày sinh) - Sắp theo tháng sinh</h2>
				<table>
					<tr>
						<th>STT</th>
						<th>Họ tên</th>
						<th>Ngày sinh</th>
					</tr>
					<xsl:apply-templates select="school/student" mode="byMonth">
						<xsl:sort select="substring(date,6,2)" data-type="number" order="ascending" />
					</xsl:apply-templates>
				</table>

				<!-- 4 -->
				<h2>4. Danh sách các khóa học có sinh viên học (sắp xếp theo tên khóa học)</h2>
				<table>
					<tr>
						<th>Mã KH</th>
						<th>Tên khóa học</th>
					</tr>
					<xsl:apply-templates select="school/course">
						<xsl:sort select="name" order="ascending" />
					</xsl:apply-templates>
				</table>

				<!-- 5 -->
				<h2>5. Danh sách sinh viên đăng ký khóa học "Hóa học 201"</h2>
				<table>
					<tr>
						<th>Mã SV</th>
						<th>Họ tên</th>
						<th>Khóa học</th>
					</tr>
					<xsl:apply-templates
						select="school/enrollment[courseRef=/school/course[name='Hóa học 201']/id]"
						mode="hoaHoc" />
				</table>

				<!-- 6 -->
				<h2>6. Danh sách sinh viên sinh năm 1997</h2>
				<table>
					<tr>
						<th>Mã SV</th>
						<th>Họ tên</th>
						<th>Ngày sinh</th>
					</tr>
					<xsl:apply-templates select="school/student[starts-with(date,'1997')]"
						mode="byYear" />
				</table>

				<!-- 7 -->
				<h2>7. Danh sách sinh viên họ "Trần"</h2>
				<table>
					<tr>
						<th>Mã SV</th>
						<th>Họ tên</th>
					</tr>
					<xsl:apply-templates select="school/student[starts-with(name,'Trần')]"
						mode="bySurname" />
				</table>

			</body>
		</html>
	</xsl:template>

	<!-- 1 -->
	<xsl:template match="student" mode="listAll">
		<tr>
			<td>
				<xsl:value-of select="id" />
			</td>
			<td>
				<xsl:value-of select="name" />
			</td>
		</tr>
	</xsl:template>

	<!-- 2 -->
	<xsl:template match="student">
		<tr>
			<td>
				<xsl:value-of select="id" />
			</td>
			<td>
				<xsl:value-of select="name" />
			</td>
			<td>
				<xsl:value-of select="grade" />
			</td>
		</tr>
	</xsl:template>

	<!-- 3 -->
	<xsl:template match="student" mode="byMonth">
		<tr>
			<td>
				<xsl:value-of select="position()" />
			</td>
			<td>
				<xsl:value-of select="name" />
			</td>
			<td>
				<xsl:value-of select="date" />
			</td>
		</tr>
	</xsl:template>

	<!-- 4 -->
	<xsl:template match="course">
		<tr>
			<td>
				<xsl:value-of select="id" />
			</td>
			<td>
				<xsl:value-of select="name" />
			</td>
		</tr>
	</xsl:template>

	<!-- 5 -->
	<xsl:template match="enrollment" mode="hoaHoc">
		<xsl:variable name="sid" select="studentRef" />
		<tr>
			<td>
				<xsl:value-of select="$sid" />
			</td>
			<td>
				<xsl:value-of select="/school/student[id=$sid]/name" />
			</td>
			<td>Hóa học 201</td>
		</tr>
	</xsl:template>

	<!-- 6 -->
	<xsl:template match="student" mode="byYear">
		<tr>
			<td>
				<xsl:value-of select="id" />
			</td>
			<td>
				<xsl:value-of select="name" />
			</td>
			<td>
				<xsl:value-of select="date" />
			</td>
		</tr>
	</xsl:template>

	<!-- 7 -->
	<xsl:template match="student" mode="bySurname">
		<tr>
			<td>
				<xsl:value-of select="id" />
			</td>
			<td>
				<xsl:value-of select="name" />
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>