import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/const/colors.dart';
import 'package:course_ui/controllers/review_controller.dart';
import 'package:course_ui/data/user_data.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:course_ui/view/write_review_bottomsheet.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class ReviewList extends StatelessWidget {
  ReviewList({super.key});

  final CourseModel course = Get.arguments;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ReviewController rc = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Reviews"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              radius: Radius.circular(16),
              child: FirestoreListView(
                query: _firestore
                    .collection("Courses")
                    .doc(course.id)
                    .collection("reviews")
                    .orderBy("time", descending: true),
                padding: EdgeInsets.symmetric(vertical: 6),
                emptyBuilder: (context) =>
                    Center(child: Text("No reviews found")),
                errorBuilder: (context, error, stackTrace) =>
                    Center(child: Text("Something went wrong")),
                itemBuilder: (context, doc) {
                  final Map review = doc.data();
                  return reviewCard(context, review);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      rc.reviewText.text = "";
                      rc.starRating.value = 0;
                      return WriteReviewBottomsheet(
                        course: course,
                        taskType: "New",
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text("Write your Review"),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget reviewCard(BuildContext context, Map review) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withAlpha(85)),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(40),
                  child: CachedNetworkImage(
                    imageUrl: review['image'],
                    fit: BoxFit.cover,
                    height: 38,
                    width: 38,
                    errorWidget: (context, url, error) =>
                        ColoredBox(color: Colors.grey),
                    placeholder: (context, url) =>
                        ColoredBox(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${review['name'] ?? ""}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          StarRating(
                            rating: review['rating'].toDouble() ?? 0,
                            color: Colors.amber,
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                          Text(
                            " ${review['rating']}",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Text(
                            DateFormat(
                              'dd MMMM yyyy',
                            ).format(review['time'].toDate()),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review['review'] ?? "",
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),

            Visibility(
              visible: review['uid'] == userData['uid'],
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      rc.reviewText.text = review['review'];
                      rc.starRating.value = review['rating'];
                      return WriteReviewBottomsheet(
                        course: course,
                        taskType: "Edit",
                        oldReview: review['rating'],
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.edit, size: 18, color: primaryColor),
                      Text(
                        " Edit your review",
                        style: TextStyle(fontSize: 12, color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
