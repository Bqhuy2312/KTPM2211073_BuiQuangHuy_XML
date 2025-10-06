from lxml import etree

# Đọc file XML
tree = etree.parse("quanlybanan.xml")
root = tree.getroot()

def print_query(desc, xpath_expr):
    result = root.xpath(xpath_expr)
    # Làm sạch kết quả
    cleaned = [r.text if isinstance(r, etree._Element) else str(r) for r in result]
    print(f"\n{desc}\n=> {cleaned}")

# 1. Lấy tất cả bàn
print("1️⃣ Tất cả bàn:")
for ban in root.xpath("/QUANLY/BANS/BAN"):
    soban = ban.findtext("SOBAN")
    tenban = ban.findtext("TENBAN")
    print(f"   - Số bàn: {soban} | Tên bàn: {tenban}")

# 2. Lấy tất cả nhân viên
print("\n2️⃣ Tất cả nhân viên:")
for nv in root.xpath("/QUANLY/NHANVIENS/NHANVIEN"):
    manv = nv.findtext("MANV")
    tennv = nv.findtext("TENV")
    print(f"   - Mã NV: {manv} | Tên NV: {tennv}")

# 3. Lấy tất cả tên món
print_query("3. Tất cả tên món", "/QUANLY/MONS/MON/TENMON/text()")

# 4. Lấy tên nhân viên có mã NV02
print_query("4. Tên nhân viên NV02", "/QUANLY/NHANVIENS/NHANVIEN[MANV='NV02']/TENV/text()")

# 5. Lấy tên và số điện thoại của nhân viên NV03
print_query("5. Tên và SDT nhân viên NV03", "/QUANLY/NHANVIENS/NHANVIEN[MANV='NV03']/TENV/text() | /QUANLY/NHANVIENS/NHANVIEN[MANV='NV03']/SDT/text()")

# 6. Lấy tên món có giá > 50,000
print_query("6. Món có giá > 50000", "/QUANLY/MONS/MON[GIA>50000]/TENMON/text()")

# 7. Lấy số bàn của hóa đơn HD03
print_query("7. Số bàn của hóa đơn HD03", "/QUANLY/HOADONS/HOADON[SOHD='HD03']/SOBAN/text()")

# 8. Lấy tên món có mã M02
print_query("8. Tên món M02", "/QUANLY/MONS/MON[MAMON='M02']/TENMON/text()")

# 9. Lấy ngày lập của hóa đơn HD03
print_query("9. Ngày lập HD03", "/QUANLY/HOADONS/HOADON[SOHD='HD03']/NGAYLAP/text()")

# 10. Lấy tất cả mã món trong hóa đơn HD01
print_query("10. Mã món trong HD01", "/QUANLY/HOADONS/HOADON[SOHD='HD01']/CTHDS/CTHD/MAMON/text()")

# 11. Lấy tên món trong hóa đơn HD01
print_query("11. Tên món trong HD01", "/QUANLY/MONS/MON[MAMON=/QUANLY/HOADONS/HOADON[SOHD='HD01']/CTHDS/CTHD/MAMON]/TENMON/text()")

# 12. Lấy tên nhân viên lập hóa đơn HD02
print_query("12. Tên nhân viên lập hóa đơn HD02", "/QUANLY/NHANVIENS/NHANVIEN[MANV=/QUANLY/HOADONS/HOADON[SOHD='HD02']/MANV]/TENV/text()")

# 13. Đếm số bàn
print(f"\n13. Tổng số bàn: {int(root.xpath('count(/QUANLY/BANS/BAN)'))}")

# 14. Đếm số hóa đơn lập bởi NV01
print(f"14. Số hóa đơn lập bởi NV01: {int(root.xpath('count(/QUANLY/HOADONS/HOADON[MANV=\"NV01\"])'))}")

# 15. Tên món có trong hóa đơn của bàn số 2
print_query("15. Tên món trong hóa đơn của bàn 2",
            "/QUANLY/MONS/MON[MAMON=/QUANLY/HOADONS/HOADON[SOBAN=2]/CTHDS/CTHD/MAMON]/TENMON/text()")

# 16. Tất cả nhân viên từng lập hóa đơn cho bàn số 3
print_query("16. Nhân viên lập hóa đơn cho bàn 3",
            "/QUANLY/NHANVIENS/NHANVIEN[MANV=/QUANLY/HOADONS/HOADON[SOBAN=3]/MANV]/TENV/text()")

# 17. Tất cả hóa đơn mà nhân viên nữ lập
print_query("17. Hóa đơn nhân viên nữ lập",
            "/QUANLY/HOADONS/HOADON[MANV=/QUANLY/NHANVIENS/NHANVIEN[GIOITINH='Nữ']/MANV]/SOHD/text()")

# 18. Tất cả nhân viên từng phục vụ bàn số 1
print_query("18. Nhân viên phục vụ bàn 1",
            "/QUANLY/NHANVIENS/NHANVIEN[MANV=/QUANLY/HOADONS/HOADON[SOBAN=1]/MANV]/TENV/text()")

# 19. Món được gọi nhiều hơn 1 lần trong các hóa đơn
print_query("19. Món được gọi >1 lần",
            "/QUANLY/MONS/MON[MAMON=/QUANLY/HOADONS/HOADON/CTHDS/CTHD[SOLUONG>1]/MAMON]/TENMON/text()")

# 20. Tên bàn + ngày lập hóa đơn tương ứng SOHD='HD02'
tenban = root.xpath("/QUANLY/BANS/BAN[SOBAN=/QUANLY/HOADONS/HOADON[SOHD='HD02']/SOBAN]/TENBAN/text()")
ngaylap = root.xpath("/QUANLY/HOADONS/HOADON[SOHD='HD02']/NGAYLAP/text()")
print(f"\n20️. Tên bàn + ngày lập HD02:\n=> {tenban[0]} - {ngaylap[0]}")