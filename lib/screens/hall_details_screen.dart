import 'package:barat/screens/booking_form.dart';
import 'package:barat/screens/loginPage.dart';
import 'package:barat/screens/signUpPage.dart';
import 'package:barat/services/locationservices.dart';
import 'package:barat/widgets/reusable_detail_copy_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../Models/hall_model.dart';
import '../utils/color.dart';

class HallDetailScreen extends StatefulWidget {
  String routename;
  HallDetailScreen({this.routename = ''});
  static const routeName = '/HallDetailScreen';
  @override
  _HallDetailScreenState createState() => _HallDetailScreenState();
}

class _HallDetailScreenState extends State<HallDetailScreen> {
  // List images = [
  //   'welcome-one.png',
  //   'welcome-two.png',
  //   'welcome-three.png',
  // ];
  LocationServices locationServices = LocationServices();
  HallModel hallmodel = Get.arguments[0]['hallmodel'];
  final areaid = Get.arguments[1]['areaid'];

  Widget _ratting({
    bool totalHallRating = true,
    iconSize = 20.0,
    starSize = 18.0,
    individualFeedbackRating = 0.0,
  }) {
    return Center(
      child: RatingStars(
        value: totalHallRating ? hallmodel.rating! : individualFeedbackRating,
        starBuilder: (index, color) => Icon(
          Icons.star,
          size: iconSize,
          color: color,
        ),
        starCount: 5,
        starSize: starSize,
        maxValue: 5,
        maxValueVisibility: false,
        valueLabelVisibility: false,
        animationDuration: const Duration(milliseconds: 300),
        starOffColor: Colors.black.withOpacity(0.6),
        starColor: Colors.yellow,
      ),
    );
  }

  showAlertDialog(BuildContext ctx) {
    Widget signup = TextButton(
      child: const Text("Sign Up"),
      onPressed: () {
        Get.back();
        Get.to(() => const SignUpPage());
      },
    );
    Widget signin = TextButton(
      child: const Text("Sign In"),
      onPressed: () {
        Get.back();
        Get.to(() => const LoginPage());
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Account Required"),
      content: const Text("Please Sign in to Book Hall"),
      actions: [
        signup,
        signin,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print("Rounded${double.parse("3.5444444")}");
    print("Onwer id : ${hallmodel.hallid}");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 230,
              color: Colors.black,
              child: CarouselSlider.builder(
                itemCount: hallmodel.images!.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        Container(
                  width: 900,
                  // margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              NetworkImage("${hallmodel.images![itemIndex]}"),
                          fit: BoxFit.contain)),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                            children: List.generate(hallmodel.images!.length,
                                (indexDots) {
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
                child: SizedBox(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "DETAILS",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      ReusableDetailsCopyText(
                        text1: "Owner/Manger",
                        text2: "${hallmodel.ownerName}",

                        // text2: "${snapshot.data!.data![0].ownerName}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Contact",
                        text2: "${hallmodel.ownerContact}",

                        // text2: "${snapshot.data!.data![0].ownerContact}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Email",
                        text2: "${hallmodel.ownerEmail}",

                        // text2: "${snapshot.data!.data![0].ownerEmail}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Address",
                        text2: "${hallmodel.hallAddress}",

                        // text2: "${snapshot.data!.data![0].hallAddress}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Capacity per Hall",
                        text2: "${hallmodel.hallCapacity}",
                        // text2: "${snapshot.data!.data![0].hallCapacity}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Rate per head",
                        text2: "${hallmodel.pricePerHead}",
                        // text2: "${snapshot.data!.data![0].pricePerHead}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Catering Service per head",
                        // text2: "${snapshot.data!.data![0].cateringPerHead}",
                        text2: "${hallmodel.cateringPerHead}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Event planner services",
                        text2: "Contact Owner/Manager",
                      ),
                      widget.routename == "Halls screen"
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 20.0),
                              child: SizedBox(
                                height: 50.h,
                                width: size.width,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (FirebaseAuth.instance.currentUser !=
                                        null) {
                                      Get.to(() => const BookingForm(),
                                          arguments: [
                                            {'hallmodel': hallmodel},
                                            {"areaid": areaid},
                                          ]);
                                    } else {
                                      showAlertDialog(context);
                                    }
                                  },
                                  child: Text(
                                    "Book Now",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: whiteColor,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.blueGrey,
                                    primary: background1Color,
                                    elevation: 9,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: 0.0,
                              height: 0.0,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            const Text(
                              "Rating",
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "${hallmodel.rating!}/5",
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Wrap(
                              children: [
                                _ratting(),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("bookings")
                            .where("hallid", isEqualTo: hallmodel.hallid)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator.adaptive());
                          } else if (!snapshot.hasData ||
                              snapshot.data!.size == 0) {
                            return const SizedBox(
                              width: 0.0,
                              height: 0.0,
                            );
                          } else {
                            return ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                Map<String, dynamic> data = documentSnapshot
                                    .data()! as Map<String, dynamic>;

                                return data["feedback"] != ""
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical: 10.0,
                                        ),
                                        width: size.width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              const Icon(
                                                Icons.person_pin,
                                                size: 30,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minWidth: size.width * 0.6,
                                                    maxWidth: size.width * 0.6),
                                                child: Text(
                                                  "${data["clientname"]}",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  data["rating"].toString(),
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                _ratting(
                                                  totalHallRating: false,
                                                  iconSize: 14.0,
                                                  starSize: 14.0,
                                                  individualFeedbackRating:
                                                      double.parse(
                                                    data["rating"].toString(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  style: BorderStyle.solid,
                                                  width: 0.0,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  bottomLeft:
                                                      Radius.circular(10.0),
                                                ),
                                              ),
                                              child: Text(
                                                "${data["feedback"]}",
                                                softWrap: true,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(
                                        width: 0.0,
                                        height: 0.0,
                                      );
                              }).toList(),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
