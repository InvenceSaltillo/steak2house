// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
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

  String? id;
  String? name;
  String? description;
  String? price;
  String? existence;
  dynamic? includes;
  String? status;
  String? picture;
  String? categoryId;
  DateTime? updatedAt;
  DateTime? createdAt;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
