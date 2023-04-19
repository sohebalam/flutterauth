import 'package:authapp/shared/widgets.dart';
import 'package:authapp/style/contstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicalNumberPage extends StatefulWidget {
  const VehicalNumberPage(
      {Key? key, required this.controller, required this.onNext})
      : super(key: key);

  final TextEditingController controller;
  final Function() onNext;

  // bool notValid = true;

  @override
  State<VehicalNumberPage> createState() => _VehicalNumberPageState();
}

class _VehicalNumberPageState extends State<VehicalNumberPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Vehicle Number ?',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 4) {
                if (value == null || value.isEmpty || value.length < 4) {
                  _showSnackbar('Please enter a valid vehicle number', context);
                  return '';
                }
              }
              return null;
            },
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: 'Enter Vehicle Number',
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 18.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onNext();
                  }
                },
                child: Container(
                  height: 56.0,
                  width: 56.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: CircleBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showSnackbar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    ),
  );
}
