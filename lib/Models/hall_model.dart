import 'package:cloud_firestore/cloud_firestore.dart';

class HallModel {
  List? images;

  String? ownerName;
  String? ownerContact;
  String? ownerEmail;
  String? hallAddress;
  late var hallCapacity;
  late var pricePerHead;
  late var cateringPerHead;
  String? hallOwnerId;
  String? hallid;
  var rating;
  String? hallname;

  HallModel.fromMap(dynamic data) {
    images = data["images"];

    ownerName = data["OwnerName"];
    ownerContact = data["OwnerContact"];
    ownerEmail = data["OwnerEmail"];
    hallAddress = data["HallAddress"];
    hallCapacity = data["HallCapacity"];
    pricePerHead = data["PricePerHead"];
    cateringPerHead = data["CateringPerHead"];
    hallOwnerId = data["hallOwnerId"];
    hallid = data["hall_id"];
    hallname = data["hallName"];
    rating = parseToDouble(double.parse(data["hallrating"].toString()));
  }

  double parseToDouble(double rating) {
    String inString = rating.toStringAsFixed(1); // '2.35'
    return double.parse(inString); // 2.35
  }
}
