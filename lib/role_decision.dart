import 'package:authapp/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:authapp/auth/sign_in.dart';

import 'package:get/get.dart';

class SelectedRoleView extends StatelessWidget {
  SelectedRoleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Spare Park!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Please select your role:",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            DecisionButton('assets/driver.png', 'I am a Driver', () {
              Get.to(() => SignInView(role: 'driver'));
            }, Get.width * 0.6),
            const SizedBox(
              height: 20,
            ),
            DecisionButton('assets/customer.png', 'I am a Rider', () {
              Get.to(() => SignInView(role: 'rider'));
            }, Get.width * 0.6),
          ],
        ),
      ),
    );
  }
}
