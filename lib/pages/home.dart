import 'package:flutter/material.dart';
import 'package:flutter_test_drive/components/big_card.dart';
import 'package:flutter_test_drive/state.dart';
import 'package:provider/provider.dart';

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
        page = GeneratorPage();
        break;
      case 1:
        page = FavouritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
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
              icon: Icon(Icons.favorite),
              label: 'Favourites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
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

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    return ListView(
      children: [
        Column(
          children: [
            Center(child: Text('Your favs:')),
            for (var pair in appState.favorites)
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text(pair.asLowerCase),
              )
            // TODO: how to refactor to map?
            // appState.favorites
            //     .map((e) => ListTile(
            //           leading: Icon(Icons.favorite),
            //           title: Text(e.asLowerCase),
            //         ))
            //     .toList(),
          ],
        ),
      ],
    );
  }
}
