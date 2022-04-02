import 'dart:core';
import 'dart:html';

import 'package:eisenhower/list.dart';
import 'package:eisenhower/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskTypeAdapter());
  await Hive.openBox<Task>('tasks');

  TaskManager taskManager = TaskManager();
  taskManager.updateList();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eisenhover',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Eisenhover'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  final TaskManager taskManager = TaskManager();
  final taskTitle = TextEditingController();
  final taskDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TaskType ddVal = TaskType.doIt;

  @override
  Widget build(BuildContext context) => _MyHomePageView(
        state: this,
      );

  void _changeValue(TaskType newValue) {
    ddVal = newValue;
  }

  void _setState() {
    setState(() {});
  }
}

class _MyHomePageView extends StatelessWidget {
  const _MyHomePageView({Key? key, required this.state}) : super(key: key);

  final _MyHomePageState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Eisenhover task manager                                                                                                                                      Add task'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => _FormPageView(
                            state: state,
                          )),
                );
              }),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: TitledContainer(
                            title: 'Do it',
                            fontSize: 20,
                            titleColor: Colors.green,
                            textAlign: TextAlignTitledContainer.Center,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.green, width: 3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: ListView(
                                children: [
                                  ...state.taskManager.doIt
                                      .map(
                                        (element) => ListTile(
                                          title: Text(element.title),
                                          subtitle: Text(element.desc),
                                          onTap: () => state.taskManager.doIt
                                              .remove(element),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                          )),
                          const Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Expanded(
                              child: TitledContainer(
                            title: 'Delegate',
                            fontSize: 20,
                            titleColor: Colors.blue,
                            textAlign: TextAlignTitledContainer.Center,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: ListView(
                                children: [
                                  ...state.taskManager.delegate
                                      .map(
                                        (element) => ListTile(
                                          title: Text(element.title),
                                          subtitle: Text(element.desc),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: TitledContainer(
                            title: 'Decide',
                            fontSize: 20,
                            titleColor: Colors.red,
                            textAlign: TextAlignTitledContainer.Center,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red, width: 3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: ListView(
                                children: [
                                  ...state.taskManager.decide
                                      .map(
                                        (element) => ListTile(
                                          title: Text(element.title),
                                          subtitle: Text(element.desc),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                          )),
                          const Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Expanded(
                              child: TitledContainer(
                            title: 'Delete',
                            fontSize: 20,
                            titleColor: Colors.grey,
                            textAlign: TextAlignTitledContainer.Center,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: ListView(
                                children: [
                                  ...state.taskManager.delete
                                      .map(
                                        (element) => ListTile(
                                          title: Text(element.title),
                                          subtitle: Text(element.desc),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormPageView extends StatelessWidget {
  _FormPageView({Key? key, required this.state}) : super(key: key);

  final _MyHomePageState state;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state._formKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('Eisenhover task manager')),
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  decoration: const InputDecoration(
                      labelText: 'Title', counterText: 'Max 30 characters'),
                  controller: state.taskTitle,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  controller: state.taskDescription,
                ),
                DropdownButton<TaskType>(
                    value: state.ddVal,
                    onChanged: (value) => state._changeValue(value!),
                    items: TaskType.values.map((TaskType type) {
                      return DropdownMenuItem<TaskType>(
                          value: type, child: Text(type.toString()));
                    }).toList()),
                ElevatedButton(
                  onPressed: () {
                    if (!state._formKey.currentState!.validate()) {
                      print('Jest źle');
                    } else {
                      Navigator.pop(context);
                      state.taskManager.addTask(state.taskTitle.text,
                          state.taskDescription.text, state.ddVal);
                      state._setState();
                    }
                  },
                  child: const Text('Add task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
