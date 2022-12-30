import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scv_app/api/school.dart';
import 'package:scv_app/api/status.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id;
  String displayName;
  String givenName;
  String mail;
  String mobilePhone;
  String surname;
  String userPrincipalName;
  CachedNetworkImageProvider image;

  bool loggedIn = true;
  bool logingIn = false;
  bool loading = true;
  bool loadingFromWeb = true;

  School school;
  Status status;

  User() {
    this.school = new School();
    this.status = new Status();
    this.id = "";
    this.displayName = "";
    this.givenName = "";
    this.mail = "";
    this.mobilePhone = "";
    this.surname = "";
    this.userPrincipalName = "";
    this.image = CachedNetworkImageProvider("https://via.placeholder.com/150");
    this.loggedIn = true;
    this.logingIn = false;
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(global.apiUrl + "/user/get"),
        headers: {"Authorization": global.token.accessToken});
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      this.fromJSON(json);
      this.loggedIn = true;
      image = CachedNetworkImageProvider(
        "${global.apiUrl}/user/get/profilePicture?=${json['mail']}",
        headers: {"Authorization": global.token.accessToken},
        errorListener: () => print("Error in image"),
      );
      this.saveToCache();
    } else {
      throw Exception('Failed to load user');
    }
    this.logingIn = false;
    this.loading = false;
    this.loadingFromWeb = false;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": this.id,
      "displayName": this.displayName,
      "givenName": this.givenName,
      "mail": this.mail,
      "mobilePhone": this.mobilePhone,
      "surname": this.surname,
      "userPrincipalName": this.userPrincipalName,
    };
  }

  void fromJSON(Map<String, dynamic> map) {
    this.id = map['id'];
    this.displayName = map['displayName'];
    this.givenName = map['givenName'];
    this.mail = map['mail'];
    this.mobilePhone = map['mobilePhone'];
    this.surname = map['surname'];
    this.userPrincipalName = map['userPrincipalName'];
  }

  Future<void> saveToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(this.toJSON()));
  }

  Future<void> loadFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString("user");
    if (user != null) {
      this.fromJSON(jsonDecode(user));
      this.loading = false;
    }
  }

  Future<void> fetchAll() async {
    await Future.wait([
      this.fetchData(),
      this.school.fetchData(),
      this.status.fetchData(),
    ]);
  }
}
