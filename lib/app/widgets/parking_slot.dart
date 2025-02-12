// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../app/modules/reserved/controllers/reserved_controller.dart';
//
// class ParkingSlotWidget extends StatelessWidget {
//   final int index;
//   final ReservedController controller = Get.find();
//
//   ParkingSlotWidget({required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       var slotData = controller.reservedSlots[index];
//       bool isOccupied = slotData["status"] == "Occupied";
//       bool isSelected = controller.selectedSlot.value == index;
//
//       return GestureDetector(
//         onTap: () {
//           if (isOccupied) {
//             // Show a message if the slot is occupied
//             Get.snackbar(
//               'Occupied',
//               'This slot is already occupied. Please select another slot.',
//               snackPosition: SnackPosition.BOTTOM,
//               backgroundColor: Colors.red.shade600,
//               colorText: Colors.white,
//             );
//           } else {
//             // Toggle selection for the slot
//             controller.selectSlot(index);
//           }
//         },
//         child: AnimatedContainer(
//           duration: Duration(milliseconds: 150),
//           width: 120,
//           height: 65,
//           margin: EdgeInsets.symmetric(vertical: 8),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: isSelected
//                   ? [Colors.blue.shade600, Colors.blue.shade800]
//                   : (isOccupied
//                   ? [Colors.red.shade600, Colors.red.shade800]
//                   : [Colors.green.shade600, Colors.green.shade800]),
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             border: Border.all(
//               color: isSelected ? Colors.blue.shade900 : Colors.black,
//               width: 2,
//             ),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 6,
//                 offset: Offset(3, 3),
//               ),
//             ],
//           ),
//           alignment: Alignment.center,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Slot ${slotData["slot"]}',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   shadows: [
//                     Shadow(
//                       color: Colors.black45,
//                       blurRadius: 2,
//                       offset: Offset(1, 1),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 4),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     isOccupied ? Icons.directions_car : Icons.check_circle,
//                     color: Colors.white70,
//                     size: 18,
//                   ),
//                   SizedBox(width: 4),
//                   Text(
//                     isOccupied ? 'Occupied' : 'Free',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }