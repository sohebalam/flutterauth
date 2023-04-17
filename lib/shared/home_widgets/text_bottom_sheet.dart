import 'package:authapp/shared/home_functions.dart';
import 'package:authapp/shared/polyline_handler.dart';
import 'package:authapp/shared/widgets.dart';
import 'package:authapp/style/contstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;

final TextEditingController destinationController = TextEditingController();
final TextEditingController sourceController = TextEditingController();
bool showSourceField = false;
LatLng? destination;
LatLng? source;
GoogleMapController? myMapController;
Set<Marker> markers = {};

Widget buildTextField(BuildContext context, Function setState) {
  return Positioned(
    top: 170,
    left: 20,
    right: 20,
    child: Container(
      width: Get.width,
      height: 50,
      padding: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 4,
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: destinationController,
        readOnly: true,
        onTap: () async {
          final Prediction? p = await showGoogleAutoComplete(context);

          if (p != null) {
            final String selectedPlace = p.description ?? '';

            destinationController.text = selectedPlace;

            final List<geoCoding.Location> locations =
                await geoCoding.locationFromAddress(selectedPlace);

            destination = LatLng(
              locations.first.latitude,
              locations.first.longitude,
            );

            markers.add(
              Marker(
                markerId: MarkerId(selectedPlace),
                infoWindow: InfoWindow(
                  title: 'Destination: $selectedPlace',
                ),
                position: destination!,
                icon: BitmapDescriptor.fromBytes(markIcons),
              ),
            );

            myMapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: destination!,
                  zoom: 14,
                ),
              ),
            );

            setState(() {
              showSourceField = true;
            });
          }
        },
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: 'Search for a destination',
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              Icons.search,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    ),
  );
}

Widget buildTextFieldForSource(
    BuildContext context, setState, source, destination) {
  return Positioned(
    top: 230,
    left: 20,
    right: 20,
    child: Container(
      width: Get.width,
      height: 50,
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 4,
                blurRadius: 10)
          ],
          borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        controller: sourceController,
        readOnly: true,
        onTap: () async {
          buildSourceSheet(
            context,
            source,
            destination,
            setState,
          );
        },
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: 'From:',
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              Icons.search,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    ),
  );
}

void buildSourceSheet(BuildContext context, source, destination, setState) {
  Get.bottomSheet(Container(
    width: Get.width,
    height: Get.height * 0.5,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        color: Colors.white),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          "Select Your Location",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Home Address",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () async {
            Get.back();
            source = authController.myUser.value.homeAddress!;
            sourceController.text = authController.myUser.value.hAddress!;

            if (markers.length >= 2) {
              markers.remove(markers.last);
            }
            markers.add(Marker(
                markerId: MarkerId(authController.myUser.value.hAddress!),
                infoWindow: InfoWindow(
                  title: 'Source: ${authController.myUser.value.hAddress!}',
                ),
                position: source));

            await getPolylines(source, destination);

            // drawPolyline(place);

            myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: source, zoom: 14)));
            setState(() {});

            buildRideConfirmationSheet(context, setState);
          },
          child: Container(
            width: Get.width,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      spreadRadius: 4,
                      blurRadius: 10)
                ]),
            child: Row(
              children: [
                Text(
                  authController.myUser.value.hAddress != null
                      ? authController.myUser.value.hAddress!
                      : "",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Business Address",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () async {
            Get.back();
            source = authController.myUser.value.businessAddress!;
            sourceController.text = authController.myUser.value.bAddress!;

            if (markers.length >= 2) {
              markers.remove(markers.last);
            }
            markers.add(Marker(
                markerId: MarkerId(authController.myUser.value.bAddress!),
                infoWindow: InfoWindow(
                  title: 'Source: ${authController.myUser.value.bAddress!}',
                ),
                position: source));

            await getPolylines(source, destination);

            // drawPolyline(place);

            myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: source, zoom: 14)));
            setState(() {});

            buildRideConfirmationSheet(context, setState);
          },
          child: Container(
            width: Get.width,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      spreadRadius: 4,
                      blurRadius: 10)
                ]),
            child: Row(
              children: [
                Text(
                  authController.myUser.value.bAddress != null
                      ? authController.myUser.value.bAddress!
                      : "",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () async {
            Get.back();
            Prediction? p = await showGoogleAutoComplete(context);

            String place = p!.description!;

            sourceController.text = place;

            source = await buildLatLngFromAddress(place);

            if (markers.length >= 2) {
              markers.remove(markers.last);
            }
            markers.add(Marker(
                markerId: MarkerId(place),
                infoWindow: InfoWindow(
                  title: 'Source: $place',
                ),
                position: source));

            await getPolylines(source, destination);

            // drawPolyline(place);

            myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: source, zoom: 14)));
            setState(() {});
            buildRideConfirmationSheet(context, setState);
          },
          child: Container(
            width: Get.width,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      spreadRadius: 4,
                      blurRadius: 10)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Search for Address",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ));
}

buildRideConfirmationSheet(BuildContext context, Function setState) {
  Get.bottomSheet(Container(
    width: Get.width,
    height: Get.height * 0.4,
    padding: EdgeInsets.only(left: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(12), topLeft: Radius.circular(12)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Container(
            width: Get.width * 0.2,
            height: 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.grey),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        textWidget(
            text: 'Select an option:',
            fontSize: 18,
            fontWeight: FontWeight.bold),
        const SizedBox(
          height: 20,
        ),
        buildDriversList(),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: buildPaymentCardWidget(context, setState)),
              MaterialButton(
                onPressed: () {},
                child: textWidget(
                  text: 'Confirm',
                  color: Colors.white,
                ),
                color: AppColors.primaryColor,
                shape: StadiumBorder(),
              )
            ],
          ),
        )
      ],
    ),
  ));
}

int selectedRide = 0;

buildDriversList() {
  return Container(
    height: 90,
    width: Get.width,
    child: StatefulBuilder(builder: (context, set) {
      return ListView.builder(
        itemBuilder: (ctx, i) {
          return InkWell(
            onTap: () {
              set(() {
                selectedRide = i;
              });
            },
            child: buildDriverCard(selectedRide == i),
          );
        },
        itemCount: 3,
        scrollDirection: Axis.horizontal,
      );
    }),
  );
}

buildDriverCard(bool selected) {
  return Container(
    margin: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
    height: 85,
    width: 165,
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: selected
                  ? Color(0xff2DBB54).withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              offset: Offset(0, 5),
              blurRadius: 5,
              spreadRadius: 1)
        ],
        borderRadius: BorderRadius.circular(12),
        color: selected ? Color(0xff2DBB54) : Colors.grey),
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                  text: 'Standard',
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
              textWidget(
                  text: '\$9.90',
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
              textWidget(
                  text: '3 MIN',
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.normal,
                  fontSize: 12),
            ],
          ),
        ),
        Positioned(
            right: -20,
            top: 0,
            bottom: 0,
            child: Image.asset('assets/Mask Group 2.png'))
      ],
    ),
  );
}

buildPaymentCardWidget(BuildContext context, setState) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/visa.png',
          width: 40,
        ),
        SizedBox(
          width: 10,
        ),
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: textWidget(text: value),
            );
          }).toList(),
        )
      ],
    ),
  );
}
