import 'package:course_ui/controllers/list_controller.dart';
import 'package:course_ui/view/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/user_data.dart';
import '../models/course_model.dart';

class CourseList extends StatelessWidget {
  CourseList({super.key});

  final ListController lc = Get.put(ListController());
  final RxSet<String> selected = {"All Courses"}.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crash Courses"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(
            () => SegmentedButton(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: "All Courses",
                  icon: Icon(
                    Icons.school_rounded,
                    size: 16,
                    color: Colors.green,
                  ),
                  label: Text("All Courses", style: TextStyle(fontSize: 12)),
                ),
                ButtonSegment(
                  value: "My Purchased",
                  icon: Icon(
                    Icons.receipt_long_rounded,
                    size: 16,
                    color: Colors.blue,
                  ),
                  label: Text("My Purchases", style: TextStyle(fontSize: 12)),
                ),
                ButtonSegment(
                  value: "My Favourites",
                  icon: Icon(
                    Icons.favorite_rounded,
                    size: 16,
                    color: Colors.red,
                  ),
                  label: Text("My Favourites", style: TextStyle(fontSize: 12)),
                ),
              ],
              selected: selected,
              onSelectionChanged: (p0) {
                // ignore: invalid_use_of_protected_member
                selected.value = p0;
              },
            ),
          ),

          Obx(() {
            final selectedValue = selected.first;

            if (selectedValue == "All Courses") {
              return allCourseList();
            } else if (selectedValue == "My Purchased") {
              return purchasedCourseList();
            } else {
              return myFavList();
            }
          }),
        ],
      ),
    );
  }

  Widget allCourseList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(
          () => lc.courseList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.separated(
                  shrinkWrap: true,
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
      ),
    );
  }

  Widget purchasedCourseList() {
    return Expanded(
      child: Padding(
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
      ),
    );
  }

  Widget myFavList() {
    return Expanded(
      child: Padding(
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

                    return userData.value.favCourses.contains(item.id)
                        ? CourseCard(item: item)
                        : SizedBox.shrink();
                  },
                ),
        ),
      ),
    );
  }
}
