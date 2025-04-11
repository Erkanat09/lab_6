import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'user_info_page.dart';
import '../model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // временный пользователь
  User dummyUser = User(
    name: "N/A",
    phone: "N/A",
    email: "N/A",
    story: "N/A",
  );

  @override
  Widget build(BuildContext context) {
    final pages = [
      RegistrationPage(onUserRegistered: (user) {
        setState(() {
          dummyUser = user;
          _currentIndex = 1;
        });
      }),
      UserInfoPage(userInfo: dummyUser),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.app_registration), label: "Register"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "User Info"),
        ],
      ),
    );
  }
}
