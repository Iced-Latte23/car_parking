import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/reserved/controllers/reserved_controller.dart';

class ReservationBottomSheet extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController plateNumberController;
  final TextEditingController phoneNumberController;
  final String slotId;
  final VoidCallback onConfirm;
  final ReservedController controller = Get.find<ReservedController>();

  ReservationBottomSheet({
    required this.firstNameController,
    required this.lastNameController,
    required this.plateNumberController,
    required this.phoneNumberController,
    required this.slotId,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 55),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'Reservation Confirmation',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                      labelText: 'First Name', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(width: 25),
              Expanded(
                child: TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                      labelText: 'Last Name', border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          TextField(
            controller: plateNumberController,
            decoration: InputDecoration(
                labelText: 'Plate Number', border: OutlineInputBorder()),
          ),
          SizedBox(height: 15),
          TextField(
            controller: phoneNumberController,
            decoration: InputDecoration(
                labelText: 'Phone Number', border: OutlineInputBorder()),
          ),
          SizedBox(height: 15),
          TextField(
            readOnly: true,
            controller: TextEditingController(text: slotId),
            decoration: InputDecoration(
                labelText: 'Slot Number', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                controller.selectedTime.value = picked;
              }
            },
            child: Obx(() => InputDecorator(
                decoration: InputDecoration(
                    labelText: 'Select Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time)),
                child: Text(
                    controller.selectedTime.value != null
                        ? controller.selectedTime.value!.format(context)
                        : 'Tap on select time',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                textStyle: TextStyle(fontSize: 22, color: Colors.white),
                minimumSize: Size(MediaQuery.of(context).size.width, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onConfirm,
              child: Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }
}
