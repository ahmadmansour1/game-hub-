// import 'package:flutter/material.dart';
// import 'package:game/controllers/booking_conmtroller.dart';
// import 'package:get/get.dart';
//
// class BookingListPage extends StatelessWidget {
//   final BookingController bookingController = Get.find<BookingController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (bookingController.isLoading.value) {
//         return Center(child: CircularProgressIndicator());
//       }
//
//       if (bookingController.bookings.isEmpty) {
//         return Center(child: Text('No bookings found.'));
//       }
//
//       return ListView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: bookingController.bookings.length,
//         itemBuilder: (context, index) {
//           final booking = bookingController.bookings[index];
//           return ListTile(
//             title: Text('${booking.gameCenter!.name} - Room ${booking.roomNumber}'),
//             subtitle: Text('Date: ${booking.date}\nTime: ${booking.startTime} - ${booking.endTime}'),
//             trailing: Text(
//               '${booking.status!.toUpperCase()}',
//               style: TextStyle(
//                 color: _getStatusColor(booking.status!),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             },
//           );
//         },
//       );
//     });
//   }
//
//
// }
