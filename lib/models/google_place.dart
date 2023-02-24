// To parse this JSON data, do
//
//     final googlePlace = googlePlaceFromJson(jsonString);

import 'dart:convert';

List<GooglePlace> googlePlaceFromJson(String str) => List<GooglePlace>.from(json.decode(str)['results'].map((x) => GooglePlace.fromJson(x)));

String googlePlaceToJson(List<GooglePlace> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GooglePlace {
  GooglePlace({
    this.businessStatus,
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.openingHours,
    this.photos,
    this.placeId,
    this.priceLevel,
    this.rating,
    this.reference,
    this.types,
    this.userRatingsTotal,
  });

  String? businessStatus;
  String? formattedAddress;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  OpeningHours? openingHours;
  List<Photo>? photos;
  String? placeId;
  int? priceLevel;
  double? rating;
  String? reference;
  List<String>? types;
  int? userRatingsTotal;

  GooglePlace copyWith({
    String? businessStatus,
    String? formattedAddress,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    OpeningHours? openingHours,
    List<Photo>? photos,
    String? placeId,
    int? priceLevel,
    double? rating,
    String? reference,
    List<String>? types,
    int? userRatingsTotal,
  }) =>
      GooglePlace(
        businessStatus: businessStatus ?? this.businessStatus,
        formattedAddress: formattedAddress ?? this.formattedAddress,
        geometry: geometry ?? this.geometry,
        icon: icon ?? this.icon,
        iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
        iconMaskBaseUri: iconMaskBaseUri ?? this.iconMaskBaseUri,
        name: name ?? this.name,
        openingHours: openingHours ?? this.openingHours,
        photos: photos ?? this.photos,
        placeId: placeId ?? this.placeId,
        priceLevel: priceLevel ?? this.priceLevel,
        rating: rating ?? this.rating,
        reference: reference ?? this.reference,
        types: types ?? this.types,
        userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      );

  factory GooglePlace.fromJson(Map<String, dynamic> json) => GooglePlace(
    businessStatus: json["business_status"],
    formattedAddress: json["formatted_address"],
    geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
    icon: json["icon"],
    iconBackgroundColor: json["icon_background_color"],
    iconMaskBaseUri: json["icon_mask_base_uri"],
    name: json["name"],
    openingHours: json["opening_hours"] == null ? null : OpeningHours.fromJson(json["opening_hours"]),
    photos: json["photos"] == null ? [] : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
    placeId: json["place_id"],
    priceLevel: json["price_level"],
    rating: json["rating"]?.toDouble(),
    reference: json["reference"],
    types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    userRatingsTotal: json["user_ratings_total"],
  );

  Map<String, dynamic> toJson() => {
    "business_status": businessStatus,
    "formatted_address": formattedAddress,
    "geometry": geometry?.toJson(),
    "icon": icon,
    "icon_background_color": iconBackgroundColor,
    "icon_mask_base_uri": iconMaskBaseUri,
    "name": name,
    "opening_hours": openingHours?.toJson(),
    "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x.toJson())),
    "place_id": placeId,
    "price_level": priceLevel,
    "rating": rating,
    "reference": reference,
    "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    "user_ratings_total": userRatingsTotal,
  };
}

class Geometry {
  Geometry({
    this.location,
    this.viewport,
  });

  Location? location;
  Viewport? viewport;

  Geometry copyWith({
    Location? location,
    Viewport? viewport,
  }) =>
      Geometry(
        location: location ?? this.location,
        viewport: viewport ?? this.viewport,
      );

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    viewport: json["viewport"] == null ? null : Viewport.fromJson(json["viewport"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "viewport": viewport?.toJson(),
  };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  Location copyWith({
    double? lat,
    double? lng,
  }) =>
      Location(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Viewport {
  Viewport({
    this.northeast,
    this.southwest,
  });

  Location? northeast;
  Location? southwest;

  Viewport copyWith({
    Location? northeast,
    Location? southwest,
  }) =>
      Viewport(
        northeast: northeast ?? this.northeast,
        southwest: southwest ?? this.southwest,
      );

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    northeast: json["northeast"] == null ? null : Location.fromJson(json["northeast"]),
    southwest: json["southwest"] == null ? null : Location.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast?.toJson(),
    "southwest": southwest?.toJson(),
  };
}

class OpeningHours {
  OpeningHours({
    this.openNow,
  });

  bool? openNow;

  OpeningHours copyWith({
    bool? openNow,
  }) =>
      OpeningHours(
        openNow: openNow ?? this.openNow,
      );

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
    openNow: json["open_now"],
  );

  Map<String, dynamic> toJson() => {
    "open_now": openNow,
  };
}

class Photo {
  Photo({
    this.height,
    this.photoReference,
    this.width,
  });

  int? height;
  String? photoReference;
  int? width;

  Photo copyWith({
    int? height,
    String? photoReference,
    int? width,
  }) =>
      Photo(
        height: height ?? this.height,
        photoReference: photoReference ?? this.photoReference,
        width: width ?? this.width,
      );

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    height: json["height"],
    photoReference: json["photo_reference"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "photo_reference": photoReference,
    "width": width,
  };
}
