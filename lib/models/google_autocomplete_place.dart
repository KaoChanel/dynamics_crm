// To parse this JSON data, do
//
//     final prediction = predictionFromJson(jsonString);

import 'dart:convert';

List<GoogleAutocompletePlace> googleAutocompletePlaceFromJson(String str) => List<GoogleAutocompletePlace>.from((json.decode(str)['predictions']).map((x) => GoogleAutocompletePlace.fromJson(x)));

String googleAutocompletePlaceToJson(List<GoogleAutocompletePlace> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GoogleAutocompletePlace {
  GoogleAutocompletePlace({
    this.description,
    this.placeId,
    this.reference,
    this.types,
  });

  String? description;
  String? placeId;
  String? reference;
  List<String>? types;

  GoogleAutocompletePlace copyWith({
    String? description,
    String? placeId,
    String? reference,
    List<String>? types,
  }) =>
      GoogleAutocompletePlace(
        description: description ?? this.description,
        placeId: placeId ?? this.placeId,
        reference: reference ?? this.reference,
        types: types ?? this.types,
      );

  factory GoogleAutocompletePlace.fromJson(Map<String, dynamic> json) => GoogleAutocompletePlace(
    description: json["description"],
    placeId: json["place_id"],
    reference: json["reference"],
    types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "place_id": placeId,
    "reference": reference,
    "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
  };
}
