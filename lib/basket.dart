import 'dart:convert';
import 'dart:io';

import 'package:cafeteria_leones/consumerinformation.dart';
import 'package:cafeteria_leones/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Basket extends StatelessWidget {
  const Basket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'WorkSans'
      ),
      home: const BasketInterface(),
    );
  }
}

class BasketInterface extends StatefulWidget {
  const BasketInterface({Key? key}) : super(key: key);
  @override
  State<BasketInterface> createState() => _BasketInterface();
}

class _BasketInterface extends State<BasketInterface> {
  List saucers = <Map<String, dynamic>>[];

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

  Future<void> getSaucers() async {
    final String config_json = await readConfig();
    Map<String, dynamic> pre_config = jsonDecode(config_json);
    double aux_price = 0;

    for(int i = 0; i < pre_config['products'].length; i++) {
      final doc = await FirebaseFirestore.instance
          .collection('Saucer')
          .doc(pre_config['products'][i]['name'])
          .get();

      aux_price = double.parse(doc.get('price'));
      setState(() {
        saucers.add({
          'name': pre_config['products'][i]['name'],
          'count': pre_config['products'][i]['count'],
          'pu': aux_price,
          'pt': aux_price * pre_config['products'][i]['count']
        });
      });
      
      print(saucers[i]['name']);
    }
  }

  Future<void> eraseList() async {
    final String config_json = await readConfig();
    Map<String, dynamic> pre_config = jsonDecode(config_json);
    pre_config['products'] = [];

    setState(() {
      saucers = <Map<String, dynamic>>[ ];
    });

    writeConfig(jsonEncode(pre_config));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSaucers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(165, 110, 202, 1),
            title: const Text('Canasta')
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
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsumerInformation()));
                },
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: const Text(
                        'Productos',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 6,
                      child: const Text(
                        'P.U.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 14,
                        ),
                      )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 6,
                      child: const Text(
                        'P.T.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 0.0,
                                    color: Colors.transparent
                                  ),
                                  top: BorderSide(
                                    width: 0.0,
                                    color: Colors.transparent
                                  ),
                                  right: BorderSide(
                                    width: 0.0,
                                    color: Colors.transparent
                                  ),
                                  bottom: BorderSide(
                                    color: const Color.fromRGBO(165, 110, 202, 1),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 10,
                                left: 30,
                                right: 30
                              ),
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.3,
                                    child: Text(
                                      '${saucers[index]['count']}  ${saucers[index]['name']}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'SourceSansPro',
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 6,
                                    child: Text(
                                      '${saucers[index]['pu']}',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'SourceSansPro',
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 6,
                                    child: Text(
                                      '${saucers[index]['pt']}',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'SourceSansPro',
                                          color: Colors.black
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          childCount: saucers.length,
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: eraseList,
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              primary: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 15)
                          ),
                          child: const Text(
                            'Borrar lista',
                            style: TextStyle(fontSize: 18),
                          )
                      )
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
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
                            'Comprar',
                            style: TextStyle(fontSize: 18),
                          )
                      )
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50,)
            ],
          ),
        )
    );
  }
}
