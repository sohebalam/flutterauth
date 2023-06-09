import 'dart:io';

import 'package:authapp/driver/car_registration/pages/location_page.dart';
import 'package:authapp/driver/car_registration/pages/upload_document_page.dart';
import 'package:authapp/driver/car_registration/pages/vehical_color_page.dart';
import 'package:authapp/driver/car_registration/pages/vehical_make.dart';
import 'package:authapp/driver/car_registration/pages/vehical_model_page.dart';
import 'package:authapp/driver/car_registration/pages/vehical_model_year_page.dart';
import 'package:authapp/driver/car_registration/pages/vehical_number_page.dart';
import 'package:authapp/driver/car_registration/pages/vehical_type_page.dart';
import 'package:authapp/driver/car_registration/pages/verification_pending_screen.dart';
import 'package:authapp/shared/auth_controller.dart';
import 'package:authapp/shared/functions.dart';
import 'package:authapp/shared/widgets.dart';
import 'package:authapp/style/contstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarRegistrationTemplate extends StatefulWidget {
  const CarRegistrationTemplate({Key? key}) : super(key: key);

  @override
  State<CarRegistrationTemplate> createState() =>
      _CarRegistrationTemplateState();
}

class _CarRegistrationTemplateState extends State<CarRegistrationTemplate> {
  String selectedLocation = '';
  String selectedVehicalType = '';
  String selectedVehicalMake = '';
  String selectedVehicalModel = '';
  String selectModelYear = '';
  PageController pageController = PageController();
  TextEditingController vehicalNumberController = TextEditingController();
  String vehicalColor = '';
  File? document;

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(text: 'Register Car'),
      body: Column(
        children: [
          IntroWidget(
              title: 'Car Registration',
              subtitle: 'Complete the process detail'),
          Container(
            // height: Get.height * 0.30,
            child: const SizedBox(
              height: 20,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PageView(
                onPageChanged: (int page) {
                  currentPage = page;
                },
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  LocationPage(
                    selectedLocation: selectedLocation,
                    onSelect: (String location) {
                      setState(() {
                        selectedLocation = location;
                      });
                    },
                    onNext: () {
                      if (currentPage < 7) {
                        pageController.animateToPage(currentPage + 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else {
                        uploadDriverCarEntry();
                      }
                    },
                  ),
                  VehicalTypePage(
                    selectedVehical: selectedVehicalType,
                    onSelect: (String vehicalType) {
                      setState(() {
                        selectedVehicalType = vehicalType;
                      });
                    },
                    onNext: () {
                      if (currentPage < 7) {
                        pageController.animateToPage(currentPage + 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else {
                        uploadDriverCarEntry();
                      }
                    },
                  ),
                  VehicalMakePage(
                    selectedVehical: selectedVehicalMake,
                    onSelect: (String vehicalMake) {
                      setState(() {
                        selectedVehicalMake = vehicalMake;
                      });
                    },
                    onNext: () {
                      if (currentPage < 7) {
                        pageController.animateToPage(currentPage + 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else {
                        uploadDriverCarEntry();
                      }
                    },
                  ),
                  VehicalModelPage(
                    selectedModel: selectedVehicalModel,
                    onSelect: (String vehicalModel) {
                      setState(() {
                        selectedVehicalModel = vehicalModel;
                      });
                    },
                    onNext: () {
                      if (currentPage < 7) {
                        pageController.animateToPage(currentPage + 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else {
                        uploadDriverCarEntry();
                      }
                    },
                  ),
                  VehicalModelYearPage(
                    onSelect: (int year) {
                      setState(() {
                        selectModelYear = year.toString();
                      });
                    },
                    onNext: () {
                      if (currentPage < 7) {
                        pageController.animateToPage(currentPage + 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else {
                        uploadDriverCarEntry();
                      }
                    },
                  ),
                  VehicalNumberPage(
                    controller: vehicalNumberController,
                    onNext: () {
                      if (currentPage < 7) {
                        pageController.animateToPage(currentPage + 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else {
                        uploadDriverCarEntry();
                      }
                    },
                  ),
                  VehicalColorPage(
                    onColorSelected: (String selectedColor) {
                      vehicalColor = selectedColor;
                    },
                    onNext: () {
                      if (currentPage < 7) {
                        pageController.animateToPage(currentPage + 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else {
                        uploadDriverCarEntry();
                      }
                    },
                  ),
                  UploadDocumentPage(
                    onImageSelected: (File? image) {
                      document = image;
                    },
                    onNext: () {
                      if (currentPage < 7) {
                        pageController.animateToPage(currentPage + 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else {
                        uploadDriverCarEntry();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  var isUploading = false.obs;

  void uploadDriverCarEntry() async {
    isUploading(true);
    String imageUrl = await Get.put(AuthController()).uploadImage(document!);

    Map<String, dynamic> carData = {
      'country': selectedLocation,
      'vehicle_type': selectedVehicalType,
      'vehicle_make': selectedVehicalMake,
      'vehicle_model': selectedVehicalModel,
      'vehicle_year': selectModelYear,
      'vehicle_number': vehicalNumberController.text.trim(),
      'vehicle_color': vehicalColor,
      'document': imageUrl
    };

    await uploadCarEntry(carData);
    isUploading(false);
    Get.off(() => VerificaitonPendingScreen());
  }
}
