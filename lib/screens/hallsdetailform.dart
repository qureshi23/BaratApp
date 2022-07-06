import 'dart:async';
import 'dart:io';

import 'package:barat/screens/custom_google_map.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../services/locationservices.dart';
import '../utils/color.dart';
import '../widgets/reusableTextField.dart';
import '../widgets/reusableTextIconButton.dart';
import 'admin.dart';

class HallsDetailForm extends StatefulWidget {
  const HallsDetailForm({Key? key}) : super(key: key);
  static const routeName = '/hall-details-form';

  @override
  State<HallsDetailForm> createState() => _HallsDetailFormState();
}

class _HallsDetailFormState extends State<HallsDetailForm> {
  final areaid = Get.arguments[0]['areaid'];
  final hallid = Get.arguments[1]['hallid'];

  final locationServices = Get.find<LocationServices>();
  // LocationServices locationServices = LocationServices();
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  List<String> arrimgsUrl = [];
  int uploadItem = 0;
  bool _upLoading = false;
  var totalimages = 0;

  String? AreaName;
  String? UserName;
  List<String>? AreaListArray = ['A', 'B', 'C', 'D'];
  RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  final TextEditingController ownerName = TextEditingController();
  final TextEditingController hallName = TextEditingController();
  final TextEditingController ownerContact = TextEditingController();
  final TextEditingController ownerEmail = TextEditingController();
  final TextEditingController hallAddress = TextEditingController();
  final TextEditingController hallCapacity = TextEditingController();
  final TextEditingController pricePerHead = TextEditingController();
  final TextEditingController cateringPerHead = TextEditingController();
  final TextEditingController areaName = TextEditingController();
  //Uploading data to Firebase
  bool _isHallSubmitted = false;
  bool eventPlanner = false;
  bool isAdmin = true;
  bool isload = false;

  Future<void> _asyncMethod() async {
    try {
      await FirebaseFirestore.instance
          .collection("admin")
          .doc(areaid)
          .collection('halls')
          .doc(hallid)
          .get()
          .then((DocumentSnapshot docsnapshot) {
        Map<String, dynamic> data = docsnapshot.data()! as Map<String, dynamic>;
        hallName.text = data["hallName"];
        // areaName.text = data["areaName"];
        ownerName.text = data["OwnerName"];
        ownerContact.text = data["OwnerContact"].toString();
        ownerEmail.text = data["OwnerEmail"];
        hallAddress.text = data["HallAddress"];
        hallCapacity.text = data["HallCapacity"].toString();
        pricePerHead.text = data["PricePerHead"].toString();
        cateringPerHead.text = data["CateringPerHead"].toString();
        eventPlanner = data["EventPlanner"];
      });

      if (hallid != null) {
        await FirebaseFirestore.instance
            .collection("admin")
            .doc(areaid)
            .collection('halls')
            .doc(hallid)
            .get()
            .then((snapshot) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          // arrimgsUrl.add(data['images'].toString());
          arrimgsUrl = data['images'].cast<String>();
        });
      }

      if (eventPlanner) {
        eventPlanner == true;
      }
      setState(() {
        isload = true;
      });
      totalimages = arrimgsUrl.length + _selectedFiles.length;
      print(arrimgsUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong try again"),
        ),
      );
    }
  }

  @override
  void initState() {
    print("Hall id : $hallid");
    //subscribe
    if (isAdmin) {
      FirebaseMessaging.instance.subscribeToTopic("Admin");
    }
    if (hallid != null) {
      _asyncMethod().whenComplete(() {});
    } else {
      setState(() {
        isload = true;
      });
    }
    super.initState();
    // LocationServices().fetchLocationArea();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ownerName.dispose();
    hallName.dispose();
    ownerContact.dispose();
    ownerEmail.dispose();
    hallAddress.dispose();
    hallCapacity.dispose();
    pricePerHead.dispose();
    cateringPerHead.dispose();
    areaName.dispose();
  }

  displayValidationError(BuildContext context, String errorname) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$errorname is Empty"),
      ),
    );
  }

  void validationForNewHall(BuildContext context) {
    try {
      if (ownerName.text.trim().isEmpty &&
          hallName.text.trim().isEmpty &&
          ownerContact.text.trim().isEmpty &&
          ownerEmail.text.trim().isEmpty &&
          hallAddress.text.trim().isEmpty &&
          hallCapacity.text.trim().isEmpty &&
          pricePerHead.text.trim().isEmpty &&
          cateringPerHead.text.trim().isEmpty &&
          areaName.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("All Field Are Empty"),
          ),
        );
      } else if (hallName.text.trim().isEmpty) {
        displayValidationError(context, "Hall Name");
      } else if (areaName.text.trim().isEmpty) {
        displayValidationError(context, "Area Name");
      } else if (ownerName.text.trim().isEmpty) {
        displayValidationError(context, "Owner Name");
      } else if (ownerContact.text.trim().isEmpty) {
        displayValidationError(context, "Owner's Contact");
      } else if (ownerEmail.text.trim().isEmpty) {
        displayValidationError(context, "Owner's Email");
      } else if (!regExp.hasMatch(ownerEmail.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please Try Vaild Email"),
          ),
        );
      } else if (hallAddress.text.trim().isEmpty) {
        displayValidationError(context, "Hall Address");
      } else if (hallCapacity.text.trim().isEmpty) {
        displayValidationError(context, "Hall Capacity");
      } else if (pricePerHead.text.trim().isEmpty) {
        displayValidationError(context, "Price");
      } else if (cateringPerHead.text.trim().isEmpty) {
        displayValidationError(context, "Catering Price");
      } else if (_selectedFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please Select Image"),
          ),
        );
      } else {
        if (_selectedFiles.isNotEmpty) {
          postHallsByAdmin(
              listImages: arrimgsUrl,
              areaName: areaName.text.toString().toLowerCase(),
              halladdress: hallAddress.text.toString(),
              ownerName: ownerName.text.toString(),
              hallName: hallName.text.toString(),
              ownerContact: ownerContact.text.toString(),
              ownerEmail: ownerEmail.text.toString(),
              hallCapacity: int.parse(hallCapacity.text),
              pricePerHead: int.parse(pricePerHead.text),
              cateringPerHead: int.parse(cateringPerHead.text),
              eventPlanner: eventPlanner,
              context: context);
          // Get.to(() => const AdminPage());
        }
      }
    } catch (e) {
      print("Error in Hall Form Validation ${e.toString()}");
    }
  }

  Future<void> postHallsByAdmin(
      {required List listImages,
      required String ownerName,
      required String hallName,
      required String halladdress,
      required String ownerContact,
      required String ownerEmail,
      required String areaName,
      required int hallCapacity,
      required int pricePerHead,
      required int cateringPerHead,
      required bool eventPlanner,
      required BuildContext context}) async {
    setState(() {
      _isHallSubmitted = true;
    });
    try {
      var db = FirebaseFirestore.instance;
      bool? checkOwnerEmail;
      bool? checklawn;
      var ownerid;
      var areaid;
      print("Owner email is $ownerEmail");

      // get user from Firebase
      QuerySnapshot userdata = await db
          .collection('User')
          .where('email', isEqualTo: ownerEmail)
          .get();

      // get area from Firebase
      // check if area exist in Firebase
      QuerySnapshot area = await db
          .collection('admin')
          .where('areaName', isEqualTo: areaName)
          .get();
      print("Getting user data : $userdata and  Area $area");
      if (userdata.size > 0 && area.size > 0) {
        userdata.docs.forEach((doc) {
          ownerid = doc.get("userId");
          print("Owner email is $ownerEmail");
        });
        area.docs.forEach((doc) {
          print("The Data is F0ollowing : ${userdata.docs[0].get("email")}");
          areaid = doc.get("id");
        });
        print("The Area Name is $areaid");
        await uploadFunction(_selectedFiles);
        var halldoc = await FirebaseFirestore.instance
            .collection("admin")
            .doc(areaid)
            .collection("halls")
            .doc();
        print("The Hall id is ${halldoc}");

        await FirebaseFirestore.instance
            .collection("admin")
            .doc(areaid)
            .collection("halls")
            .doc(halldoc.id)
            .set({
          "areaId": area.docs[0].id,
          "hallName": hallName,
          "hall_id": halldoc.id,
          "EventPlanner": eventPlanner,
          "CateringPerHead": cateringPerHead,
          "HallAddress": halladdress,
          "HallCapacity": hallCapacity,
          "OwnerContact": ownerContact,
          "OwnerEmail": ownerEmail,
          "OwnerName": ownerName,
          "PricePerHead": pricePerHead,
          "createdAt": Timestamp.now(),
          "images": listImages,
          "updatedAt": Timestamp.now(),
          "hallOwnerId": ownerid,
          "hallrating": 0.0,
        });
        _selectedFiles.clear();
        print("Hall Created");
        Get.back();
      } else if (userdata.docs.isEmpty) {
        setState(() {
          _isHallSubmitted = false;
        });
        print("The Email is ${ownerEmail}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text("Owner Email is Invalid"),
          ),
        );
      } else if (area.docs.isEmpty) {
        setState(() {
          _isHallSubmitted = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Area is Invalid"),
          ),
        );
      } else {
        print("Something went Wrong");
      }
    } on SocketException catch (e) {
      setState(() {
        _isHallSubmitted = false;
      });
      print("Error in Post Hall Admin ${e.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "No Internet Connection",
        ),
      ));
    } catch (e) {
      print("Problem in Post Hall Admin ${e.toString()}");
      setState(() {
        _isHallSubmitted = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "Something went Wrong Try Again later",
        ),
      ));
    }
  }

  Future<void> validationForExistingHall(BuildContext context) async {
    try {
      if (ownerName.text.trim().isEmpty &&
          hallName.text.trim().isEmpty &&
          ownerContact.text.trim().isEmpty &&
          hallAddress.text.trim().isEmpty &&
          hallCapacity.text.trim().isEmpty &&
          pricePerHead.text.trim().isEmpty &&
          cateringPerHead.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("All Field Are Empty"),
          ),
        );
      } else if (hallName.text.trim().isEmpty) {
        displayValidationError(context, "Hall Name");
      } else if (ownerName.text.trim().isEmpty) {
        displayValidationError(context, "Owner Name");
      } else if (ownerContact.text.trim().isEmpty) {
        displayValidationError(context, "Owner's Contact");
      } else if (hallAddress.text.trim().isEmpty) {
        displayValidationError(context, "Hall Address");
      } else if (hallCapacity.text.trim().isEmpty) {
        displayValidationError(context, "Hall Capacity");
      } else if (pricePerHead.text.trim().isEmpty) {
        displayValidationError(context, "Price");
      } else if (cateringPerHead.text.trim().isEmpty) {
        displayValidationError(context, "Catering Price");
      } else if (arrimgsUrl.isEmpty && _selectedFiles.isEmpty) {
        displayValidationError(context, "Image");
      } else if (_selectedFiles.isEmpty) {
        // If Images are not updated, Only Text is updated
        updateHallByAdmin(
            listImages: arrimgsUrl,
            halladdress: hallAddress.text.toString(),
            ownerName: ownerName.text.toString(),
            hallName: hallName.text.toString(),
            ownerContact: ownerContact.text.toString(),
            hallCapacity: int.parse(hallCapacity.text),
            pricePerHead: int.parse(pricePerHead.text),
            cateringPerHead: int.parse(cateringPerHead.text),
            eventPlanner: eventPlanner,
            context: context);
      } else if (_selectedFiles.isNotEmpty) {
        // If Images are updated

        await uploadFunction(_selectedFiles);
        updateHallByAdmin(
            listImages: arrimgsUrl,
            halladdress: hallAddress.text.toString(),
            ownerName: ownerName.text.toString(),
            hallName: hallName.text.toString(),
            ownerContact: ownerContact.text.toString(),
            hallCapacity: int.parse(hallCapacity.text),
            pricePerHead: int.parse(pricePerHead.text),
            cateringPerHead: int.parse(cateringPerHead.text),
            eventPlanner: eventPlanner,
            context: context);
      }
    } catch (e) {
      print("Error in Exist Hall Validation ${e.toString()}");
    }
  }

// Update Hall
  Future<void> updateHallByAdmin(
      {required List listImages,
      required String ownerName,
      required String hallName,
      required String halladdress,
      required String ownerContact,
      required int hallCapacity,
      required int pricePerHead,
      required int cateringPerHead,
      required bool eventPlanner,
      required BuildContext context}) async {
    if (_isHallSubmitted != true) {
      setState(() {
        _isHallSubmitted = true;
      });
    }

    try {
      await FirebaseFirestore.instance
          .collection("admin")
          .doc(areaid)
          .collection("halls")
          .doc(hallid)
          .update({
        "hallName": hallName,
        "EventPlanner": eventPlanner,
        "CateringPerHead": cateringPerHead,
        "HallAddress": halladdress,
        "HallCapacity": hallCapacity,
        "OwnerContact": ownerContact,
        "OwnerName": ownerName,
        "PricePerHead": pricePerHead,
        "images": listImages,
        "updatedAt": Timestamp.now(),
      });
      _selectedFiles.clear();
      print("Hall Updated");
      Get.back();
    } on SocketException catch (e) {
      setState(() {
        _isHallSubmitted = false;
      });
      print("Error in Update Hall Admin ${e.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "No Internet Connection",
        ),
      ));
    } catch (e) {
      print("Problem in Update Hall Admin ${e.toString()}");
      setState(() {
        _isHallSubmitted = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "Something went Wrong Try Again later",
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('49 ${locationServices.fetchLocationArea()}');

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background1Color,
        centerTitle: true,
        title: const Text('Create Hall Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20.h),
          decoration: BoxDecoration(
              color: whiteColor, borderRadius: BorderRadius.circular(8)),
          child: isload == true
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextField(
                      controller: hallName,
                      hintText: 'Hall Name',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    hallid == null
                        ? ReusableTextField(
                            controller: areaName,
                            hintText: 'Area Name',
                            keyboardType: TextInputType.emailAddress,
                          )
                        : const SizedBox(width: 0.0, height: 0.0),
                    hallid == null
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox(width: 0.0, height: 0.0),
                    ReusableTextField(
                      controller: ownerName,
                      hintText: 'Owner Name',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextField(
                      controller: ownerContact,
                      hintText: 'Owner Contact',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextField(
                      readonly: hallid != null ? true : false,
                      controller: ownerEmail,
                      hintText: 'Owner Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextField(
                      controller: hallAddress,
                      hintText: 'Hall Address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextField(
                      controller: hallCapacity,
                      hintText: 'Hall Capacity',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextField(
                      controller: pricePerHead,
                      hintText: 'Price Per Head',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextField(
                      controller: cateringPerHead,
                      hintText: 'Catering Per Head',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          CupertinoSwitch(
                            value: eventPlanner,
                            onChanged: (value) {
                              setState(() {
                                eventPlanner = value;
                              });
                            },
                          ),
                          const Text('Event Planner')
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: height * 0.5,
                      child: _upLoading
                          ? showLoading()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      selectImage();
                                    },
                                    child: const Text(
                                      'Select Files',
                                      style: TextStyle(color: background1Color),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: _selectedFiles.length == null
                                      ? const Text("No Images Selected")
                                      : Text(
                                          'Image is Selected : ${_selectedFiles.length.toString()}'),
                                ),
                                Expanded(
                                  child: hallid == null ||
                                          _selectedFiles.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 20),
                                          child: GridView.builder(
                                              itemCount:
                                                  _selectedFiles.length + 1,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return index == 0
                                                    ? InkWell(
                                                        onTap: () {
                                                          pickImage();
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            width: 100,
                                                            height: 100,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      220,
                                                                      220,
                                                                      220,
                                                                      1.0),
                                                            ),
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons.add,
                                                                size: 40.0,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: double.infinity,
                                                        alignment:
                                                            Alignment.center, //
                                                        child: Stack(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Image.file(
                                                                  File(_selectedFiles[
                                                                          index -
                                                                              1]
                                                                      .path),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: 130,
                                                                  height: 130),
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  _selectedFiles
                                                                      .removeAt(
                                                                          index -
                                                                              1);
                                                                  setState(
                                                                      () {});
                                                                  print(
                                                                      'delete image from List');
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.cancel,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                              }),
                                        )
                                      : GridView.builder(
                                          itemCount: arrimgsUrl.length + 1,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return index == 0
                                                ? InkWell(
                                                    onTap: () {
                                                      pickImage();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              220,
                                                              220,
                                                              220,
                                                              1.0),
                                                        ),
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.add,
                                                            size: 40.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: double.infinity,
                                                    alignment: Alignment.center,
                                                    child: Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Image.network(
                                                            arrimgsUrl[
                                                                index - 1],
                                                            fit: BoxFit.cover,
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              arrimgsUrl
                                                                  .removeAt(
                                                                      index -
                                                                          1);
                                                              setState(() {});
                                                              print(
                                                                  'delete image from List');
                                                            },
                                                            child: const Icon(
                                                              Icons.cancel,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                          }),
                                )
                              ],
                            ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    InkWell(
                      onTap: _isHallSubmitted == false
                          ? () async {
                              _upLoading == false
                                  ? hallid == null
                                      ?
                                      // Create New Hall
                                      validationForNewHall(context)
                                      :
                                      // Update Existing Hall
                                      validationForExistingHall(context)
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Please Wait Hall is Uploading"),
                                      ),
                                    );
                            }
                          : () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Processing... Please Wait"),
                                ),
                              ),
                      child: ReusableTextIconButton(
                        text: "Submit",
                        color: _isHallSubmitted == false
                            ? background1Color
                            : Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                  ],
                )
              : Container(
                  color: Colors.white,
                  height: height,
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Please Wait..."),
                      SizedBox(
                        height: 15,
                      ),
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  //showLoading Login()
  Widget showLoading() {
    return Center(
      child: Column(
        children: [
          Text(
            "Uploading : " +
                uploadItem.toString() +
                "/" +
                _selectedFiles.length.toString(),
          ),
          const SizedBox(height: 30),
          const CircularProgressIndicator()
        ],
      ),
    );
  }
  //Finish showLoading Login()

  //upload ImageFile One by one
  Future<List> uploadFunction(List<XFile> _images) async {
    for (int i = 0; i < _images.length; i++) {
      var imageUrl = await uploadFile(_images[i]);
      arrimgsUrl.add(imageUrl.toString());
    }

    print("93 $arrimgsUrl");
    return arrimgsUrl;
  }
  //Finish upload ImageFile One by one

  //Upload Images in Firestore Storage
  Future<String> uploadFile(XFile _image) async {
    setState(() {
      _upLoading = true;
      _isHallSubmitted = true;
    });
    Reference reference =
        _firebaseStorage.ref().child("areaImages").child(_image.name);
    await reference.putFile(File(_image.path)).whenComplete(() async {
      setState(() {
        uploadItem += 1;
        if (uploadItem == _selectedFiles.length) {
          _upLoading = false;
          uploadItem = 0;
        }
      });
    });

    return await reference.getDownloadURL();
  }
  //Finish Upload Images in Firestore Storage

  Future<void> pickImage() async {
    try {
      final List<XFile>? imgs = await _imagePicker.pickMultiImage(
        imageQuality: 50,
        maxWidth: 400,
        maxHeight: 400,
      );

      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);
        totalimages += imgs.length;
      }
      print("List of Images : " + imgs.length.toString());
    } catch (e) {
      print("Something Wrong" + e.toString());
    }
    setState(() {});
  }

//Select Image From Gallery
  Future<void> selectImage() async {
    _selectedFiles.clear();

    try {
      final List<XFile>? imgs = await _imagePicker.pickMultiImage(
        imageQuality: 50,
        maxWidth: 400,
        maxHeight: 400,
      );

      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);
      }
      print("List of Images : " + imgs.length.toString());
    } catch (e) {
      print("Something Wrong" + e.toString());
    }
    setState(() {});
  }
//Finish Select Image From Gallery

}
