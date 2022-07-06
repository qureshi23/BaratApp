import 'dart:async';

import 'package:barat/Models/location_model.dart';
import 'package:barat/screens/admin.dart';
import 'package:barat/screens/areaForm.dart';
import 'package:barat/screens/halls_screen.dart';
import 'package:barat/screens/loginPage.dart';
import 'package:barat/screens/order_confirm_list.dart';
import 'package:barat/services/locationservices.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:barat/widgets/reusableText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/credentialservices.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GetStorage getStorage = GetStorage('myData');
  final locationServices = Get.put(LocationServices());

  final credentialServices = Get.find<CredentialServices>();
  final getHall = FirebaseFirestore.instance.collection("admin");

  Future checkEmailVerifiedThenSignIn() async {
    try {
      User? _user = FirebaseAuth.instance.currentUser;
      print("Checking curret User $_user");

      if (_user != null) {
        await FirebaseAuth.instance.currentUser?.reload();
        bool isEmaiLVerified = _user.emailVerified;
        if (isEmaiLVerified != true) {
          FirebaseAuth.instance.signOut();
          setState(() {});
        } else {
          checkAuthCredential();
        }
      }
    } catch (e) {
      print("CheckingError $e");
    }
  }

  Future<void> checkAuthCredential() async {
    credentialServices.userUid.value = await getStorage.read('user') ?? ' ';
    credentialServices.isAdmin.value =
        await getStorage.read('isAdmin') ?? false;
    credentialServices.isGoogleSignedIn.value =
        getStorage.read('isGoogle') ?? false;
    print(
        "The calues are ${credentialServices.userUid.value},${credentialServices.isAdmin.value},${credentialServices.isGoogleSignedIn.value}");
    if (credentialServices.userUid.value != ' ') {
      credentialServices.username.value = await getStorage.read('name');
      credentialServices.useremail.value = await getStorage.read('email');
      getToken();
    }
  }

  Future<void> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      print("The Token is $token");
      saveToken(token!);
    });
  }

  Future<void> saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("usertokens")
        .doc(credentialServices.userUid.value)
        .set({
      'token': token,
      'username': credentialServices.username.value,
      'useremail': credentialServices.useremail.value,
    });
  }

  deleteAreaDialog({required String areaId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text(
              'Are you sure you want to Delete Area?',
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: const Text('Delete'),
                  onPressed: () {
                    locationServices.deleteArea(
                        context: context, areaId: areaId);
                  }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue[700]),
                  child: const Text('Cancel'),
                  onPressed: () => Get.back()),
            ]);
      },
    );
  }

  AppBar _localAppBar() {
    return AppBar(
      backgroundColor: background1Color,
      elevation: 0.0,
      title: const Text('Select Area'),
      centerTitle: true,
      actions: [
        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.idTokenChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final bool signedIn = snapshot.hasData;
              if (signedIn == true) {
                print("The current user in Firebase ${signedIn}");
                return Obx(
                  () => InkWell(
                    onTap: () {},
                    child: credentialServices.getisAdmin != true
                        ? Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: SizedBox(
                              width: 20.0,
                              child: PopupMenuButton(
                                padding: const EdgeInsets.all(0.0),
                                onSelected: (result) {
                                  if (result == 0) {
                                    Get.to(() => const OrderConfirmList());
                                  } else if (result == 1) {
                                    credentialServices.getisGoogleSignedIn ==
                                            true
                                        ? credentialServices.SignOutGoogle()
                                        : credentialServices.LogOutViaEmail();
                                  }
                                },
                                itemBuilder: (BuildContext context) => const [
                                  PopupMenuItem(
                                    value: 0,
                                    child: Text(
                                      'Bookings',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      'Sign Out',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: SizedBox(
                              width: 20,
                              child: PopupMenuButton(
                                padding: const EdgeInsets.all(0.0),
                                onSelected: (result) {
                                  if (result == 0) {
                                    Get.offAll(() => const AdminPage());
                                  } else if (result == 1) {
                                    credentialServices.LogOutViaEmail();
                                    credentialServices.isAdmin.value = false;
                                    // FirebaseAuth.instance.signOut();
                                    // Get.off(() => const LoginPage());
                                  }
                                },
                                itemBuilder: (BuildContext context) => const [
                                  PopupMenuItem(
                                    value: 0,
                                    child: Text(
                                      'Dashboard',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      'Sign Out',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: TextButton(
                  onPressed: () {
                    Get.to(() => const LoginPage())!.then((value) {
                      checkAuthCredential();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.person_outlined, color: Colors.white),
                      SizedBox(width: 5.0),
                      Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LoginPage(),
                    ),
                  ).then((value) {
                    checkAuthCredential();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 5.0),
                    Text("Sign In"),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _showArea() {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: StreamBuilder<QuerySnapshot>(
                stream: getHall.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!snapshot.hasData) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                    ;
                  } else if (!snapshot.hasData && snapshot.data!.size == 0) {
                    return const Center(
                      child: Text(
                        'Record not found',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  } else {
                    return ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      // itemCount: snapshot.data!.docs.isEmpty ? 1 : snapshot.data!.docs.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      // gridDelegate:
                      // SliverGridDelegateWithMaxCrossAxisExtent(
                      //     maxCrossAxisExtent: 160.h,
                      //     mainAxisExtent: 230.w,
                      //     crossAxisSpacing: 25.0.h,
                      //     mainAxisSpacing: 10.0.w,
                      //     childAspectRatio: 0.7),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15,
                      ),

                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        Map<String, dynamic> data =
                            documentSnapshot.data()! as Map<String, dynamic>;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              Get.to(
                                () => const HallsScreen(),
                                arguments: [
                                  {"id": data["id"]},
                                  {"AreaName": data["areaName"]},
                                ],
                              );
                            },
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 180,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15.0),
                                        topLeft: Radius.circular(15.0),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15.0),
                                        topLeft: Radius.circular(15.0),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: data["areaImage"],
                                        placeholder: (context, url) => Image(
                                          image: const AssetImage(
                                              "images/placeholder.jpg"),
                                          fit: BoxFit.cover,
                                          height: 180,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        height: 180,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 12),
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 7.0),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                      minWidth: 50,
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              100),
                                                  child: Text(
                                                    "${data["areaName"].toString().substring(0, 1).toUpperCase() + data["areaName"].toString().substring(1, data["areaName"].toString().length)} ",
                                                    style: const TextStyle(
                                                      fontSize: 18.0,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream: FirebaseAuth.instance
                                              .authStateChanges(),
                                          builder: (context, snapshot) {
                                            // print(
                                            //     "Check isAdmin ${credentialServices.getisAdmin} ");
                                            if (snapshot.connectionState ==
                                                ConnectionState.active) {
                                              if (FirebaseAuth
                                                      .instance.currentUser !=
                                                  null) {
                                                return credentialServices
                                                            .getisAdmin ==
                                                        true
                                                    ? PopupMenuButton(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        onSelected: (result) {
                                                          if (result == 0) {
                                                            Get.to(
                                                                () =>
                                                                    const AdminAreaForm(),
                                                                arguments: [
                                                                  {
                                                                    "areaid":
                                                                        data[
                                                                            "id"]
                                                                  },
                                                                ]);
                                                          } else if (result ==
                                                              1) {
                                                            deleteAreaDialog(
                                                                areaId:
                                                                    data["id"]);
                                                          }
                                                        },
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context) =>
                                                                const [
                                                          PopupMenuItem(
                                                            value: 0,
                                                            child: Text(
                                                              'Edit',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child: Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox(
                                                        width: 0.0,
                                                        height: 0.0,
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
                                          },
                                        ),
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
    );
  }

  @override
  void initState() {
    super.initState();
    checkEmailVerifiedThenSignIn();
    LocationServices();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: _localAppBar(),
        body: SafeArea(
          child: Container(
            width: width,
            height: height,
            color: whiteColor,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: background1Color,
                    width: width,
                    height: height * 0.15,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          ReusableBigText(
                            text: "Welcome to Barat App",
                            fontSize: 25,
                          ),
                          ReusableText(
                            text: "Book your Hall or Lawn",
                            fontSize: 20,
                          ),
                        ]),
                  ),
                  _showArea(),
                ],
              ),
            ),
          ),
        ));
  }
}
