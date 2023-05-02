import 'package:flutter/material.dart';
import 'package:flutter_test_drive/data/data.dart';
import 'package:flutter_test_drive/pages/home.dart';
import 'package:flutter_test_drive/pages/login.dart';
import 'package:flutter_test_drive/state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _loggedUser;

  @override
  void initState() {
    super.initState();
    _loadLoggedUser();
  }

  @override
  Widget build(BuildContext context) {
    Widget home = Login(title: "Login");
    if (_loggedUser != null) {
      home = HomePage(_loggedUser!);
    }

    return ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: home,
      ),
    );
  }

  Future<void> _loadLoggedUser() async {
    String? user = await getLoggedUser();
    setState(() {
      _loggedUser = user;
    });
  }
}
