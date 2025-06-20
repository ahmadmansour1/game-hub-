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
}
