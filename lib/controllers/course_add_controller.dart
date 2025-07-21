import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:course_ui/routes/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class CourseAddController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController courseByController = TextEditingController();
  final TextEditingController promoVideoController = TextEditingController();
  final TextEditingController tagAdd = TextEditingController();

  final TextEditingController originalAmountController =
      TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final TextEditingController featureTitle = TextEditingController();
  final TextEditingController featureSubtitle = TextEditingController();

  final TextEditingController chapterTitleController = TextEditingController();

  final TextEditingController videoTitleController = TextEditingController();
  final TextEditingController videoIdController = TextEditingController();
  final TextEditingController videoDurationController = TextEditingController();

  final RxList imageList = [].obs;
  final RxList<String> tags = <String>[].obs;
  final RxList<FeatureModel> features = <FeatureModel>[].obs;

  final RxList chapters = [].obs;

  final RxString isFree = "Yes".obs;
  final items = ['Yes', 'No'];

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
            "features": features.map((e) => e.toJson()).toList(),
            "tags": tags,
            "image": imageList,
            "video": extractYoutubeVideoId(promoVideoController.text),
            "rating": 5,
            "rating_count": 0,
            "data": chapters,
            "hours": int.parse(hoursController.text),
            "isFree": isFree.value == "Yes" ? true : "No",
            "original_amount": isFree.value == "Yes"
                ? 0
                : int.parse(originalAmountController.text),
            "amount": isFree.value == "Yes"
                ? 0
                : int.parse(amountController.text),
          }, SetOptions(merge: true))
          .then((_) {
            clearTextFields();
            Get.offAllNamed(AppRoutes.home);
          });
    } catch (e) {
      log("addCourse exception: $e");
    }
  }

  Future<void> editCourseDetails(String id) async {
    try {
      await _firestore
          .collection("Courses")
          .doc(id)
          .set({
            "title": titleController.text,
            "description": descriptionController.text,
            "type": typeController.text,
            "course_by": courseByController.text,
            "features": features.map((e) => e.toJson()).toList(),
            "tags": tags,
            "image": imageList,
            "video": extractYoutubeVideoId(promoVideoController.text),
            "data": chapters,
            "hours": int.parse(hoursController.text),
            "isFree": isFree.value == "Yes" ? true : "No",
            "original_amount": isFree.value == "Yes"
                ? 0
                : int.parse(originalAmountController.text),
            "amount": isFree.value == "Yes"
                ? 0
                : int.parse(amountController.text),
          }, SetOptions(merge: true))
          .then((_) {
            clearTextFields();
            Get.offAllNamed(AppRoutes.home);
          });
    } catch (e) {
      log("editCourseDetails exception: $e");
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
    imageList.value = course.image;
    promoVideoController.text = course.video ?? "";
    tags.value = course.tags;
    features.assignAll(course.features);

    hoursController.text = (course.hours ?? 0).toString();

    isFree.value = course.isFree ? "Yes" : "No";
    originalAmountController.text = (course.originalAmount ?? 0).toString();
    amountController.text = (course.amount).toString();

    chapters.assignAll(course.data.cast<Map<String, dynamic>>());

    Get.toNamed(AppRoutes.courseAddForm, arguments: course.id);
  }

  void clearTextFields() {
    titleController.clear();
    typeController.clear();
    hoursController.clear();
    descriptionController.clear();
    courseByController.clear();
    originalAmountController.clear();
    amountController.clear();
    chapters.clear();

    imageList.clear();
    tags.clear();
    features.clear();
  }

  Future<void> pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) return; // User cancelled

      File imageFile = File(pickedFile.path);
      String fileName = path.basename(imageFile.path);

      // Create reference
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child("Course_thumbnail")
          .child("${DateTime.now().millisecondsSinceEpoch}_$fileName");

      // Upload
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      imageList.add(downloadUrl);
    } catch (e) {
      log("Image upload error: $e");
      return;
    }
  }

  String? extractYoutubeVideoId(String url) {
    final RegExp regExp = RegExp(
      r'(?:(?:v=)|(?:\/embed\/)|(?:\/shorts\/)|(?:youtu\.be\/))([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );

    final match = regExp.firstMatch(url);
    if (match != null) return match.group(1);

    // Fallback: if input looks like a video ID
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(url)) {
      return url;
    }

    return null;
  }
}
