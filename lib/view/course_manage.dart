import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/const/colors.dart';
import 'package:course_ui/controllers/course_add_controller.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:course_ui/routes/app_routes.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class CourseManage extends StatelessWidget {
  CourseManage({super.key});

  final CourseAddController cac = Get.put(CourseAddController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          cac.clearTextFields();
          Get.toNamed(AppRoutes.courseAddForm, arguments: "Add");
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: Icon(Icons.add_rounded),
        label: Text("Add Course"),
      ),
      body: FirestoreListView(
        query: FirebaseFirestore.instance.collection("Courses"),
        padding: EdgeInsets.symmetric(vertical: 6),
        itemBuilder: (context, doc) {
          final CourseModel course = CourseModel.fromJson(doc.data());
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: ListTile(
              title: Text(course.title),
              subtitle: Text("By ${course.courseBy}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      cac.editCourse(course);
                    },
                    icon: Icon(Icons.edit_outlined, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text("Delete Course"),
                            content: Text(
                              "Are you sure? this action can't be undone",
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
                                  cac.deleteCourse(course.id);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
