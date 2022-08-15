import 'package:cafeteria_leones/editsaucer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mac_address/mac_address.dart';

class SearchSaucer extends StatelessWidget {
  const SearchSaucer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'WorkSans'
      ),
      home: const SearchSaucerInterface(),
    );
  }
}

class SearchSaucerInterface extends StatefulWidget {
  const SearchSaucerInterface({Key? key}) : super(key: key);
  @override
  State<SearchSaucerInterface> createState() => _SearchSaucerInterface();
}

class _SearchSaucerInterface extends State<SearchSaucerInterface> {
  final search_ctrl = TextEditingController();
  List saucers = <Map<String, dynamic>>[];
  List all_saucers = <Map<String, dynamic>>[];

  void back() {
    Navigator.of(context, rootNavigator: true).pop(context);
  }

  Future<void> getSaucers() async {
    await FirebaseFirestore.instance
        .collection('Saucer')
        .get()
        .then((collection) => {
          collection.docs.forEach((element) {
            setState(() {
              saucers.add({
                'name': element.id,
                'availability': element.get('availability')
              });

              all_saucers.add({
                'name': element.id,
                'availability': element.get('availability')
              });
            });
          }),
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correcto')))
        }).catchError((error) => {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ha ocurrido un error')))
        });
  }

  Future<void> changeStatus(bool value, int index) async {
    setState(() {
      saucers[index]['availability'] = value;
    });

    await FirebaseFirestore.instance
      .collection('Saucer')
      .doc(saucers[index]['name'])
      .update({'availability' : value}) // <-- Updated data
      .then((_) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Disponibilidad cambiada')))
      }).catchError((error) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al actualizar')))
      });
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSaucers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: back,
          ),
          backgroundColor: const Color.fromRGBO(118, 71, 151, 1),
          title: const Text('Platillos')
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextFormField(
                controller: search_ctrl,
                onFieldSubmitted: (value) {
                  searchSaucer();
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Buscar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 5
                          ),
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditSaucer(title: saucers[index]['name'])));
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  shadowColor: Colors.transparent,
                                  elevation: 0.0
                                ),
                                child: Text(
                                  '${saucers[index]['name']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'SourceSansPro',
                                    color: Colors.black
                                  ),
                                )
                              ),
                              Switch(
                                value: saucers[index]['availability'],
                                onChanged: (value) {
                                  changeStatus(value, index);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: saucers.length,
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
