import 'dart:developer';

import 'package:course_ui/controllers/course_controller.dart';
import 'package:course_ui/view/widgets/progress_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class CourseScreen extends StatelessWidget {
  CourseScreen({super.key});

  final CourseController cc = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      cc.currentProgress.value = 0;
      cc.subProgress.value = 0;
      cc.changeVideo(cc.data[0]['contents'][0]['video']);
      const platform = MethodChannel('com.example.course_ui/screen_security');
      try {
        await platform.invokeMethod('enableSecurity');
      } catch (e) {
        log("Error enabling screen security: $e");
      }
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        const platform = MethodChannel('com.example.course_ui/screen_security');
        await platform.invokeMethod('disableSecurity');
      },
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(controller: cc.ytController),
        builder: (context, player) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(title: Text("Course Name")),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                player,
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Obx(
                          // () => Text("Progress: ${cc.currentProgress.value}"),
                          //),
                          //Obx(
                          //  () => Text("Sub Progress: ${cc.subProgress.value}"),
                          // ),
                          // Obx(() => Text("Video Id: ${cc.currentVideo.value}")),
                          Text(
                            "Material",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: cc.data.length,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 16.0),
                            itemBuilder: (context, index) {
                              Map item = cc.data[index];
                              return ProgressTile(item: item, index: index);
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
