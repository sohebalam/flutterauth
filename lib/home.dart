import 'package:authapp/shared/functions.dart';
import 'package:authapp/shared/home_widgets/others.dart';
import 'package:authapp/shared/home_widgets/text_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:typed_data';

import 'package:authapp/profile/my_profile.dart';
import 'package:authapp/screens/cards.dart';
import 'package:authapp/shared/auth_controller.dart';
import 'package:authapp/shared/home_functions.dart';
import 'package:authapp/shared/polyline_handler.dart';
import 'package:authapp/shared/widgets.dart';
import 'package:authapp/style/contstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_webservice/places.dart';

import 'package:geocoding/geocoding.dart' as geoCoding;
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _mapStyle;

  AuthController authController = Get.put(AuthController());

  final Set<Polyline> _polyline = {};
  List<String> list = <String>[
    '**** **** **** 8789',
    '**** **** **** 8921',
    '**** **** **** 1233',
    '**** **** **** 4352'
  ];

  String dropdownValue = '**** **** **** 8789';
  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();

    authController.getUserInfo();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    loadCustomMarker();
  }

  User? user = FirebaseAuth.instance.currentUser;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        text: "Home Page",
      ),
      drawer: MyDrawer(context, user),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              markers: markers,
              polylines: polyline,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                myMapController = controller;

                myMapController!.setMapStyle(_mapStyle);
              },
              initialCameraPosition: _kGooglePlex,
            ),
          ),
          Builder(builder: (context) => buildProfileTile(context)),
          Builder(builder: (context) => buildTextField(context, setState)),
          showSourceField
              ? Builder(
                  builder: (context) => buildTextFieldForSource(
                      context, setState, source, destination))
              : Container(),
          Builder(builder: (context) => buildCurrentLocationIcon(context)),
          Builder(builder: (context) => buildNotificationIcon(context)),
          Builder(builder: (context) => buildBottomSheet(context)),
        ],
      ),
    );
  }
}
