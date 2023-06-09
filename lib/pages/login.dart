import 'package:flutter/material.dart';
import 'package:cookbook/api/api.dart';
import 'package:cookbook/data/data.dart';
import 'package:cookbook/pages/home.dart';
import 'package:get_it/get_it.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle =
        theme.textTheme.displayMedium!.copyWith(color: theme.primaryColorDark);

    return Scaffold(
        body: Container(
      color: theme.colorScheme.primaryContainer,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: titleStyle,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Container(
                          color: theme.colorScheme.background,
                          child: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Email"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Container(
                          color: theme.colorScheme.background,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Password"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var cookbook = GetIt.instance<CookbookClient>();

                                try {
                                  var token = await cookbook.signIn(
                                      emailController.text,
                                      passwordController.text);
                                  await setCookbookToken(token);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(emailController.text)),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Invalid Credentials')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please fill input')),
                                );
                              }
                            },
                            child: const Text('Login'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
