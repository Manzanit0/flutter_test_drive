import 'dart:convert';

import 'package:http/http.dart' as http;

class ListRecipesResponse {
  late List<Recipe> recipes;

  ListRecipesResponse({required this.recipes});

  ListRecipesResponse.fromJson(Map<String, dynamic> json) {
    recipes = <Recipe>[];

    if (json['recipes'] != null) {
      json['recipes'].forEach((v) {
        recipes.add(Recipe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recipes'] = recipes.map((v) => v.toJson()).toList();
    return data;
  }
}

class Recipe {
  late int id;
  late Collection collection;
  late String name;
  late List<String> ingredients;
  late List<Category> categories;
  String? externalUrl;
  String? description;

  Recipe(
      {required this.id,
      required this.collection,
      required this.name,
      this.externalUrl,
      required this.ingredients,
      this.description,
      required this.categories});

  Recipe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    collection = Collection.fromJson(json["collection"]);
    name = json['name'];
    externalUrl = json['external_url'];
    ingredients = json['ingredients'].cast<String>();
    description = json['description'];
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['collection'] = collection.toJson();
    data['name'] = name;
    data['external_url'] = externalUrl;
    data['ingredients'] = ingredients;
    data['description'] = description;
    data['categories'] = categories.map((v) => v.toJson()).toList();
    return data;
  }
}

class Category {
  late int id;
  late String name;
  String? master;

  Category({required this.id, required this.name, this.master});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    master = json['master'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['master'] = master;
    return data;
  }
}

class Collection {
  late int id;
  late String name;
  late User owner;

  Collection({required this.id, required this.name, required this.owner});

  Collection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    owner = User.fromJson(json["owner"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['owner'] = owner.toJson();
    return data;
  }
}

class User {
  late int id;
  late String email;

  User({required this.id, required this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    return data;
  }
}

class CookbookClient {
  String host;
  String? email;
  String? password;
  String? token;

  CookbookClient(this.host);

  Future<String> signIn(String email, String password) async {
    this.email = email;
    this.password = password;

    var url = Uri.parse('$host/api/login');

    final response =
        await http.post(url, body: {'email': email, 'password': password});

    if (response.statusCode != 200) {
      throw Exception('failed to authenticate');
    }

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    token = decodedResponse['token'] as String;
    return token!;
  }

  Future<String> reIssueAuthToken() async {
    if (email == null || password == null) {
      throw Exception('need to sign-in first with email/password');
    }

    return signIn(email!, password!);
  }

  Future<List<Recipe>> listRecipes() async {
    // FIXME: ideally what we want to do here is execute a login() call if the
    // the request returns a 401.
    //
    // TODO: Might be worth to track expiration too as an optimisation? -> 2 req
    // as opposed to 3.
    await reIssueAuthToken();

    var url = Uri.parse('$host/api/recipes');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return ListRecipesResponse.fromJson(jsonDecode(response.body)).recipes;
    } else {
      throw Exception('Failed to fetch recipes');
    }
  }
}
