import 'dart:convert';
import 'dart:io';

import 'package:cafeteria_leones/home.dart';
import 'package:cafeteria_leones/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ConsumerInformation extends StatelessWidget {
  const ConsumerInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'WorkSans'
      ),
      home: const ConsumerInformationInterface(),
    );
  }
}

class ConsumerInformationInterface extends StatefulWidget {
  const ConsumerInformationInterface({Key? key}) : super(key: key);
  @override
  State<ConsumerInformationInterface> createState() => _ConsumerInformationInterface();
}

class _ConsumerInformationInterface extends State<ConsumerInformationInterface> {
  String title = '';
  String id = '';
  final delivery_place_ctrl = TextEditingController();
  final card_num_ctrl = TextEditingController();
  final exp_date_ctrl = TextEditingController();
  final cvv_ctrl = TextEditingController();

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/config.json');
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

  void seeBasket() {

  }

  Future<void> getUserData() async {
    final String config_json = await readConfig();
    Map<String, dynamic> pre_config = jsonDecode(config_json);

    final doc = await FirebaseFirestore.instance
        .collection('Consumer')
        .doc(pre_config['id'])
        .get();

    setState(() {
      title = doc.get('name');
      id = pre_config['id'];
    });

    delivery_place_ctrl.text = doc.get('delivery_place');
    card_num_ctrl.text = pre_config['card_num'];
    exp_date_ctrl.text = pre_config['exp_Date'];
    cvv_ctrl.text = pre_config['cvv'];
  }

  Future<void> saveData() async {
    final String config_json = await readConfig();
    Map<String, dynamic> pre_config = jsonDecode(config_json);
    String delivery_place = delivery_place_ctrl.text;
    String card_num = card_num_ctrl.text;
    String exp_date = exp_date_ctrl.text;
    String cvv = cvv_ctrl.text;
    
    if (delivery_place.isNotEmpty && card_num.isNotEmpty && exp_date.isNotEmpty && cvv.isNotEmpty) {
      pre_config['card_num'] = card_num;
      pre_config['exp_date'] = exp_date;
      pre_config['cvv'] = cvv;
      
      try {
        writeConfig(jsonEncode(pre_config));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al guardar los datos')));
      }

      await FirebaseFirestore.instance
        .collection('Consumer')
        .doc(pre_config['id'])
        .update({'delivery_place': delivery_place})
      .then((value) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Datos guardados de forma correcta')))
      })
      .catchError((error) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al actualizar los datos')))
      });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debes de ingresar los datos de manera correcta')));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(118, 71, 151, 1),
          toolbarHeight: MediaQuery.of(context).size.height / 5,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomLeft,
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 20,),
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  const SizedBox(width: 60,),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600
                    )
                  )
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        drawer: Drawer(
          backgroundColor: Color.fromRGBO(164, 111, 201, 1),
          child: ListView(
            padding: EdgeInsets.only(top: 40),
            children: [
              ExpansionTile(
                backgroundColor: const Color.fromRGBO(118, 71, 151, 1),
                title: const Text(
                  'Buscar',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                children: [
                  ListTile(
                    title: const Text(
                      'Todo el menú',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Platillos',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text(
                      'Bebidas',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text(
                      'Botanas',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                    onTap: () {},
                  )
                ],
              ),
              ListTile(
                title: const Text(
                  'Canasta',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                onTap: () { },
              ),
              ListTile(
                title: const Text(
                  'Usuario',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                onTap: () { },
              ),
              ListTile(
                title: const Text(
                  'Compras',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                onTap: () { },
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Container(
                margin: const EdgeInsets.only(left: 130),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Matricula: ${id}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: delivery_place_ctrl,
                  decoration: InputDecoration(
                    labelText: 'Lugar de entrega',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: card_num_ctrl,
                  decoration: InputDecoration(
                    labelText: 'Numero de tarjeta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: exp_date_ctrl,
                        decoration: InputDecoration(
                          labelText: 'Fecha',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: cvv_ctrl,
                        decoration: InputDecoration(
                          labelText: 'CVV',
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
                child: ElevatedButton(
                    onPressed: saveData,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: const Color.fromRGBO(165, 110, 202, 1),
                        padding: const EdgeInsets.symmetric(vertical: 15)
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 18),
                    )
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: seeBasket,
          tooltip: 'ShoppingBasket',
          child: Icon(Icons.shopping_basket),
          backgroundColor: const Color.fromRGBO(165, 110, 202, 1),
        )
    );
  }
}
