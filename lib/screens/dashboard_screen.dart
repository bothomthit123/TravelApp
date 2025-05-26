import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'account_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String username;
  final String email;
  final int accountId; // 🔥 Thêm accountId
  const DashboardScreen({super.key, required this.username, required this.email, required this.accountId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    print("Username: ${widget.username}");
    print("Email: ${widget.email}");
    print("AccountId: ${widget.accountId}");
    _pages = [
      _buildWelcomeScreen(),
      MapScreen(accountId: widget.accountId),
    AccountScreen(accountId: widget.accountId, user: widget.username , email: widget.username),
    ];
  }

  Widget _buildWelcomeScreen() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/185289.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Smart Travel',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black54,
                    offset: Offset(3, 3),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Xin chào, ${widget.username}!',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 10, color: Colors.black)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
