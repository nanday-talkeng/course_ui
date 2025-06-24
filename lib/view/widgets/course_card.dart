import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_ui/controllers/list_controller.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:course_ui/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/course_data.dart';
import '../../data/user_data.dart';

class CourseCard extends StatelessWidget {
  CourseCard({super.key, required this.item});

  final CourseModel item;
  final ListController lc = Get.find();

  void startCourse(CourseModel course) {
    data.value = item.data;

    currentCourse.value = (lc.userCourseProgress as List).firstWhere(
      (c) => c['id'] == item.id,
      orElse: () => {
        "current_stage": 0,
        "sub_stage": 0,
        "finished": false,
        "id": item.id,
        "total_played": 0,
      }, // Assign empty map if not found
    );

    courseId.value = item.id;

    Get.toNamed(AppRoutes.courseOverview, arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        startCourse(item);
      },

      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withAlpha(85)),
          borderRadius: BorderRadius.circular(8),
        ),

        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: item.image,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 120,
                  ),
                ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: item.isFree ? Colors.green : Colors.amber,
                    child: Text(
                      item.isFree ? "Free" : "Paid",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.type,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    item.title,
                    style: TextStyle(
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "By ${item.courseBy}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "${item.rating}⭐",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
