import 'package:course_ui/controllers/course_controller.dart';
import 'package:course_ui/controllers/user_controller.dart';
import 'package:course_ui/view/course_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final CourseController cc = Get.put(CourseController());
  final UserController uc = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Course Name"), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.withAlpha(85)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Course Name Full Name long",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Course by ",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: "Nanday Das",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Each tile draws only half of the line connecting the neighboring tiles. Using the connected constructor, lines connecting adjacent tiles can build as one index.",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      tagText("Tone", Colors.red),
                      tagText("Accuracy", Colors.green),
                      tagText("Speed", Colors.blue),
                    ],
                  ),
                  detailsText(
                    "Lecture Type",
                    "Pre-recorded",
                    Iconsax.shapes_copy,
                  ),
                  detailsText("Course Level", "Beginner", Iconsax.medal_copy),
                  detailsText(
                    "Duration",
                    "4 Stages, 12 Hours",
                    Iconsax.clock_copy,
                  ),
                  detailsText("Course Level", "Beginner", Iconsax.map_copy),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.withAlpha(85)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Study Progress",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: cc.data.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => Center(
                        child: Container(
                          color: Colors.teal.withAlpha(100),
                          width: 16,
                          height: 4,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        final Map item = cc.data[index];
                        return uc.userProgress['current_stage'] > index
                            ? CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.teal,

                                child: Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                ),
                              )
                            : uc.userProgress['current_stage'] != index
                            ? CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.teal,

                                child: Icon(
                                  Icons.hourglass_bottom,
                                  color: Colors.white,
                                ),
                              )
                            : CircularPercentIndicator(
                                radius: 20.0,
                                lineWidth: 5.0,
                                percent: item['progress'] / 100,
                                center: Text(
                                  "${item['progress']}%",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                progressColor: Colors.deepOrangeAccent,
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(20),
                      border: Border.all(color: Colors.green.withAlpha(85)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Great Job 🎉 You're on the path to becoming a certified [Course Name]. Your dedication to learning is impressive Finish Strong!",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.withAlpha(85)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Course Certificate",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Issued by Agatsya Edutech Private Limited",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Image.asset("images/quality.png", height: 50, width: 50),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CourseScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text("START LEARNING"),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget tagText(String tag, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Text(tag, style: TextStyle(color: color)),
    );
  }

  Widget detailsText(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Spacer(),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
