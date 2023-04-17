import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  String? role;
  String? name;
  String? bAddress;
  String? hAddress;
  String? mallAddress;
  String? image;
  bool? profile = false;

  LatLng? homeAddress;
  LatLng? businessAddress;
  LatLng? shoppingAddress;

  var phoneNumber;

  UserModel(
      {this.phoneNumber,
      this.role,
      this.name,
      this.mallAddress,
      this.hAddress,
      this.bAddress,
      this.image});

  Map<String, dynamic> toMap() {
    return {
      'role': role,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(role: map['role'], phoneNumber: null);
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    bAddress = json['business_address'];
    hAddress = json['home_address'];
    mallAddress = json['shopping_address'];
    name = json['name'];
    image = json['image'];
    homeAddress =
        LatLng(json['home_latlng'].latitude, json['home_latlng'].longitude);
    businessAddress = LatLng(
        json['business_latlng'].latitude, json['business_latlng'].longitude);
    shoppingAddress = LatLng(
        json['shopping_latlng'].latitude, json['shopping_latlng'].longitude);
  }
}
