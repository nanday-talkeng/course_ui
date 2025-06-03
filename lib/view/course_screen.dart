import 'package:course_ui/controllers/course_controller.dart';
import 'package:course_ui/view/widgets/progress_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:flutter_in_app_pip/pip_widget.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseScreen extends StatelessWidget {
  CourseScreen({super.key});

  final CourseController cc = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero).then((_) {
      cc.currentProgress.value = 0;
      cc.subProgress.value = 0;
      cc.changeVideo(cc.data[0]['contents'][0]['video']);
    });

    return YoutubePlayerBuilder(
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
                        ElevatedButton(
                          onPressed: () {
                            PictureInPicture.startPiP(
                              pipWidget: PiPWidget(
                                onPiPClose: () {
                                  //Handle closing events e.g. dispose controllers.
                                },
                                elevation: 10, //Optional
                                pipBorderRadius: 10,
                                child: Container(
                                  child: Text("data"),
                                ), //Optional
                              ),
                            );
                          },
                          child: Text("Start PIP"),
                        ),
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
    );
  }
}
