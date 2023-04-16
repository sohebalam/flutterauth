import 'package:authapp/auth/sign_in.dart';
import 'package:authapp/functions.dart';
import 'package:authapp/style/contstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({Key? key}) : super(key: key);

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            onPressed: () async {
              await disconnect();
              // if (user != null) {
              // } else {
              //   Get.to(SignInView(
              //     role: '',
              //   ));
              // }
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('Driver Home')],
        ),
      ),
    );
  }
}
