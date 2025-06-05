import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    getCourseList();
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
      log(e.toString());
    }
  }

  final RxList courses = [].obs;

  void getUserCourses() async {
    courses.clear();

    try {
      await _firestore
          .collection("Users")
          .doc("Din7wKdWg8GSRbY784aS")
          .get()
          .then((snapshot) {
            for (var i in snapshot.data()!['courses']) {
              courses.add(i);
            }
          });
      log(courses.toString());
    } catch (e) {
      log("getUserData exception: $e");
    }
  }
}
