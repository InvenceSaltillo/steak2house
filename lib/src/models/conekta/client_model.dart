// To parse this JSON data, do
//
//     final conecktaClient = conecktaClientFromJson(jsonString);

import 'dart:convert';

ConecktaClient conecktaClientFromJson(String str) =>
    ConecktaClient.fromJson(json.decode(str));

String conecktaClientToJson(ConecktaClient data) => json.encode(data.toJson());

class ConecktaClient {
  ConecktaClient({
    this.livemode,
    this.name,
    this.email,
    this.phone,
    this.id,
    this.object,
    this.createdAt,
    this.corporate,
    this.customReference,
    this.defaultPaymentSourceId,
    this.paymentSources,
  });

  bool? livemode;
  String? name;
  String? email;
  String? phone;
  String? id;
  String? object;
  int? createdAt;
  bool? corporate;
  String? customReference;
  String? defaultPaymentSourceId;
  PaymentSources? paymentSources;

  factory ConecktaClient.fromJson(Map<String, dynamic> json) => ConecktaClient(
        livemode: json["livemode"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        id: json["id"],
        object: json["object"],
        createdAt: json["created_at"],
        corporate: json["corporate"],
        customReference: json["custom_reference"],
        defaultPaymentSourceId: json["default_payment_source_id"],
        // paymentSources: PaymentSources.fromJson(json["payment_sources"]) ,
      );

  Map<String, dynamic> toJson() => {
        "livemode": livemode,
        "name": name,
        "email": email,
        "phone": phone,
        "id": id,
        "object": object,
        "created_at": createdAt,
        "corporate": corporate,
        "custom_reference": customReference,
        "default_payment_source_id": defaultPaymentSourceId,
        // "payment_sources": paymentSources!.toJson(),
      };
}

class PaymentSources {
  PaymentSources({
    this.nextPageUrl,
    this.object,
    this.hasMore,
    this.total,
    this.data,
  });

  String? nextPageUrl;
  String? object;
  bool? hasMore;
  int? total;
  List<Datum>? data;

  factory PaymentSources.fromJson(Map<String, dynamic> json) => PaymentSources(
        nextPageUrl: json["next_page_url"],
        object: json["object"],
        hasMore: json["has_more"],
        total: json["total"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "next_page_url": nextPageUrl,
        "object": object,
        "has_more": hasMore,
        "total": total,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.object,
    this.type,
    this.createdAt,
    this.last4,
    this.bin,
    this.cardType,
    this.expMonth,
    this.expYear,
    this.brand,
    this.name,
    this.parentId,
    this.datumDefault,
    this.visibleOnCheckout,
  });

  String? id;
  String? object;
  String? type;
  int? createdAt;
  String? last4;
  String? bin;
  String? cardType;
  String? expMonth;
  String? expYear;
  String? brand;
  String? name;
  String? parentId;
  bool? datumDefault;
  bool? visibleOnCheckout;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        object: json["object"],
        type: json["type"],
        createdAt: json["created_at"],
        last4: json["last4"],
        bin: json["bin"],
        cardType: json["card_type"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        brand: json["brand"],
        name: json["name"],
        parentId: json["parent_id"],
        datumDefault: json["default"],
        visibleOnCheckout: json["visible_on_checkout"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "type": type,
        "created_at": createdAt,
        "last4": last4,
        "bin": bin,
        "card_type": cardType,
        "exp_month": expMonth,
        "exp_year": expYear,
        "brand": brand,
        "name": name,
        "parent_id": parentId,
        "default": datumDefault,
        "visible_on_checkout": visibleOnCheckout,
      };
}
