import 'package:flutter/material.dart';
import 'package:game/controllers/booking_conmtroller.dart';
import 'package:game/service/payment_service.dart';
import 'package:get/get.dart';

import '../../data/game_center.dart';

class RequestForm extends StatefulWidget {
  final GameCenters center;
  final int pricePerHour;
  final String userId; // pass user info for booking API

  const RequestForm({
    Key? key,
    required this.center,
    required this.pricePerHour,
    required this.userId,
  }) : super(key: key);

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  bool _isProcessing = false;

  final BookingController bookingController = Get.find(); // assuming initialized somewhere

  void _showBookingDialog() {
    final roomController = TextEditingController();
    final dateController = TextEditingController();
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();

    Get.defaultDialog(
      title: "Confirm Booking",
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("Game Center: ${widget.center.name}"),
            const SizedBox(height: 10),
            TextField(
              controller: roomController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Room Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Date (YYYY-MM-DD)",
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  dateController.text = date.toIso8601String().split('T').first;
                }
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: startTimeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Start Time (HH:mm AM/PM)",
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  startTimeController.text = time.format(context);
                }
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: endTimeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "End Time (HH:mm AM/PM)",
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  endTimeController.text = time.format(context);
                }
              },
            ),
          ],
        ),
      ),
      textConfirm: "Confirm",
      textCancel: "Cancel",
      onConfirm: () async {
        if (roomController.text.isEmpty ||
            dateController.text.isEmpty ||
            startTimeController.text.isEmpty ||
            endTimeController.text.isEmpty) {
          Get.snackbar("Error", "Please fill all booking details",
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        int? roomNumber = int.tryParse(roomController.text);
        if (roomNumber == null || roomNumber <= 0) {
          Get.snackbar("Error", "Please enter a valid room number",
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        Get.back(); // close dialog

        setState(() => _isProcessing = true);

        try {
          // Step 1: Payment
          await PaymentManager.makePayment(widget.pricePerHour.toInt(), "usd");

          // Step 2: Call your booking API here
          bool success = await bookingController.createBooking(
            userId: widget.userId,
            gameCenterId: widget.center.sId!,
            roomNumber: roomNumber,
            date: dateController.text,
            startTime: _convertTo24HourFormat(startTimeController.text),
            endTime: _convertTo24HourFormat(endTimeController.text),
            price: widget.pricePerHour.toDouble(),
          );

          if (success) {
            Get.snackbar("Success", "Booking created successfully",
                backgroundColor: Colors.green, colorText: Colors.white);
          } else {
            Get.snackbar("Failed", "Booking creation failed",
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        } catch (e) {
          Get.snackbar("Payment Failed", e.toString(),
              backgroundColor: Colors.red, colorText: Colors.white);
        } finally {
          setState(() => _isProcessing = false);
        }
      },
      confirmTextColor: Colors.white,
      buttonColor: Colors.deepPurple,
      cancelTextColor: Colors.deepPurple,
    );
  }

  String _convertTo24HourFormat(String time12h) {
    // Time format from TimeOfDay.format is like: '5:30 PM' or '11:15 AM'
    try {
      final parts = time12h.split(' ');
      if (parts.length != 2) return time12h; // unexpected format, return as is

      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      final String ampm = parts[1].toUpperCase();

      if (ampm == "PM" && hour != 12) {
        hour += 12;
      } else if (ampm == "AM" && hour == 12) {
        hour = 0;
      }

      final hourStr = hour.toString().padLeft(2, '0');
      final minStr = minute.toString().padLeft(2, '0');
      return "$hourStr:$minStr";
    } catch (e) {
      return time12h; // fallback, return original
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          widget.center.name!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.center.location!,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              "Rooms: ${widget.center.numberOfRooms} • Price/hr: \$${widget.pricePerHour.toString()}",
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: _isProcessing
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 3),
        )
            : ElevatedButton(
          onPressed: _showBookingDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Book Now"),
        ),
      ),
    );
  }
}
