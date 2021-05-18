// To parse this JSON data, do
//
//     final conecktaClient = conecktaClientFromJson(jsonString);

import 'dart:convert';

ConecktaClient conecktaClientFromJson(String str) =>
    ConecktaClient.fromJson(json.decode(str));

String conecktaClientToJson(ConecktaClient data) => json.encode(data.toJson());

class ConecktaClient {
  ConecktaClient({
    this.id,
    this.object,
    this.livemode,
    this.createdAt,
    this.name,
    this.email,
    this.phone,
    this.corporate,
    this.antifraudInfo,
    this.defaultShippingContactId,
    this.defaultPaymentSourceId,
    this.paymentSources,
    this.shippingContacts,
    this.subscription,
  });

  String? id;
  String? object;
  bool? livemode;
  int? createdAt;
  String? name;
  String? email;
  String? phone;
  bool? corporate;
  AntifraudInfo? antifraudInfo;
  String? defaultShippingContactId;
  String? defaultPaymentSourceId;
  PaymentSources? paymentSources;
  ShippingContacts? shippingContacts;
  Subscription? subscription;

  factory ConecktaClient.fromJson(Map<String, dynamic> json) => ConecktaClient(
        id: json["id"],
        object: json["object"],
        livemode: json["livemode"],
        createdAt: json["created_at"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        corporate: json["corporate"],
        antifraudInfo: AntifraudInfo.fromJson(json["antifraud_info"]),
        defaultShippingContactId: json["default_shipping_contact_id"],
        defaultPaymentSourceId: json["default_payment_source_id"],
        paymentSources: PaymentSources.fromJson(json["payment_sources"]),
        shippingContacts: ShippingContacts.fromJson(json["shipping_contacts"]),
        subscription: Subscription.fromJson(json["subscription"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "livemode": livemode,
        "created_at": createdAt,
        "name": name,
        "email": email,
        "phone": phone,
        "corporate": corporate,
        "antifraud_info": antifraudInfo!.toJson(),
        "default_shipping_contact_id": defaultShippingContactId,
        "default_payment_source_id": defaultPaymentSourceId,
        "payment_sources": paymentSources!.toJson(),
        "shipping_contacts": shippingContacts!.toJson(),
        "subscription": subscription!.toJson(),
      };
}

class AntifraudInfo {
  AntifraudInfo({
    this.accountCreatedAt,
    this.firstPaidAt,
  });

  int? accountCreatedAt;
  int? firstPaidAt;

  factory AntifraudInfo.fromJson(Map<String, dynamic> json) => AntifraudInfo(
        accountCreatedAt: json["account_created_at"],
        firstPaidAt: json["first_paid_at"],
      );

  Map<String, dynamic> toJson() => {
        "account_created_at": accountCreatedAt,
        "first_paid_at": firstPaidAt,
      };
}

class PaymentSources {
  PaymentSources({
    this.hasMore,
    this.object,
    this.total,
    this.data,
  });

  bool? hasMore;
  String? object;
  int? total;
  List<PaymentSourcesDatum>? data;

  factory PaymentSources.fromJson(Map<String, dynamic> json) => PaymentSources(
        hasMore: json["has_more"],
        object: json["object"],
        total: json["total"],
        data: List<PaymentSourcesDatum>.from(
            json["data"].map((x) => PaymentSourcesDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "has_more": hasMore,
        "object": object,
        "total": total,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PaymentSourcesDatum {
  PaymentSourcesDatum({
    this.id,
    this.name,
    this.expMonth,
    this.expYear,
    this.object,
    this.type,
    this.createdAt,
    this.last4,
    this.brand,
    this.parentId,
  });

  String? id;
  String? name;
  int? expMonth;
  int? expYear;
  String? object;
  String? type;
  int? createdAt;
  String? last4;
  String? brand;
  String? parentId;

  factory PaymentSourcesDatum.fromJson(Map<String, dynamic> json) =>
      PaymentSourcesDatum(
        id: json["id"],
        name: json["name"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        object: json["object"],
        type: json["type"],
        createdAt: json["created_at"],
        last4: json["last4"],
        brand: json["brand"],
        parentId: json["parent_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "exp_month": expMonth,
        "exp_year": expYear,
        "object": object,
        "type": type,
        "created_at": createdAt,
        "last4": last4,
        "brand": brand,
        "parent_id": parentId,
      };
}

class ShippingContacts {
  ShippingContacts({
    this.hasMore,
    this.object,
    this.total,
    this.data,
  });

  bool? hasMore;
  String? object;
  int? total;
  List<ShippingContactsDatum>? data;

  factory ShippingContacts.fromJson(Map<String, dynamic> json) =>
      ShippingContacts(
        hasMore: json["has_more"],
        object: json["object"],
        total: json["total"],
        data: List<ShippingContactsDatum>.from(
            json["data"].map((x) => ShippingContactsDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "has_more": hasMore,
        "object": object,
        "total": total,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ShippingContactsDatum {
  ShippingContactsDatum({
    this.id,
    this.object,
    this.createdAt,
    this.phone,
    this.receiver,
    this.betweenStreets,
    this.address,
    this.parentId,
  });

  String? id;
  String? object;
  int? createdAt;
  String? phone;
  String? receiver;
  String? betweenStreets;
  Address? address;
  String? parentId;

  factory ShippingContactsDatum.fromJson(Map<String, dynamic> json) =>
      ShippingContactsDatum(
        id: json["id"],
        object: json["object"],
        createdAt: json["created_at"],
        phone: json["phone"],
        receiver: json["receiver"],
        betweenStreets: json["between_streets"],
        address: Address.fromJson(json["address"]),
        parentId: json["parent_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "created_at": createdAt,
        "phone": phone,
        "receiver": receiver,
        "between_streets": betweenStreets,
        "address": address!.toJson(),
        "parent_id": parentId,
      };
}

class Address {
  Address({
    this.object,
    this.street1,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.residential,
  });

  String? object;
  String? street1;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  bool? residential;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        object: json["object"],
        street1: json["street1"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postalCode: json["postal_code"],
        residential: json["residential"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "street1": street1,
        "city": city,
        "state": state,
        "country": country,
        "postal_code": postalCode,
        "residential": residential,
      };
}

class Subscription {
  Subscription({
    this.id,
    this.status,
    this.object,
    this.start,
    this.billingCycleStart,
    this.plan,
    this.card,
  });

  String? id;
  String? status;
  String? object;
  int? start;
  int? billingCycleStart;
  String? plan;
  String? card;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        status: json["status"],
        object: json["object"],
        start: json["start"],
        billingCycleStart: json["billing_cycle_start"],
        plan: json["plan"],
        card: json["card"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "object": object,
        "start": start,
        "billing_cycle_start": billingCycleStart,
        "plan": plan,
        "card": card,
      };
}
