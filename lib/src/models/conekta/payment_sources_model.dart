// To parse this JSON data, do
//
//     final conecktaPaymentSource Json(jsonString);

import 'dart:convert';

List<ConecktaPaymentSource> conecktaPaymentSourceFromJson(String str) =>
    List<ConecktaPaymentSource>.from(
        json.decode(str).map((x) => ConecktaPaymentSource.fromJson(x)));

String conecktaPaymentSourceToJson(List<ConecktaPaymentSource> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConecktaPaymentSource {
  ConecktaPaymentSource({
    this.id,
    this.object,
    this.type,
    // this.address,
    this.createdAt,
    this.last4,
    this.bin,
    this.expMonth,
    this.expYear,
    this.brand,
    this.name,
    this.parentId,
    this.conecktaPaymentSourceDefault,
  });

  String? id;
  String? object;
  String? type;
  // Address? address;
  int? createdAt;
  String? last4;
  String? bin;
  String? expMonth;
  String? expYear;
  String? brand;
  String? name;
  String? parentId;
  bool? conecktaPaymentSourceDefault;

  factory ConecktaPaymentSource.fromJson(Map<String, dynamic> json) =>
      ConecktaPaymentSource(
        id: json["id"],
        object: json["object"],
        type: json["type"],
        // address: Address.fromJson(json["address"]),
        createdAt: json["created_at"],
        last4: json["last4"],
        bin: json["bin"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        brand: json["brand"],
        name: json["name"],
        parentId: json["parent_id"],
        conecktaPaymentSourceDefault: json["default"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "type": type,
        // "address": address!.toJson(),
        "created_at": createdAt,
        "last4": last4,
        "bin": bin,
        "exp_month": expMonth,
        "exp_year": expYear,
        "brand": brand,
        "name": name,
        "parent_id": parentId,
        "default": conecktaPaymentSourceDefault,
      };
}

class Address {
  Address({
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.country,
    this.object,
    this.postalCode,
  });

  String? street1;
  String? street2;
  String? city;
  String? state;
  String? country;
  String? object;
  String? postalCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street1: json["street1"],
        street2: json["street2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        object: json["object"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "street1": street1,
        "street2": street2,
        "city": city,
        "state": state,
        "country": country,
        "object": object,
        "postal_code": postalCode,
      };
}
