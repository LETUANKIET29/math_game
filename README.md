# Math Game - Ứng dụng học Toán tương tác cho học sinh tiểu học

![App Logo](assets/images/logo_beanmind.png)

## 📚 Giới thiệu

**Math Game** là một ứng dụng giáo dục tương tác dành cho học sinh tiểu học, giúp các em học toán thông qua các trò chơi hấp dẫn và thú vị. Ứng dụng được phát triển bằng Flutter và sử dụng Firebase để lưu trữ dữ liệu, cung cấp trải nghiệm học tập toán học vui nhộn và hiệu quả.

## 🎮 Các trò chơi

Ứng dụng bao gồm nhiều trò chơi giáo dục, mỗi trò chơi đều được thiết kế để dạy các khái niệm toán học khác nhau:

### 🌱 Happy Farm (Nông trại vui vẻ)
- **Level 1-3**: Giúp học sinh học toán qua các hoạt động chăm sóc nông trại
- Phù hợp cho việc học đếm và các phép tính cơ bản

### 🌊 Ocean Adventure (Cuộc phiêu lưu đại dương)
- **Level 1-3**: Khám phá đại dương cùng với các bài toán
- Giúp học sinh phát triển kỹ năng giải quyết vấn đề trong môi trường đại dương thú vị

### 🔢 Sorting Numbers (Sắp xếp số)
- **Level 1-3**: Học cách sắp xếp các số theo thứ tự
- Phát triển tư duy logic và kỹ năng so sánh số

### ♻️ Odd and Even (Chẵn lẻ)
- **Level 1-2**: Phân loại số chẵn và số lẻ
- Xây dựng nền tảng kiến thức về tính chất của các số

### 🛒 Shopping Game (Trò chơi đi chợ)
- Học toán thông qua tình huống mua sắm hàng ngày
- Phát triển kỹ năng tính toán tiền và làm quen với khái niệm kinh tế cơ bản

### 📝 Math Game (Trò chơi toán học)
- **Level 1-3**: Các bài tập toán học cơ bản với độ khó tăng dần
- Bao gồm phép cộng, trừ, nhân, chia phù hợp với từng độ tuổi

## 🔧 Công nghệ sử dụng

- **Flutter/Dart**: Framework phát triển đa nền tảng (Android, iOS, Web)
- **Firebase**: Lưu trữ dữ liệu và xác thực người dùng
- **GetX**: Quản lý trạng thái và điều hướng
- **Flame**: Framework game 2D cho Flutter
- **Lottie**: Hiển thị hoạt ảnh tương tác
- **Audioplayers**: Phát nhạc và âm thanh trong trò chơi

## ✨ Tính năng

- 🎯 Nhiều trò chơi giáo dục với nhiều cấp độ khó khác nhau
- 🎨 Giao diện thân thiện và hấp dẫn với trẻ em
- 🔊 Âm thanh và hiệu ứng hình ảnh sinh động
- 📊 Theo dõi tiến độ và thành tích học tập
- 🏆 Hệ thống phần thưởng và thành tích động viên
- 📱 Hoạt động trên nhiều thiết bị (điện thoại, máy tính bảng, web)

## 📲 Cài đặt và chạy dự án

### Yêu cầu
- Flutter SDK (phiên bản ^3.5.0)
- Dart SDK
- Android Studio/VS Code
- Firebase account

### Các bước cài đặt

1. Clone dự án từ GitHub:
```bash
git clone https://github.com/your-username/math_game.git
cd math_game
```

2. Cài đặt các dependencies:
```bash
flutter pub get
```

3. Kết nối Firebase:
   - Tạo dự án Firebase mới
   - Thêm các ứng dụng Android/iOS vào dự án
   - Tải tệp cấu hình và đặt vào vị trí phù hợp
   - Bật các dịch vụ Firebase cần thiết (Authentication, Firestore, Storage)

4. Chạy ứng dụng:
```bash
flutter run
```

## 🏗️ Cấu trúc dự án

```
lib/
├── configs/           # Cấu hình ứng dụng
├── constants/         # Hằng số và giá trị cố định
├── controller/        # Các controller (GetX)
├── core/              # Logic cốt lõi của ứng dụng
├── data/              # Lớp quản lý dữ liệu
├── domain/            # Logic nghiệp vụ
├── firebase/          # Cấu hình và dịch vụ Firebase
├── model/             # Các model dữ liệu
├── presentation/      # Các thành phần giao diện người dùng
├── routes/            # Định tuyến và điều hướng
├── screens/           # Các màn hình của ứng dụng
│   └── game/          # Các màn hình trò chơi
├── services/          # Các dịch vụ
├── utils/             # Tiện ích và hàm helper
├── widget/            # Các widget tái sử dụng
└── main.dart          # Điểm khởi đầu của ứng dụng
```

## 🤝 Đóng góp

Mọi đóng góp cho dự án đều được hoan nghênh! Vui lòng làm theo các bước sau để đóng góp:

1. Fork dự án
2. Tạo nhánh tính năng (`git checkout -b feature/amazing-feature`)
3. Commit các thay đổi (`git commit -m 'Add some amazing feature'`)
4. Push lên nhánh (`git push origin feature/amazing-feature`)
5. Mở Pull Request

## 📄 Giấy phép

Dự án này được cấp phép theo [MIT License](LICENSE).

## 📬 Liên hệ

Nếu bạn có bất kỳ câu hỏi hoặc đề xuất nào, vui lòng liên hệ:
- Email: your-email@example.com
- Website: [your-website.com](https://your-website.com)

---

Được phát triển với ❤️ bởi [Your Team/Company Name]
