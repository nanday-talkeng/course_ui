import 'dart:async';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseController extends GetxController {
  final List data = [
    {
      'title': "Preparing for the Interview",
      'progress': 0,
      'contents': [
        {
          'title': "Breaking down job descriptions",
          'duration': 16.43,
          'video': "sCQ0VYNCmKw",
        },
        {
          'title': "Aligning skills with requirements",
          'duration': 5.49,
          'video': "8bD1F97azDk",
        },
        {
          'title': "Common questions related the role",
          'duration': 8.37,
          'video': "hwQw0AXa4Ys",
        },
      ],
    },
    {
      'title': "Understand the Role",
      'progress': 25,
      'contents': [
        {
          'title': "How to start app Development",
          'duration': 17.47,
          'video': "7nQsQ0rvYqQ",
        },
        {'title': "Web Vs App", 'duration': 12.20, 'video': "vQcHPQJ4Ujs"},
        {
          'title': "What is Web Development?",
          'duration': 5.39,
          'video': "Ax83R9krXaw",
        },
      ],
    },
    {
      'title': "Learn More, Earn More",
      'progress': 50,
      'contents': [
        {
          'title': "Breaking down job descriptions",
          'duration': 16.44,
          'video': "sCQ0VYNCmKw",
        },
        {
          'title': "Aligning skills with requirements",
          'duration': 5.50,
          'video': "8bD1F97azDk",
        },
        {
          'title': "Common questions related the role",
          'duration': 8.38,
          'video': "hwQw0AXa4Ys",
        },
      ],
    },
    {
      'title': "You are a Champ !",
      'progress': 100,
      'contents': [
        {
          'title': "Breaking down job descriptions",
          'duration': 16.43,
          'video': "sCQ0VYNCmKw",
        },
        {
          'title': "Aligning skills with requirements",
          'duration': 5.50,
          'video': "8bD1F97azDk",
        },
        {
          'title': "Common questions related the role. Long title UI Check",
          'duration': 8.38,
          'video': "hwQw0AXa4Ys",
        },
      ],
    },
  ];

  final RxInt currentProgress = 0.obs;
  final RxInt subProgress = 0.obs;

  final RxString currentVideo = "qxOkaU6RVz4".obs;

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
  void onInit() {
    super.onInit();

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

      percentagePlayed.value = ((100 / secondsTotal.value) * seconds.value)
          .toInt();
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
