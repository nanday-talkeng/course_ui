import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  final Timestamp scheduleTime;
  final String scheduleDate;
  final Map creatorDetails;
  final List<String> studentList;
  final String meetingId;
  final String title;
  final String group;
  final String sessionFor;
  final int pin;
  final bool completed;

  Session({
    required this.scheduleTime,
    required this.scheduleDate,
    required this.creatorDetails,
    required this.studentList,
    required this.meetingId,
    required this.title,
    required this.group,
    required this.sessionFor,
    required this.pin,
    required this.completed,
  });

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      scheduleTime: map['scheduleTime'] as Timestamp,
      scheduleDate: map['scheduleDate'] ?? '',
      creatorDetails: map['creatorDetails'] ?? '',
      studentList: List<String>.from(map['studentList'] ?? []),
      meetingId: map['meetingId'] ?? '',
      title: map['title'] ?? '',
      group: map['group'] ?? '',
      sessionFor: (map['sessionFor'] ?? '0').toString(),
      pin: map['pin'] ?? 0,
      completed: map['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'scheduleTime': scheduleTime,
      'scheduleDate': scheduleDate,
      'creatorDetails': creatorDetails,
      'studentList': studentList,
      'meetingId': meetingId,
      'title': title,
      'group': group,
      'sessionFor': sessionFor,
      'pin': pin,
      'completed': completed,
    };
  }
}
