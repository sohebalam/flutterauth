import 'package:authapp/shared/widgets.dart';
import 'package:authapp/style/contstants.dart';
import 'package:flutter/material.dart';

class VehicalMakePage extends StatefulWidget {
  VehicalMakePage(
      {Key? key,
      required this.onSelect,
      required this.selectedVehical,
      required this.onNext})
      : super(key: key);

  final String selectedVehical;
  final Function onSelect;
  final Function() onNext;

  @override
  State<VehicalMakePage> createState() => _VehicalMakePageState();
}

class _VehicalMakePageState extends State<VehicalMakePage> {
  List<String> vehicalMake = [
    'Honda',
    'GMC',
    'Ford',
    'Kia',
    'Leusx',
  ];

  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'What make of vehicle is it ?',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              itemBuilder: (ctx, i) {
                return ListTile(
                  onTap: () {
                    setState(() {
                      _isValid = true;
                    });
                    widget.onSelect(vehicalMake[i]);
                  },
                  visualDensity: VisualDensity(vertical: -4),
                  title: Text(vehicalMake[i]),
                  trailing: widget.selectedVehical == vehicalMake[i]
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                );
              },
              itemCount: vehicalMake.length),
        ),
        ElevatedIconButton(
          isValid: _isValid,
          onNext: widget.onNext,
          text: 'vehicle make',
        ),
      ],
    );
  }
}
