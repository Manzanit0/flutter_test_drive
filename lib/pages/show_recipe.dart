import 'package:flutter/material.dart';
import 'package:flutter_test_drive/api/api.dart';

class ShowRecipePage extends StatelessWidget {
  final Recipe recipe;

  ShowRecipePage(this.recipe);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(recipe.name!),
              backgroundColor: theme.backgroundColor,
              pinned: true,
              floating: true,
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text('Ingredients'),
                  ),
                  Tab(child: Text('Steps')),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      ListTile(
                          leading: Icon(Icons.share),
                          title: Text("External URL"),
                          subtitle: Text(recipe.externalUrl ?? "...")),
                      ExpansionTile(
                        title: Text(
                          "Categories",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        children: <Widget>[
                          Column(
                            children: [
                              for (Category content in recipe.categories!)
                                ListTile(
                                  title: Text(
                                    "${content.master}: ${content.name!}",
                                  ),
                                  leading: Icon(Icons.category),
                                )
                            ],
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text(
                          "Ingredients",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        children: <Widget>[
                          Column(
                            children: _buildExpandableIngredients(recipe),
                          ),
                        ],
                      ),
                    ]),
                  )),
            ),
            Container(
                height: MediaQuery.of(context).size.height,
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(recipe.description ?? "No steps available"),
                )),
          ],
        ),
      )),
    );
  }

  _buildExpandableIngredients(Recipe vehicle) {
    List<Widget> columnContent = [];

    for (String ingredient in vehicle.ingredients!) {
      columnContent.add(
        ListTile(
          title: Text(
            ingredient,
          ),
          leading: Icon(Icons.task_alt),
        ),
      );
    }

    return columnContent;
  }
}
