import 'package:cafeteria_leones/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class ConsumerLogin extends StatelessWidget {
  const ConsumerLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'WorkSans'
      ),
      home: const ConsumerLoginInterface(),
    );
  }
}

class ConsumerLoginInterface extends StatefulWidget {
  const ConsumerLoginInterface({Key? key}) : super(key: key);
  @override
  State<ConsumerLoginInterface> createState() => _ConsumerLoginInterface();
}

class _ConsumerLoginInterface extends State<ConsumerLoginInterface> {
  final name_ctrl = TextEditingController();
  final school_id_ctrl = TextEditingController();

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

  Future<void> registerStudent() async {
    bool exist = false;
    String name = name_ctrl.text;
    String school_id = school_id_ctrl.text;
    final String config_json = await readConfig();
    Map<String, dynamic> pre_config = jsonDecode(config_json);

    if (name != '' && school_id != '') {
      try {
        var doc = await FirebaseFirestore.instance
          .collection('Consumer')
          .doc(school_id)
          .get();

        exist = doc.exists;
      } catch (e) {
        rethrow;
      }

      if (exist == false) {
        try {
          await FirebaseFirestore.instance
            .collection('Consumer')
            .doc(school_id)
            .set({
              'name': name,
              'delivery_place': '',
              'picture': ''
            });

          pre_config['logged'] = true;
          pre_config['type'] = 'consumer';
          pre_config['id'] = school_id;
          writeConfig(jsonEncode(pre_config));

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Se ha iniciado sesión')));
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al iniciar sesión')));
          rethrow;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El usuario ya existe')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa los campos necesarios')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Inicia Sesión',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 120),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                  controller: name_ctrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                  controller: school_id_ctrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Matricula',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              CupertinoButton(
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromRGBO(164, 111, 201, 1),
                onPressed: registerStudent,
                child: const Text('Entrar'),
              )
            ],
          ),
        )
    );
  }
}