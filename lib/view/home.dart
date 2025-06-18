import 'package:course_ui/const/colors.dart';
import 'package:course_ui/controllers/list_controller.dart';
import 'package:course_ui/view/course_manage.dart';
import 'package:course_ui/view/course_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final ListController lc = Get.put(ListController());

  final List tabs = [CourseList(), CourseManage()];
  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Courses"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Obx(() => tabs[selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (selection) {
            selectedIndex.value = selection;
          },
          currentIndex: selectedIndex.value,
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book_rounded),
              label: "Courses",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings_outlined),
              activeIcon: Icon(Icons.admin_panel_settings_rounded),
              label: "Admin",
            ),
          ],
        ),
      ),
    );
  }
}
