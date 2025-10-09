from lxml import etree
import mysql.connector

# 1. Parse XML và XSD
xml_file = "TMDT.xml"
xsd_file = "TMDT.xsd"

# Đọc file XML
xml_tree = etree.parse(xml_file)

# Kiểm tra hợp lệ với XSD
with open(xsd_file, 'rb') as f:
    xmlschema_doc = etree.parse(f)
    xmlschema = etree.XMLSchema(xmlschema_doc)

if xmlschema.validate(xml_tree):
    print(" XML hợp lệ với XSD.")
else:
    print(" XML không hợp lệ!")
    for error in xmlschema.error_log:
        print(error.message)
    exit()

# 2. Kết nối MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Qu@ngHuy2312",     
    database="TMDT"
)

cursor = conn.cursor()

#3. Tạo bảng nếu chưa có
cursor.execute("""
CREATE TABLE IF NOT EXISTS categories (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS products (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    category_id VARCHAR(10),
    FOREIGN KEY (category_id) REFERENCES categories(id)
)
""")

# 4. Lấy dữ liệu bằng XPath
categories = xml_tree.xpath("//categories/category")
products = xml_tree.xpath("//products/product")

# 5. Insert dữ liệu vào MySQL
# -- Bảng Categories --
for cat in categories:
    cat_id = cat.get("id")
    cat_name = cat.text.strip()
    cursor.execute("""
        INSERT INTO categories (id, name) VALUES (%s, %s)
        ON DUPLICATE KEY UPDATE name = VALUES(name)
    """, (cat_id, cat_name))

# -- Bảng Products --
for prod in products:
    prod_id = prod.get("id")
    category_ref = prod.get("categoryRef")
    name = prod.findtext("name").strip()
    price = float(prod.findtext("price").strip())
    stock = int(prod.findtext("stock").strip())

    cursor.execute("""
        INSERT INTO products (id, name, price, stock, category_id)
        VALUES (%s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE name = VALUES(name),
                                price = VALUES(price),
                                stock = VALUES(stock),
                                category_id = VALUES(category_id)
    """, (prod_id, name, price, stock, category_ref))

# Lưu thay đổi
conn.commit()
print(" Dữ liệu đã được lưu thành công vào MySQL!")

# Đóng kết nối
cursor.close()
conn.close()
