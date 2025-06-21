import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_ui/const/colors.dart';
import 'package:course_ui/controllers/review_controller.dart';
import 'package:course_ui/data/user_data.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:course_ui/models/review_model.dart';
import 'package:course_ui/view/write_review_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReviewList extends StatelessWidget {
  ReviewList({super.key});

  final CourseModel course = Get.arguments;
  final ReviewController rc = Get.put(ReviewController());

  final RxInt selectedStar = 0.obs;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero).then((_) {
      rc.getReviewList(course.id);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Reviews"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: 6,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 8),
              itemBuilder: (context, index) {
                return Center(
                  child: InkWell(
                    onTap: () {
                      selectedStar.value = index;
                    },
                    borderRadius: BorderRadius.circular(40),
                    child: Obx(
                      () => Container(
                        width: 64,
                        decoration: BoxDecoration(
                          color: selectedStar.value == index
                              ? primaryColor
                              : Colors.grey.withAlpha(60),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 20,
                              color: selectedStar.value == index
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            Text(
                              index == 0 ? "All" : index.toString(),
                              style: TextStyle(
                                color: selectedStar.value == index
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: selectedStar.value == index
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text("Comment"),
                Spacer(),
                Text(
                  "⭐${course.rating}",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("(${course.ratingCount})"),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => rc.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Scrollbar(
                      radius: Radius.circular(16),
                      child: ListView.builder(
                        itemCount: rc.reviewList.length,
                        itemBuilder: (context, index) {
                          final ReviewModel review = ReviewModel.fromJson(
                            rc.reviewList[index],
                          );
                          return Obx(
                            () => selectedStar.value == 0
                                ? reviewCard(context, review)
                                : selectedStar.value == review.rating
                                ? reviewCard(context, review)
                                : SizedBox(),
                          );
                        },
                      ),
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

  Widget reviewCard(BuildContext context, ReviewModel review) {
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
                    imageUrl: review.image,
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
                        review.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          StarRating(
                            rating: review.rating.toDouble(),
                            color: Colors.amber,
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                          Text(
                            " ${review.rating}",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Text(
                            DateFormat(
                              'dd MMMM yyyy',
                            ).format(review.time.toDate()),
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
            Text(review.review, maxLines: 5, overflow: TextOverflow.ellipsis),

            Visibility(
              visible: review.uid == userId,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    enableDrag: true,
                    builder: (context) {
                      rc.reviewText.text = review.review;
                      rc.starRating.value = review.rating;
                      return WriteReviewBottomsheet(
                        course: course,
                        taskType: "Edit",
                        oldReview: review.rating,
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
