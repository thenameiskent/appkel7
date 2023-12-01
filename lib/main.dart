import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student CRUD App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiUrl = 'https://65695aeede53105b0dd6efe3.mockapi.io/appkel7/student';
  List students = [];

  TextEditingController addNameController = TextEditingController();
  TextEditingController addAgeController = TextEditingController();
  TextEditingController updateNameController = TextEditingController();
  TextEditingController updateAgeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        students = json.decode(response.body);
      });
    }
  }

  Future addStudent(String name, int age) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'age': age}),
    );
    if (response.statusCode == 201) {
      fetchData();
    }
  }

  Future updateStudent(String id, String name, int age) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'age': age}),
    );
    if (response.statusCode == 200) {
      fetchData();
    }
  }

  Future deleteStudent(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student CRUD App'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(students[index]['name']),
            subtitle: Text('Age: ${students[index]['age']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteStudent(students[index]['id']),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Update Student'),
                    content: Column(
                      children: [
                        TextField(
                          controller: updateNameController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          controller: updateAgeController,
                          decoration: InputDecoration(labelText: 'Age'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          updateStudent(
                            students[index]['id'],
                            updateNameController.text,
                            int.parse(updateAgeController.text),
                          );
                          Navigator.pop(context);
                        },
                        child: Text('Update'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Student'),
                content: Column(
                  children: [
                    TextField(
                      controller: addNameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: addAgeController,
                      decoration: InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      addStudent(
                        addNameController.text,
                        int.parse(addAgeController.text),
                      );
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
