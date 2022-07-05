import 'package:barat/screens/HomePage.dart';
import 'package:barat/screens/areaForm.dart';
import 'package:barat/screens/create_hall_user.dart';
import 'package:barat/screens/hallsdetailform.dart';
import 'package:barat/screens/order_confirm_list.dart';
import 'package:barat/services/locationservices.dart';
import 'package:barat/utils/color.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:barat/services/credentialservices.dart';

import '../widgets/reusableTextIconButton.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final credentialServices = Get.put(CredentialServices());
  final locationServices = Get.put(LocationServices());

  Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 5.0,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: background1Color,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              const SizedBox(height: 50.0),
              Center(
                  child: Icon(
                icon,
                size: 40.0,
                color: whiteColor,
              )),
              const SizedBox(height: 20.0),
              Center(
                child: Text(title,
                    style: const TextStyle(fontSize: 18.0, color: whiteColor)),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Are you sure you want to Exit?',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text(
                    'Exit',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                )
              ],
            );
          },
        );
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: background1Color,
            title: const Text("Dashboard"),
          ),
          body: Container(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(3.0),
                    children: [
                      InkWell(
                        onTap: () =>
                            Get.to(() => const AdminAreaForm(), arguments: [
                          {"areaid": null},
                        ]),
                        child: makeDashboardItem(
                            "Create Area", Icons.add_location_alt_rounded),
                      ),
                      InkWell(
                        onTap: () =>
                            Get.to(() => const HallsDetailForm(), arguments: [
                          {"areaid": null},
                          {"hallid": null}
                        ]),
                        child: makeDashboardItem(
                            "Create Halls", Icons.holiday_village_outlined),
                      ),
                      InkWell(
                        onTap: () => Get.to(() => const CreateHallUser()),
                        child:
                            makeDashboardItem("Create User", Icons.person_add),
                      ),
                      InkWell(
                        onTap: () => Get.to(() => const OrderConfirmList()),
                        child: makeDashboardItem(
                            "Show Bookings", Icons.bookmark_add_rounded),
                      ),
                    ],
                  ),
                  Flexible(
                    child: SizedBox(
                      width: width * 0.5,
                      height: height * 0.25,
                      child: GestureDetector(
                        onTap: () => Get.to(() => const HomePage()),
                        child: makeDashboardItem("Home", Icons.home),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
