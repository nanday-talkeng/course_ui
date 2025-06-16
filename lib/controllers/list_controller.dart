import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/data/user_data.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    getCourseList();
    getUserData();
    getUserCourses();
    super.onInit();
  }

  final RxList courseList = [].obs;

  void getCourseList() async {
    try {
      await _firestore.collection("Courses").get().then((snapshot) {
        for (var s in snapshot.docs) {
          courseList.add(s.data());
        }
      });
    } catch (e) {
      log("getCourseList exception: $e");
    }
  }

  void getUserData() async {
    try {
      await _firestore.collection("Users").doc(userId).get().then((snapshot) {
        userData.value = snapshot.data()!;
      });
    } catch (e) {
      log("getUserData exception: $e");
    }
  }

  RxList<Map> userCourseProgress = <Map>[].obs;

  void getUserCourses() async {
    userCourseProgress.clear();

    try {
      await _firestore
          .collection("user_course_progress")
          .doc(userId)
          .get()
          .then((snapshot) {
            userCourseProgress.value = snapshot.data()!.entries.map((entry) {
              return {"uid": entry.key, ...entry.value};
            }).toList();

            log("getUserCourses: $userCourseProgress");
          });
    } catch (e) {
      log("getUserCourses exception: $e");
    }
  }
}
