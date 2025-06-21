import 'package:course_ui/const/colors.dart';
import 'package:course_ui/controllers/course_add_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ManageChapters extends StatelessWidget {
  ManageChapters({super.key});

  final String type = Get.arguments; // Edit / Add

  final CourseAddController cac = Get.find();

  final _chapterFormKey = GlobalKey<FormState>();
  final _videoFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Chapters/Videos"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => cac.chapters.isEmpty
                  ? Center(child: Text("No Chapters added"))
                  : Scrollbar(
                      radius: Radius.circular(16),
                      child: ListView.builder(
                        itemCount: cac.chapters.length,
                        padding: EdgeInsets.all(12),
                        itemBuilder: (context, index) {
                          final Map chapter = cac.chapters[index];
                          return Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Chapter ${index + 1}",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              chapter['title'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                addVideo(context, index),
                                          );
                                        },
                                        icon: Icon(Icons.add),
                                        label: Text("Add Video"),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          cac.chapters.removeAt(index);
                                        },
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.grey.withAlpha(100)),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: chapter['contents'].length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final Map video =
                                          chapter['contents'][index];
                                      return ListTile(
                                        dense: true,
                                        leading: Icon(
                                          Icons.play_circle_rounded,
                                          color: primaryColor,
                                        ),
                                        title: Text(video['title']),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(video['video']),
                                            Text(
                                              video['duration']
                                                  .toString()
                                                  .replaceAll(".", ":"),
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            //cac.chapters[].removeAt(index);
                                          },
                                          icon: Icon(
                                            Icons.close_rounded,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => addChapter(context),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Add Chapter"),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (cac.chapters.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Must add atleast one chapter",
                          );
                        } else {
                          type == "Add"
                              ? cac.addCourse()
                              : cac.editCourseDetails(type);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Save Changes"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addChapter(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Add Chapter"),
      content: Form(
        key: _chapterFormKey,
        child: TextFormField(
          controller: cac.chapterTitleController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Chapter Title",
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_chapterFormKey.currentState!.validate()) {
              cac.chapters.add({
                "title": cac.chapterTitleController.text,
                "contents": [],
              });
              cac.videoTitleController.text = "";
              cac.videoIdController.text = "";
              cac.videoDurationController.text = "";
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text("Add"),
        ),
      ],
    );
  }

  Widget addVideo(BuildContext context, int index) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Add Video"),
      content: Form(
        key: _videoFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: cac.videoTitleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Video Title",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: cac.videoIdController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Video Link",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: cac.videoDurationController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Video Duration",
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_videoFormKey.currentState!.validate()) {
              cac.chapters[index]['contents'].add({
                "title": cac.videoTitleController.text,
                "video": cac.extractYoutubeVideoId(cac.videoIdController.text),
                "duration": double.parse(cac.videoDurationController.text),
              });
              cac.chapters.refresh();
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text("Add"),
        ),
      ],
    );
  }
}
