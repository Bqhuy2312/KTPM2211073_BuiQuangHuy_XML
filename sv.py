from lxml import etree

# Đọc file XML
tree = etree.parse("sv.xml")
root = tree.getroot()

def print_query(desc, xpath_expr):
    """Hàm in kết quả từng truy vấn"""
    result = root.xpath(xpath_expr)
    # Chuyển node thành text nếu có
    clean = []
    for r in result:
        if isinstance(r, etree._Element):
            clean.append(etree.tostring(r, pretty_print=True).decode().strip())
        else:
            clean.append(str(r))
    print(f"\n{desc}\n=> {clean}")

# 1. Lấy tất cả sinh viên
print("\n1. Tất cả sinh viên:")
students = root.xpath("/school/student")
for s in students:
    id_ = s.findtext("id")
    name = s.findtext("name")
    date = s.findtext("date")
    print(f"   - ID: {id_} | Tên: {name} | Ngày sinh: {date}")

# 2. Liệt kê tên tất cả sinh viên
print_query("2. Tên sinh viên", "/school/student/name/text()")

# 3. Lấy tất cả id của sinh viên
print_query("3. ID sinh viên", "/school/student/id/text()")

# 4. Ngày sinh SV01
print_query("4. Ngày sinh SV01", "/school/student[id='SV01']/date/text()")

# 5. Lấy các khóa học
print_query("5. Các khóa học", "/school/enrollment/course/text()")

# 6. Lấy toàn bộ thông tin của sinh viên đầu tiên
print_query("6. Thông tin SV đầu tiên", "/school/student[1]/*/text()")

# 7. Lấy mã sinh viên đăng ký khóa học Vatly203
print_query("7. Mã SV học Vatly203", "/school/enrollment[course='Vatly203']/studentRef/text()")

# 8. Lấy tên sinh viên học môn Toan101
print_query("8. Tên SV học Toan101", "/school/student[id=/school/enrollment[course='Toan101']/studentRef]/name/text()")

# 9. Lấy tên sinh viên học môn Vatly203
print_query("9. Tên SV học Vatly203", "/school/student[id=/school/enrollment[course='Vatly203']/studentRef]/name/text()")

# 10. Lấy ngày sinh SV01
print_query("10. Ngày sinh SV01", "/school/student[id='SV01']/date/text()")

# 11. Tên và ngày sinh SV sinh năm 1997
print_query("11. SV sinh năm 1997", "/school/student[starts-with(date,'1997')]/name/text()")

# 12. Tên SV có ngày sinh trước năm 1998
print_query("12. SV sinh trước 1998", "/school/student[number(substring(date,1,4)) < 1998]/name/text()")

# 13. Đếm tổng số sinh viên
total = int(root.xpath("count(/school/student)"))
print(f"\n13. Tổng số sinh viên: {total}")

# 14. Lấy tất cả sinh viên chưa đăng ký môn nào
print_query("14. SV chưa đăng ký", "/school/student[not(id = /school/enrollment/studentRef)]/name/text()")

# 15. Lấy phần tử <date> sau <name> của SV01
print_query("15. <date> sau <name> của SV01", "/school/student[id='SV01']/name/following-sibling::date/text()")

# 16. Lấy phần tử <id> trước <name> của SV02
print_query("16. <id> trước <name> của SV02", "/school/student[id='SV02']/name/preceding-sibling::id/text()")

# 17. Lấy toàn bộ <course> trong cùng enrollment với studentRef='SV03'
print_query("17. Môn học SV03", "/school/enrollment[studentRef='SV03']/course/text()")

# 18. Lấy sinh viên có họ là “Trần”
print_query("18. SV họ Trần", "/school/student[starts-with(name,'Trần')]/name/text()")

# 19. Lấy năm sinh của SV01
print_query("19. Năm sinh SV01", "substring(/school/student[id='SV01']/date,1,4)")
