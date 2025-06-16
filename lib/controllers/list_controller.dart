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
      await _firestore
          .collection("Users")
          .doc("Din7wKdWg8GSRbY784aS")
          .get()
          .then((snapshot) {
            userData.value = snapshot.data()!;
          });
    } catch (e) {
      log("getUserData exception: $e");
    }
  }
}
