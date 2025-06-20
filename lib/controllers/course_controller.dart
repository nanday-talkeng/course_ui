import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/routes/app_routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../data/course_data.dart';
import '../data/user_data.dart';

class CourseController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxInt currentProgress = 0.obs;
  final RxInt subProgress = 0.obs;

  final RxString currentVideo = "".obs;

  late YoutubePlayerController ytController;

  final RxInt seconds = 0.obs; // video played
  final RxDouble secondsTotal = 0.0.obs;
  final RxInt percentagePlayed = 0.obs; // video played

  RxBool showCustomControls = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    currentProgress.value = currentCourse['current_stage'];
    subProgress.value = currentCourse['sub_stage'];

    currentVideo.value =
        data[currentProgress.value]['contents'][subProgress.value]['video'];

    ytController = YoutubePlayerController(
      initialVideoId: currentVideo.value,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );

    bool isVideoEndedHandled = false;

    ytController.addListener(() {
      showCustomControls.value = ytController.value.isControlsVisible;

      if (ytController.value.playerState == PlayerState.playing) {
        isVideoEndedHandled = false;

        percentagePlayed.value =
            ((100 / secondsTotal.value) * ytController.value.position.inSeconds)
                .toInt();
      } else if (ytController.value.playerState == PlayerState.paused ||
          ytController.value.playerState == PlayerState.buffering) {
      } else if (ytController.value.playerState == PlayerState.ended &&
          !isVideoEndedHandled) {
        isVideoEndedHandled = true; // Prevent multiple calls
        playNext();
      }
    });

    ever(currentVideo, (String id) {
      ytController.load(id);
    });
  }

  void changeVideo(String id, double duration) {
    log("Changing video");
    currentVideo.value = id;
    secondsTotal.value = (duration * 60.0);
  }

  void startVideo() {
    currentProgress.value = currentCourse['current_stage'];
    subProgress.value = currentCourse['sub_stage'];

    changeVideo(
      data[0]['contents'][0]['video'],
      data[0]['contents'][0]['duration'],
    );
  }

  Future<void> playNext() async {
    if (currentProgress.value < currentCourse['current_stage']) {
      nextVideo();
    } else {
      if (percentagePlayed.value > 80) {
        nextVideo();
      } else {
        Fluttertoast.showToast(msg: "Must play atleast 80% of the video");
      }
    }
  }

  Future<void> nextVideo() async {
    //Must play 80% of the video
    if (subProgress.value <
        data[currentProgress.value]['contents'].length - 1) {
      subProgress.value += 1;

      changeVideo(
        data[currentProgress.value]['contents'][subProgress.value]['video'],
        data[currentProgress.value]['contents'][subProgress.value]['duration'],
      );

      //Updating user progress
      currentCourse['sub_stage'] = subProgress;
      currentCourse['total_played'] += 1;
      currentCourse.refresh();
    } else {
      if (currentProgress.value < data.length - 1) {
        currentProgress.value += 1;
        subProgress.value = 0;

        changeVideo(
          data[currentProgress.value]['contents'][subProgress.value]['video'],
          data[currentProgress.value]['contents'][subProgress
              .value]['duration'],
        );

        //Updating user progress
        currentCourse['current_stage'] = currentProgress.value;
        currentCourse['sub_stage'] = subProgress.value;
        currentCourse['total_played'] += 1;
        currentCourse.refresh();

        try {
          //Updating if user finished course
          await _firestore //TODO
              .collection("user_course_progress")
              .doc(userId)
              .set({
                courseId.value: {
                  "id": courseId.value,
                  "current_stage": currentProgress.value,
                  "sub_stage": subProgress.value,
                  "finished": false,
                },
              }, SetOptions(merge: true))
              .then((_) {
                log("course progress updated");
              });
        } catch (e) {
          log("Updating next video exception $e");
        }
      } else {
        log("All videos Finished");
        Get.toNamed(AppRoutes.certificateScreen);
        try {
          //Updating if user finished course
          await _firestore //TODO
              .collection("user_course_progress")
              .doc(userId)
              .set({
                courseId.value: {
                  "id": courseId.value,
                  "current_stage": currentProgress.value,
                  "sub_stage": subProgress.value,
                  "finished": true,
                },
              }, SetOptions(merge: true))
              .then((_) {
                log("course finish updated");
              });
        } catch (e) {
          log("Setting course complete exception: $e");
        }
      }
    }
  }

  void playPrevious() {
    if (subProgress.value > 0) {
      subProgress.value -= 1;

      changeVideo(
        data[currentProgress.value]['contents'][subProgress.value]['video'],
        data[currentProgress.value]['contents'][subProgress.value]['duration'],
      );
    } else {
      if (currentProgress.value > 0) {
        currentProgress.value -= 1;
        subProgress.value = data[currentProgress.value]['contents'].length - 1;

        changeVideo(
          data[currentProgress.value]['contents'][subProgress.value]['video'],
          data[currentProgress.value]['contents'][subProgress
              .value]['duration'],
        );
      } else {
        log("you've reached top");
      }
    }
  }

  @override
  void onClose() {
    ytController.dispose();
    super.onClose();
  }
}
