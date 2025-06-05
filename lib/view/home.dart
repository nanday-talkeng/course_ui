import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_ui/controllers/list_controller.dart';
import 'package:course_ui/data/course_data.dart';
import 'package:course_ui/data/user_data.dart';
import 'package:course_ui/view/course_overview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final ListController lc = Get.put(ListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Courses"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => lc.courseList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: lc.courseList.length,
                  itemBuilder: (context, index) {
                    var item = lc.courseList[index];
                    return InkWell(
                      onTap: () {
                        data.value = item['data'];

                        for (var c in lc.courses) {
                          if (c['id'] == item['id']) {
                            userProgress.value = c as Map<String, dynamic>;
                          }
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CourseOverview(courseData: item),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.withAlpha(85)),
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: item['image'],
                                fit: BoxFit.cover,
                                height: 100,
                                width: 120,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['type'],
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  item['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "By ${item['course_by']}",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  "${item['rating']}⭐",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
