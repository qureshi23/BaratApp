import 'package:barat/Models/booked_hall_model.dart';
import 'package:barat/screens/showbookedhall.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/services/locationservices.dart';
import 'package:barat/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderConfirmList extends StatefulWidget {
  const OrderConfirmList({Key? key}) : super(key: key);

  @override
  State<OrderConfirmList> createState() => _OrderConfirmListState();
}

class _OrderConfirmListState extends State<OrderConfirmList> {
  final locationServices = Get.put(LocationServices());
  final credentialServices = Get.find<CredentialServices>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocationServices();
  }

  String getTime(dynamic timedata) {
    String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(timedata);
    print("booking timem is : $date");
    return date;
  }

  Widget myBookings(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Obx(() => StreamBuilder<QuerySnapshot>(
                stream: credentialServices.getisAdmin == true
                    ? FirebaseFirestore.instance
                        .collection("bookings")
                        .orderBy("bookingtime", descending: true)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("bookings")
                        .orderBy("bookingtime", descending: true)
                        // .where('clientid',
                        //     isEqualTo: credentialServices.getUserId)
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.green,
                    ));
                  } else if (!snapshot.hasData || snapshot.data!.size == 0) {
                    return const Center(
                      child: Text(
                        "No Booking Done",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    );
                  } else {
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot docSnaps) {
                        Map<String, dynamic> data =
                            docSnaps.data()! as Map<String, dynamic>;
                        Timestamp time = data["Date"];

                        // bookedHallModelList!.add(data);
                        return Obx(
                          () => data["clientid"] ==
                                      credentialServices.getUserId ||
                                  credentialServices.getisAdmin == true
                              ? InkWell(
                                  onTap: () {
                                    var bookedModel =
                                        BookedHallModel.fromMap(data);
                                    Get.to(() => const ShowBookedHall(),
                                        arguments: [
                                          {"bookedHallModel": bookedModel},
                                          {"ismyhall": false}
                                          // {"ListImage": data["images"]},
                                          // // {"userId": data.toString()},
                                          // {
                                          //   "ownername":
                                          //       data["ownername"].toUpperCase(),
                                          // },
                                          // {
                                          //   "ownercontact": data["ownercontact"]
                                          // },
                                          // {"owneremail": data["owneremail"]},
                                          // {"halladdress": data["halladdress"]},
                                          // {
                                          //   "guestsQuantity":
                                          //       data["GuestsQuantity"]
                                          // },
                                          // {
                                          //   "clientname":
                                          //       data["clientname"].toUpperCase()
                                          // },
                                          // {"clientemail": data["clientemail"]},
                                          // {
                                          //   "totalPayment":
                                          //       data["TotalPaynment"]
                                          // },

                                          // {"date": data["Date"].toDate()},

                                          // {"hallname": data["hallname"]},
                                          // {"eventplanner": data["EventPlaner"]},
                                          // {
                                          //   "cateringServices":
                                          //       data["CateringServices"]
                                          // },
                                          // {"ismyhall": false},

                                          // {"bookingId": data["bookingId"]},

                                          // {"feedback": data["feedback"]},
                                          // {"event": data["event"]}
                                        ]);
                                  },
                                  child: Container(
                                    height: 65,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 10),
                                          blurRadius: 50,
                                          color: background1Color
                                              .withOpacity(0.23),
                                        ),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Wrap(
                                        children: [
                                          ListTile(
                                              dense: true,
                                              isThreeLine: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5.0,
                                                vertical: 0.0,
                                              ),
                                              leading: CircleAvatar(
                                                maxRadius: 19,
                                                backgroundColor:
                                                    background1Color,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[100],
                                                  maxRadius: 18,
                                                  child: Text(
                                                    data["ownername"]
                                                        .toString()
                                                        .substring(0, 1)
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                credentialServices.getisAdmin !=
                                                        true
                                                    ? "Owner Name:  ${data["ownername"].toUpperCase()}"
                                                    : "Client Name:  ${data["clientname"].toUpperCase()}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Text(
                                                "Hall Name : ${data["hallname"]}\nDate : ${getTime(data["bookingtime"].toDate())}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0,
                                                        bottom: 9.0),
                                                    child: Icon(Icons
                                                        .arrow_forward_ios_outlined),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(width: 0.0, height: 0.0),
                        );
                      }).toList(),
                    );
                  }
                },
              )),
        ),
      ],
    );
  }

  Widget myHallsBooked(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Obx(() => StreamBuilder<QuerySnapshot>(
                stream: credentialServices.getisAdmin == true
                    ? FirebaseFirestore.instance
                        .collection("bookings")
                        .orderBy("bookingtime", descending: true)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('bookings')
                        .orderBy('bookingtime', descending: true)
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.green,
                    ));
                  } else if (!snapshot.hasData || snapshot.data!.size == 0) {
                    return const Center(
                      child: Text(
                        "No Booking Done",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    );
                  } else {
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot docSnaps) {
                        Map<String, dynamic> data =
                            docSnaps.data()! as Map<String, dynamic>;
                        print(
                            "The Value of Admin in Order Confrim Page is ${credentialServices.getisAdmin}");

                        return Obx(
                          () => data["hallOwnerId"] ==
                                      credentialServices.getUserId ||
                                  credentialServices.getisAdmin == true
                              ? InkWell(
                                  onTap: () {
                                    var bookedModel =
                                        BookedHallModel.fromMap(docSnaps);
                                    Get.to(() => const ShowBookedHall(),
                                        arguments: [
                                          {"bookedHallModel": bookedModel},

                                          {"ismyhall": true},
                                          // {"ListImage": data["images"]},
                                          // // {"userId": data.toString()},
                                          // {
                                          //   "ownername":
                                          //       data["ownername"].toUpperCase(),
                                          // },
                                          // {
                                          //   "ownercontact": data["ownercontact"]
                                          // },
                                          // {"owneremail": data["owneremail"]},
                                          // {"halladdress": data["halladdress"]},
                                          // {
                                          //   "guestsQuantity":
                                          //       data["GuestsQuantity"]
                                          // },
                                          // {"clientname": data["clientname"]},
                                          // {"clientemail": data["clientemail"]},
                                          // {
                                          //   "totalPayment":
                                          //       data["TotalPaynment"]
                                          // },

                                          // {
                                          //   "date": data["Date"].toDate(),
                                          // },
                                          // {"hallname": data["hallname"]},
                                          // {"eventplanner": data["EventPlaner"]},
                                          // {
                                          //   "cateringServices":
                                          //       data["CateringServices"]
                                          // },

                                          // {"bookingId": data["bookingId"]},
                                          // {"feedback": data["feedback"]},
                                          // {"event": data["event"]}
                                        ]);
                                  },
                                  child: Container(
                                    height: 65,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 10),
                                          blurRadius: 50,
                                          color: background1Color
                                              .withOpacity(0.23),
                                        ),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Wrap(
                                        children: [
                                          ListTile(
                                              dense: true,
                                              isThreeLine: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5.0,
                                                vertical: 0.0,
                                              ),
                                              leading: CircleAvatar(
                                                maxRadius: 19,
                                                backgroundColor:
                                                    background1Color,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[100],
                                                  maxRadius: 18,
                                                  child: Text(
                                                    data["clientname"]
                                                        .toString()
                                                        .substring(0, 1)
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                credentialServices.getisAdmin !=
                                                        true
                                                    ? "Client Name:  ${data["clientname"].toUpperCase()}"
                                                    : "Owner Name:  ${data["ownername"].toUpperCase()}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Text(
                                                "Hall Name : ${data["hallname"]}\nDate : ${getTime(data["Date"].toDate())}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0,
                                                        bottom: 9.0),
                                                    child: Icon(Icons
                                                        .arrow_forward_ios_outlined),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ))
                              : const SizedBox(width: 0.0, height: 0.0),
                        );
                      }).toList(),
                    );
                  }
                },
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: background1Color,
          bottom: TabBar(indicatorColor: Colors.white, tabs: [
            Tab(
              text: credentialServices.getisAdmin == true
                  ? "User Hall Booking"
                  : "My Bookings",
              icon: const Icon(Icons.bookmark_added),
            ),
            Tab(
              text: credentialServices.getisAdmin == true
                  ? "Owner Hall Booked"
                  : "My Halls Booked",
              icon: const Icon(Icons.villa_sharp),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            myBookings(context),
            myHallsBooked(context),
          ],
        ),
        // body:
        // Center(
        //   child: FutureBuilder(
        //     future: locationServices.getHallOwner(),
        //     builder: (context, AsyncSnapshot<HallOwnerModel?> snapshot) {
        //       if (snapshot.hasData != null) {
        //         return ListView.builder(
        //             itemCount: snapshot.data?.data?.length,
        //             itemBuilder: (context, index) {
        //               return ListTile(
        //                   leading: const Icon(Icons.list),
        //                   trailing: Text(
        //                     "${snapshot.data?.data?[index].userEmail}",
        //                     style: const TextStyle(
        //                         color: Colors.green, fontSize: 15),
        //                   ),
        //                   title: Text("List item $index"));
        //             });
        //       } else {
        //         return const Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       }
        //     },
        //   ),
        // ),
      ),
    );
  }
}
