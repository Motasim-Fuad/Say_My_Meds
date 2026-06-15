// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:saymymeds/app/core/consants/api_constants.dart';
// import 'package:saymymeds/app/views/screens/home/controller/recently_scenned_controller.dart';
// import 'package:go_router/go_router.dart';
//
// class RecentlyScznned extends StatelessWidget {
//   const RecentlyScznned({super.key});
//
//   final String baseUrl = ApiConstants.baseUrl;
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(RecentlyScannedController());
//
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       if (controller.errorMessage.value.isNotEmpty) {
//         return Center(
//           child: Text(
//             controller.errorMessage.value,
//             style: const TextStyle(color: Colors.red),
//           ),
//         );
//       }
//
//       final medicines = controller.medicines;
//
//       if (medicines.isEmpty) {
//         return Center(child: Text('noMedicationsFound'.tr));
//       }
//
//       // শুধু শেষ ২টা ডাটা দেখাবে
//       final lastTwoMedicines = medicines.length >= 2
//           ? medicines.sublist(medicines.length - 2)
//           : medicines;
//
//       // ListView এর পরিবর্তে Column ব্যবহার করছি
//       return Column(
//         children: [
//           ...lastTwoMedicines.map((medicine) => Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: _buildMedicineCard(medicine, context),
//           )),
//         ],
//       );
//     });
//   }
//
//   Widget _buildMedicineCard(dynamic medicine, BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: Card(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//           side: const BorderSide(
//             color: Color(0xFF4F85AA),
//             width: 0.5,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Medicine Image
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey[200],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     '$baseUrl${medicine.originalImage}',
//                     fit: BoxFit.contain,
//                     errorBuilder: (_, __, ___) => const Icon(
//                       Icons.medication_outlined,
//                       size: 40,
//                       color: Colors.grey,
//                     ),
//                     loadingBuilder: (_, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//
//               // Medicine Details
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       medicine.genericName,
//                       style: const TextStyle(
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                         color: Colors.black,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 6),
//                     RichText(
//                       text: TextSpan(
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black87,
//                           fontFamily: 'Poppins',
//                         ),
//                         children: [
//                           TextSpan(
//                             text: "${'genericName'.tr}: ",
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           TextSpan(
//                             text: medicine.brandName ?? '',
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _formatDate(medicine.createdAt),
//                           style: const TextStyle(
//                             color: Colors.grey,
//                             fontSize: 11,
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             context.push("/checkInfoPage/${medicine.id}");
//                           },
//                           child: Text(
//                             'viewDetails'.tr,
//                             style: const TextStyle(
//                               fontFamily: 'Open Sans',
//                               fontWeight: FontWeight.w400,
//                               fontSize: 11,
//                               color: Color(0xFF4F85AA),
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(dynamic date) {
//     if (date == null) return '';
//     DateTime parsedDate;
//     if (date is String) {
//       parsedDate = DateTime.tryParse(date) ?? DateTime.now();
//     } else if (date is DateTime) {
//       parsedDate = date;
//     } else {
//       return '';
//     }
//     return '${parsedDate.day.toString().padLeft(2, '0')}/'
//         '${parsedDate.month.toString().padLeft(2, '0')}/'
//         '${parsedDate.year}';
//   }
// }