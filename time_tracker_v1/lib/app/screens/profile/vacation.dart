import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/app/controller/vacation_controller.dart';
import 'package:time_tracker/app/screens/profile/views/leaving_history.dart';
import 'package:time_tracker/app/screens/profile/views/vacation_history.dart';
import 'package:time_tracker/app/services/api.dart';
import 'package:time_tracker/app/widgets/vacation_widget.dart';

class VacationScreen extends StatelessWidget {
  VacationScreen({super.key});

  final controller = Get.find<VacationController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.grey[300],
            title: const Text(
              "Vacations",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
          ),
          body: Container(
            width: Get.width,
            height: Get.height,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 24, 46, 59),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.to(() => LeavingHistoryScreen());
                          },
                          icon: const Icon(
                            Icons.access_time,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.to(() => VacationHistoryScreen());
                          },
                          icon: const Icon(
                            Icons.event_available,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // applyLeavingButton(() {
                    //   Get.to(() => VacationHistoryScreen());
                    // }, 'Show History of Vacations'),

                    const SizedBox(height: 12),
                    vacationAlignWidget('Send a request for vacation'),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        vacationDays('Allowed days : ${api.AnnualLeave}'),
                        // vacationDays('Allowed days : ${api.AnnualLeave}'),
                        const Spacer(),
                        Obx(() {
                          final remain = api.AnnualLeave! - controller.remainDays.value;
                          return vacationDays('Remain : $remain');
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(() => Visibility(
                          visible: controller.remainDays.value == 0,
                          child: ToggleButtons(
                            isSelected: [controller.leaveType.value == "Annual", controller.leaveType.value == "Sick"],
                            onPressed: (int index) {
                              if (index == 0) {
                                controller.leaveType.value = "Annual";
                              } else {
                                controller.leaveType.value = "Sick";
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: Colors.white,
                            color: Colors.orange,
                            fillColor: Colors.lightBlue,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text("Annual", style: TextStyle(fontSize: 16)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text("Sick", style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 20),
                    Obx(() => Visibility(
                          visible: controller.remainDays.value == 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              vacationDate(
                                () => controller.selectDate(context, true),
                                'From',
                                controller.fromDate.value == null ? "  " : "  ${DateFormat('yyyy-MM-dd').format(controller.fromDate.value!)}",
                              ),
                              vacationDate(
                                () => controller.selectDate(context, false),
                                'To',
                                controller.toDate.value == null ? "  " : "  ${DateFormat('yyyy-MM-dd').format(controller.toDate.value!)}",
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 20),

                    Obx(() => Visibility(
                          visible: controller.remainDays.value > 0, // 🔥 إخفاء الزر بالكامل إذا remainDays == 0
                          child: applyLeavingButton(
                            controller.remainDays.value == 0
                                ? null // ❌ تعطيل الزر عند عدم وجود أيام متاحة
                                : () async {
                                    await api.refresh();
                                    controller.sendRequestVacation(controller.userID.value, controller.leaveType.value);
                                  },
                            controller.remainDays.value == 0 ? 'غير مسموح' : 'Apply for Vacation', // 🔥 تغيير النص ديناميكيًا
                            controller.remainDays.value == 0 ? Colors.red : Colors.green, // 🎨 تغيير اللون تلقائيًا
                          ),
                        )),

                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    vacationAlignWidget('Send a request for leaving'),
                    const SizedBox(height: 20),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          vacationDate(() => controller.selectTime(context, true), "From",
                              (controller.fromTime.value == null ? " " : " ${controller.formatTimeOfDay(controller.fromTime.value!)}")),
                          vacationDate(() => controller.selectTime(context, false), "To",
                              (controller.toTime.value == null ? " " : " ${controller.formatTimeOfDay(controller.toTime.value!)}")),
                        ],
                      );
                    }),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: controller.descriptionController,
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(.9),
                        filled: true,
                        label: const Text("Description"),
                        labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    applyLeavingButton(
                      () async {
                        String description = controller.descriptionController.text.trim();
                        await api.refresh();
                        if (description.isNotEmpty) {
                          controller.sendRequestLeave(controller.userID.value, description);
                        } else {
                          Get.snackbar(
                            "Please enter a description",
                            '',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      "Apply for leaving",
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
