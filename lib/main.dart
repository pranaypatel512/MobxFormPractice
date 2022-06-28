import 'package:flutter/material.dart';

import 'form_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FormStore store = FormStore();

  @override
  void initState(){
    super.initState();
    store.setUpValidators();
  }
  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Observer(
                builder: (_) => TextField(
                  onChanged: (value) => store.name = value,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Pick a username',
                      errorText: store.error.username),
                ),
              ),
              Observer(
                  builder: (_) => AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: store.isUserCheckPending ? 1 : 0,
                      child: const LinearProgressIndicator())),
              Observer(
                builder: (_) => TextField(
                  onChanged: (value) => store.email = value,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                      errorText: store.error.email),
                ),
              ),
              Observer(
                builder: (_) => TextField(
                  onChanged: (value) => store.password = value,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Set a password',
                      errorText: store.error.password),
                ),
              ),
              ElevatedButton(
                onPressed: store.validateAll,
                child: const Text('Sign up'),
              )
            ],
          ),
        ),
      )
    );
  }
}
