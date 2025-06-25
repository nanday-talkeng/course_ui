import 'package:course_ui/models/user_model.dart';
import 'package:get/get.dart';

String userId = "Din7wKdWg8GSRbY784aS-1";

final Rx<UserModel> userData = UserModel(
  uid: "",
  name: "",
  image: "",
  email: "",
  courses: [],
).obs;

final RxMap currentCourse = {}.obs;
