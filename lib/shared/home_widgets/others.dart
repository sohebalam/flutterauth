import 'package:authapp/shared/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AuthController authController = Get.put(AuthController());

Widget buildCurrentLocationIcon(BuildContext context) {
  return Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 30, right: 8),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.my_location,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget buildProfileTile(BuildContext context) {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Obx(() => authController.myUser.value.name == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            width: Get.width,
            height: Get.width * 0.5,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(color: Colors.white70),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: authController.myUser.value.image == null
                          ? DecorationImage(
                              image: AssetImage('assets/person.png'),
                              fit: BoxFit.fill)
                          : DecorationImage(
                              image: NetworkImage(
                                  authController.myUser.value.image!),
                              fit: BoxFit.fill)),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Good Morning, ',
                            style:
                                TextStyle(color: Colors.black, fontSize: 14)),
                        TextSpan(
                            text: authController.myUser.value.name,
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                    Text(
                      "Where are you going?",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                )
              ],
            ),
          )),
  );
}

Widget buildNotificationIcon(BuildContext context) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 30, left: 8),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.notifications,
          color: Color(0xffC3CDD6),
        ),
      ),
    ),
  );
}

Widget buildBottomSheet(BuildContext context) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: Get.width * 0.8,
      height: 25,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 4,
                blurRadius: 10)
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12), topLeft: Radius.circular(12))),
      child: Center(
        child: Container(
          width: Get.width * 0.6,
          height: 4,
          color: Colors.black45,
        ),
      ),
    ),
  );
}
