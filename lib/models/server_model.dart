import 'package:hive_flutter/hive_flutter.dart';

part 'server_model.g.dart';

@HiveType(typeId: 0)
class Server {
  @HiveField(0)
  String address;

  @HiveField(1)
  int port;

  @HiveField(2)
  String username;

  @HiveField(3)
  String password;

  @HiveField(4)
  bool save;

  @HiveField(5)
  bool isKey;

  @HiveField(6)
  bool couldReach;

  Server(
    this.address,
    this.port,
    this.username,
    this.password,
    this.save,
    this.isKey, {
    this.couldReach = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Server &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          port == other.port &&
          username == other.username;

  @override
  int get hashCode =>
      address.hashCode + (username.hashCode << 16) + (port.hashCode << 24);

  static Server fromMap(Map<String, dynamic> serverdata) => Server(
        serverdata["address"],
        serverdata["port"],
        serverdata["username"],
        serverdata["password"],
        serverdata["save"],
        serverdata["isKey"],
      );

  Map<String, dynamic> toMap() {
    return {
      "address": address,
      "port": port,
      "username": username,
      "password": password,
      "save": save,
      "isKey": isKey,
    };
  }
}
