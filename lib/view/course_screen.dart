import 'dart:developer';
import 'package:course_ui/controllers/course_controller.dart';
import 'package:course_ui/data/user_data.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:course_ui/view/progress_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import '../data/course_data.dart';

class CourseScreen extends StatelessWidget {
  CourseScreen({super.key});

  final CourseModel course = Get.arguments;
  final CourseController cc = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero).then((_) async {
      const platform = MethodChannel('com.example.course_ui/screen_security');
      try {
        await platform.invokeMethod('enableSecurity');
      } catch (e) {
        log("Error enabling screen security: $e");
      }

      cc.course.value = course;

      cc.currentProgress.value = currentCourse['current_stage'];
      cc.subProgress.value = currentCourse['sub_stage'];

      cc.changeVideo(
        data[currentCourse['current_stage']]['contents'][currentCourse['sub_stage']]['video'],
        data[currentCourse['current_stage']]['contents'][currentCourse['sub_stage']]['duration'],
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        const platform = MethodChannel('com.example.course_ui/screen_security');
        await platform.invokeMethod('disableSecurity');
        cc.dispose();
      },
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: cc.ytController,
          onReady: () {
            log("YT Player ready");
          },
        ),
        builder: (context, player) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Course Name"),
              actions: [
                IconButton(
                  onPressed: () {
                    //TODO Help/Support
                  },
                  icon: Icon(Icons.help_outline),
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    player,
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Obx(
                        () => Visibility(
                          visible: cc.showCustomControls.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  cc.playPrevious();
                                },
                                icon: Icon(
                                  Icons.skip_previous,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cc.playNext();
                                },
                                icon: Icon(
                                  Icons.skip_next,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Obx(() => Text("${cc.percentagePlayed.value}%")),
                          Text(
                            "Material",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: data.length,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 16.0),
                            itemBuilder: (context, index) {
                              Map item = data[index];

                              return ProgressTile(
                                item: item,
                                index: index,
                                length: data.length,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
