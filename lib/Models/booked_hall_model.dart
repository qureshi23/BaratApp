import 'package:cloud_firestore/cloud_firestore.dart';

class BookedHallModel {
  List? listimages;
  String? ownerName;
  String? ownerContact;
  String? ownerEmail;
  String? hallAddress;
  var guestsQuantity;
  String? clientname;
  String? clientemail;
  var totalPayment;
  late DateTime date;
  String? hallname;
  bool? eventplanner;
  bool? cateringServices;
  String? hallid;
  String? bookingId;
  String? feedback;
  String? event;
  String? areaid;

  BookedHallModel.fromMap(dynamic data) {
    listimages = data["images"] ?? ' ';
    ownerName = data["ownername"].toUpperCase() ?? ' ';
    ownerContact = data["ownercontact"] ?? ' ';
    ownerEmail = data["owneremail"] ?? ' ';
    hallAddress = data["halladdress"];
    guestsQuantity = data["GuestsQuantity"] ?? 0.0;
    clientname = data["clientname"] ?? ' ';
    clientemail = data["clientemail"] ?? ' ';
    totalPayment = data["TotalPaynment"] ?? 0.0;
    date = data["Date"].toDate() ?? ' ';
    hallname = data["hallname"] ?? ' ';
    eventplanner = data["EventPlaner"] ?? ' ';
    cateringServices = data["CateringServices"] ?? ' ';
    hallid = data["hallid"] ?? ' ';
    bookingId = data["bookingId"] ?? ' ';
    feedback = data["feedback"] ?? ' ';
    event = data["event"] ?? ' ';
    areaid = data["areaid"] ?? ' ';
  }
}
