import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:qookit/models/recipe.dart';
import 'package:qookit/models/user.dart';
import 'package:qookit/services/services.dart';
import 'package:http/http.dart' as http;

import '../../../models/checkditem.dart';

@singleton
class UsersService {
  static const String endpoint = '/v1/user';
  static const  String ditemendpoint = '/v1/ingredients';

  Future<UserRoot> getUserInfo(String userId) async {
    UserRoot thisUser;
    var uri = Uri.https(
      elasticService.domain,
      endpoint,
    );
    var token = await authService.token;

    var userResponse = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    thisUser = UserRoot.fromJson(jsonDecode(userResponse.body));
    print('.....................................//////..........................');
    print(thisUser);

    return thisUser;
  }

  Future<CheckDitem> detectedItem() async {
    CheckDitem thisUser;
    var uri = Uri.https(
      elasticService.domain,
      ditemendpoint,
    );
    var token = await authService.token;

    var userResponse = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    print('response body:============ ' + userResponse.body);

    thisUser = CheckDitem.fromJson(jsonDecode(userResponse.body));
    print('.....................................//////..........................');

    // for(int i = 0; i<thisUser.items.length; i++)
    //   {
    //     print(thisUser.items[i].name);
    //     print(thisUser.items[i].imageUrl);
    //   }
    //
    // print(thisUser.items[0].name);

    return thisUser;
  }








  Future<List<Recipe>> getUserRecipes(String userId) async {
    UserRoot thisUser;
    var uri = Uri.https(elasticService.domain, endpoint + '/$userId');
    var token = await authService.token;

    try {
      var userResponse = await http.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      print('response body: ' + userResponse.body);

      thisUser = UserRoot.fromJson(jsonDecode(userResponse.body));
      List<Recipe> userRecipes = thisUser.recipes;
      print('my recipes: ' + userRecipes.toString());

      return userRecipes;
    } catch (e) {
      print('error: ' + e.toString());
      return [];
    }
  }

  /*Map<String, dynamic> exampleUser = {
    "userName": null,
    "photoUrl": "string",
    "backgroundUrl": "string",
    "displayName": "Joe,m",
    "personal": {
      "firstName": "Joe",
      "lastName": "S",
      "fullName": "string",
      "email": "jtmuller5@gmail.com",
      "aboutMe": "string",
      "homeUrl": "string",
      "location": {"city": "Taberg", "state": "NY", "country": "USA", "zip": "13471", "gps": null, "ip_addr": "192.168.1.1"}
    },
    "preferences": {
      "units": "Imperial",
      "recipe": ["string"],
      "diet": ["string"]
    }
  };*/

  Future<UserRoot> addUserToElastic({required UserRoot addUser}) async {
    UserRoot thisUser = UserRoot.empty();
    /*UserRoot testUser = UserRoot(
      displayName: 'test',
      userName: 'testUser',
      preferences: Preference(),
      personal: Personal(
          email: email,
          firstName: firstName,
          lastName: lastName,
          fullName: firstName + ' ' + lastName,
          aboutMe: 'Hello',
          homeUrl: '',
          location: Location(
            city: '',
            country: '',
            gps: '',
            ipAddr: '',
            state: '',
            zip: '',
          )),
      backgroundUrl: '',
      id: userService.uid,
      photoUrl: '',
      recipes: [],
      pantryItems: [],
    );*/

    String added = jsonEncode(addUser.toJson());

    print(added);

    var uri = Uri.https(
      elasticService.domain,
      endpoint,
    );
    var token = await authService.token;

    var userResponse = await http.post(
      uri,
      body: jsonEncode(addUser.toJson()),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json-patch+json',
      },
    );

    print('Reason Phrase: ' + userResponse.reasonPhrase.toString());
    print('Body: ' + userResponse.body);
    print('Reason Phrase: ' + userResponse.reasonPhrase.toString());
    print('Reason Phrase: ' + userResponse.reasonPhrase.toString());
    print('URI : ' + uri.toString());

    return thisUser;
  }
}
