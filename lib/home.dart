import 'dart:convert';
import 'dart:io';

import 'package:cafeteria_leones/basket.dart';
import 'package:cafeteria_leones/consumerinformation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'WorkSans'
      ),
      home: const HomeInterface(),
    );
  }
}

class HomeInterface extends StatefulWidget {
  const HomeInterface({Key? key}) : super(key: key);
  @override
  State<HomeInterface> createState() => _HomeInterface();
}

class _HomeInterface extends State<HomeInterface> {
  final search_ctrl = TextEditingController();
  List saucers = <Map<String, dynamic>>[];
  List all_saucers = <Map<String, dynamic>>[];

  void seeBasket() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Basket()));
  }

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

  void searchSaucer() {
    saucers.clear();
    all_saucers.forEach((element) {
      if (element['name'].toString().contains(search_ctrl.text) == true) {
        setState(() {
          saucers.add(element);
        });
      }
    });
  }


  Future<void> addToBasket(int index) async {
    final String config_json = await readConfig();
    Map<String, dynamic> pre_config = jsonDecode(config_json);
    bool exist = false;

    try {
      for (int i = 0; i < pre_config['products'].length; i++) {
        if (saucers[index]['name'] == pre_config['products'][i]['name']) {
          exist = true;
          pre_config['products'][i]['count'] += 1;
          break;
        }
      }

      if (exist == false) {
        pre_config['products'].add({
          'name': saucers[index]['name'],
          'count': 1
        });
      }

      writeConfig(jsonEncode(pre_config));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Añadido')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al añadir al carrito')));
    }
  }

  Future<void> getSaucers() async {
    await FirebaseFirestore.instance
        .collection('Saucer')
        .get()
        .then((collection) => {
          collection.docs.forEach((element) async {
            String url = await FirebaseStorage.instance
                .ref()
                .child('${element.id}.jpg')
                .getDownloadURL();

            setState(() {
              saucers.add({
                'name': element.id,
                'price': element.get('price'),
                'availability': element.get('availability'),
                'image': url
              });

              all_saucers.add({
                'name': element.id,
                'price': element.get('price'),
                'availability': element.get('availability'),
                'image': url
              });
            });
          }),
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correcto')))
        }).catchError((error) => {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ha ocurrido un error')))
        });
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
        title: const Text('Buscar')
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
                  onTap: () {},
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Basket()));
              },
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10
              ),
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: const Color.fromRGBO(157, 118, 185, 1),
                ),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: TextFormField(
                      onFieldSubmitted: (value) {
                        searchSaucer();
                      },
                      controller: search_ctrl,
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  const Icon(Icons.search),
                ],
              ),
            ),
            const SizedBox(height: 20,),

            Expanded(
                child: CustomScrollView(
                  primary: false,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20
                        ),
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (saucers[index]['availability'] == true) {
                                return Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            saucers[index]['image']),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(15),
                                              color: const Color.fromRGBO(
                                                  118, 71, 151, 1),
                                            ),
                                            child: Text(
                                              '\$${saucers[index]['price']}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              addToBasket(index);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder(),
                                                padding: const EdgeInsets.all(
                                                    3),
                                                primary: const Color.fromRGBO(
                                                    118, 71, 151, 1)
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 15.0,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(vertical: 10),
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.6),
                                                    borderRadius: BorderRadius
                                                        .circular(10)
                                                ),
                                                child: Text(
                                                  '${saucers[index]['name']}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18
                                                  ),
                                                ),
                                              )
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                          childCount: saucers.length
                        )
                      ),
                    )
                  ],
                )
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
