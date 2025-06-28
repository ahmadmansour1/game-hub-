import 'dart:convert';

import 'package:game/data/booking.dart';
import 'package:game/service/api_serveice.dart';
import 'package:get/get.dart';


class BookingController extends GetxController {
  var isLoading = false.obs;
  var bookings = <BookingModel>[].obs;
  @override
  void onInit() {
    fetchBookings();
    super.onInit();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final result = await ApiService.getBookings();
      bookings.value = result;
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> updateStatus(String bookingId, String newStatus) async {
    final success = await ApiService.updateBookingStatus(bookingId, newStatus);
    if (success) {
      await fetchBookings(); // refresh data
      Get.snackbar('Success', 'Booking $newStatus', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to update status', snackPosition: SnackPosition.BOTTOM);
    }
  }
  Future<bool> createBooking({
    required String userId,
    required String gameCenterId,
    required int roomNumber,
    required String date,       // 'YYYY-MM-DD'
    required String startTime,  // 'HH:mm'
    required String endTime,    // 'HH:mm'
    required double price,
  }) async {
    try {
      isLoading.value = true;

      final success = await ApiService.createBooking(
        userId: userId,
        gameCenterId: gameCenterId,
        roomNumber: roomNumber,
        date: date,
        startTime: startTime,
        endTime: endTime,
        price: price,
      );


      return success;
    } finally {
      isLoading.value = false;
    }
  }

}
