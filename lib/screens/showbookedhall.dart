import 'package:barat/Models/booked_hall_model.dart';
import 'package:barat/screens/confirm_order_screen.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:barat/widgets/reusable_detail_copy_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowBookedHall extends StatefulWidget {
  const ShowBookedHall({Key? key}) : super(key: key);

  @override
  State<ShowBookedHall> createState() => _ShowBookedHallState();
}

class _ShowBookedHallState extends State<ShowBookedHall> {
  BookedHallModel bookedHallModel = Get.arguments[0]['bookedHallModel'];
  final ismyhall = Get.arguments[1]['ismyhall'];
  String? bookedDate;
  bool isHaveFeedBack = false;

  Future<void> isFeedBackGiven() async {
    await FirebaseFirestore.instance
        .collection("bookings")
        .doc(bookedHallModel.bookingId)
        .get()
        .then((doc) {
      if (doc.exists) {
        Map<String, dynamic>? map = doc.data();
        if (map!.containsKey('feedback')) {
          print("Have Feedback ${map.containsKey('feedback')}");
          setState(() {
            isHaveFeedBack = true;
          });
        }
      }
    });
  }

  @override
  void initState() {
    isFeedBackGiven();
    bookedDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(bookedHallModel.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Container(
        height: 230,
        color: Colors.black,
        child: CarouselSlider.builder(
          itemCount: bookedHallModel.listimages!.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) =>
                  Container(
            width: 900,
            // margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "${bookedHallModel.listimages![itemIndex]}"),
                    fit: BoxFit.contain)),
            child: Padding(
              padding: EdgeInsets.only(bottom: 25.0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      children: List.generate(
                          bookedHallModel.listimages!.length, (indexDots) {
                    return Container(
                      margin: const EdgeInsets.only(left: 5),
                      height: 8,
                      width: itemIndex == indexDots ? 25 : 8,
                      decoration: BoxDecoration(
                        color: itemIndex == indexDots
                            ? Colors.blue
                            : Colors.blue.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  })),
                ],
              ),
            ),
          ),
          options: CarouselOptions(
            autoPlay: true,
            enableInfiniteScroll: false,
            // enlargeCenterPage: true,
            viewportFraction: 1.1,
            // aspectRatio: 2.0,
            initialPage: 0,
          ),
        ),
      ),
      SizedBox(height: 10.h),
      Expanded(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            const Text(
              "DETAILS",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            ReusableDetailsCopyText(
              text1: "Owner/Manger",
              text2: "${bookedHallModel.ownerName}",

              // text2: "${snapshot.data!.data![0].ownerName}",
            ),
            ReusableDetailsCopyText(
              text1: "Contact",
              text2: "${bookedHallModel.ownerContact}",

              // text2: "${snapshot.data!.data![0].ownerContact}",
            ),
            ReusableDetailsCopyText(
              text1: "Email",
              text2: "${bookedHallModel.ownerEmail}",

              // text2: "${snapshot.data!.data![0].ownerEmail}",
            ),
            ReusableDetailsCopyText(
              text1: "Client Name",
              text2: "${bookedHallModel.clientname}",

              // text2: "${snapshot.data!.data![0].ownerEmail}",
            ),
            ReusableDetailsCopyText(
              text1: "Client Email",
              text2: "${bookedHallModel.clientemail}",

              // text2: "${snapshot.data!.data![0].ownerEmail}",
            ),
            ReusableDetailsCopyText(
              text1: "Address",
              text2: "${bookedHallModel.hallAddress}",

              // text2: "${snapshot.data!.data![0].hallAddress}",
            ),
            ReusableDetailsCopyText(
              text1: "Guest Quantity",
              text2: "${bookedHallModel.guestsQuantity}",
              // text2: "${snapshot.data!.data![0].hallCapacity}",
            ),
            ReusableDetailsCopyText(
              text1: "Total Amount",
              text2: "${bookedHallModel.totalPayment}",
              // text2: "${snapshot.data!.data![0].pricePerHead}",
            ),
            ReusableDetailsCopyText(
              text1: "Booking Date",
              // text2: "${snapshot.data!.data![0].cateringPerHead}",
              text2: "$bookedDate",
            ),
            ReusableDetailsCopyText(
              text1: "Event Type",
              // text2: "${snapshot.data!.data![0].cateringPerHead}",
              text2: "${bookedHallModel.event}",
            ),
            ReusableDetailsCopyText(
              text1: "Event Planner",
              // text2: "${snapshot.data!.data![0].cateringPerHead}",
              text2: bookedHallModel.eventplanner == true ? "Yes" : "No",
            ),
            ReusableDetailsCopyText(
              text1: "Catering Services",
              // text2: "${snapshot.data!.data![0].cateringPerHead}",
              text2: bookedHallModel.cateringServices == true ? "Yes" : "No",
            ),
            ismyhall != true
                ? bookedHallModel.date.compareTo(DateTime.now()) < 0
                    ? bookedHallModel.feedback == ""
                        ? InkWell(
                            onTap: () {
                              Get.to(() => ConfirmOrderScreen(
                                    date: bookedDate!,
                                    bookid: bookedHallModel.bookingId,
                                    areaid: bookedHallModel.areaid,
                                    hallid: bookedHallModel.hallid,
                                    bookingid: bookedHallModel.bookingId,
                                    feedback: bookedHallModel.feedback,
                                  ));
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 45.0),
                              child: const ReusableTextIconButton(
                                text: "Give FeedBack",
                                margin: 10,
                              ),
                            ),
                          )
                        : const SizedBox(
                            height: 0.0,
                            width: 0.0,
                          )
                    : const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      )
                : const SizedBox(
                    height: 0.0,
                    width: 0.0,
                  ),
            const SizedBox(
              height: 40,
            )
          ]),
        ),
      ),
    ])));
  }
}
