import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  final String user;
  final String email;

  const AccountScreen({
    super.key,
    required this.user,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thông tin tài khoản")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("👤 Người dùng: $user", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("📧 Email: $email", style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Quay lại màn hình trước (hoặc logout)
              },
              child: Text("Đăng xuất"),
            ),
          ],
        ),
      ),
    );
  }
}
