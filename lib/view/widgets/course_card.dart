import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_ui/controllers/list_controller.dart';
import 'package:course_ui/models/course_model.dart';
import 'package:course_ui/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import '../../data/course_data.dart';
import '../../data/user_data.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CourseCard extends StatelessWidget {
  CourseCard({super.key, required this.item});

  final CourseModel item;
  final ListController lc = Get.find();

  void startCourse(CourseModel course) {
    data.value = item.data;

    currentCourse.value = (lc.userCourseProgress as List).firstWhere(
      (c) => c['id'] == item.id,
      orElse: () => {
        "current_stage": 0,
        "sub_stage": 0,
        "finished": false,
        "id": item.id,
        "total_played": 0,
      }, // Assign empty map if not found
    );

    courseId.value = item.id;

    Get.toNamed(AppRoutes.courseOverview, arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withAlpha(85)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),

            child: item.image.length <= 1
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: item.image[0],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1,
                      enlargeCenterPage: false,
                    ),
                    items: item.image.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) =>
                                  ColoredBox(color: Colors.grey),
                              errorWidget: (context, url, error) =>
                                  ColoredBox(color: Colors.grey),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
          ),
          Row(
            children: [
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle_rounded,
                          color: Colors.blue,
                          size: 16,
                        ),
                        Text(
                          " ${item.courseBy}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Spacer(),
                        InkWell(
                          onTap: () {
                            lc.addtoFavourites(item.id);
                          },
                          child: Icon(
                            userData.value.favCourses.contains(item.id)
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline,
                            color: userData.value.favCourses.contains(item.id)
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      item.title,
                      style: TextStyle(
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    // Text(
                    //   item.type,
                    //   style: TextStyle(
                    //     color: Colors.blue,
                    //     fontSize: 10,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${item.rating} ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        StarRating(
                          rating: item.rating,
                          color: Colors.amber,
                          size: 18,
                        ),
                        Text(
                          " (${item.ratingCount})",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.school_rounded, size: 18, color: Colors.red),
                Text(
                  " ${item.data.length} Chapters",
                  style: TextStyle(fontSize: 12),
                ),
                Spacer(),
                Icon(Icons.timer_rounded, size: 18, color: Colors.red),
                Text(" ${item.hours} Hours", style: TextStyle(fontSize: 12)),
                Spacer(),
                Icon(Icons.group_rounded, size: 18, color: Colors.red),
                Text(
                  " ${item.enrolled} Enrolled",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Visibility(
                  visible:
                      (item.originalAmount != 0) ||
                      (item.originalAmount != item.amount),
                  child: Text(
                    "₹${item.originalAmount} ",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  item.isFree ? "Free" : " ₹${item.amount}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: item.isFree ? Colors.green : Colors.black,
                  ),
                ),
                Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    startCourse(item);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                  ),
                  icon: Icon(Icons.dashboard_rounded),
                  label: Text("View Details"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
