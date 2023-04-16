import 'package:authapp/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:authapp/auth/sign_in.dart';

class SelectedRoleView extends StatelessWidget {
  const SelectedRoleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Visibility(
          visible: user != null, // Show AppBar only if user is logged in
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              IconButton(
                onPressed: () async {
                  await disconnect();
                  // if (user != null) {
                  //   // Handle user logout
                  // } else {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => SignInView(role: '')),
                  //   );
                  // }
                },
                icon: const Icon(Icons.logout_outlined),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Spare Park!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Please select your role:",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInView(role: 'driver'),
                  ),
                );
              },
              child: const Text(
                'I am a Driver',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInView(role: 'rider'),
                  ),
                );
              },
              child: const Text(
                'I am a Rider',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
