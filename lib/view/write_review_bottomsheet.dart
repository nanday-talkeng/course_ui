import 'package:course_ui/const/colors.dart';
import 'package:course_ui/controllers/review_controller.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';

class WriteReviewBottomsheet extends StatelessWidget {
  WriteReviewBottomsheet({
    super.key,
    required this.course,
    required this.taskType,
    this.oldReview,
  });

  final ReviewController rc = Get.put(ReviewController());
  final CourseModel course;
  final String taskType; //New or Edit
  final double? oldReview;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "How was the Course?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              Obx(
                () => StarRating(
                  onRatingChanged: (rating) {
                    rc.starRating.value = rating;
                  },
                  allowHalfRating: true,
                  color: Colors.amber,
                  size: 40,
                  rating: rc.starRating.value.toDouble(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: rc.reviewText,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Describe your experience",
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                "Reviews are public and include your account info.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.grey.withAlpha(50),
                          foregroundColor: Colors.black,
                        ),
                        child: Text("Cancel"),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 45,

                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // for (int i = 0; i < 100; i++) {
                            //   userId = i.toString();
                            //   rc.reviewText.text = i.toString();
                            //   rc.starRating.value = 3.0;
                            //   rc.submitReview(
                            //     course,
                            //     taskType,
                            //     taskType == "Edit" ? oldReview : null,
                            //   );
                            //   log(i.toString());
                            // }
                            rc.submitReview(
                              course,
                              taskType,
                              taskType == "Edit" ? oldReview : null,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Submit"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
