import 'package:course_ui/controllers/list_controller.dart';
import 'package:course_ui/view/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/course_model.dart';

class CourseList extends StatelessWidget {
  CourseList({super.key});

  final ListController lc = Get.put(ListController());

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

                  return CourseCard(item: item);
                },
              ),
      ),
    );
  }
}
