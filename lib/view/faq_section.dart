import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/data/user_data.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FaqSection extends StatelessWidget {
  FaqSection({super.key, required this.course});

  final CourseModel course;

  final List availableTimes = [
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "8:00 PM",
    "9:00 PM",
    "10:00 PM",
    "11:00 PM",
  ];

  final Rx<dynamic> selectedDate = DateTime.now().obs;
  final Rx<dynamic> selectedTime = "".obs;

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
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white.withAlpha(200),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.courseBy,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Eiusmod officia nulla esse laborum amet. Ex cillum consectetur exercitation occaecat elit et nisi dolor est labore ex. Deserunt consequat ea veniam aliquip. Qui fugiat nulla nisi ad incididunt tempor aliqua nostrud eiusmod anim. Ullamco commodo aliquip aliquip ea fugiat aliquip duis proident consequat laborum amet reprehenderit et. Eu enim commodo duis laborum voluptate aute magna anim consectetur enim dolor sunt.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
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
                    onTap: () {
                      selectedDate.value = DateTime(
                        date.year,
                        date.month,
                        date.day,
                      );
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
                    selectedTime.value = availableTimes[index];
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedTime.value == availableTimes[index]
                          ? Colors.orange
                          : Colors.orange.shade50,
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        availableTimes[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedTime.value == availableTimes[index]
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
                    log("message");
                    String id = Timestamp.now().millisecondsSinceEpoch
                        .toString();
                    try {
                      await FirebaseFirestore.instance
                          .collection("course_doubt_session")
                          .doc(id)
                          .set({
                            'id': id,
                            'selected_date': selectedDate.value,
                            'selected_time': selectedTime.value,
                            'course_id': course.id,
                            'note': noteController.text,
                            'uid': 'user_id', // Replace with actual user ID
                          }, SetOptions(merge: true));
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
}
