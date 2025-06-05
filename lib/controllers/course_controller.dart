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

  Timer? _timer;
  final RxInt seconds = 0.obs; // video played
  final RxDouble secondsTotal = 0.0.obs;
  final RxInt percentagePlayed = 0.obs; // video played

  void startTimer() {
    _timer ??= Timer.periodic(Duration(seconds: 1), (timer) {
      seconds.value++; // 👈 Increment observable
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void restartTimer() {
    stopTimer();
    seconds.value = 0;
    startTimer();
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    currentProgress.value = userProgress['current_stage'];
    subProgress.value = userProgress['sub_stage'];

    currentVideo.value =
        data[currentProgress.value]['contents'][subProgress.value]['video'];

    log("Initial Video: ${data[0]['contents'][0]['video']}");
    ytController = YoutubePlayerController(
      initialVideoId: currentVideo.value,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );

    bool isVideoEndedHandled = false;

    ytController.addListener(() {
      if (ytController.value.playerState == PlayerState.playing) {
        startTimer();
        isVideoEndedHandled = false;
      } else if (ytController.value.playerState == PlayerState.paused ||
          ytController.value.playerState == PlayerState.buffering) {
        stopTimer();
      } else if (ytController.value.playerState == PlayerState.ended &&
          !isVideoEndedHandled) {
        isVideoEndedHandled = true; // Prevent multiple calls
        playNext();
      }

      if (secondsTotal.value > 0 && seconds.value >= 0) {
        percentagePlayed.value = ((100 / secondsTotal.value) * seconds.value)
            .toInt();
      } else {
        percentagePlayed.value = 0;
      }

      log(percentagePlayed.value.toString());
    });

    ever(currentVideo, (String id) {
      ytController.load(id);
    });
  }

  void changeVideo(String id, double duration) {
    currentVideo.value = id;
    secondsTotal.value = (duration * 60.0);
  }

  void startVideo() {
    currentProgress.value = userProgress['current_stage'];
    subProgress.value = userProgress['sub_stage'];

    changeVideo(
      data[0]['contents'][0]['video'],
      data[0]['contents'][0]['duration'],
    );
  }

  void playNext() {
    if (percentagePlayed.value > 10) {
      //Must play 10% of the video
      if (subProgress.value <
          data[currentProgress.value]['contents'].length - 1) {
        subProgress.value += 1;

        restartTimer();
        changeVideo(
          data[currentProgress.value]['contents'][subProgress.value]['video'],
          data[currentProgress.value]['contents'][subProgress
              .value]['duration'],
        );

        //Updating user progress
        userProgress['sub_stage'] = subProgress;
        userProgress['total_played'] += 1;
        userProgress.refresh();
      } else {
        if (currentProgress.value < data.length - 1) {
          currentProgress.value += 1;
          subProgress.value = 0;

          restartTimer();
          changeVideo(
            data[currentProgress.value]['contents'][subProgress.value]['video'],
            data[currentProgress.value]['contents'][subProgress
                .value]['duration'],
          );

          //Updating user progress
          userProgress['current_stage'] = currentProgress;
          userProgress['sub_stage'] = subProgress;
          userProgress['total_played'] += 1;
          userProgress.refresh();
        } else {
          stopTimer();
          log("All videos Finished");
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Must play atleast 10% of the video");
    }
  }

  void playPrevious() {
    if (subProgress.value > 0) {
      subProgress.value -= 1;
      restartTimer();
      changeVideo(
        data[currentProgress.value]['contents'][subProgress.value]['video'],
        data[currentProgress.value]['contents'][subProgress.value]['duration'],
      );
    } else {
      if (currentProgress.value > 0) {
        currentProgress.value -= 1;
        subProgress.value = 0;
        restartTimer();
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
    stopTimer();
    super.onClose();
  }
}
