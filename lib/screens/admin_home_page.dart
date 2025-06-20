import 'package:flutter/material.dart';
import 'package:game/controllers/booking_conmtroller.dart';
import 'package:get/get.dart';

class AdminHomePage extends StatelessWidget {
  AdminHomePage({super.key});

  final BookingController bookingController = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        final bookings = bookingController.bookings;
        final totalBookings = bookings.length;
        final totalRevenue = bookings.fold(0.0, (sum, b) => sum + b.price!);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryCard("Total Bookings", "$totalBookings", Icons.calendar_today, Colors.orange),
                    _buildSummaryCard("Revenue", "\$${totalRevenue.toStringAsFixed(2)}", Icons.attach_money, Colors.green),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Today's Bookings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                bookings.isEmpty
                    ? const Center(child: Text("No bookings found"))
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final  booking = bookings[index];

                    return GestureDetector(
                      onTap: (){
                        if (booking.status == 'pending') {
                          _showApprovalDialog(context, booking);
                        }

                      },
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(booking.roomNumber.toString()),
                          ),
                          title: Text("User: ${booking.user!.username}"),
                          subtitle: Text("Time: ${booking.startTime} - ${booking.endTime}"),
                          trailing: Icon(
                            booking.status == "approved" ? Icons.check_circle : Icons.hourglass_bottom,
                            color: booking.status == "approved" ? Colors.green : Colors.orange,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color iconColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
  void _showApprovalDialog(BuildContext context, dynamic booking) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, color: Colors.blueAccent, size: 36),
              const SizedBox(height: 10),
              const Text(
                "Booking Confirmation",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildDetailRow("Game Center", booking.gameCenter?.name),
              _buildDetailRow("Room", booking.roomNumber.toString()),
              _buildDetailRow("Date", booking.date),
              _buildDetailRow("Time", "${booking.startTime} - ${booking.endTime}"),
              const SizedBox(height: 20),
              const Text(
                "Do you want to approve or decline this booking?",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Decline Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await bookingController.updateStatus(booking.id, 'declined');

                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Decline",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Approve Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await bookingController.updateStatus(booking.id, 'approved');
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Approve",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
