import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/const/colors.dart';
import 'package:course_ui/data/user_data.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class CertificateScreen extends StatelessWidget {
  CertificateScreen({super.key});

  final CourseModel course = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 9 / 16,
              child: Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 64, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.withAlpha(60)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        CircleAvatar(
                          radius: 30,
                          child: Icon(
                            Icons.verified_rounded,
                            color: primaryColor,
                            size: 50,
                          ),
                        ),
                        Text(
                          "CERTIFICATE",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "About Completing the Course",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          course.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Presented to:",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          userData.value.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Date: ${DateFormat.yMMMd().format(Timestamp.now().toDate())}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Er. Subra Deb\nCEO & Founder",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "${course.courseBy}\nCourse Instructor",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            icon: Icon(Icons.save_alt_rounded),
                            label: Text("Download Certificate"),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("Back to course page"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
