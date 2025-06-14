import 'package:course_ui/controllers/course_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressTile extends StatelessWidget {
  ProgressTile({super.key, required this.item, required this.index});

  final int index;
  final Map item;

  final CourseController cc = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withAlpha(85)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: cc.currentProgress.value == index,
          backgroundColor: Colors.grey.withAlpha(25),
          leading: Obx(
            () => cc.currentProgress.value > index
                ? CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.teal,

                    child: Icon(Icons.check_rounded, color: Colors.white),
                  )
                : cc.currentProgress.value != index
                ? CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.teal,

                    child: Icon(Icons.hourglass_bottom, color: Colors.white),
                  )
                : CircularPercentIndicator(
                    radius: 24.0,
                    lineWidth: 5.0,
                    percent: item['progress'] / 100,
                    center: Text(
                      "${item['progress']}%",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    progressColor: Colors.deepOrangeAccent,
                  ),
          ),
          title: Text("Stage ${index + 1}"),
          subtitle: Text(
            item['title'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          children: [
            Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              itemCount: item['contents'].length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final Map subItem = item['contents'][index];
                return InkWell(
                  onTap: () {
                    String videoId = subItem['video'];
                    cc.subProgress.value = index;
                    cc.changeVideo(videoId, subItem['duration']);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Obx(
                      () => Row(
                        children: [
                          Icon(
                            cc.currentVideo.value == subItem['video']
                                ? Icons.stop_circle_rounded
                                : Icons.play_circle_rounded,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Obx(
                              () => Text(
                                subItem['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:
                                      cc.currentVideo.value == subItem['video']
                                      ? Colors.green
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16.0),
                          Text(
                            subItem['duration'].toString().replaceAll(".", ":"),
                            style: TextStyle(
                              color: cc.currentVideo.value == subItem['video']
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
