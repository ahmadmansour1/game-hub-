class GameCenterModel {
  List<GameCenters>? gameCenters;

  GameCenterModel({this.gameCenters});

  GameCenterModel.fromJson(Map<String, dynamic> json) {
    if (json['gameCenters'] != null) {
      gameCenters = <GameCenters>[];
      json['gameCenters'].forEach((v) {
        gameCenters!.add(new GameCenters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gameCenters != null) {
      data['gameCenters'] = this.gameCenters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GameCenters {
  String? sId;
  String? name;
  int? numberOfRooms;
  List<Prices>? prices;
  String? location;


  GameCenters(
      {this.sId, this.name, this.numberOfRooms, this.prices, this.location});

  GameCenters.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    numberOfRooms = json['numberOfRooms'];
    if (json['prices'] != null) {
      prices = <Prices>[];
      json['prices'].forEach((v) {
        prices!.add(new Prices.fromJson(v));
      });
    }
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['numberOfRooms'] = this.numberOfRooms;
    if (this.prices != null) {
      data['prices'] = this.prices!.map((v) => v.toJson()).toList();
    }
    data['location'] = this.location;
    return data;
  }
}

class Prices {
  int? roomNumber;
  int? pricePerHour;
  String? sId;

  Prices({this.roomNumber, this.pricePerHour, this.sId});

  Prices.fromJson(Map<String, dynamic> json) {
    roomNumber = json['roomNumber'];
    pricePerHour = json['pricePerHour'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomNumber'] = this.roomNumber;
    data['pricePerHour'] = this.pricePerHour;
    data['_id'] = this.sId;
    return data;
  }
}