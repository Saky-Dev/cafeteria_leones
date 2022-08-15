import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddSaucer extends StatelessWidget {
  const AddSaucer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'WorkSans'
      ),
      home: const AddSaucerInterface(),
    );
  }
}

class AddSaucerInterface extends StatefulWidget {
  const AddSaucerInterface({Key? key}) : super(key: key);
  @override
  State<AddSaucerInterface> createState() => _AddSaucerInterface();
}

class _AddSaucerInterface extends State<AddSaucerInterface> {
  String dropDownValue = 'Platillo';
  File saucer_picture = new File('');
  final name_ctrl = TextEditingController();
  final description_ctrl = TextEditingController();
  final price_ctrl = TextEditingController();

  var types = [
    'Platillo',
    'Bebidas',
    'Botanas'
  ];

  void back() {
    Navigator.of(context, rootNavigator: true).pop(context);
  }

  Future<void> addNewSaucer() async {
    String name = name_ctrl.text;
    String description = description_ctrl.text;
    String price = price_ctrl.text;

    print(name.length);
    print(description.length);
    print(price.length);

    if (name.length == 0 || description.length == 0 || price.length == 0 || saucer_picture.path == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Los campos deben ser correctamente llenados')));
    } else {

      await FirebaseFirestore.instance
        .collection('Saucer')
        .doc(name)
        .set({
          'price': price,
          'description': description,
          'availability': true,
          'type': dropDownValue,
          'picture': ''
        }).then((value) => {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('añadido de forma correcta'))),
          name_ctrl.text = '',
          description_ctrl.text = '',
          price_ctrl.text = '',
          setState(() {
            dropDownValue = 'Platillo';
          })
        }).catchError((error) => {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al añadir')))
        });

      final storageRef = FirebaseStorage.instance.ref();
      final saucer = storageRef.child('$name.jpg');

      await saucer.putFile(saucer_picture).then((p0) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imagen subida de forma correcta')))
      })
      .catchError((onError) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al subir la imagen')))
      });
    }
  }

  Future<void> getImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedFile != null) {
      saucer_picture = File(pickedFile.path);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foto añadida!')));
    }
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
          title: const Text('Nuevo Platillo')
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: getImage,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                      primary: const Color.fromRGBO(118, 71, 151, 1)
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.7,
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
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextFormField(
                maxLines: 8,
                controller: description_ctrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Descripcion',
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextFormField(
                      controller: price_ctrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Precio',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: const Color.fromRGBO(157, 118, 185, 1),
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5
                      ),
                      child: DropdownButton(
                        value: dropDownValue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        underline: Container(),
                        items: types.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropDownValue = value!;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40,),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: ElevatedButton(
                onPressed: addNewSaucer,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  primary: const Color.fromRGBO(118, 71, 151, 1),
                  padding: const EdgeInsets.symmetric(vertical: 15)
                ),
                child: const Text(
                  'Agregar',
                  style: TextStyle(fontSize: 18),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
