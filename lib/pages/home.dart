import 'package:flutter/material.dart';
import 'package:flutter_test_drive/api/api.dart';
import 'package:flutter_test_drive/data/data.dart';
import 'package:flutter_test_drive/pages/create_recipe.dart';
import 'package:flutter_test_drive/pages/login.dart';
import 'package:flutter_test_drive/pages/show_recipe.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  String user;

  HomePage(this.user);

  @override
  State<HomePage> createState() => _HomePageState(user);
}

class _HomePageState extends State<HomePage> {
  String user;
  _HomePageState(this.user); // we can now use this to greet

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = RecipesPage();
        break;
      default:
        // TODO: this should be stored at login time.
        page = SettingsPage(
            user, DateFormat.yMEd().add_jms().format(DateTime.now()));
        break;
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (int index) => setState(() {
            selectedIndex = index;
          }),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: page,
        ),
      );
    });
  }
}

class RecipesPage extends StatefulWidget {
  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late Future<List<Recipe>> futureRecipes;
  @override
  void initState() {
    super.initState();
    var cookbook = GetIt.instance<CookbookClient>();

    try {
      futureRecipes = cookbook.listRecipes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get recipes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
    );

    return FutureBuilder<List<Recipe>>(
      future: futureRecipes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: theme.colorScheme.primaryContainer,
            body: ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                          child: Text(
                        'Recipes',
                        style: style,
                      )),
                    ),
                    for (var recipe in snapshot.data!)
                      ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowRecipePage(recipe))),
                        leading: Icon(Icons.bookmark),
                        title: Text(recipe.name),
                      )
                  ],
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              hoverColor: theme.colorScheme.secondary,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateRecipePage()));
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return ListView(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                    child: Text(
                  'Recipes',
                  style: style,
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ]);
      },
    );
  }
}

class SettingsPage extends StatelessWidget {
  String loggedUser;
  String loggedInAt;

  SettingsPage(this.loggedUser, this.loggedInAt);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
    );

    return ListView(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                  child: Text(
                'Settings',
                style: style,
              )),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("User: $loggedUser"),
            ),
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text("Logged in: $loggedInAt"),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login(title: "Login")));
                },
                icon: Icon(Icons.logout),
                label: Text('Logout'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
