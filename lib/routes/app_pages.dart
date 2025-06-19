import 'package:course_ui/view/course_add_form.dart';
import 'package:course_ui/view/course_overview.dart';
import 'package:course_ui/view/course_screen.dart';
import 'package:course_ui/view/home.dart';
import 'package:course_ui/view/manage_chapters.dart';
import 'package:course_ui/view/review_list.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => MyHomePage()),
    GetPage(name: AppRoutes.courseOverview, page: () => CourseOverview()),
    GetPage(name: AppRoutes.courseScreen, page: () => CourseScreen()),
    GetPage(name: AppRoutes.courseReviews, page: () => ReviewList()),

    GetPage(name: AppRoutes.courseAddForm, page: () => CourseAddForm()),
    GetPage(name: AppRoutes.manageChapters, page: () => ManageChapters()),
  ];
}
