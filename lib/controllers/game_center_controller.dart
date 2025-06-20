import 'package:game/data/booking.dart';
import 'package:game/data/game_center.dart';
import 'package:game/service/api_serveice.dart';
import 'package:get/get.dart';

class GameCenterController extends GetxController {
  var isLoading = false.obs;

  // Observable list of GameCenters
  var gameCenters = <GameCenters>[].obs;

  Future<void> fetchGameCenters() async {
    try {
      isLoading.value = true;

      final result = await ApiService.getAllGameCenters();

      if (result != null && result.gameCenters != null) {
        gameCenters.value = result.gameCenters!;  // Assign list here
      } else {
        gameCenters.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }


}
