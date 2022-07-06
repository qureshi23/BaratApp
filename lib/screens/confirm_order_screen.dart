import 'dart:convert';

import 'package:barat/screens/HomePage.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/services/ratingservice.dart';
import 'package:barat/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../widgets/reusableText.dart';

class ConfirmOrderScreen extends StatefulWidget {
  String? date;
  String? bookid;
  String? areaid;
  String? hallid;
  String? bookingid;
  String? feedback;
  ConfirmOrderScreen({
    Key? key,
    this.date = "",
    this.bookid = "",
    this.areaid = "",
    this.hallid = "",
    this.bookingid = "",
    this.feedback = "",
  }) : super(key: key);
  static const routeName = '/confirm-order-screen';
  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  RatingService ratingService = RatingService();
  final credentialServices = Get.find<CredentialServices>();
  final TextEditingController feedbackCont = TextEditingController();
  double rating = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    feedbackCont.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 100.h),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: feedbackCont,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter yout feedback'),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _ratting(),
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () {},
                    child: IconButton(
                      splashColor: background1Color,
                      onPressed: () {
                        if (feedbackCont.text.isNotEmpty && rating != 0) {
                          ratingService.giveFeeback(
                            areaid: widget.areaid,
                            hallid: widget.hallid,
                            bookingid: widget.bookingid,
                            feedback: feedbackCont.text,
                            rating: rating,
                            context: context,
                          );
                        } else if (feedbackCont.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              "Please Give Feedback",
                            ),
                          ));
                        } else if (rating == 0) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              "Please Give Rating",
                            ),
                          ));
                        }
                      },
                      icon: const Icon(
                        Icons.home,
                        size: 40,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double starRattingValue = 0;
  Widget _ratting() {
    return Center(
      child: RatingStars(
        value: starRattingValue,
        onValueChanged: (v) {
          starRattingValue = v;
          setState(() {
            rating = v;
          });
        },
        starBuilder: (index, color) => Icon(
          Icons.star,
          size: 45,
          color: color,
        ),
        starCount: 5,
        starSize: 60,
        maxValue: 5,
        starSpacing: 5,
        maxValueVisibility: false,
        valueLabelVisibility: false,
        animationDuration: const Duration(milliseconds: 300),
        starOffColor: Colors.black.withOpacity(0.6),
        starColor: Colors.yellow,
      ),
    );
  }
}
