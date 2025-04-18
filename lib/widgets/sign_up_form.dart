import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final TextEditingController fullNameController;
  final VoidCallback onRegister;

  const SignUpForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.emailController,
    required this.fullNameController,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: usernameController,
          decoration: InputDecoration(labelText: "Tên đăng nhập"),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: "Mật khẩu"),
          obscureText: true,
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: "Email"),
        ),
        TextField(
          controller: fullNameController,
          decoration: InputDecoration(labelText: "Họ và tên"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onRegister,
          child: Text("Đăng ký"),
        ),
      ],
    );
  }
}
