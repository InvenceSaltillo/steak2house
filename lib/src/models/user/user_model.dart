// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.tel,
    this.status,
    this.avatar,
    this.birthday,
    this.gender,
    this.lastLogin,
    this.lat,
    this.lng,
    this.provider,
    this.conektaCustomerId,
    this.updatedAt,
    this.createdAt,
  });

  String? id;
  String? name;
  String? email;
  String? tel;
  String? status;
  String? avatar;
  String? birthday;
  String? gender;
  DateTime? lastLogin;
  dynamic? lat;
  dynamic? lng;
  String? provider;
  String? conektaCustomerId;
  DateTime? updatedAt;
  DateTime? createdAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        tel: json["tel"],
        status: json["status"],
        avatar: json["avatar"],
        birthday: json["birthday"],
        gender: json["gender"],
        lastLogin: DateTime.now(),
        // lastLogin: DateTime.parse(json["last_login"]),
        lat: json["lat"],
        lng: json["lng"],
        provider: json["provider"],
        conektaCustomerId: json["conekta_customer_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "tel": tel,
        "status": status,
        "avatar": avatar,
        "birthday": birthday,
        "gender": gender,
        "last_login": lastLogin!.toIso8601String(),
        "lat": lat,
        "lng": lng,
        "provider": provider,
        "conekta_customer_id": conektaCustomerId,
        "updated_at": updatedAt!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
      };
}
