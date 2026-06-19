# 🔐 Amazon Macie - Phát hiện Dữ liệu Nhạy cảm trong S3 & Gửi Cảnh báo qua Email

## 📋 Mô tả Dự án

Dự án Terraform này triển khai một hệ thống tự động để:

1. **Tạo S3 Bucket** và upload file chứa dữ liệu nhạy cảm mẫu (số thẻ tín dụng, SSN).
2. **Kích hoạt Amazon Macie** và chạy Classification Job để quét S3 Bucket.
3. **Thiết lập EventBridge Rule** bắt sự kiện khi Macie phát hiện dữ liệu nhạy cảm.
4. **Gửi cảnh báo qua SNS → Email** khi có phát hiện.

## 🏗️ Kiến trúc Hệ thống

```
User uploads file → S3 Bucket
                      ↓
              Amazon Macie (Classification Job)
                      ↓
                  Findings
                      ↓
              EventBridge Rule (event pattern: aws.macie / Macie Finding)
                      ↓
                  SNS Topic
                      ↓
                Email Alert
```

## 📂 Cấu trúc Thư mục

```
.
├── providers.tf              # Cấu hình AWS Provider
├── variables.tf              # Biến đầu vào (region, email, bucket prefix)
├── s3.tf                     # S3 Bucket + upload file nhạy cảm mẫu
├── macie.tf                  # Kích hoạt Macie + Classification Job
├── sns.tf                    # SNS Topic + Email Subscription
├── eventbridge.tf            # EventBridge Rule + Target
├── outputs.tf                # Outputs (bucket name, SNS ARN, job ID)
├── dummy_sensitive_data.csv  # File dữ liệu nhạy cảm giả lập
└── README.md                 # Hướng dẫn sử dụng
```

## ⚙️ Yêu cầu Cài đặt

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0.0
- [AWS CLI](https://aws.amazon.com/cli/) đã cấu hình với credentials (`aws configure`)
- Tài khoản AWS có quyền truy cập các dịch vụ: S3, Macie, SNS, EventBridge, IAM

## 🚀 Hướng dẫn Triển khai

### Bước 1: Clone Repository

```bash
git clone https://github.com/<your-username>/CDO_Security_Rabbitboy.git
cd CDO_Security_Rabbitboy
```

### Bước 2: Khởi tạo Terraform

```bash
terraform init
```

### Bước 3: Kiểm tra cấu hình

```bash
terraform validate
terraform plan -var="alert_email=email_cua_ban@gmail.com"
```

### Bước 4: Triển khai hạ tầng

```bash
terraform apply -var="alert_email=email_cua_ban@gmail.com" -auto-approve
```

> ⚠️ **Quan trọng**: Thay `email_cua_ban@gmail.com` bằng địa chỉ email thật của bạn.

### Bước 5: Xác nhận Email Subscription

Sau khi `terraform apply` thành công:
1. Kiểm tra hộp thư đến (Inbox) của email bạn đã nhập.
2. Tìm email từ **AWS Notifications** với tiêu đề **"AWS Notification - Subscription Confirmation"**.
3. Nhấn vào link **"Confirm subscription"** trong email.

### Bước 6: Chờ Macie quét và tạo Findings

- Macie Classification Job sẽ tự động chạy ngay sau khi được tạo.
- Thời gian quét: **khoảng 5–15 phút** tùy thuộc vào kích thước dữ liệu.
- Sau khi quét xong, Macie sẽ tạo **Findings** cho các dữ liệu nhạy cảm được phát hiện (Credit Card, SSN).

### Bước 7: Chụp ảnh màn hình

#### 📸 Ảnh 1 – Macie Findings (Detection)
1. Truy cập **AWS Console** → Tìm dịch vụ **Amazon Macie**.
2. Nhấn vào **Findings** ở menu bên trái.
3. Bạn sẽ thấy danh sách các Finding (ví dụ: `SensitiveData:S3Object/Credentials`, `SensitiveData:S3Object/Financial`).
4. **Chụp ảnh màn hình** trang này.

#### 📸 Ảnh 2 – Email Alert
1. Kiểm tra hộp thư đến của email bạn đã đăng ký.
2. Tìm email cảnh báo từ **AWS Notifications** chứa nội dung JSON của Macie Finding.
3. **Chụp ảnh màn hình** email này.

## 🧹 Dọn dẹp Tài nguyên

Sau khi hoàn thành lab, hãy xoá toàn bộ tài nguyên để tránh phát sinh chi phí:

```bash
terraform destroy -var="alert_email=email_cua_ban@gmail.com" -auto-approve
```

## 📤 Đẩy code lên GitHub (Public)

```bash
# Khởi tạo Git repository
git init
git add .
git commit -m "feat: Terraform Macie sensitive data detection and email alert"

# Tạo repository Public trên GitHub, sau đó:
git remote add origin https://github.com/<your-username>/CDO_Security_Rabbitboy.git
git branch -M main
git push -u origin main
```

> 📌 **Lưu ý**: Đảm bảo repository trên GitHub được đặt ở chế độ **Public**.

## 📝 Ghi chú

- Amazon Macie có **30 ngày dùng thử miễn phí** cho tài khoản mới.
- File `dummy_sensitive_data.csv` chứa dữ liệu **hoàn toàn giả lập**, không phải thông tin thật.
- Nếu không nhận được email cảnh báo, hãy kiểm tra thư mục **Spam/Junk**.

## 👤 Tác giả

- **Dự án**: CDO Security Lab - Amazon Macie
- **Mục đích**: Hands-on Lab bảo mật AWS
