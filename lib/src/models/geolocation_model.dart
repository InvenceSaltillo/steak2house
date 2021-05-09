// To parse this JSON data, do
//
//     final geocodingResponse = geocodingResponseFromJson(jsonString);

import 'dart:convert';

GeocodingResponse geocodingResponseFromJson(String str) =>
    GeocodingResponse.fromJson(json.decode(str));

String geocodingResponseToJson(GeocodingResponse data) =>
    json.encode(data.toJson());

class GeocodingResponse {
  GeocodingResponse({
    this.plusCode,
    this.results,
    this.status,
  });

  PlusCode? plusCode;
  List<Result>? results;
  String? status;

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) =>
      GeocodingResponse(
        plusCode: PlusCode.fromJson(json["plus_code"]),
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "plus_code": plusCode!.toJson(),
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
        "status": status,
      };
}

class PlusCode {
  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  String? compoundCode;
  String? globalCode;

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}

class Result {
  Result({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.plusCode,
    this.types,
  });

  List<AddressComponent>? addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;
  PlusCode? plusCode;
  List<String>? types;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: List<AddressComponent>.from(
            json["address_components"]
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "address_components":
            List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "geometry": geometry!.toJson(),
        "place_id": placeId,
        "plus_code": plusCode == null ? null : plusCode!.toJson(),
        "types": List<dynamic>.from(types!.map((x) => x)),
      };
}

class AddressComponent {
  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  String? longName;
  String? shortName;
  List<String>? types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": List<dynamic>.from(types!.map((x) => x)),
      };
}

class Geometry {
  Geometry({
    this.location,
    this.locationType,
    this.viewport,
    this.bounds,
  });

  Location? location;
  String? locationType;
  Viewport? viewport;
  Viewport? bounds;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
        locationType: json["location_type"],
        viewport: Viewport.fromJson(json["viewport"]),
        bounds:
            json["bounds"] == null ? null : Viewport.fromJson(json["bounds"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location!.toJson(),
        "location_type": locationType,
        "viewport": viewport!.toJson(),
        "bounds": bounds == null ? null : bounds!.toJson(),
      };
}

class Viewport {
  Viewport({
    this.northeast,
    this.southwest,
  });

  Location? northeast;
  Location? southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast!.toJson(),
        "southwest": southwest!.toJson(),
      };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

// // To parse required this JSON data, do
// //
// //     final geocodingResponse = geocodingResponseFromJson(jsonString);

// import 'dart:convert';

// GeocodingResponse geocodingResponseFromJson(String str) =>
//     GeocodingResponse.fromJson(json.decode(str));

// String geocodingResponseToJson(GeocodingResponse data) =>
//     json.encode(data.toJson());

// class GeocodingResponse {
//   GeocodingResponse({
//     this.type,
//     this.query,
//     this.features,
//     this.attribution,
//   });

//   String? type;
//   List<String>? query;
//   List<Feature>? features;
//   String? attribution;

//   factory GeocodingResponse.fromJson(Map<String, dynamic> json) =>
//       GeocodingResponse(
//         type: json["type"],
//         query: List<String>.from(json["query"].map((x) => x)),
//         features: List<Feature>.from(
//             json["features"].map((x) => Feature.fromJson(x))),
//         attribution: json["attribution"],
//       );

//   Map<String, dynamic> toJson() => {
//         "type": type,
//         "query": List<dynamic>.from(query!.map((x) => x)),
//         "features": List<dynamic>.from(features!.map((x) => x.toJson())),
//         "attribution": attribution,
//       };
// }

// class Feature {
//   Feature({
//     required this.id,
//     required this.type,
//     required this.placeType,
//     required this.relevance,
//     required this.properties,
//     required this.textEs,
//     required this.languageEs,
//     required this.placeNameEs,
//     required this.text,
//     required this.language,
//     required this.placeName,
//     required this.bbox,
//     required this.center,
//     required this.geometry,
//     required this.context,
//     required this.matchingText,
//     required this.matchingPlaceName,
//   });

//   String id;
//   String type;
//   List<String> placeType;
//   int relevance;
//   Properties properties;
//   String textEs;
//   Language? languageEs;
//   String placeNameEs;
//   String text;
//   Language? language;
//   String placeName;
//   List<double>? bbox;
//   List<double> center;
//   Geometry geometry;
//   List<Context> context;
//   String matchingText;
//   String matchingPlaceName;

//   factory Feature.fromJson(Map<String, dynamic> json) => Feature(
//         id: json["id"],
//         type: json["type"],
//         placeType: List<String>.from(json["place_type"].map((x) => x)),
//         relevance: json["relevance"],
//         properties: Properties.fromJson(json["properties"]),
//         textEs: json["text_es"],
//         languageEs: json["language_es"] == null
//             ? null
//             : languageValues.map[json["language_es"]],
//         placeNameEs: json["place_name_es"],
//         text: json["text"],
//         language: json["language"] == null
//             ? null
//             : languageValues.map[json["language"]],
//         placeName: json["place_name"],
//         bbox: json["bbox"] == null
//             ? null
//             : List<double>.from(json["bbox"].map((x) => x.toDouble())),
//         center: List<double>.from(json["center"].map((x) => x.toDouble())),
//         geometry: Geometry.fromJson(json["geometry"]),
//         context:
//             List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
//         matchingText:
//             json["matching_text"] == null ? '' : json["matching_text"],
//         matchingPlaceName: json["matching_place_name"] == null
//             ? ''
//             : json["matching_place_name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "type": type,
//         "place_type": List<dynamic>.from(placeType.map((x) => x)),
//         "relevance": relevance,
//         "properties": properties.toJson(),
//         "text_es": textEs,
//         "language_es":
//             languageEs == null ? null : languageValues.reverse[languageEs],
//         "place_name_es": placeNameEs,
//         "text": text,
//         "language": language == null ? null : languageValues.reverse[language],
//         "place_name": placeName,
//         "bbox": bbox == null ? null : List<dynamic>.from(bbox!.map((x) => x)),
//         "center": List<dynamic>.from(center.map((x) => x)),
//         "geometry": geometry.toJson(),
//         "context": List<dynamic>.from(context.map((x) => x.toJson())),
//         "matching_text": matchingText == null ? null : matchingText,
//         "matching_place_name":
//             matchingPlaceName == null ? null : matchingPlaceName,
//       };
// }

// class Context {
//   Context({
//     required this.id,
//     required this.wikidata,
//     required this.shortCode,
//     required this.textEs,
//     required this.languageEs,
//     required this.text,
//     required this.language,
//   });

//   String id;
//   String? wikidata;
//   ShortCode? shortCode;
//   String textEs;
//   Language? languageEs;
//   String text;
//   Language? language;

//   factory Context.fromJson(Map<String, dynamic> json) => Context(
//         id: json["id"],
//         wikidata: json["wikidata"],
//         shortCode: json["short_code"] == null
//             ? null
//             : shortCodeValues.map[json["short_code"]],
//         textEs: json["text_es"],
//         languageEs: languageValues.map[json["language_es"]],
//         text: json["text"],
//         language: languageValues.map[json["language"]],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "wikidata": wikidata,
//         "short_code":
//             shortCode == null ? null : shortCodeValues.reverse[shortCode],
//         "text_es": textEs,
//         "language_es": languageValues.reverse[languageEs],
//         "text": text,
//         "language": languageValues.reverse[language],
//       };
// }

// enum Language { ES }

// final languageValues = EnumValues({"es": Language.ES});

// enum ShortCode { MX_COA, MX }

// final shortCodeValues =
//     EnumValues({"mx": ShortCode.MX, "MX-COA": ShortCode.MX_COA});

// class Geometry {
//   Geometry({
//     required this.type,
//     required this.coordinates,
//   });

//   String type;
//   List<double> coordinates;

//   factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
//         type: json["type"],
//         coordinates:
//             List<double>.from(json["coordinates"].map((x) => x.toDouble())),
//       );

//   Map<String, dynamic> toJson() => {
//         "type": type,
//         "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
//       };
// }

// class Properties {
//   Properties({
//     required this.wikidata,
//     required this.foursquare,
//     required this.landmark,
//     required this.category,
//     required this.maki,
//     required this.accuracy,
//   });

//   String wikidata;
//   String foursquare;
//   bool landmark;
//   String category;
//   String maki;
//   String accuracy;

//   factory Properties.fromJson(Map<String, dynamic> json) => Properties(
//         wikidata: json["wikidata"] == null ? '' : json["wikidata"],
//         foursquare: json["foursquare"] == null ? '' : json["foursquare"],
//         landmark: json["landmark"] == null ? false : json["landmark"],
//         category: json["category"] == null ? '' : json["category"],
//         maki: json["maki"] == null ? '' : json["maki"],
//         accuracy: json["accuracy"] == null ? '' : json["accuracy"],
//       );

//   Map<String, dynamic> toJson() => {
//         "wikidata": wikidata == null ? null : wikidata,
//         "foursquare": foursquare == null ? null : foursquare,
//         "landmark": landmark == null ? null : landmark,
//         "category": category == null ? null : category,
//         "maki": maki == null ? null : maki,
//         "accuracy": accuracy == null ? null : accuracy,
//       };
// }

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
