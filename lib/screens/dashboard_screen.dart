import 'package:flutter/material.dart';
import 'map_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String username;
  final String email;

  const DashboardScreen({super.key, required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Travel"),
        backgroundColor: const Color(0xFFA577AD),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: Text(email),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/travel_logo.png'),
              ),
              decoration: const BoxDecoration(color: Color(0xFFA577AD)),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Bản đồ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  MapScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text("Chào mừng bạn đến với Smart Travel"),
      ),
    );
  }
}
