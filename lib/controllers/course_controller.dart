import 'dart:developer';
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
          'duration': "12:23",
          'video': "sCQ0VYNCmKw",
        },
        {
          'title': "Aligning skills with requirements",
          'duration': "12:23",
          'video': "8bD1F97azDk",
        },
        {
          'title': "Common questions related the role",
          'duration': "12:23",
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
          'duration': "12:23",
          'video': "7nQsQ0rvYqQ",
        },
        {'title': "Web Vs App", 'duration': "12:23", 'video': "vQcHPQJ4Ujs"},
        {
          'title': "What is Web Development?",
          'duration': "12:23",
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
          'duration': "12:23",
          'video': "sCQ0VYNCmKw",
        },
        {
          'title': "Aligning skills with requirements",
          'duration': "12:23",
          'video': "8bD1F97azDk",
        },
        {
          'title': "Common questions related the role",
          'duration': "12:23",
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
          'duration': "12:23",
          'video': "sCQ0VYNCmKw",
        },
        {
          'title': "Aligning skills with requirements",
          'duration': "12:23",
          'video': "30BrCz0KPNg",
        },
        {
          'title': "Common questions related the role",
          'duration': "12:23",
          'video': "hwQw0AXa4Ys",
        },
      ],
    },
  ];

  final RxInt currentProgress = 0.obs;
  final RxInt subProgress = 0.obs;

  final RxString currentVideo = "qxOkaU6RVz4".obs;

  late YoutubePlayerController ytController;

  @override
  void onInit() {
    super.onInit();

    ytController = YoutubePlayerController(
      initialVideoId: currentVideo.value,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );

    bool isVideoEndedHandled = false;

    ytController.addListener(() {
      if (ytController.value.playerState == PlayerState.ended &&
          !isVideoEndedHandled) {
        isVideoEndedHandled = true; // Prevent multiple calls

        onVideoEnded();
      }

      // Reset flag when a new video starts playing
      if (ytController.value.playerState == PlayerState.playing) {
        isVideoEndedHandled = false;
      }
    });

    ever(currentVideo, (String id) {
      ytController.load(id);
    });
  }

  void changeVideo(String id) {
    currentVideo.value = id;
  }

  void onVideoEnded() {
    if (subProgress.value <
        data[currentProgress.value]['contents'].length - 1) {
      subProgress.value += 1;
      currentVideo.value =
          data[currentProgress.value]['contents'][subProgress.value]['video'];
    } else {
      if (currentProgress.value < data.length - 1) {
        currentProgress.value += 1;
        subProgress.value = 0;
        currentVideo.value =
            data[currentProgress.value]['contents'][subProgress.value]['video'];
      } else {
        log("All videos Finished");
      }
    }
  }

  @override
  void onClose() {
    ytController.dispose();
    super.onClose();
  }
}
