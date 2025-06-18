import 'package:course_ui/const/colors.dart';
import 'package:course_ui/controllers/course_add_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageChapters extends StatelessWidget {
  ManageChapters({super.key});

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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => Scrollbar(
                  radius: Radius.circular(16),
                  child: ListView.builder(
                    itemCount: cac.chapters.length,
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
                                          style: TextStyle(color: Colors.grey),
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
                                  final Map video = chapter['contents'][index];
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
                                        Text(video['duration'].toString()),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        cac.chapters.removeAt(index);
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
            Row(
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
                        //TODO
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
          ],
        ),
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
                "progress": 0,
                "contents": [],
              });
              cac.chapterTitleController.text = "";
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
              controller: cac.chapterTitleController,
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
              controller: cac.chapterTitleController,
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
              cac.chapters[index]['contents'].add(
                {},
              ); //TODO add video to contents list
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
