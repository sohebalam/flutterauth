import 'package:authapp/shared/widgets.dart';
import 'package:authapp/style/contstants.dart';
import 'package:flutter/material.dart';

class VehicalTypePage extends StatefulWidget {
  final Function() onNext;

  VehicalTypePage({
    Key? key,
    required this.onSelect,
    required this.selectedVehical,
    required this.onNext,
  }) : super(key: key);

  final String selectedVehical;
  final Function onSelect;
  @override
  State<VehicalTypePage> createState() => _VehicalTypePageState();
}

class _VehicalTypePageState extends State<VehicalTypePage> {
  List<String> vehicalType = ['Economy', 'Business', 'Middle'];

  bool _isValid = false;
  String _selectedType = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'What type of vehicle is it?',
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
                      _selectedType = vehicalType[i];
                      _isValid = true;
                    });
                    widget.onSelect(_selectedType);
                  },
                  visualDensity: VisualDensity(vertical: -4),
                  title: Text(vehicalType[i]),
                  trailing: widget.selectedVehical == vehicalType[i]
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
              itemCount: vehicalType.length),
        ),
        ElevatedIconButton(
          isValid: _isValid,
          onNext: widget.onNext,
          text: 'vehicle  type',
        ),
      ],
    );
  }
}
