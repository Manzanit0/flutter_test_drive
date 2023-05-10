import 'package:flutter/material.dart';
import 'package:flutter_test_drive/api/api.dart';

class ShowRecipePage extends StatelessWidget {
  final Recipe recipe;

  ShowRecipePage(this.recipe);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.name!,
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      // deluge-citadel-lethargic
      body: Container(
        color: theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Column(
                children: [
                  ListTile(
                    title: Text("Metadata"),
                  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text("External URL"),
                    subtitle: Text(recipe.externalUrl ?? "empty url"),
                  ),
                  ListTile(
                    title: Text("Categories"),
                  ),
                  for (var category in recipe.categories ?? [])
                    ListTile(
                      leading: Icon(Icons.category),
                      title: Text(category.master ?? "empty master"),
                      subtitle: Text(category.name ?? "empty name"),
                    ),
                  ListTile(
                    title: Text("Ingredients"),
                  ),
                  for (var ingredient in recipe.ingredients ?? [])
                    ListTile(
                      leading: Icon(Icons.task_alt),
                      title: Text(ingredient ?? "empty master"),
                    ),
                  ListTile(
                    title: Text("Description"),
                  ),
                  ListTile(
                    title: Text(recipe.description ?? ""),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
