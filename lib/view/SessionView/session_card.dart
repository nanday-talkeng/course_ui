import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_ui/controllers/SessionView/gd_controller.dart';
import 'package:course_ui/models/SessionView/session_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionCard extends StatelessWidget {
  SessionCard({super.key, required this.sessionData});

  final Session sessionData;

  String getFriendlyDate(DateTime date) {
    return DateFormat('d MMM y, h:mm a').format(date);
  }

  final GdController gdc = GdController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: sessionData.completed ? Colors.green : Colors.amber,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        children: [
          SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 8,
                        ),
                        child: Text(
                          sessionData.group,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${sessionData.studentList.length} Students",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sessionData.title,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),

                  Row(
                    children: [
                      Text(
                        getFriendlyDate(sessionData.scheduleTime.toDate()),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "  |  ${sessionData.sessionFor} ${(sessionData.sessionFor.contains("Min") || sessionData.sessionFor.contains("Hour")) ? "" : "Min"}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      overlapped(sessionData.studentList),
                      Spacer(),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: profilePicture(
                              sessionData.creatorDetails['photoUrl'],
                            ),
                          ),
                          Positioned(
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.amber,
                              child: Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text("Mark session as complete"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                    ),
                                    child: Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      gdc.markAsComplete(sessionData.meetingId);

                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: sessionData.completed
                              ? Colors.grey
                              : Colors.lightBlue,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.check_rounded),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.phone_forwarded_rounded),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.add_call),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.close_rounded),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {},

                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.share_rounded),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.videocam_rounded),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget overlapped(List<dynamic> picList, {String? textline, double? size}) {
    final overlap = (size ?? 32.0) - (size ?? 20.0) / 6;

    picList = picList.toSet().toList();
    picList.shuffle();
    final items = [
      if (picList.length > 7)
        for (var item in picList.sublist(0, 7)) profilePicture(item)
      else
        for (var item in picList) profilePicture(item),
      picList.length > 7
          ? Padding(
              padding: const EdgeInsets.only(left: 20, top: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "+ ${picList.length - 7}",
                    style: TextStyle(color: Colors.grey, fontSize: 10.0),
                  ),
                  Text(
                    "More ${textline ?? 'students'}",
                    style: TextStyle(color: Colors.grey, fontSize: 10.0),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 12, top: 6.0),
              child: Text(
                " ",
                style: TextStyle(color: Colors.grey, fontSize: 10.0),
              ),
            ),
    ];

    List<Widget> stackLayers = List<Widget>.generate(items.length, (index) {
      return Padding(
        padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0),
        child: items[index],
      );
    });

    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: stackLayers,
    );
  }

  Widget profilePicture(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(100),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.all(2),

      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(50),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 40,
          height: 40,
          errorWidget: (context, url, error) => ColoredBox(
            color: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          placeholder: (context, url) => ColoredBox(color: Colors.grey),
        ),
      ),
    );
  }
}
