import 'package:flutter/material.dart';
import '../model/user.dart';

class UserInfoPage extends StatelessWidget {
  final User userInfo;

  const UserInfoPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${userInfo.name}", style: const TextStyle(fontSize: 18)),
            Text("Phone: ${userInfo.phone}", style: const TextStyle(fontSize: 18)),
            Text("Email: ${userInfo.email}", style: const TextStyle(fontSize: 18)),
            Text("Story: ${userInfo.story}", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
