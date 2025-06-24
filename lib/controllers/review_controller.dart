import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/data/user_data.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxDouble starRating = 0.0.obs;
  final TextEditingController reviewText = TextEditingController();

  final RxList reviewList = [].obs;
  final RxBool isLoading = false.obs;

  Future<void> getReviewList(String id) async {
    isLoading.value = true;
    reviewList.clear();
    log("getReviewList called");
    try {
      await _firestore.collection("reviews").doc(id).get().then((snapshot) {
        reviewList.value = snapshot.data()!.values.toList();
        reviewList.sort(
          (a, b) => (b['time'] as Timestamp).compareTo(a['time'] as Timestamp),
        );

        isLoading.value = false;
        log("getReviewList success");
      });
    } catch (e) {
      isLoading.value = false;
      log("getReviewList exception: $e");
    }
  }

  Future<void> submitReview(
    CourseModel course,
    String type,
    double? oldRating,
  ) async {
    try {
      final double newRating = starRating.value;
      final int currentCount = course.ratingCount;
      final double currentAverage = course.rating;

      double newAverage;

      if (type == "New") {
        newAverage =
            ((currentAverage * currentCount) + newRating) / (currentCount + 1);
      } else if (oldRating != null) {
        newAverage =
            ((currentAverage * currentCount) - oldRating + newRating) /
            currentCount;
      } else {
        throw Exception("Old rating is null during edit");
      }

      newAverage = double.parse(newAverage.toStringAsFixed(1));

      await _firestore.collection("reviews").doc(course.id).set({
        userId: {
          "rating": newRating,
          "review": reviewText.text.trim(),
          "time": Timestamp.now(),
          "uid": userData.value.uid,
          "name": userData.value.name,
          "image": userData.value.image,
        },
      }, SetOptions(merge: true));

      reviewList.add({
        "rating": newRating,
        "review": reviewText.text.trim(),
        "time": Timestamp.now(),
        "uid": userData.value.uid,
        "name": userData.value.name,
        "image": userData.value.image,
      });

      reviewList.sort(
        (a, b) => (b['time'] as Timestamp).compareTo(a['time'] as Timestamp),
      );

      reviewText.clear();
      starRating.value = 0.0;
      Fluttertoast.showToast(msg: "Review submitted");
      Get.back();

      await _firestore.collection("Courses").doc(course.id).set({
        "rating": newAverage,
        "rating_count": type == "New" ? currentCount + 1 : currentCount,
      }, SetOptions(merge: true));
    } catch (e) {
      log("submitReview exception: $e");
      Fluttertoast.showToast(msg: "Something went wrong.");
    }
  }
}
