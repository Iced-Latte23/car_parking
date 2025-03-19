import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_car_parking/app/widgets/show_dialog.dart';
import '../controllers/reserved_controller.dart';

class ReservedView extends GetView<ReservedController> {
  const ReservedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Reservation', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 35),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Entrance',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10), // Add some spacing
            // Use Obx to reactively update the UI
            Obx(() {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (var i = 0; i < controller.slots.length; i += 2)
                          _buildSlot(i),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        for (var i = 1; i < controller.slots.length; i += 2)
                          _buildSlot(i),
                      ],
                    ),
                  ),
                ],
              );
            }),

            SizedBox(height: 45),
            Obx(() {
              if(controller.selectedSlot.value == -1) return const SizedBox();
              final selectedSlotIndex = controller.selectedSlot.value;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey)
                  )
                ),
                child: Column(
                  children: [
                    Text(
                        'Selected Slot: ${controller.slots[selectedSlotIndex]['id']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      ElevatedButton(
                        onPressed: controller.confirmSelection,
                        child: const Text('Confirm'),
                      ),
                      TextButton(onPressed: controller.cancelSelection, child: const Text('Cancel'),)
                    ],)
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSlot(int index) {
    return Obx(() {
      final slot = controller.slots[index];
      return GestureDetector(
        onTap: () => controller.selectSlot(index),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: slot['status'] == 'free' ? Colors.green[400] : Colors.red[400],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Slot ${slot['id']}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }


}