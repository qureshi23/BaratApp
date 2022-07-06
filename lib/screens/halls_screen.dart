import 'package:barat/Models/hall_model.dart';
import 'package:barat/screens/hallsdetailform.dart';
import 'package:barat/screens/manual_booking.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/services/locationservices.dart';
import 'package:barat/services/ratingservice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../Models/get_halls_by_i_d.dart';
import '../utils/color.dart';
import '../widgets/reusableBigText.dart';
import '../widgets/reusableText.dart';
import 'hall_details_screen.dart';

class HallsScreen extends StatefulWidget {
  const HallsScreen({Key? key}) : super(key: key);

  @override
  _HallsScreenState createState() => _HallsScreenState();
}

class _HallsScreenState extends State<HallsScreen> {
  String? hallName;
  final locationServices = Get.find<LocationServices>();
  final credentialServices = Get.find<CredentialServices>();

  var areaId = Get.arguments[0]['id'];
  String? areaName = Get.arguments[1]['AreaName'];
  var areaid;
  List<int> halls = [];
  RatingService ratingService = RatingService();

  deleteHallDialog({required String areaId, required String? hallId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text(
              'Are you sure you want to Delete Hall?',
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: const Text('Delete'),
                  onPressed: () {
                    locationServices.deleteHall(
                        context: context, areaId: areaId, hallId: hallId);
                  }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue[700]),
                  child: const Text('Cancel'),
                  onPressed: () => Get.back()),
            ]);
      },
    );
  }

  PopupMenuItem<int> _buildMenuItem(String option, int value) {
    return PopupMenuItem<int>(
      value: value,
      child: Text(option),
    );
  }

  List<HallModel> hallModelList = [];
  bool isRatingFetched = false;

//  Future<void> getAllHalls()async{
  //     await
  //}

  Future<void> fetchHallsRating() async {
    hallModelList.forEach((hallModel) async {
      checkRating(hallModel);
    });
    setState(() {
      isRatingFetched = true;
    });
  }

  Future<double> checkRating(HallModel hallModel) async {
    int countRating = 0;
    double singleratings = 0.0;
    double rating = 0.0;

    await FirebaseFirestore.instance
        .collection("bookings")
        .where("hallid", isEqualTo: hallModel.hallid)
        .get()
        .then((snapshot) {
      if (snapshot.size > 0 && snapshot.docs.isNotEmpty) {
        countRating = snapshot.docs.length;
        snapshot.docs.forEach((docSnap) {
          Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
          singleratings += double.parse(data["rating"].toString());
        });
        print(
            "The Fetched Data is ${hallModel.rating = singleratings / countRating}");
        return hallModel.rating = singleratings / countRating;
      }
      return 0.0;
    });
    return 0.0;
  }

  @override
  void initState() {
    // TODO: implement initState
    areaid = FirebaseFirestore.instance
        .collection("admin")
        .doc(areaId)
        .collection("halls");
    fetchHallsRating();
    print('20 ${areaName.toString()}');
    print('21 ${areaId.toString()}');
    LocationServices();
    super.initState();

    // locationServices.getHallApiById(data);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: background1Color,
          elevation: 0.0,
        ),
        body: Container(
          width: width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: background1Color,
                  width: width,
                  height: height * 0.15,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableBigText(
                          text: areaName
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase() +
                              areaName
                                  .toString()
                                  .substring(1, areaName.toString().length),
                          fontSize: 25,
                        ),
                        const ReusableText(
                          text: "Select Your Lawn Or Hall",
                          fontSize: 20,
                        ),
                      ]),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: areaid.snapshots(),
                            // locationServices.fetchLocationArea()

                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                );
                              }

                              if (!snapshot.hasData) {
                                return Container(
                                  color: Colors.white,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.size == 0) {
                                return Container(
                                  color: Colors.white,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: const Center(
                                    child: Text(
                                      "No Hall Found",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                                // Assigning total document size to document field

                              } else {
                                return ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 15,
                                  ),
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot documentSnapshot) {
                                    Map<String, dynamic> data = documentSnapshot
                                        .data()! as Map<String, dynamic>;
                                    HallModel hallModel =
                                        HallModel.fromMap(data);
                                    hallModelList.add(hallModel);

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () async {
                                          Get.to(
                                              () => HallDetailScreen(
                                                  routename: "Halls screen"),
                                              arguments: [
                                                {"hallmodel": hallModel},
                                                {"areaid": areaId},
                                              ]);
                                        },
                                        child: Card(
                                          elevation: 5.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: 180,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(15.0),
                                                    topLeft:
                                                        Radius.circular(15.0),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(15.0),
                                                    topLeft:
                                                        Radius.circular(15.0),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        hallModel.images![0],
                                                    placeholder:
                                                        (context, url) => Image(
                                                      image: const AssetImage(
                                                          "images/placeholder.jpg"),
                                                      fit: BoxFit.cover,
                                                      height: 180,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    height: 180,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                  ),
                                                ),
                                                // child: FadeInImage(
                                                //   image: NetworkImage(e.thumbnail),
                                                //   placeholder:
                                                //       AssetImage("assets/placeholder.jpg"),
                                                //   width: MediaQuery.of(context).size.width,
                                                //   height: 250,
                                                //   fit: BoxFit.cover,
                                                // ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 12),
                                                height: 70,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7.0),
                                                            child: Container(
                                                              constraints: BoxConstraints(
                                                                  minWidth: 50,
                                                                  maxWidth: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      120),
                                                              child: Text(
                                                                // data["hallName"]
                                                                hallModel
                                                                        .hallname
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            1)
                                                                        .toUpperCase() +
                                                                    // data["hallName"]
                                                                    hallModel
                                                                        .hallname
                                                                        .toString()
                                                                        .substring(
                                                                            1,
                                                                            // data["hallName"]
                                                                            hallModel.hallname.toString().length),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                RatingStars(
                                                                  starSpacing:
                                                                      5.0,
                                                                  value: hallModel
                                                                      .rating,
                                                                  starBuilder:
                                                                      (index, color) =>
                                                                          Icon(
                                                                    Icons.star,
                                                                    size: 18,
                                                                    color:
                                                                        color,
                                                                  ),
                                                                  starCount: 5,
                                                                  starSize: 20,
                                                                  maxValue: 5,
                                                                  maxValueVisibility:
                                                                      false,
                                                                  valueLabelVisibility:
                                                                      false,
                                                                  animationDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              300),
                                                                  starOffColor: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.6),
                                                                  starColor:
                                                                      Colors
                                                                          .yellow,
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  "${hallModel.rating!} ",
                                                                  style:
                                                                      const TextStyle(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    StreamBuilder(
                                                        stream: FirebaseAuth
                                                            .instance
                                                            .authStateChanges(),
                                                        builder: (context,
                                                            snapshot) {
                                                          print(
                                                              "Check isAdmin ${credentialServices.getisAdmin} ");
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .active) {
                                                            if (FirebaseAuth
                                                                    .instance
                                                                    .currentUser !=
                                                                null) {
                                                              return credentialServices
                                                                              .getisAdmin ==
                                                                          true ||
                                                                      credentialServices
                                                                              .getUserId ==
                                                                          hallModel
                                                                              .hallOwnerId
                                                                  // data[
                                                                  //     "hallOwnerId"]
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              5.0),
                                                                      child: PopupMenuButton(onSelected:
                                                                          (result) {
                                                                        if (result ==
                                                                            0) {
                                                                          Get.to(
                                                                              () => const HallsDetailForm(),
                                                                              arguments: [
                                                                                {
                                                                                  "areaid": areaId
                                                                                },
                                                                                {
                                                                                  "hallid": hallModel.hallid
                                                                                  // data["hall_id"]
                                                                                },
                                                                              ]);
                                                                        } else if (result ==
                                                                            1) {
                                                                          deleteHallDialog(
                                                                            areaId:
                                                                                areaId,
                                                                            hallId:
                                                                                hallModel.hallid,
                                                                            // data["hall_id"]
                                                                          );
                                                                        } else if (result ==
                                                                            2) {
                                                                          Get.to(
                                                                              () => const ManaulBooking(),
                                                                              arguments: [
                                                                                {
                                                                                  "hallid": hallModel.hallid
                                                                                  //  data["hall_id"]
                                                                                },
                                                                                {
                                                                                  "areaid": areaId,
                                                                                },
                                                                                {
                                                                                  "hallownerid": hallModel.hallOwnerId,
                                                                                  //   data["hallOwnerId"],
                                                                                }
                                                                              ]);
                                                                          print(
                                                                              "We are in this section");
                                                                        }
                                                                      }, itemBuilder:
                                                                          (BuildContext
                                                                              context) {
                                                                        print(
                                                                            "The Value of Hall Owner is ${hallModel.hallOwnerId} && ${credentialServices.getUserId}");
                                                                        //     data["hallOwnerId"]

                                                                        return credentialServices.getUserId ==
                                                                                data["hallOwnerId"]
                                                                            ? <PopupMenuItem<int>>[
                                                                                _buildMenuItem("Edit", 0),
                                                                                _buildMenuItem("Delete", 1),
                                                                                _buildMenuItem("Manual Booking", 2),
                                                                              ]
                                                                            : <PopupMenuItem<int>>[
                                                                                _buildMenuItem("Edit", 0),
                                                                                _buildMenuItem("Delete", 1),
                                                                              ];
                                                                      }),
                                                                    )
                                                                  : const SizedBox(
                                                                      width:
                                                                          0.0,
                                                                      height:
                                                                          0.0,
                                                                    );
                                                            }
                                                            return const SizedBox(
                                                              width: 0.0,
                                                              height: 0.0,
                                                            );
                                                          }
                                                          return const SizedBox(
                                                            width: 0.0,
                                                            height: 0.0,
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            })),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
