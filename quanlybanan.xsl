<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
        <html>
            <head>
                <title>Quản lý bàn ăn - Truy vấn</title>
                <style>
                    body { font-family: Arial; margin: 20px; }
                    table { border-collapse: collapse; width: 85%; margin-bottom: 40px; }
                    th, td { border: 1px solid #444; padding: 6px; text-align: left; }
                    th { background: #ddd; }
                    h2 { color: #003366; }
                </style>
            </head>
            <body>
                <h1>Kết quả truy vấn dữ liệu Quản lý bàn ăn</h1>

                <!-- 1 -->
                <h2>1. Danh sách tất cả các bàn</h2>
                <table>
                    <tr>
                        <th>STT</th>
                        <th>Số bàn</th>
                        <th>Tên bàn</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/BANS/BAN" mode="ban" />
                </table>

                <!-- 2 -->
                <h2>2. Danh sách các nhân viên</h2>
                <table>
                    <tr>
                        <th>STT</th>
                        <th>Mã NV</th>
                        <th>Tên NV</th>
                        <th>Giới tính</th>
                        <th>SĐT</th>
                        <th>Địa chỉ</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/NHANVIENS/NHANVIEN" mode="nhanvien" />
                </table>

                <!-- 3 -->
                <h2>3. Danh sách các món ăn</h2>
                <table>
                    <tr>
                        <th>STT</th>
                        <th>Mã món</th>
                        <th>Tên món</th>
                        <th>Giá</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/MONS/MON" mode="mon" />
                </table>

                <!-- 4 -->
                <h2>4. Thông tin nhân viên NV02</h2>
                <table>
                    <tr>
                        <th>Mã NV</th>
                        <th>Tên NV</th>
                        <th>Giới tính</th>
                        <th>SĐT</th>
                        <th>Địa chỉ</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/NHANVIENS/NHANVIEN[MANV='NV02']" mode="nv02" />
                </table>

                <!-- 5 -->
                <h2>5. Danh sách các món ăn có giá &gt; 50,000</h2>
                <table>
                    <tr>
                        <th>STT</th>
                        <th>Mã món</th>
                        <th>Tên món</th>
                        <th>Giá</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/MONS/MON[GIA &gt; 50000]" mode="mon" />
                </table>

                <!-- 6 -->
                <h2>6. Thông tin hóa đơn HD03</h2>
                <table>
                    <tr>
                        <th>Tên nhân viên</th>
                        <th>Số bàn</th>
                        <th>Ngày lập</th>
                        <th>Tổng tiền</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/HOADONS/HOADON[SOHD='HD03']" mode="hd03" />
                </table>

                <!-- 7 -->
                <h2>7. Tên các món ăn trong hóa đơn HD02</h2>
                <table>
                    <tr>
                        <th>STT</th>
                        <th>Tên món</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/HOADONS/HOADON[SOHD='HD02']/CTHDS/CTHD"
                        mode="mon_hd02" />
                </table>

                <!-- 8 -->
                <h2>8. Tên nhân viên lập hóa đơn HD02</h2>
                <table>
                    <tr>
                        <th>Tên nhân viên</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/HOADONS/HOADON[SOHD='HD02']" mode="nv_hd02" />
                </table>

                <!-- 9 -->
                <h2>9. Đếm số bàn</h2>
                <p>Tổng số bàn: <xsl:value-of select="count(QUANLY/BANS/BAN)" /></p>

                <!-- 10 -->
                <h2>10. Đếm số hóa đơn lập bởi NV01</h2>
                <p>Số hóa đơn lập bởi NV01: <xsl:value-of
                        select="count(QUANLY/HOADONS/HOADON[MANV='NV01'])" /></p>

                <!-- 11 -->
                <h2>11. Danh sách các món từng bán cho bàn số 2</h2>
                <table>
                    <tr>
                        <th>STT</th>
                        <th>Tên món</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/HOADONS/HOADON[SOBAN='2']/CTHDS/CTHD"
                        mode="mon_ban2" />
                </table>

                <!-- 12 -->
                <h2>12. Danh sách nhân viên từng lập hóa đơn cho bàn số 3</h2>
                <table>
                    <tr>
                        <th>STT</th>
                        <th>Tên nhân viên</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/HOADONS/HOADON[SOBAN='3']" mode="nv_ban3" />
                </table>

                <!-- 13 -->
                <h2>13. Các món ăn được gọi nhiều hơn 1 lần trong các hóa đơn</h2>
                <table>
                    <tr>
                        <th>STT</th>
                        <th>Tên món</th>
                        <th>Tổng số lần gọi</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/MONS/MON" mode="mon_nhieu_lan" />
                </table>

                <!-- 14 -->
                <h2>14. Thông tin chi tiết tính tiền cho hóa đơn HD04</h2>
                <table>
                    <tr>
                        <th>Mã món</th>
                        <th>Tên món</th>
                        <th>Đơn giá</th>
                        <th>Thành tiền</th>
                    </tr>
                    <xsl:apply-templates select="QUANLY/HOADONS/HOADON[SOHD='HD04']/CTHDS/CTHD"
                        mode="cthd_hd04" />
                </table>

            </body>
        </html>
    </xsl:template>

    <!-- 1 -->
    <xsl:template match="BAN" mode="ban">
        <tr>
            <td>
                <xsl:value-of select="position()" />
            </td>
            <td>
                <xsl:value-of select="SOBAN" />
            </td>
            <td>
                <xsl:value-of select="TENBAN" />
            </td>
        </tr>
    </xsl:template>

    <!-- 2 -->
    <xsl:template match="NHANVIEN" mode="nhanvien">
        <tr>
            <td>
                <xsl:value-of select="position()" />
            </td>
            <td>
                <xsl:value-of select="MANV" />
            </td>
            <td>
                <xsl:value-of select="TENV" />
            </td>
            <td>
                <xsl:value-of select="GIOITINH" />
            </td>
            <td>
                <xsl:value-of select="SDT" />
            </td>
            <td>
                <xsl:value-of select="DIACHI" />
            </td>
        </tr>
    </xsl:template>

    <!-- 3 -->
    <xsl:template match="MON" mode="mon">
        <tr>
            <td>
                <xsl:value-of select="position()" />
            </td>
            <td>
                <xsl:value-of select="MAMON" />
            </td>
            <td>
                <xsl:value-of select="TENMON" />
            </td>
            <td>
                <xsl:value-of select="GIA" />
            </td>
        </tr>
    </xsl:template>

    <!-- 4 -->
    <xsl:template match="NHANVIEN" mode="nv02">
        <tr>
            <td>
                <xsl:value-of select="MANV" />
            </td>
            <td>
                <xsl:value-of select="TENV" />
            </td>
            <td>
                <xsl:value-of select="GIOITINH" />
            </td>
            <td>
                <xsl:value-of select="SDT" />
            </td>
            <td>
                <xsl:value-of select="DIACHI" />
            </td>
        </tr>
    </xsl:template>

    <!-- 6 -->
    <xsl:template match="HOADON" mode="hd03">
        <xsl:variable name="nv" select="MANV" />
        <tr>
            <td>
                <xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=$nv]/TENV" />
            </td>
            <td>
                <xsl:value-of select="SOBAN" />
            </td>
            <td>
                <xsl:value-of select="NGAYLAP" />
            </td>
            <td>
                <xsl:value-of select="TONGTIEN" />
            </td>
        </tr>
    </xsl:template>

    <!-- 7 -->
    <xsl:template match="CTHD" mode="mon_hd02">
        <tr>
            <td>
                <xsl:value-of select="position()" />
            </td>
            <td>
                <xsl:value-of select="/QUANLY/MONS/MON[MAMON=current()/MAMON]/TENMON" />
            </td>
        </tr>
    </xsl:template>

    <!-- 8 -->
    <xsl:template match="HOADON" mode="nv_hd02">
        <xsl:variable name="nv" select="MANV" />
        <tr>
            <td>
                <xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=$nv]/TENV" />
            </td>
        </tr>
    </xsl:template>

    <!-- 11 -->
    <xsl:template match="CTHD" mode="mon_ban2">
        <tr>
            <td>
                <xsl:value-of select="position()" />
            </td>
            <td>
                <xsl:value-of select="/QUANLY/MONS/MON[MAMON=current()/MAMON]/TENMON" />
            </td>
        </tr>
    </xsl:template>

    <!-- 12 -->
    <xsl:template match="HOADON" mode="nv_ban3">
        <tr>
            <td>
                <xsl:value-of select="position()" />
            </td>
            <td>
                <xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=current()/MANV]/TENV" />
            </td>
        </tr>
    </xsl:template>

    <!-- 13 -->
    <xsl:template match="MON" mode="mon_nhieu_lan">
        <xsl:variable name="ma" select="MAMON" />
        <xsl:variable name="tong" select="sum(/QUANLY/HOADONS/HOADON/CTHDS/CTHD[MAMON=$ma]/SOLUONG)" />
        <xsl:if test="$tong &gt; 1">
            <tr>
                <td>
                    <xsl:value-of select="position()" />
                </td>
                <td>
                    <xsl:value-of select="TENMON" />
                </td>
                <td>
                    <xsl:value-of select="$tong" />
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <!-- 14 -->
    <xsl:template match="CTHD" mode="cthd_hd04">
        <xsl:variable name="mon" select="MAMON" />
        <xsl:variable name="ten" select="/QUANLY/MONS/MON[MAMON=$mon]/TENMON" />
        <xsl:variable name="gia" select="/QUANLY/MONS/MON[MAMON=$mon]/GIA" />
        <xsl:variable name="sl" select="SOLUONG"/>
        <tr>
            <td>
                <xsl:value-of select="$mon" />
            </td>
            <td>
                <xsl:value-of select="$ten" />
            </td>
            <td>
                <xsl:value-of select="$gia" />
            </td>
            <td>
                <xsl:value-of select="$gia * $sl" />
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>