import 'dart:developer';
import 'dart:io';

import 'package:authapp/home.dart';
import 'package:authapp/models/user_model.dart';
import 'package:authapp/shared/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  String userUid = '';
  var verId = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  dynamic credentials;

  var isProfileUploading = false.obs;

  bool isLoginAsDriver = false;

  storeUserCard(String number, String expiry, String cvv, String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cards')
        .add({'name': name, 'number': number, 'cvv': cvv, 'expiry': expiry});

    return true;
  }

  RxList userCards = [].obs;

  getUserCards() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cards')
        .snapshots()
        .listen((event) {
      userCards.value = event.docs;
    });
  }

  var myUser = UserModel().obs;

  // getUserInfo() {
  //   String? phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
  //   if (phoneNumber != null) {
  //     print(phoneNumber);
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(phoneNumber)
  //         .snapshots()
  //         .listen((event) {
  //       print('above here');
  //       myUser.value = UserModel.fromJson(event.data()!);
  //       print(myUser.value);
  //       print('here');
  //     }).onError((error) {
  //       print('Firestore error: $error');
  //     });
  //   }
  // }

  Future<void> getUserInfo() async {
    String? phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
    if (phoneNumber != null) {
      print(phoneNumber);
      try {
        var documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(phoneNumber)
            .get();
        if (documentSnapshot.exists) {
          print('above here');
          myUser.value = UserModel.fromJson(documentSnapshot.data()!);
          print(myUser.value);
          print('here');
        }
      } catch (error) {
        print('Firestore error: $error');
      }
    }
  }

  phoneAuth(String phone) async {
    try {
      credentials = null;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          log('Completed');
          credentials = credential;
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        forceResendingToken: resendTokenId,
        verificationFailed: (FirebaseAuthException e) {
          log('Failed');
          if (e.code == 'invalid-phone-number') {
            debugPrint('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          log('Code sent');
          verId = verificationId;
          resendTokenId = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      log("Error occured $e");
    }
  }

  uploadImage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance
        .ref()
        .child('users/$fileName'); // Modify this path/string as your need
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then(
      (value) {
        imageUrl = value;
        print("Download URL: $value");
      },
    );

    return imageUrl;
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
    String phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;

    FirebaseFirestore.instance.collection('users').doc(phoneNumber).set({
      'image': url_new,
      'name': name,
      'email': email,
      'role': 'driver',
      'profile': true
    }, SetOptions(merge: true)).then((value) {
      isProfileUploading(false);

      // Get.off(() => CarRegistrationTemplate());
    });
  }

  storeUserInfo(
    File? selectedImage,
    String name,
    String home,
    String business,
    String shop, {
    String url = '',
    LatLng? homeLatLng,
    LatLng? businessLatLng,
    LatLng? shoppingLatLng,
  }) async {
    String url_new = url;
    if (selectedImage != null) {
      url_new = await uploadImage(selectedImage);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url_new,
      'name': name,
      'home_address': home,
      'business_address': business,
      'shopping_address': shop,
      'home_latlng': GeoPoint(homeLatLng!.latitude, homeLatLng.longitude),
      'business_latlng':
          GeoPoint(businessLatLng!.latitude, businessLatLng.longitude),
      'shopping_latlng':
          GeoPoint(shoppingLatLng!.latitude, shoppingLatLng.longitude),
    }, SetOptions(merge: true)).then((value) {
      isProfileUploading(false);

      Get.to(() => HomeScreen());
    });
  }
}
