# 📚 Library Management System (LMS) - Enterprise Database Design

> **Đồ án Cơ sở dữ liệu** | Xây dựng hệ thống quản lý thư viện quy mô lớn với cấu trúc dữ liệu chuẩn hóa và tối ưu.

![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Standard](https://img.shields.io/badge/Database_Normalization-3NF-blue?style=for-the-badge)
![Author](https://img.shields.io/badge/Author-Nguyen_Huy_Khang-orange?style=for-the-badge)

---

## 💡 Tổng quan giải pháp
Dự án này giải quyết bài toán quản lý vận hành cho các thư viện đại học có lưu lượng mượn trả lớn. Thay vì chỉ quản lý đầu sách đơn thuần, hệ thống tập trung vào việc **theo dõi vòng đời của từng bản sao (Copy ID)**, quản lý **vị trí lưu kho vật lý** và tự động hóa **quy trình xử lý vi phạm**.

## 🏗 Kiến trúc Cơ sở dữ liệu (Database Architecture)

Hệ thống được thiết kế cực kỳ chi tiết với **29 thực thể**, chia thành 4 phân vùng chức năng chính:

### 1. Quản trị Kho & Tài sản (Inventory Management)
* **Phân cấp:** Thư viện ➔ Kệ sách ➔ Vị trí (Slot).
* **Quản lý:** Tình trạng vật lý của từng cuốn sách (Mới, cũ, hỏng), theo dõi chi tiết phiếu nhập kho và nhà cung cấp.

### 2. Quản lý Độc giả & Đặc quyền (User & Membership)
* **Cơ chế:** Phân quyền theo loại độc giả (Sinh viên, Giảng viên, Nghiên cứu sinh).
* **Ràng buộc:** Mỗi loại độc giả có quy định riêng về: *Số lượng sách tối đa* và *Thời gian mượn tối đa*.

### 3. Nghiệp vụ Mượn - Trả (Circulation & Workflow)
* **Gia hạn:** Cho phép độc giả gia hạn thời gian mượn dựa trên lý do thực tế.
* **Kiểm kho:** Quy trình kiểm kê định kỳ đối chiếu giữa dữ liệu hệ thống và thực tế tại kệ.

### 4. Xử lý Vi phạm & Tài chính (Compliance & Finance)
* **Phạt quá hạn:** Tự động hóa tính phí phạt dựa trên số ngày trễ hạn.
* **Báo mất:** Quy trình bồi thường và xử lý hồ sơ mất sách chuyên nghiệp.

---

## 📊 Sơ đồ thực thể liên kết (ERD Highlight)
* **Chuẩn hóa:** Đạt chuẩn **3NF** giúp loại bỏ dư thừa và đảm bảo tính toàn vẹn tham chiếu (`Foreign Key Constraints`).
* **Tính toàn vẹn:** Sử dụng `CHECK CONSTRAINT` cho các trạng thái sách và `DEFAULT` cho các mốc thời gian thực hiện nghiệp vụ.

---

## 🛠 Công nghệ & Kỹ thuật sử dụng
* **T-SQL (Transact-SQL):** Sử dụng các truy vấn lồng, phép Join phức tạp và thống kê dữ liệu.
* **Database Design:** Kỹ thuật thiết kế Schema đảm bảo khả năng mở rộng (Scalability).
* **Version Control:** Quản lý mã nguồn SQL qua Git/GitHub.

## 📈 Truy vấn Nghiệp vụ tiêu biểu
Hệ thống hỗ trợ các báo cáo quản trị phức tạp:
* Thống kê tần suất mượn để tối ưu hóa việc nhập đầu sách mới.
* Phân tích hiệu suất làm việc của thủ thư trong các ca trực.
* Tổng kết doanh thu tiền phạt và phí đền bù định kỳ.

---

## 👥 Thông tin tác giả
* **Họ và tên:** Nguyễn Huy Khang (MSSV: 6551071043)
* **Khoa:** Công nghệ thông tin - Trường Đại học Giao thông Vận tải (UTC)
* **Giảng viên hướng dẫn:** ThS. Phạm Thị Miên

---
*Developed with ❤️ for Database Course @ UTC*
