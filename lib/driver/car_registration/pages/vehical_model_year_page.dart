import 'dart:developer';

import 'package:authapp/shared/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VehicalModelYearPage extends StatefulWidget {
  VehicalModelYearPage({Key? key, required this.onSelect, required this.onNext})
      : super(key: key);

  final Function onSelect;
  final Function() onNext;

  @override
  State<VehicalModelYearPage> createState() => _VehicalModelYearPageState();
}

class _VehicalModelYearPageState extends State<VehicalModelYearPage> {
  List<dynamic> years = [
    'Please select',
    2000,
    2001,
    2002,
    2003,
    2004,
    2005,
    2006,
    2007,
    2008,
    2009,
    2010,
  ];

  bool _isValid = false;
  dynamic _selectedYear = 0;

  _VehicalModelYearPageState() {
    _isValid = false;
    _selectedYear = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'What is the vehicle model year ?',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: Center(
          child: CupertinoPicker.builder(
            childCount: years.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                  child: Text(
                years[index].toString(),
                style: TextStyle(fontWeight: FontWeight.w600),
              ));
            },
            itemExtent: 100,
            onSelectedItemChanged: (value) {
              setState(() {
                _selectedYear = years[value];
                _isValid = true;
              });
              widget.onSelect(_selectedYear);
            },
          ),
        )),
        ElevatedIconButton(
          isValid: _isValid,
          onNext: widget.onNext,
        ),
      ],
    );
  }
}
