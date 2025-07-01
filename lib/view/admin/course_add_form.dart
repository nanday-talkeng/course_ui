import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_ui/const/colors.dart';
import 'package:course_ui/controllers/course_add_controller.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:course_ui/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseAddForm extends StatelessWidget {
  CourseAddForm({super.key});

  final CourseAddController cac = Get.put(CourseAddController());
  final _formKey = GlobalKey<FormState>();

  final String type = Get.arguments; // Add / id(for Edit)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("${type == "Add" ? "Add" : "Edit"} Course"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => cac.imageList.isEmpty
                      ? uploadButton()
                      : SizedBox(
                          height: 100,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: cac.imageList.length + 1,
                            itemBuilder: (context, index) {
                              if (index == cac.imageList.length) {
                                return uploadButton();
                              }
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 6,
                                      right: 16,
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: cac.imageList[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 10,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black.withOpacity(
                                        0.5,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          cac.imageList.removeAt(index);
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: cac.hoursController,
                        decoration: InputDecoration(
                          labelText: "Hours",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
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
                TextFormField(
                  controller: cac.promoVideoController,
                  decoration: InputDecoration(
                    labelText: "Promo Video (Youtube Link)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Row(
                    children: [
                      Text("Is Free: "),
                      DropdownButton<String>(
                        value: cac.isFree.value,
                        items: cac.items
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) cac.isFree.value = value;
                        },
                      ),
                      const SizedBox(width: 8),
                      Visibility(
                        visible: cac.isFree.value == "No",
                        child: Expanded(
                          child: TextFormField(
                            controller: cac.originalAmountController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Original Amt.",
                              hintText: "0",
                              prefixText: "₹ ",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (cac.isFree.value == "No") {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                final amount = int.tryParse(value);
                                if (amount == null || amount <= 0) {
                                  return 'Amount should be greater than 0';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Visibility(
                        visible: cac.isFree.value == "No",
                        child: Expanded(
                          child: TextFormField(
                            controller: cac.amountController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Current Amt.",
                              hintText: "0",
                              prefixText: "₹ ",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (cac.isFree.value == "No") {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                final amount = int.tryParse(value);
                                if (amount == null || amount <= 0) {
                                  return 'Amount should be greater than 0';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                Text("Tags"),
                Obx(
                  () => Wrap(
                    spacing: 8.0,
                    runSpacing: 2.0,
                    children: cac.tags.map((tag) {
                      return InputChip(
                        label: Text(tag),
                        side: BorderSide(color: Colors.blue.withOpacity(0.5)),
                        deleteIcon: Icon(Icons.close),
                        onDeleted: () {
                          cac.tags.remove(tag);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: cac.tagAdd,
                        decoration: InputDecoration(
                          hintText: "Tag",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 45,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          if (cac.tagAdd.text != "") {
                            cac.tags.add(cac.tagAdd.text);
                            cac.tagAdd.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Add"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text("Features"),
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: cac.features.length,
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var feature = cac.features[index];
                      return ListTile(
                        dense: true,
                        title: Text(feature.title),
                        subtitle: Text(feature.sub),
                        trailing: IconButton(
                          onPressed: () {
                            cac.features.removeAt(index);
                          },
                          icon: Icon(Icons.close),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: cac.featureTitle,
                        decoration: InputDecoration(
                          hintText: "Title",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: cac.featureSubtitle,
                        decoration: InputDecoration(
                          hintText: "Subtitle",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 45,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          if ((cac.featureTitle.text != "") &&
                              (cac.featureSubtitle.text != "")) {
                            cac.features.add(
                              FeatureModel.fromJson({
                                "title": cac.featureTitle.text,
                                "sub": cac.featureSubtitle.text,
                                "icon": "type",
                              }),
                            );
                            cac.featureTitle.clear();
                            cac.featureSubtitle.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Add"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Get.toNamed(AppRoutes.manageChapters, arguments: type);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      "Next (${type == "Add" ? "Add" : "Edit"} Videos)",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget uploadButton() {
    return InkWell(
      onTap: () {
        cac.pickAndUploadImage();
      },

      child: Container(
        height: 100,
        width: 100,
        margin: const EdgeInsets.only(top: 4, right: 4),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: Colors.white),
              Text(
                "Upload Image",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
