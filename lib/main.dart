import 'package:cafeteria_leones/adminpanel.dart';
import 'package:cafeteria_leones/home.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria_leones/init.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

Future<File> get _localFile async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  return File('$path/config.json');
}

Future<File> writeConfig(String config) async {
  final file = await _localFile;
  return file.writeAsString(config);
}

Future<String> readConfig() async {
  try {
    final file = await _localFile;
    final String config = await file.readAsString();

    return config;
  } catch (e) {
    return 'err';
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final file = await _localFile;
  final config = {
    'logged': false,
    'type': '',
    'id': '',
    'card_num': '',
    'exp_date': '',
    'cvv': '',
    'products': []
  };

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (file.existsSync() == false) {
    final write = await writeConfig(jsonEncode(config));
    runApp(const Init());

  } else {
    final config_json = await readConfig();

    if(config_json != 'err') {
      final pre_config = jsonDecode(config_json);
      runApp(pre_config['logged'] == true ? (pre_config['type'] == 'consumer' ? const Home() : const AdminPanel()) : const Init());
    }
  }
}

/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Buscar'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _seeBasket() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _seeBasket,
        tooltip: 'ShoppingBasket',
        child: const Icon(Icons.shopping_basket),
      ),
    );
  }
}*/
