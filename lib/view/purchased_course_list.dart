import 'package:course_ui/controllers/list_controller.dart';
import 'package:course_ui/data/user_data.dart';
import 'package:course_ui/view/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/course_model.dart';

class PurchasedCourseList extends StatelessWidget {
  PurchasedCourseList({super.key});

  final ListController lc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Obx(
        () => lc.courseList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: lc.courseList.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final CourseModel item = CourseModel.fromJson(
                    lc.courseList[index],
                  );

                  return userData.value.courses.contains(item.id)
                      ? CourseCard(item: item)
                      : SizedBox.shrink();
                },
              ),
      ),
    );
  }
}
