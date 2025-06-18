import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:course_ui/routes/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CourseAddController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController courseByController = TextEditingController();

  final TextEditingController chapterTitleController = TextEditingController();

  final RxString imageUrl = "".obs;
  final RxList<String> tags = <String>[].obs;
  final RxList<FeatureModel> features = <FeatureModel>[].obs;

  final RxList chapters = [].obs;

  Future<void> addCourse() async {
    final String id = Timestamp.now().millisecondsSinceEpoch.toString();

    try {
      await _firestore
          .collection("Courses")
          .doc(id)
          .set({
            "id": id,
            "title": titleController.text,
            "description": descriptionController.text,
            "type": typeController.text,
            "course_by": courseByController.text,
            "features": features,
            "tags": tags,
            "image": imageUrl.value,
            "rating": 5,
            "rating_count": 0,
            "data": [],
          })
          .then((_) {
            clearTextFields();
          });
    } catch (e) {
      log("addCourse exception: $e");
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      await _firestore.collection("Courses").doc(id).delete();
    } catch (e) {
      log("deleteCourse exception: $e");
    }
  }

  void editCourse(CourseModel course) {
    titleController.text = course.title;
    typeController.text = course.type;
    descriptionController.text = course.description;
    courseByController.text = course.courseBy;
    imageUrl.value = course.image;
    tags.value = course.tags;
    features.assignAll(course.features);

    chapters.assignAll(course.data.cast<Map<String, dynamic>>());

    Get.toNamed(AppRoutes.courseAddForm, arguments: "Edit");
  }

  void clearTextFields() {
    titleController.clear();
    typeController.clear();
    descriptionController.clear();
    courseByController.clear();
    chapters.clear();

    imageUrl.value = "";
    tags.clear();
    features.clear();
  }
}
