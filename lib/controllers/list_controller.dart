import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/data/user_data.dart';
import 'package:course_ui/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final box = GetStorage();

  @override
  void onInit() {
    getCourseList();
    getUserData();
    getUserCourses();
    super.onInit();
  }

  final RxList courseList = [].obs;

  Future<void> getCourseList() async {
    const cacheKey = 'cached_course_list';
    const expiryKey = 'cached_course_list_expiry';

    final int? expiryTimestamp = box.read(expiryKey);
    final now = DateTime.now().millisecondsSinceEpoch;

    // If data exists and not expired, use cache
    if (expiryTimestamp != null && now < expiryTimestamp) {
      final List<dynamic>? cachedData = box.read(cacheKey);
      if (cachedData != null) {
        courseList.assignAll(List<Map<String, dynamic>>.from(cachedData));

        log("Loaded course list from cache");
        return;
      }
    }

    try {
      await _firestore.collection("Courses").get().then((snapshot) {
        courseList.assignAll(snapshot.docs.map((s) => s.data()).toList());

        // Update cache
        box.write(cacheKey, courseList.toList());
        box.write(expiryKey, now + const Duration(minutes: 60).inMilliseconds);

        log("Loaded course list from Firestore and cached");
      });
    } catch (e) {
      log("getCourseList exception: $e");
    }
  }

  Future<void> getUserData() async {
    try {
      await _firestore.collection("Users").doc(userId).get().then((snapshot) {
        userData.value = UserModel.fromJson(snapshot.data()!);
        log(userData.value.courses.toString());
      });
    } catch (e) {
      log("getUserData exception: $e");
    }
  }

  RxList<Map> userCourseProgress = <Map>[].obs;

  Future<void> getUserCourses() async {
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
