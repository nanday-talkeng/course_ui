import 'package:course_ui/view/course_overview.dart';
import 'package:course_ui/view/home.dart';
import 'package:course_ui/view/review_list.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => MyHomePage()),
    GetPage(name: AppRoutes.courseOverview, page: () => CourseOverview()),
    GetPage(name: AppRoutes.courseReviews, page: () => ReviewList()),
  ];
}
