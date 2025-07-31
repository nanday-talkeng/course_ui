import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/data/course_data.dart';
import 'package:course_ui/data/user_data.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FaqSection extends StatelessWidget {
  FaqSection({super.key, required this.course});

  final CourseModel course;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List availableTimes = [
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
    "5:00 PM",
    "6:00 PM",
    "7:00 PM",
    "8:00 PM",
    "9:00 PM",
  ];

  final Rx<dynamic> selectedDate = DateTime.now().obs;
  final Rx<dynamic> selectedTime = "".obs;

  final RxList alreadyBooked = [].obs;

  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Meet Your Mentor",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: course.support!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final Map item = course.support![index];
                return tutorCard(context, item);
              },
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1),
          const SizedBox(height: 8),
          Text(
            "Book a Doubt Clearing Session",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(
                  Duration(days: index + 1),
                ); // Start from tomorrow
                final dayName = [
                  "Mon",
                  "Tue",
                  "Wed",
                  "Thu",
                  "Fri",
                  "Sat",
                  "Sun",
                ][date.weekday - 1];
                final formatted = "${date.day}";
                return Obx(
                  () => InkWell(
                    onTap: () async {
                      selectedDate.value = DateTime(
                        date.year,
                        date.month,
                        date.day,
                      );

                      await _firestore
                          .collection("course_doubt_session")
                          .where("selected_date", isEqualTo: selectedDate.value)
                          .get()
                          .then((snapshot) {
                            alreadyBooked.clear();
                            for (var s in snapshot.docs) {
                              alreadyBooked.add(s.data()['selected_time']);
                            }
                            log(alreadyBooked.toString());
                          });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selectedDate.value.year == date.year &&
                                selectedDate.value.month == date.month &&
                                selectedDate.value.day == date.day
                            ? Colors.blue
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  selectedDate.value.year == date.year &&
                                      selectedDate.value.month == date.month &&
                                      selectedDate.value.day == date.day
                                  ? Colors.white
                                  : Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            formatted,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  selectedDate.value.year == date.year &&
                                      selectedDate.value.month == date.month &&
                                      selectedDate.value.day == date.day
                                  ? Colors.white
                                  : Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1),
          const SizedBox(height: 8),
          Text(
            "Choose Schedule Time",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 2 columns
              childAspectRatio: 3, // Adjust height/width ratio
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: EdgeInsets.all(0),
            itemCount: availableTimes.length,
            itemBuilder: (context, index) {
              return Obx(
                () => InkWell(
                  onTap: () {
                    if (alreadyBooked.contains(availableTimes[index])) {
                      Fluttertoast.showToast(msg: "Slot already booked.");
                    } else {
                      selectedTime.value = availableTimes[index];
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: alreadyBooked.contains(availableTimes[index])
                          ? Colors.grey.shade50
                          : selectedTime.value == availableTimes[index]
                          ? Colors.orange
                          : Colors.orange.shade50,
                      border: Border.all(
                        color: alreadyBooked.contains(availableTimes[index])
                            ? Colors.grey
                            : Colors.orange,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        availableTimes[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: alreadyBooked.contains(availableTimes[index])
                              ? Colors.grey
                              : selectedTime.value == availableTimes[index]
                              ? Colors.white
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Divider(height: 1),
          const SizedBox(height: 8),
          Text(
            "Custom note (Optional)",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText:
                  "Write any specific doubts or topics you want to discuss",
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 45,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (currentCourse['doubt_sessions'] > 0) {
                  if (selectedDate.value == "") {
                    Fluttertoast.showToast(msg: "Please select a date.");
                  } else if (selectedTime.value == "") {
                    Fluttertoast.showToast(msg: "Please select a time.");
                  } else {
                    String id = Timestamp.now().millisecondsSinceEpoch
                        .toString();

                    WriteBatch batch = _firestore.batch();

                    batch.set(
                      _firestore.collection("user_course_progress").doc(userId),
                      {
                        courseId.value: {
                          "doubt_sessions": FieldValue.increment(-1),
                        },
                      },
                      SetOptions(merge: true),
                    );

                    batch.set(
                      _firestore.collection("course_doubt_session").doc(id),
                      {
                        'id': id,
                        'selected_date': selectedDate.value,
                        'selected_time': selectedTime.value,
                        'course_id': course.id,
                        'note': noteController.text == ""
                            ? "NA"
                            : noteController.text.trim(),
                        'uid': userId, // Replace with actual user ID
                        'created_at': FieldValue.serverTimestamp(),
                      },
                      SetOptions(merge: true),
                    );

                    try {
                      await batch.commit();
                      selectedDate.value = DateTime.now();
                      selectedTime.value = "";
                      Fluttertoast.showToast(
                        msg: "Session booked successfully.",
                      );
                      currentCourse['doubt_sessions']--;
                    } catch (e) {
                      log("Error booking session: $e");
                      Fluttertoast.showToast(msg: "Failed to book session.");
                    }
                  }
                } else {
                  Fluttertoast.showToast(msg: "No sessions remaining.");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text("Book Session"),
            ),
          ),
        ],
      ),
    );
  }

  Widget tutorCard(BuildContext context, Map tutorDetails) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(40),
            child: CachedNetworkImage(
              imageUrl: tutorDetails['image'] ?? "-",
              height: 80,
              width: 80,
              placeholder: (context, url) => ColoredBox(color: Colors.grey),
              errorWidget: (context, url, error) =>
                  ColoredBox(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tutorDetails['name'] ?? "-",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  tutorDetails['description'] ?? "-",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
