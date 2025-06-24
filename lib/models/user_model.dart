class UserModel {
  final String uid;
  final String name;
  final String email;
  final String image;
  final List<dynamic>
  courses; // You can change this to List<String> or List<CourseModel> if needed

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.image,
    required this.courses,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      courses: json['courses'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
      'courses': courses,
    };
  }
}
