import 'package:barat/Models/hall_model.dart';
import 'package:barat/screens/price_screen.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:barat/widgets/reusableText.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/locationservices.dart';

class BookingForm extends StatefulWidget {
  const BookingForm({Key? key}) : super(key: key);

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  HallModel hallmodel = Get.arguments[0]['hallmodel'];
  final areaid = Get.arguments[1]['areaid'];

  final TextEditingController noOfGuests = TextEditingController();
  final locationServices = Get.find<LocationServices>();

  String? date;
  String? time;
  bool isCartService = false;
  bool isEventPlanner = false;
  List<DateTime> dates = [];
  Set<String> unselectableDates = {}; // assuming this is set somewhere
  bool isload = false;
  DateTime? _initalDate;
  DateTime dateCheck = DateTime.now();
  var _db = FirebaseFirestore.instance;

  Future<void> getPredictedDate() async {
    await _db
        .collection("bookings")
        .where("hallid", isEqualTo: hallmodel.hallid)
        .get()
        .then((QuerySnapshot snasphot) {
      if (snasphot.docs.isNotEmpty && snasphot.size > 0) {
        snasphot.docs.forEach((element) {
          // print("The Dates are : ${element.get("Date").toDate()}");
          dates.add(element.get("Date").toDate());
        });
      }
    });
    await _db
        .collection("reserved_halls")
        .where("hallid", isEqualTo: hallmodel.hallid)
        .get()
        .then((QuerySnapshot snasphot) {
      if (snasphot.docs.isNotEmpty && snasphot.size > 0) {
        snasphot.docs.forEach((element) {
          // print("The Dates are : ${element.get("Date").toDate()}");
          dates.add(element.get("Date").toDate());
        });
      }
    });
    dates.sort();
    unselectableDates = getDateSet(dates);

    dates.forEach((date) {
      print("Date is Coming : $date");
      print("Date Check is : $date");

      if (date.day != dateCheck.day) {
        print("Selected Date : ${dateCheck.day}");
        _initalDate = dateCheck;
        return;
      } else {
        dateCheck = dateCheck.add(const Duration(days: 1));
      }
    });

    setState(() {
      isload = true;
    });
  }

  String sanitizeDateTime(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  Set<String> getDateSet(List<DateTime> dates) {
    return dates.map(sanitizeDateTime).toSet();
  }

  int _groupValue = 0;
  TextEditingController otherController = TextEditingController();
  var event = "Wedding";
  bool isOther = false;
  Widget _myRadioButton(
      {required String title,
      required int value,
      required Function(int?)? onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  itemUnits() {
    Size size = MediaQuery.of(context).size;

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Select Event",
                              style: TextStyle(fontFamily: "Poppins"),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close),
                            )
                          ],
                        ),
                        _myRadioButton(
                            title: "Wedding",
                            value: 0,
                            onChanged: (newValue) {
                              setState(() {
                                isOther = false;
                                _groupValue = newValue!;
                                event = "Wedding";
                                print(event);
                              });
                            }),
                        _myRadioButton(
                            title: "Valima",
                            value: 1,
                            onChanged: (newValue) {
                              setState(() {
                                isOther = false;
                                _groupValue = newValue!;
                                event = "Valima";
                                print(event);
                              });
                            }),
                        _myRadioButton(
                            title: "Mehendi",
                            value: 2,
                            onChanged: (newValue) {
                              setState(() {
                                isOther = false;
                                _groupValue = newValue!;
                                event = "Mehendi";
                                print(event);
                              });
                            }),
                        _myRadioButton(
                            title: "Birthday",
                            value: 3,
                            onChanged: (newValue) {
                              setState(() {
                                isOther = false;
                                _groupValue = newValue!;
                                event = "Birthday";
                                print(event);
                              });
                            }),
                        Row(
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: _myRadioButton(
                                  title: "Other",
                                  value: 4,
                                  onChanged: (newValue) {
                                    setState(() {
                                      isOther = true;
                                      _groupValue = newValue!;
                                    });
                                  }),
                            ),
                            isOther == true
                                ? Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: TextField(
                                        controller: otherController,
                                        onChanged: (value) {
                                          event = value;
                                          print(event);
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Enter a search term',
                                        ),
                                      ),
                                    ))
                                : const SizedBox(
                                    height: 0.0,
                                    width: 0.0,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPredictedDate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    noOfGuests.dispose();
    otherController.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: isload == true
              ? Container(
                  height: 600.h,
                  padding:
                      EdgeInsets.only(top: 25.0.h, left: 10.0.w, right: 10.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: ReusableBigText(
                          text: "Booking Form",
                          fontSize: 40,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      DateTimePicker(
                        selectableDayPredicate: (DateTime val) {
                          String sanitized = sanitizeDateTime(val);
                          return !unselectableDates.contains(sanitized);
                        },

                        initialDate: dateCheck,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.black,
                                width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Date',
                        ),
                        type: DateTimePickerType.date,
                        //dateMask: 'yyyy/MM/dd',
                        // controller: _controller3,
                        // initialValue: _initalDate,
                        // initialValue: _initalDate.toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: const Icon(Icons.event),
                        dateLabelText: 'Date',
                        onChanged: (val) => setState(() {
                          print(date);
                          date = val;
                        }),
                        validator: (val) {
                          setState(() => date = val ?? '');
                          return null;
                        },
                        onSaved: (val) => setState(() => date = val ?? ''),
                      ),
                      SizedBox(height: 10.h),
                      DateTimePicker(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.black,
                                width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Time',
                        ),
                        type: DateTimePickerType.time,
                        //timePickerEntryModeInput: true,
                        //controller: _controller4,
                        initialValue: '', //_initialValue,
                        icon: const Icon(Icons.access_time),
                        timeLabelText: "Time",
                        // use24HourFormat: false,
                        onChanged: (val) => setState(() {
                          print(time);
                          time = val;
                        }),
                        validator: (val) {
                          setState(() => time = val ?? '');
                          return null;
                        },
                        onSaved: (val) => setState(() => time = val ?? ''),
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: noOfGuests,
                        onChanged: (val) => setState(() {
                          print((val));
                        }),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          focusColor: Colors.black,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.black,
                                width: 2.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.white,
                                width: 2.0),
                          ),
                          labelText: 'No of Guests',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () {
                          itemUnits();
                        },
                        child: AbsorbPointer(
                          child: Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 2.0)),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                TextFormField(
                                  // enabled: false,
                                  readOnly: true,

                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: 'Event',
                                    hintText: event,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    // hintStyle: TextStyle(
                                    //     fontSize: 20.0, color: Colors.redAccent),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Transform.rotate(
                                    angle: 20.4,
                                    child: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReusableBigText(
                              text: 'Catering Service',
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.8),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isCartService = true;
                                    });
                                  },
                                  child: Container(
                                      height: 50.h,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            bottomLeft: Radius.circular(25)),
                                        color: isCartService == true
                                            ? boolColor
                                            : Colors.red,
                                      ),
                                      child: const Center(child: Text('Yes'))),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isCartService = false;
                                    });
                                  },
                                  child: Container(
                                      height: 50.h,
                                      width: 60.w,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(25),
                                            bottomRight: Radius.circular(25)),
                                        color: isCartService == true
                                            ? boolColor
                                            : Colors.red,
                                      ),
                                      child: const Center(child: Text('No'))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Center(
                        child: isCartService == true
                            ? ReusableText(
                                text:
                                    "Catering Service is selected for ${noOfGuests.text.isEmpty ? '0' : noOfGuests.text.toString()} person",
                                fontSize: 12,
                              )
                            : const Text(''),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReusableBigText(
                              text: 'Event Planner Service',
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.8),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isEventPlanner = true;
                                    });
                                  },
                                  child: Container(
                                      height: 50.h,
                                      width: 60.w,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            bottomLeft: Radius.circular(25)),
                                        color: isEventPlanner == true
                                            ? boolColor
                                            : Colors.red,
                                      ),
                                      child: const Center(child: Text('Yes'))),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isEventPlanner = false;
                                    });
                                  },
                                  child: Container(
                                      height: 50.h,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(25),
                                            bottomRight: Radius.circular(25)),
                                        color: isEventPlanner == true
                                            ? boolColor
                                            : Colors.red,
                                      ),
                                      child: const Center(child: Text('No'))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Center(
                        child: isEventPlanner == true
                            ? const ReusableText(
                                text: "Contact the owner/manager of the hall",
                                fontSize: 12,
                              )
                            : const Text(''),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          if (date == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Enter Date"),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else if (time == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Enter Time"),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else if (noOfGuests.text.isEmpty ||
                              int.parse(noOfGuests.text.toString()) <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Enter No of Guests"),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            DateTime dt = DateTime.parse('$date $time');

                            Get.to(() => const PriceScreen(), arguments: [
                              {"areaid": areaid},
                              {"date": dt},
                              {"time": time!},
                              {
                                "noOfGuests":
                                    int.parse(noOfGuests.text.toString()),
                              },
                              {"isEventPlanner": isEventPlanner},
                              {"event": event},
                              {
                                "CartService": isCartService == true
                                    ? hallmodel.cateringPerHead
                                    : 0
                              },
                              {"isCartService": isCartService},
                              {"hallmodel": hallmodel}
                            ]);
                          }
                        },
                        child: const ReusableTextIconButton(
                          text: "Show Expenses",
                          margin: 10,
                          color: background1Color,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(child: CircularProgressIndicator()),
                ),
        ),
      ),
    );
  }
}
