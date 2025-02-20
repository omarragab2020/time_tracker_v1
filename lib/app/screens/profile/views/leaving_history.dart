import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:time_tracker/app/controller/vacation_controller.dart';

class LeavingHistoryScreen extends StatelessWidget {
  final VacationController leaveController = Get.put(VacationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        title: const Text(
          "Leaving History",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
      ),
      body: Obx(() {
        if (leaveController.userID.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          width: Get.width,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 24, 46, 59),
          ),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: leaveController.fetchLeaveTimeRequests(leaveController.userID.value),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text(
                  "You don't have ",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> request = snapshot.data![index];
                    String status = request['status'];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                " ${request['from']}  -  ${request['to']}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 12),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: leaveController.getStatusColor(status),
                              ),
                              const SizedBox(width: 12),
                              Text(" ${request['status']}  ", style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        );
      }),
    );
  }
}
