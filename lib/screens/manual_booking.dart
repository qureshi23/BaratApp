import 'package:barat/services/locationservices.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ManaulBooking extends StatefulWidget {
  const ManaulBooking({Key? key}) : super(key: key);

  @override
  State<ManaulBooking> createState() => _ManaulBookingState();
}

class _ManaulBookingState extends State<ManaulBooking> {
  final locationServices = Get.find<LocationServices>();

  final hallid = Get.arguments[0]['hallid'];
  final areaid = Get.arguments[1]['areaid'];
  final hallownerid = Get.arguments[2]['hallownerid'];
  String? _date;
  String? _time;

  List<DateTime> dates = [];
  Set<String> unselectableDates = {}; // assuming this is set somewhere
  bool isload = false;
  DateTime? _initalDate;
  DateTime dateCheck = DateTime.now();
  var _db = FirebaseFirestore.instance;
  Future<void> getPredictedDate() async {
    await _db
        .collection("bookings")
        .where("hallid", isEqualTo: hallid)
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
        .where("hallid", isEqualTo: hallid)
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPredictedDate();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: 25.0.h, left: 10.0.w, right: 10.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: ReusableBigText(
                    text: "Manual Booking",
                    fontSize: 40,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10.h),
                isload == true
                    ? DateTimePicker(
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
                          print(_date);
                          _date = val;
                        }),
                        validator: (val) {
                          setState(() => _date = val ?? '');
                          return null;
                        },
                        onSaved: (val) => setState(() => _date = val ?? ''),
                      )
                    : const SizedBox(
                        height: 0.0,
                        width: 0.0,
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
                    print(_time);
                    _time = val;
                  }),
                  validator: (val) {
                    setState(() => _time = val ?? '');
                    return null;
                  },
                  onSaved: (val) => setState(() => _time = val ?? ''),
                ),
                const Spacer(
                  flex: 4,
                ),
                InkWell(
                  onTap: () {
                    if (_date == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Enter Date"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else if (_time == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Enter Time"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else {
                      DateTime dt = DateTime.parse('$_date $_time');

                      locationServices.manualBooking(
                        context: context,
                        areaid: areaid,
                        hallid: hallid,
                        hallownerid: hallownerid,
                        date: dt,
                      );
                      Get.back();
                    }
                  },
                  child: Container(
                    width: width,
                    height: height / 14,
                    margin: EdgeInsets.symmetric(horizontal: 45.w),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadiusDirectional.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Done',
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
