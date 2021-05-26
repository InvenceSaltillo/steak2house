// To parse this JSON data, do
//
//     final myOrders = myOrdersFromJson(jsonString);

import 'dart:convert';

import 'detail_model.dart';

List<MyOrders> myOrdersFromJson(String str) =>
    List<MyOrders>.from(json.decode(str).map((x) => MyOrders.fromJson(x)));

String myOrdersToJson(List<MyOrders> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyOrders {
  MyOrders({
    this.id,
    this.total,
    this.subtotal,
    this.delivery,
    this.createdAt,
    this.detail,
  });

  String? id;
  String? total;
  String? subtotal;
  String? delivery;
  DateTime? createdAt;
  List<Detail>? detail;

  factory MyOrders.fromJson(Map<String, dynamic> json) => MyOrders(
        id: json["id"],
        total: json["total"],
        subtotal: json["subtotal"],
        delivery: json["delivery"],
        createdAt: DateTime.parse(json["created_at"]),
        detail:
            List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total": total,
        "subtotal": subtotal,
        "delivery": delivery,
        "created_at": createdAt!.toIso8601String(),
        "detail": List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}
