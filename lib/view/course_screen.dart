import 'dart:developer';
import 'package:course_ui/controllers/course_controller.dart';
import 'package:course_ui/controllers/user_controller.dart';
import 'package:course_ui/view/widgets/progress_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class CourseScreen extends StatelessWidget {
  CourseScreen({super.key});

  final CourseController cc = Get.put(CourseController());
  final UserController uc = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      cc.currentProgress.value = uc.userProgress['current_stage'];
      cc.subProgress.value = uc.userProgress['sub_stage'];

      cc.changeVideo(
        cc.data[0]['contents'][0]['video'],
        cc.data[0]['contents'][0]['duration'],
      );
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
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
