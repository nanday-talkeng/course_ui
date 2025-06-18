import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_ui/const/colors.dart';
import 'package:course_ui/controllers/course_add_controller.dart';
import 'package:course_ui/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseAddForm extends StatelessWidget {
  CourseAddForm({super.key});

  final CourseAddController cac = Get.put(CourseAddController());
  final _formKey = GlobalKey<FormState>();

  final String type = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("$type Course"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: InkWell(
                  onTap: () {},
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Obx(
                        () => cac.imageUrl.value == ""
                            ? Container(
                                decoration: BoxDecoration(color: Colors.grey),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add_rounded,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Upload an Image",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: cac.imageUrl.value,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cac.titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
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
                controller: cac.typeController,
                decoration: InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(),
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
                controller: cac.descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",

                  border: OutlineInputBorder(),
                ),

                maxLines: 4,
                minLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cac.courseByController,
                decoration: InputDecoration(
                  labelText: "Course By",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // cac.addCourse();
                      Get.toNamed(AppRoutes.manageChapters);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Next ($type Videos)"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
