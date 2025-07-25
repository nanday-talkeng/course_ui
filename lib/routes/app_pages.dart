import 'package:course_ui/bindings/course_binding.dart';
import 'package:course_ui/view/certificate_screen.dart';
import 'package:course_ui/view/admin/course_add_form.dart';
import 'package:course_ui/view/course_overview.dart';
import 'package:course_ui/view/course_screen.dart';
import 'package:course_ui/view/home.dart';
import 'package:course_ui/view/admin/manage_chapters.dart';
import 'package:course_ui/view/review_list.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => MyHomePage()),
    GetPage(name: AppRoutes.courseOverview, page: () => CourseOverview()),
    GetPage(
      name: AppRoutes.courseScreen,
      page: () => CourseScreen(),
      binding: CourseBinding(),
    ),
    GetPage(name: AppRoutes.courseReviews, page: () => ReviewList()),
    GetPage(name: AppRoutes.certificateScreen, page: () => CertificateScreen()),

    GetPage(name: AppRoutes.courseAddForm, page: () => CourseAddForm()),
    GetPage(name: AppRoutes.manageChapters, page: () => ManageChapters()),
  ];
}
