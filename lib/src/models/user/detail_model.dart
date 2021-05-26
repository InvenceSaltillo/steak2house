import 'dart:convert';

List<Detail> detailFromJson(String str) =>
    List<Detail>.from(json.decode(str).map((x) => Detail.fromJson(x)));

String detailToJson(List<Detail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Detail {
  Detail({
    this.orderId,
    this.qty,
    this.id,
    this.name,
    this.description,
    this.price,
    this.existence,
    this.includes,
    this.status,
    this.picture,
    this.categoryId,
    this.updatedAt,
    this.createdAt,
  });

  String? orderId;
  String? qty;
  String? id;
  String? name;
  String? description;
  String? price;
  String? existence;
  String? includes;
  String? status;
  String? picture;
  String? categoryId;
  DateTime? updatedAt;
  DateTime? createdAt;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        orderId: json["orderId"],
        qty: json["qty"],
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        existence: json["existence"],
        includes: json["includes"],
        status: json["status"],
        picture: json["picture"],
        categoryId: json["category_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "qty": qty,
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "existence": existence,
        "includes": includes,
        "status": status,
        "picture": picture,
        "category_id": categoryId,
        "updated_at": updatedAt!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
      };
}
