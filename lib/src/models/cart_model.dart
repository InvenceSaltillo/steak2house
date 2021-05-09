// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

import 'package:steak2house/src/models/product_model.dart';

List<Cart> categoryFromJson(String str) =>
    List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String categoryToJson(List<Cart> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
  Cart({
    this.product,
    this.qty,
  });

  Product? product;
  int? qty;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        product: Product.fromJson(json["product"]),
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "product": product,
        "qty": qty,
      };
}
