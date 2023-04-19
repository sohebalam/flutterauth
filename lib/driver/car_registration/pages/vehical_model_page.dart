import 'package:authapp/shared/widgets.dart';
import 'package:authapp/style/contstants.dart';
import 'package:flutter/material.dart';

class VehicalModelPage extends StatefulWidget {
  VehicalModelPage({
    Key? key,
    required this.onSelect,
    required this.selectedModel,
    required this.onNext,
  }) : super(key: key);

  final String selectedModel;
  final Function onSelect;
  final Function() onNext;

  @override
  State<VehicalModelPage> createState() => _VehicalModelPageState();
}

class _VehicalModelPageState extends State<VehicalModelPage> {
  List<String> vehicalModel = [
    'Amanti',
    'Borrego',
    'Cadenza',
    'Forte',
    'K900',
    'Niro',
    'Optima',
    'Rio',
    'Rondo',
  ];

  bool _isValid = false;
  String _selectedType = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'What model of vehicle is it ?',
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
                    _selectedType = vehicalModel[i];
                    widget.onSelect(_selectedType);
                    _isValid = true; // update _isValid
                  });
                },
                visualDensity: VisualDensity(vertical: -4),
                title: Text(vehicalModel[i]),
                trailing: widget.selectedModel == vehicalModel[i] ||
                        _selectedType == vehicalModel[i]
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
                    : null,
              );
            },
            itemCount: vehicalModel.length,
          ),
        ),
        ElevatedIconButton(
          isValid: _isValid,
          onNext: widget.onNext,
        ),
      ],
    );
  }
}
