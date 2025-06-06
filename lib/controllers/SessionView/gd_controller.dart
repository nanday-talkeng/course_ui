import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GdController extends GetxController {
  final RxList<Map> sessionList = <Map>[].obs;

  // @override
  // void onInit() {
  //   getSessionList();
  //   super.onInit();
  // }

  final Rx<dynamic> collectionRef = FirebaseFirestore.instance
      .collection("sessions")
      .orderBy("scheduleTime")
      .obs;

  // final RxBool isLoading = false.obs;

  // void getSessionList() async {
  //   sessionList.clear();
  //   isLoading.value = true;

  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("sessions")
  //         .orderBy("scheduleTime")
  //         .get()
  //         .then((snapshot) {
  //           sessionList.assignAll(snapshot.docs.map((e) => e.data()).toList());
  //           isLoading.value = false;

  //           log("getSessionList done");
  //         });
  //   } catch (e) {
  //     isLoading.value = false;
  //     log("getSessionList exception: $e");
  //   }
  // }

  // void getSessionListByTime(String date) async {
  //   log(date);
  //   sessionList.clear();
  //   isLoading.value = true;

  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("sessions")
  //         .orderBy("scheduleTime")
  //         .where("scheduleDate", isEqualTo: date)
  //         .get()
  //         .then((snapshot) {
  //           sessionList.assignAll(snapshot.docs.map((e) => e.data()).toList());
  //           isLoading.value = false;
  //           sortByTime(ascending: true);
  //         });
  //   } catch (e) {
  //     isLoading.value = false;
  //     log("getSessionList exception: $e");
  //   }
  // }

  final RxString selectedGroup = 'All Groups'.obs;

  List<String> groupOptions = [
    'All Groups',
    'General Conversation',
    'Everyday Conversations',
    'Current Affairs',
    'Learning',
    'History',
  ];

  final RxString selectedTIme = 'Ascending'.obs;

  List<String> timeOptions = ['Ascending', 'Descending'];

  void sortByTime({bool ascending = true}) {
    log("Sorted $ascending");
    sessionList.sort((a, b) {
      final timeA = (a['scheduleTime'] as Timestamp).toDate();
      final timeB = (b['scheduleTime'] as Timestamp).toDate();
      return ascending ? timeA.compareTo(timeB) : timeB.compareTo(timeA);
    });
    sessionList.refresh();
  }

  void markAsComplete(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("sessions")
          .doc(id)
          .set({'completed': true}, SetOptions(merge: true))
          .then((_) {
            log("markAsComplete done");
          });
    } catch (e) {
      log("markAsComplete exception: $e");
    }
  }

  final RxString selectedFilter = "".obs;

  void resetAllFilter() async {
    collectionRef.value = FirebaseFirestore.instance
        .collection("sessions")
        .orderBy("scheduleTime");

    selectedTIme.value = 'Ascending';
    selectedGroup.value = 'All Groups';
    selectedFilter.value = "";
  }
}
