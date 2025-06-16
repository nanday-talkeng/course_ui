import 'dart:async';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../data/course_data.dart';
import '../data/user_data.dart';

class CourseController extends GetxController {
  final RxInt currentProgress = 0.obs;
  final RxInt subProgress = 0.obs;

  final RxString currentVideo = "".obs;

  late YoutubePlayerController ytController;

  final RxInt seconds = 0.obs; // video played
  final RxDouble secondsTotal = 0.0.obs;
  final RxInt percentagePlayed = 0.obs; // video played

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

  void playNext() {
    if (percentagePlayed.value > 80) {
      //Must play 80% of the video
      if (subProgress.value <
          data[currentProgress.value]['contents'].length - 1) {
        subProgress.value += 1;

        changeVideo(
          data[currentProgress.value]['contents'][subProgress.value]['video'],
          data[currentProgress.value]['contents'][subProgress
              .value]['duration'],
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
          currentCourse['current_stage'] = currentProgress;
          currentCourse['sub_stage'] = subProgress;
          currentCourse['total_played'] += 1;
          currentCourse.refresh();
        } else {
          log("All videos Finished");
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Must play atleast 80% of the video");
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
