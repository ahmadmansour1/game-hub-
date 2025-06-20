import 'package:game/data/game_center.dart';
import 'package:game/data/user.dart';

class BookingModel {
  final String? id;
  final User? user;
  final GameCenters? gameCenter;
  final int? roomNumber;
  final String? date;
  final String? startTime;
  final String? endTime;
  final int? duration;
  final int? price;
  final String? status;

  BookingModel({
     this.id,
     this.user,
     this.gameCenter,
     this.roomNumber,
     this.date,
     this.startTime,
     this.endTime,
     this.duration,
     this.price,
    this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'],
      user: User.fromJson(json['user']),
      gameCenter: GameCenters.fromJson(json['gameCenter']),
      roomNumber: json['roomNumber'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      duration: json['duration'],
      price: json['price'],
      status: json['status'],
    );
  }
}

