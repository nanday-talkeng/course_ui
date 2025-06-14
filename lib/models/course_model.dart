class CourseModel {
  final double rating;
  final int ratingCount;
  final List data;
  final String courseBy;
  final String id;
  final String image;
  final String title;
  final String description;
  final List<FeatureModel> features;
  final List<String> tags;
  final String type;

  CourseModel({
    required this.rating,
    required this.ratingCount,
    required this.data,
    required this.courseBy,
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.features,
    required this.tags,
    required this.type,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      ratingCount: json['rating_count'],
      data: json['data'],
      courseBy: json['course_by'],
      id: json['id'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
      features: (json['features'] as List)
          .map((e) => FeatureModel.fromJson(e))
          .toList(),
      tags: List<String>.from(json['tags']),
      type: json['type'],
    );
  }
}

// class StageModel {
//   final int progress;
//   final String title;
//   final List<ContentModel> contents;

//   StageModel({
//     required this.progress,
//     required this.title,
//     required this.contents,
//   });

//   factory StageModel.fromJson(Map<String, dynamic> json) {
//     return StageModel(
//       progress: int.tryParse(json['progress'].toString()) ?? 0,
//       title: json['title'],
//       contents: (json['contents'] as List)
//           .map((e) => ContentModel.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class ContentModel {
//   final String title;
//   final double duration;
//   final String video;

//   ContentModel({
//     required this.title,
//     required this.duration,
//     required this.video,
//   });

//   factory ContentModel.fromJson(Map<String, dynamic> json) {
//     return ContentModel(
//       title: json['title'],
//       duration: double.tryParse(json['duration'].toString()) ?? 0.0,
//       video: json['video'],
//     );
//   }
// }

class FeatureModel {
  final String sub;
  final String icon;
  final String title;

  FeatureModel({required this.sub, required this.icon, required this.title});

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      sub: json['sub'],
      icon: json['icon'],
      title: json['title'],
    );
  }
}
