import 'dart:async';
import 'package:authapp/models/user_model.dart';
import 'package:authapp/style/contstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:authapp/shared/functions.dart';

class VerificationOtp extends StatefulWidget {
  const VerificationOtp({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
    required this.role,
  }) : super(key: key);

  final String verificationId;
  final String phoneNumber;
  final String role;

  @override
  State<VerificationOtp> createState() => _VerificationOtpState();
}

class _VerificationOtpState extends State<VerificationOtp> {
  String smsCode = "";
  bool loading = false;
  bool resend = false;
  int count = 20;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    decompte();
  }

  void dispose() {
    timer.cancel();
    super.dispose();
  }

  late Timer timer;

  void decompte() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (count < 1) {
        timer.cancel();
        count = 20;
        resend = true;
        if (mounted) {
          setState(() {});
        }
        return;
      }
      count--;
      setState(() {});
    });
  }

  void onResendSmsCode() {
    resend = false;
    setState(() {});
    authWithPhoneNumber(widget.phoneNumber, onCodeSend: (verificationId, v) {
      loading = false;
      decompte();
      setState(() {});
    }, onAutoVerify: (v) async {
      await _auth.signInWithCredential(v);
      Navigator.of(context).pop();
    }, onFailed: (e) {
      loading = false;
      setState(() {});
      print("The code is wrong");
    }, autoRetrieval: (v) {});
  }

  void onVerifySmsCode() async {
    loading = true;
    setState(() {});

    // Validate the OTP
    await validateOtp(
      smsCode,
      widget.verificationId,
    );

    // Update the verification status in the database
    UserModel? user = await updateStatus(widget.phoneNumber, widget.role);
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.phoneNumber)
        .get();
    final data = snapshot.data() as Map<String, dynamic>;
    final name = data['name'] as String?;
    final profile = data['profile'] as bool?;
    final role = data['role'] as String?;

    await routeOnLogin(widget.role, profile, context);

    loading = true;
    setState(() {});
    // Navigator.of(context).pop();
    print("Successfully verified");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(
                  "Verification Otp",
                  style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  "Phone number: ${widget.phoneNumber}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  "Check your messages to validate",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Pinput(
                  length: 6,
                  onChanged: (value) {
                    smsCode =
                        value; // update the smsCode variable with the current value entered by the user
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: onVerifySmsCode,
                        child: const Text("Verify"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.primaryColor),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(150, 50)),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(fontSize: 18)),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                resend
                    ? ElevatedButton(
                        onPressed: onResendSmsCode,
                        child: const Text("Resend"),
                      )
                    : Text(
                        "Resend code in ${count}s",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
