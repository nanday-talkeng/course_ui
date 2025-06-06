import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ui/controllers/SessionView/gd_controller.dart';
import 'package:course_ui/view/SessionView/session_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../models/SessionView/session_model.dart';
import 'package:intl/intl.dart';

class SessionList extends StatelessWidget {
  SessionList({super.key});

  final GdController gdc = Get.put(GdController());

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      gdc.collectionRef.value = FirebaseFirestore.instance
          .collection("sessions")
          .orderBy("scheduleTime")
          .where(
            "scheduleDate",
            isEqualTo: DateFormat('dd-MM-yyyy').format(picked),
          );
      gdc.selectedFilter.value = "ByDate";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text("Session View"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text("Filter"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text("Group: "),
                            Obx(
                              () => DropdownButton<String>(
                                value: gdc.selectedGroup.value,
                                onChanged: (value) {
                                  if (value != null) gdc.selectedGroup(value);
                                  Navigator.pop(context);
                                },
                                items: gdc.groupOptions.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Order by Schedule: "),
                            Obx(
                              () => DropdownButton<String>(
                                value: gdc.selectedTIme.value,
                                onChanged: (value) {
                                  if (value != null) gdc.selectedTIme(value);
                                  if (value == "Ascending") {
                                    gdc.sortByTime(ascending: true);
                                  } else {
                                    gdc.sortByTime(ascending: false);
                                  }
                                  Navigator.pop(context);
                                },
                                items: gdc.timeOptions.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          gdc.resetAllFilter();
                          Navigator.pop(context);
                        },
                        child: Text("Clear Filters"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.tune),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    gdc.resetAllFilter();
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: gdc.selectedFilter.value == ""
                            ? Colors.blue.withAlpha(100)
                            : Colors.grey.withAlpha(100),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.filter_alt_rounded, size: 16),
                          ),
                          Text(" Show All "),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    gdc.collectionRef.value = FirebaseFirestore.instance
                        .collection("sessions")
                        .orderBy("scheduleTime")
                        .where(
                          "scheduleDate",
                          isEqualTo: DateFormat(
                            'dd-MM-yyyy',
                          ).format(DateTime.now()),
                        );
                    gdc.selectedFilter.value = "Today";
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: gdc.selectedFilter.value == "Today"
                            ? Colors.blue.withAlpha(100)
                            : Colors.grey.withAlpha(100),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 12,
                            child: Icon(Icons.today_rounded, size: 16),
                          ),
                          Text(" Today "),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8.0),
                InkWell(
                  onTap: () {
                    _pickDate(context);
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: gdc.selectedFilter.value == "ByDate"
                            ? Colors.blue.withAlpha(100)
                            : Colors.grey.withAlpha(100),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.calendar_month_rounded, size: 16),
                          ),
                          Text(" Search by date "),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: Obx(
                () => gdc.selectedGroup.value == "All Groups"
                    ? FirestoreListView(
                        shrinkWrap: true,
                        query: gdc.collectionRef.value,
                        itemBuilder: (context, doc) {
                          Session session = Session.fromMap(
                            doc.data() as Map<String, dynamic>,
                          );

                          return SessionCard(sessionData: session);
                        },
                        emptyBuilder: (context) =>
                            Center(child: Text("No sessions found")),
                      )
                    : FirestoreListView(
                        shrinkWrap: true,
                        query: gdc.collectionRef.value,
                        itemBuilder: (context, doc) {
                          Session session = Session.fromMap(
                            doc.data() as Map<String, dynamic>,
                          );

                          if (session.group == gdc.selectedGroup.value) {
                            return SessionCard(sessionData: session);
                          } else {
                            return SizedBox();
                          }
                        },
                        emptyBuilder: (context) =>
                            Center(child: Text("No sessions found")),
                      ),
              ),
            ),
          ),
          // Obx(() {
          //   if (gdc.isLoading.value) {
          //     return Center(child: CircularProgressIndicator());
          //   }
          //   if (gdc.sessionList.isEmpty) {
          //     return Center(child: Text("No sessions found"));
          //   }

          //   final sessions = gdc.selectedGroup.value == "All Groups"
          //       ? gdc.sessionList
          //       : gdc.sessionList
          //             .where(
          //               (session) =>
          //                   session['group'] == gdc.selectedGroup.value,
          //             )
          //             .toList();

          //   return Expanded(
          //     child: Scrollbar(
          //       child: ListView.builder(
          //         itemCount: sessions.length,
          //         padding: EdgeInsets.only(bottom: 6),
          //         itemBuilder: (context, index) {
          //           Session session = Session.fromMap(
          //             sessions[index] as Map<String, dynamic>,
          //           );

          //           return SessionCard(sessionData: session);
          //         },
          //       ),
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }
}
