import 'dart:io';

import 'package:barat/widgets/reusableBigText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/locationservices.dart';
import '../utils/color.dart';
import '../widgets/reusableTextField.dart';
import '../widgets/reusableTextIconButton.dart';
import 'admin.dart';

class AdminAreaForm extends StatefulWidget {
  const AdminAreaForm({Key? key}) : super(key: key);

  @override
  State<AdminAreaForm> createState() => _AdminAreaFormState();
}

class _AdminAreaFormState extends State<AdminAreaForm> {
  final areaid = Get.arguments[0]['areaid'];

  final locationServices = Get.put(LocationServices());
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  List<String> arrimgsUrl = [];
  int uploadItem = 0;
  bool _upLoading = false;
  var img_url;
  var imagename = ' ';
  final TextEditingController areaName = TextEditingController();
  var getareaid;
  bool isLoad = false;
  bool _isAreaSubmitted = false;
  Future<void> _asyncMethod() async {
    await FirebaseFirestore.instance
        .collection("admin")
        .doc(areaid)
        .get()
        .then((DocumentSnapshot docsnapshot) {
      Map<String, dynamic> data = docsnapshot.data()! as Map<String, dynamic>;
      areaName.text = data["areaName"];
    });

    setState(() {
      isLoad = true;
    });
  }

  @override
  void initState() {
    if (areaid != null) {
      print("Area id is : $areaid");
      _asyncMethod();
    } else {
      isLoad = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    areaName.dispose();
  }

  Future<void> checkValidationAndSubmitArea() async {
    // If Admin is creating new Area
    if (areaid == null) {
      if (_selectedFiles.isNotEmpty &&
          areaName.text.toString().trim().isNotEmpty) {
        setState(() {
          _isAreaSubmitted = true;
        });
        await uploadFile(_selectedFiles.first);

        locationServices.postAreaByAdmin(
          img_url,
          areaName.text.toString(),
          context,
        );
        Get.to(() => const AdminPage());
      } else if (areaName.text.toString().trim().isEmpty) {
        setState(() {
          _isAreaSubmitted = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("PLEASE Enter Area Name")));
      } else {
        setState(() {
          _isAreaSubmitted = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("PLEASE Select Image")));
      }
    }
    // If Admin is updating Area
    else {
      if (_selectedFiles.isNotEmpty &&
          areaName.text.toString().trim().isNotEmpty) {
        setState(() {
          _isAreaSubmitted = true;
        });
        await uploadFile(_selectedFiles.first);
        locationServices.updateAreaByAdmin(
          context: context,
          areaImage: img_url,
          areaId: areaid,
          areaname: areaName.text.toString(),
        );
      } else if (areaName.text.toString().trim().isEmpty) {
        setState(() {
          _isAreaSubmitted = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("PLEASE Enter Area Name")));
      } else if (_selectedFiles.isEmpty &&
          areaName.text.toString().trim().isNotEmpty) {
        setState(() {
          _isAreaSubmitted = true;
        });
        locationServices.updateAreaByAdmin(
          context: context,
          areaImage: imagename,
          areaId: areaid,
          areaname: areaName.text.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background1Color,
        centerTitle: true,
        title: const Text('Area Form'),
      ),
      body: isLoad == true
          ? Container(
              decoration: BoxDecoration(
                  color: whiteColor, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text('data')
                  const SizedBox(
                    height: 30,
                  ),
                  const ReusableBigText(text: "Create Area For User"),
                  const SizedBox(
                    height: 30,
                  ),

                  ReusableTextField(
                    controller: areaName,
                    hintText: 'Area Name',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
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
                                    )),
                              ),
                              Center(
                                child: _selectedFiles.length == null
                                    ? const Text("No Images Selected")
                                    : Text(
                                        'Image is Selected : ${_selectedFiles.length.toString()}'),
                              ),
                              Expanded(
                                child: areaid == null ||
                                        _selectedFiles.isNotEmpty
                                    ? GridView.builder(
                                        itemCount: _selectedFiles.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Image.file(
                                                  File(_selectedFiles[index]
                                                      .path),
                                                  fit: BoxFit.cover));
                                        })
                                    : StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("admin")
                                            .doc(areaid)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.green,
                                            ));
                                          } else if (!snapshot.hasData ||
                                              !snapshot.data!.exists) {
                                            return const Center(
                                              child: Text(
                                                "No Image",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            );
                                          } else {
                                            Map<String, dynamic> data =
                                                snapshot.data!.data()
                                                    as Map<String, dynamic>;
                                            imagename = data["areaImage"];
                                            return GridView.builder(
                                                itemCount: 1,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Image.network(
                                                      data["areaImage"],
                                                      fit: BoxFit.cover,
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                    ),
                                                  );
                                                });
                                          }
                                        }),
                              )
                            ],
                          ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  InkWell(
                    onTap: _isAreaSubmitted == false
                        ? () async {
                            checkValidationAndSubmitArea();
                          }
                        : () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Processing... Please Wait"),
                              ),
                            ),
                    child: ReusableTextIconButton(
                      text: "Submit",
                      color: _isAreaSubmitted == true
                          ? Colors.grey
                          : background1Color,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                ],
              ),
            )
          : SizedBox(
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
  void uploadFunction(List<XFile> _images) async {
    for (int i = 0; i < _images.length; i++) {
      var imageUrl = await uploadFile(_images[i]);
      arrimgsUrl.add(imageUrl.toString());
    }
    print("93 $arrimgsUrl");
  }
  //Finish upload ImageFile One by one

  //Upload Images in Firestore Storage
  Future<String> uploadFile(XFile _image) async {
    setState(() {
      _upLoading = true;
      _isAreaSubmitted = false;
    });
    Reference reference =
        _firebaseStorage.ref().child("Area images").child(_image.name);
    await reference.putFile(File(_image.path)).whenComplete(() async {
      setState(() {
        uploadItem += 1;
        if (uploadItem == _selectedFiles.length) {
          _upLoading = false;
          uploadItem = 0;
        }
      });
    });
    // await reference.getDownloadURL();
    // print("111 ${await reference.getDownloadURL()}");
    img_url = await reference.getDownloadURL();

    print('function print $img_url');
    return img_url;
    // return await reference.getDownloadURL();/
  }
  //Finish Upload Images in Firestore Storage

//Select Image From Gallery
  Future<void> selectImage() async {
    _selectedFiles.clear();

    try {
      final List<XFile>? imgs =
          await _imagePicker.pickMultiImage(maxWidth: 400, maxHeight: 400);
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
