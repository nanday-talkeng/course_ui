import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String image;
  final String uid;
  final String review;
  final String name;
  final double rating;
  final Timestamp time;

  ReviewModel({
    required this.image,
    required this.uid,
    required this.review,
    required this.name,
    required this.rating,
    required this.time,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      image: json['image'] ?? '',
      uid: json['uid'] ?? '',
      review: json['review'] ?? '',
      name: json['name'] ?? '',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] ?? 0.0),
      time: json['time'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'uid': uid,
      'review': review,
      'name': name,
      'rating': rating,
      'time': time,
    };
  }

  DateTime get date => time.toDate(); // optional helper
}
