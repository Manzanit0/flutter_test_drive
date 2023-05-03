import 'dart:convert';

import 'package:http/http.dart' as http;

class ListRecipesResponse {
  int? ownerId;
  List<Recipe>? recipes;

  ListRecipesResponse({this.ownerId, this.recipes});

  ListRecipesResponse.fromJson(Map<String, dynamic> json) {
    ownerId = json['owner_id'];
    if (json['recipes'] != null) {
      recipes = <Recipe>[];
      json['recipes'].forEach((v) {
        recipes!.add(Recipe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['owner_id'] = ownerId;
    if (recipes != null) {
      data['recipes'] = recipes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Recipe {
  int? id;
  String? collectionName;
  int? collectionId;
  String? name;
  String? externalUrl;
  List<String>? ingredients;
  String? description;
  List<Category>? categories;

  Recipe(
      {this.id,
      this.collectionName,
      this.collectionId,
      this.name,
      this.externalUrl,
      this.ingredients,
      this.description,
      this.categories});

  Recipe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    collectionName = json['collection_name'];
    collectionId = json['collection_id'];
    name = json['name'];
    externalUrl = json['external_url'];
    ingredients = json['ingredients'].cast<String>();
    description = json['description'];
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['collection_name'] = collectionName;
    data['collection_id'] = collectionId;
    data['name'] = name;
    data['external_url'] = externalUrl;
    data['ingredients'] = ingredients;
    data['description'] = description;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? master;

  Category({this.id, this.name, this.master});

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

Future<List<Recipe>> listRecipes() async {
  var url = Uri.parse('https://fresh-production.up.railway.app/api/recipes');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return ListRecipesResponse.fromJson(jsonDecode(response.body)).recipes!;
  } else {
    throw Exception('Failed to fetch recipes');
  }
}
