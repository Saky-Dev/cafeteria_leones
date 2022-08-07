import 'dart:convert';
import 'dart:io';

import 'package:cafeteria_leones/adminpanel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mac_address/mac_address.dart';
import 'package:path_provider/path_provider.dart';

class SellerLogin extends StatelessWidget {
  const SellerLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'WorkSans'
      ),
      home: const SellerLoginInterface(),
    );
  }
}

class SellerLoginInterface extends StatefulWidget {
  const SellerLoginInterface({Key? key}) : super(key: key);

  @override
  State<SellerLoginInterface> createState() => _SellerLoginInterface();
}

class _SellerLoginInterface extends State<SellerLoginInterface> {
  final code_ctrl = TextEditingController();

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

  Future<void> valid() async {
    final String code = code_ctrl.text;
    String macAddress = '';
    final String config_json = await readConfig();
    Map<String, dynamic> pre_config = jsonDecode(config_json);
    bool exist = false;

    try {
      macAddress = await GetMac.macAddress;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A ocurrido un error')));
      return;
    }

    if('ADMIN%VALID' == code) {
      try {
        var doc = await FirebaseFirestore.instance
          .collection('Admin')
          .doc(macAddress)
          .get();

        exist = doc.exists;
      } catch (e) {
        rethrow;
      }

      if (exist == false) {
        try {
          await FirebaseFirestore.instance
            .collection('Admin')
            .doc(macAddress)
            .set({
              'card_num': '',
              'delivery_name': '',
              'delivery_picture': ''
            });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al registrar el dispositivo')));
          rethrow;
        }
      }

      pre_config['logged'] = true;
      pre_config['type'] = 'admin';
      writeConfig(jsonEncode(pre_config));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPanel()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Codigo incorrecto')));
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
                'Nuevo Administrador',
                style: TextStyle(
                  fontSize: 24
                ),
              ),
              const SizedBox(height: 120),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                  controller: code_ctrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Código',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Text(
                  '*Ingresa el código de acceso*',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'SourceSansPro'
                  ),
                ),
              ),
              const SizedBox(height: 70),
              CupertinoButton(
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromRGBO(164, 111, 201, 1),
                onPressed: valid,
                child: const Text('Entrar'),
              )
            ],
          ),
        )
    );
  }
}