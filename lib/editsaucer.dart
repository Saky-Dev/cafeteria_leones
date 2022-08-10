import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditSaucer extends StatelessWidget {
  const EditSaucer({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'WorkSans'
      ),
      home: EditSaucerInterface(title: title),
    );
  }
}

class EditSaucerInterface extends StatefulWidget {
  const EditSaucerInterface({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<EditSaucerInterface> createState() => _EditSaucerInterface();
}

class _EditSaucerInterface extends State<EditSaucerInterface> {
  String dropDownValue = 'Platillo';
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

  Future<void> getSaucerData() async {
    final doc = await FirebaseFirestore.instance
      .collection('Saucer')
      .doc(widget.title)
      .get();

    description_ctrl.text = doc.get('description');
    price_ctrl.text = doc.get('price');
    setState(() {
      dropDownValue = doc.get('type');
    });
  }

  Future<void> deleteSaucer() async {
    await FirebaseFirestore.instance
      .collection('Saucer')
      .doc(widget.title)
      .delete()
      .then((value) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Elemento eliminado'))),
        Navigator.of(context, rootNavigator: true).pop(context)
      }).catchError((err) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al eliminar')))
      });
  }

  Future<void> updateSaucer() async {
    String description = description_ctrl.text;
    String price = price_ctrl.text;

    if (description.length == 0 || price.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Los campos deben ser correctamente llenados')));
    } else {
      await FirebaseFirestore.instance
        .collection('Saucer')
        .doc(widget.title)
        .update({
          'price': price,
          'description': description,
          'type': dropDownValue,
        }).then((value) => {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Se ha actualizado ${widget.title}'))),
        }).catchError((error) => {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al actualizar')))
        });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSaucerData());
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
          title: Text(widget.title)
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () { },
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
            const SizedBox(height: 100,),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: ElevatedButton(
                      onPressed: deleteSaucer,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: const Color.fromRGBO(230, 20, 20, 1),
                        padding: const EdgeInsets.symmetric(vertical: 15)
                      ),
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(fontSize: 18),
                      )
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: ElevatedButton(
                      onPressed: updateSaucer,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          primary: const Color.fromRGBO(118, 71, 151, 1),
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
            )
          ],
        ),
      ),
    );
  }
}
