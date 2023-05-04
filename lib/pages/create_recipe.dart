import 'package:flutter/material.dart';

class CreateRecipePage extends StatelessWidget {
  const CreateRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: const CreateRecipeForm()),
          )),
    );
  }
}

class CreateRecipeForm extends StatefulWidget {
  const CreateRecipeForm({super.key});

  @override
  CreateRecipeFormState createState() {
    return CreateRecipeFormState();
  }
}

const List<String> list = <String>[
  '🇪🇸 Spanish',
  '🇮🇳 Indian',
  '🇲🇽 Mexican',
  '🇯🇵 Japanese'
];

class CreateRecipeFormState extends State<CreateRecipeForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "Name"),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "URL"),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(labelText: "Cuisine"),
            value: dropdownValue,
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Description"),
          ),
          // TODO: we need to add ingredients here... what should the UX be though?
          Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: actually create recipe in server.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Recipe created!')),
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
