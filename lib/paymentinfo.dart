import 'dart:convert';
import 'dart:io';

import 'package:cafeteria_leones/consumerinformation.dart';
import 'package:cafeteria_leones/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PaymentInfo extends StatelessWidget {
  const PaymentInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'WorkSans'
      ),
      home: const PaymentInfoInterface(),
    );
  }
}

class PaymentInfoInterface extends StatefulWidget {
  const PaymentInfoInterface({Key? key}) : super(key: key);
  @override
  State<PaymentInfoInterface> createState() => _PaymentInfoInterface();
}

class _PaymentInfoInterface extends State<PaymentInfoInterface> {
  List user_info = <Map<String, dynamic>>[];
  final card_num_ctrl = TextEditingController();
  final exp_date_ctrl = TextEditingController();
  final cvv_ctrl = TextEditingController();
  final name_ctrl = TextEditingController();
  final delivery_place_ctrl = TextEditingController();


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

  Future<void> getUserInfo() async {
    final String config_json = await readConfig();
    Map<String, dynamic> pre_config = jsonDecode(config_json);

    String id = pre_config['id'];

    card_num_ctrl.text = pre_config['card_num'];
    exp_date_ctrl.text = pre_config['exp_date'];
    cvv_ctrl.text = pre_config['cvv'];

    final doc = await FirebaseFirestore.instance
        .collection('Consumer')
        .doc(id)
        .get();

    name_ctrl.text = doc.get('name');
    delivery_place_ctrl.text = doc.get('delivery_place');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getUserInfo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      primary: Colors.white,
                      shadowColor: Colors.transparent,
                      elevation: 0
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.redAccent,
                      size: 25.0,
                    ))
                ],
              ),
              const SizedBox(height: 40,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Text(
                  'Compra en cafeteria',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                    fontFamily: 'SourceSansPro'
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Text(
                  'Informacion de pago',
                  style: TextStyle(
                    color: Color.fromRGBO(162, 110, 202, 1),
                    fontSize: 22,
                    fontFamily: 'SourceSansPro'
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                  controller: card_num_ctrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Numero de tarjeta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextFormField(
                        controller: exp_date_ctrl,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Fecha',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextFormField(
                        controller: cvv_ctrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'cvv',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Text(
                  'Informacion del comprador',
                  style: TextStyle(
                      color: Color.fromRGBO(162, 110, 202, 1),
                      fontSize: 22,
                      fontFamily: 'SourceSansPro'
                  ),
                ),
              ),
              const SizedBox(height: 20,),
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
              const SizedBox(height: 10,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                  controller: delivery_place_ctrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Lugar de entrega',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: ElevatedButton(
                    onPressed: () { },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: const Color.fromRGBO(165, 110, 202, 1),
                        padding: const EdgeInsets.symmetric(vertical: 15)
                    ),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(fontSize: 18),
                    )
                ),
              )
            ],
          ),
        )
    );
  }
}
