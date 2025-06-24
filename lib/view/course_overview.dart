import 'package:course_ui/controllers/payment_gateway_controller.dart';
import 'package:course_ui/data/course_data.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:course_ui/routes/app_routes.dart';
import 'package:course_ui/view/write_review_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../data/user_data.dart';

class CourseOverview extends StatelessWidget {
  CourseOverview({super.key});

  final CourseModel courseData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Course Overview"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                            courseData.title,
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
                                  text: courseData.courseBy,
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
                            courseData.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 25,
                            child: ListView.builder(
                              itemCount: courseData.tags.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final String item = courseData.tags[index];
                                return tagText(
                                  item,
                                  [
                                    Colors.blue.shade600,
                                    Colors.red.shade600,
                                    Colors.green.shade600,
                                    Colors.amber.shade600,
                                  ][index % 4],
                                );
                              },
                            ),
                          ),

                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: courseData.features.length,
                            padding: EdgeInsets.all(0),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              FeatureModel item = courseData.features[index];
                              return detailsText(
                                item.title,
                                item.sub,
                                getIconData(item.icon),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _studyProgressSection(),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.courseReviews,
                                arguments: courseData,
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Reviews",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${courseData.rating.toStringAsFixed(1)} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    StarRating(
                                      rating: courseData.rating,
                                      allowHalfRating: true,
                                      color: Colors.amber,
                                    ),
                                  ],
                                ),
                                courseData.ratingCount == 0
                                    ? Text(
                                        "No reviews yet",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      )
                                    : Text(
                                        "Rated by ${courseData.ratingCount} Learners",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(height: 24),
                              TextButton.icon(
                                onPressed: () {
                                  if (currentCourse['finished']) {
                                    Get.bottomSheet(
                                      WriteReviewBottomsheet(
                                        course: courseData,
                                        taskType: "New",
                                      ),
                                      isScrollControlled: true,
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Write Review",
                                      "Complete course to share your experience",
                                    );
                                  }
                                },
                                icon: Icon(Icons.edit),
                                label: Text("Write review"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    InkWell(
                      onTap: () {
                        if (currentCourse['finished']) {
                          Get.toNamed(
                            AppRoutes.certificateScreen,
                            arguments: courseData,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Complete course to get Certificaate",
                          );
                        }
                      },
                      child: Container(
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
                            Image.asset(
                              "images/quality.png",
                              height: 50,
                              width: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Visibility(
                  visible:
                      !courseData.isFree &&
                      !(userData.value.courses.contains(courseData.id)),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 32, left: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Buy for", style: TextStyle(fontSize: 12)),
                        Text(
                          "₹${courseData.amount.toDouble()}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (courseData.isFree) {
                          Get.toNamed(
                            AppRoutes.courseScreen,
                            arguments: courseData,
                          );
                        } else {
                          if (userData.value.courses.contains(courseId)) {
                            Get.toNamed(
                              AppRoutes.courseScreen,
                              arguments: courseData,
                            );
                          } else {
                            final PaymentController pc = Get.put(
                              PaymentController(),
                            );

                            pc.openCheckout(
                              name: userData.value.name,
                              contact: '',
                              email: userData.value.email,
                              amountInPaise: courseData.amount * 100,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("START LEARNING"),
                    ),
                  ),
                ),
              ],
            ),
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

  final Map<String, IconData> iconMap = {
    'type': Iconsax.shapes_copy,
    'level': Iconsax.medal_copy,
    'duration': Iconsax.clock_copy,
  };

  IconData getIconData(String iconName) {
    return iconMap[iconName] ?? Icons.help_outline;
  }

  Widget _studyProgressSection() {
    return Container(
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
              itemCount: courseData.data.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => Center(
                child: Container(
                  color: Colors.teal.withAlpha(100),
                  width: 16,
                  height: 4,
                ),
              ),
              itemBuilder: (context, index) {
                return currentCourse['finished']
                    ? CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.teal,

                        child: Icon(Icons.check_rounded, color: Colors.white),
                      )
                    : currentCourse['current_stage'] > index
                    ? CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.teal,

                        child: Icon(Icons.check_rounded, color: Colors.white),
                      )
                    : currentCourse['current_stage'] != index
                    ? CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,

                        child: Icon(
                          Icons.hourglass_bottom,
                          color: Colors.white,
                        ),
                      )
                    : CircularPercentIndicator(
                        radius: 20.0,
                        lineWidth: 5.0,
                        percent:
                            (index * (100 / (courseData.data.length - 1))) /
                            100,
                        center: Text(
                          "${(index * (100 / (courseData.data.length - 1))).toStringAsFixed(0)}%",
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
              "Great Job 🎉 You're on the path to becoming a certified ${courseData.title}. Your dedication to learning is impressive Finish Strong!",
            ),
          ),
        ],
      ),
    );
  }
}
