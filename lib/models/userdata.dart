// To parse this JSON data, do
//
//     final userDataModel = userDataModelFromJson(jsonString);

import 'dart:convert';


UserDataModel userDataModelFromJson(String str) =>
    UserDataModel.fromJson(json.decode(str));

String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

///Create model class for user
class UserDataModel {
  UserDataModel({
    required this.id,
    required this.userName,
    required this.backgroundUrl,
    required this.displayName,
    required this.personal,
    required this.preferences,
    required this.recipes,
    required this.pantryItems,
  });

  String id;
  String userName;
  String backgroundUrl;
  String displayName;
  Personal? personal;
  Preferences? preferences;
  List<dynamic> recipes;
  List<dynamic> pantryItems;

  static UserDataModel empty() => UserDataModel(
      id: '',
      userName: '',
      backgroundUrl: '',
      displayName: '',
      personal: null,
      preferences: null,
      recipes: [],
      pantryItems: []
  );

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        id: json['id'],
        userName: json['userName'],
        backgroundUrl: json['backgroundUrl'],
        displayName: json['displayName'],
        personal: Personal.fromJson(json['personal']),
        preferences: Preferences.fromJson(json['preferences']),
        recipes: List<dynamic>.from(json['recipes'].map((x) => x)),
        pantryItems: List<dynamic>.from(json['pantryItems'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'backgroundUrl': backgroundUrl,
        'displayName': displayName,
        'personal': personal!.toJson(),
        'preferences': preferences!.toJson(),
        'recipes': List<dynamic>.from(recipes.map((x) => x)),
        'pantryItems': List<dynamic>.from(pantryItems.map((x) => x)),
      };
}

class Personal {
  Personal({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.aboutMe,
   required  this.location,
  });

  String firstName;
  String lastName;
  String email;
  String aboutMe;
  Location location;

  factory Personal.fromJson(Map<String, dynamic> json) => Personal(
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        aboutMe: json['aboutMe'],
        location: Location.fromJson(json['location']),
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'aboutMe': aboutMe,
        'location': location.toJson(),
      };
}

class Location {
  Location({
    required this.city,
    required this.state,
    required this.country,
    required this.zip,
    required this.gps,
    required this.ipAddr,
  });

  String city;
  String state;
  String country;
  String zip;
  String gps;
  String ipAddr;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        city: json['city'],
        state: json['state'],
        country: json['country'],
        zip: json['zip'],
        gps: json['gps'],
        ipAddr: json['ip_adder'],
      );

  Map<String, dynamic> toJson() => {
        'city': city,
        'state': state,
        'country': country,
        'zip': zip,
        'gps': gps,
        'ip_addr': ipAddr,
      };
}

class Preferences {
  Preferences({
    required this.units,
    required this.recipe,
    required this.diet,
  });

  String units;
  List<String> recipe;
  List<String> diet;

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        units: json['units'],
        recipe: List<String>.from(json['recipe'].map((x) => x)),
        diet: List<String>.from(json['diet'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'units': units,
        'recipe': List<dynamic>.from(recipe.map((x) => x)),
        'diet': List<dynamic>.from(diet.map((x) => x)),
      };
}
