import 'dart:developer';

import 'package:authapp/driver/car_registration/car_registration_template.dart';
import 'package:authapp/driver/driver_home.dart';
import 'package:authapp/driver/driver_profile.dart';
import 'package:authapp/models/user_model.dart';
import 'package:authapp/profile/profile_setting.dart';
import 'package:authapp/role_decision.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
// import 'package:green_taxi/views/profile_settings.dart';
import 'package:path/path.dart' as Path;

import '../home.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

final _auth = FirebaseAuth.instance;
void authWithPhoneNumber(String phone,
    {required Function(String value, int? value1) onCodeSend,
    required Function(PhoneAuthCredential value) onAutoVerify,
    required Function(FirebaseAuthException value) onFailed,
    required Function(String value) autoRetrieval}) async {
  _auth.verifyPhoneNumber(
    phoneNumber: phone,
    timeout: const Duration(seconds: 20),
    verificationCompleted: onAutoVerify,
    verificationFailed: onFailed,
    codeSent: onCodeSend,
    codeAutoRetrievalTimeout: autoRetrieval,
  );
}

Future<void> validateOtp(String smsCode, String verificationId) async {
  try {
    final _credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    await _auth.signInWithCredential(_credential);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'invalid-verification-code') {
      print('The verification code provided is invalid.');
    }
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  } catch (e) {
    print("Error signing in with credential: $e");
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

Future<void> disconnect() async {
  print("her");
  await _auth.signOut();
  Get.offAll(() => SelectedRoleView());
}

User? get user => _auth.currentUser;

Future<String> uploadImage(File image) async {
  try {
    String imageUrl = '';
    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance.ref().child('users/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then(
      (value) {
        imageUrl = value;
        print("Download URL: $value");
      },
    );

    return imageUrl;
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    throw e;
  }
}

Future<void> storeUserInfo(File selectedImage, String name, String home,
    String business, String shop, BuildContext context) async {
  try {
    String url = await uploadImage(selectedImage);
    String phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;
    await FirebaseFirestore.instance.collection('users').doc(phoneNumber).set({
      'image': url,
      'name': name,
      'home_address': home,
      'business_address': business,
      'shopping_address': shop,
      'profile': true,
    }, SetOptions(merge: true)); // add SetOptions with merge option set to true
  } catch (exception) {
    Fluttertoast.showToast(msg: exception.toString());
    throw exception;
  }
}

Future<UserModel?> updateStatus(String phoneNumber, String role) async {
  final userDocRef =
      FirebaseFirestore.instance.collection("users").doc(phoneNumber);

  try {
    final userDoc = await userDocRef.get();
    if (!userDoc.exists) {
      final newUser = UserModel(
        role: role,
        phoneNumber: null,
      );
      // print(role);
      // debugger();
      final newUserMap = newUser.toMap();
      await userDocRef.set(newUserMap);

      // Retrieve the newly created user document
      final newUserDoc = await userDocRef.get();

      // Retrieve the user model from the user document and print the role to console
      final user = UserModel.fromMap(newUserDoc.data()!);
      // print(user.role);
      return user; // user was created
    }

    // Retrieve the user model from the user document and print the role to console
    final user = UserModel.fromMap(userDoc.data()!);
    // print(user.role);
    return user; // user already existed
  } catch (e) {
    // Handle the error
  }
  return null;
}

Future<void> routeOnLogin(String? role, bool? profile, String? car_register,
    BuildContext context) async {
  if (role == 'rider') {
    if (profile == false || profile == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileSettingScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  } else if (role == 'driver') {
    if (profile == false || profile == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DriverProfileSetup()),
      );
    } else if (car_register == false || car_register == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CarRegistrationTemplate()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DriverHome()),
      );
    }
  }
}

storeDriverProfile(
  File? selectedImage,
  String name,
  String email, {
  String url = '',
}) async {
  String url_new = url;
  if (selectedImage != null) {
    url_new = await uploadImage(selectedImage);
  }
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore.instance.collection('users').doc(uid).set(
      {'image': url_new, 'name': name, 'email': email, 'isDriver': true},
      SetOptions(merge: true)).then((value) {
    Get.off(() => CarRegistrationTemplate());
  });
}

Future<UserModel?> updateUserStatus(String phoneNumber, String role) async {
  final userDocRef =
      FirebaseFirestore.instance.collection("users").doc(phoneNumber);

  try {
    final userDoc = await userDocRef.get();
    if (!userDoc.exists) {
      final newUser = UserModel(
        role: role,
        phoneNumber: null,
      );
      final newUserMap = newUser.toMap();
      await userDocRef.set(newUserMap);

      // Retrieve the newly created user document
      final newUserDoc = await userDocRef.get();

      // Retrieve the user model from the user document and print the role to console
      final user = UserModel.fromMap(newUserDoc.data()!);
      print(user.role);
      return user; // user was created
    }

    // Retrieve the user model from the user document and print the role to console
    final user = UserModel.fromMap(userDoc.data()!);
    print(user.role);
    return user; // user already existed
  } catch (e) {
    // Handle the error
  }
  return null;
}

Future<bool> uploadCarEntry(Map<String, dynamic> carData) async {
  bool isUploaded = false;
  print("here");
  String? phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(phoneNumber)
      .set(carData, SetOptions(merge: true));

  isUploaded = true;
  print("upload");
  return isUploaded;
}
