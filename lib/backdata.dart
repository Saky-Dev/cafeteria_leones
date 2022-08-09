import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mac_address/mac_address.dart';

class BankData extends StatelessWidget {
  const BankData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'WorkSans'
      ),
      home: const BankDataInterface(),
    );
  }
}

class BankDataInterface extends StatefulWidget {
  const BankDataInterface({Key? key}) : super(key: key);
  @override
  State<BankDataInterface> createState() => _BankDataInterface();
}

class _BankDataInterface extends State<BankDataInterface> {
  final card_num_ctrl = TextEditingController();

  void back() {
    Navigator.of(context, rootNavigator: true).pop(context);
  }

  Future<void> getCardData() async {
    String macAddress = '';

    try {
      macAddress = await GetMac.macAddress;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A ocurrido un error')));
      return;
    }

    try {
      var doc = await FirebaseFirestore.instance
        .collection('Admin')
        .doc(macAddress)
        .get();

      card_num_ctrl.text = doc.get('card_num');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCardNum() async {
    String macAddress = '';

    try {
      macAddress = await GetMac.macAddress;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A ocurrido un error')));
      return;
    }

    if (card_num_ctrl.text.length != 16) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Numero de caracteres invalido')));
    } else {
      await FirebaseFirestore.instance
          .collection('Admin')
          .doc(macAddress)
          .update({'card_num' : card_num_ctrl.text}) // <-- Updated data
          .then((_) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Se ha actualizado')))
      }).catchError((error) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al actualizar')))
      });
    }

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getCardData());
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
          title: const Text('Datos bancarios')
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
              const SizedBox(height: 30,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: ElevatedButton(
                  onPressed: updateCardNum,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    primary: const Color.fromRGBO(162, 112, 201, 1),
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
    );
  }
}
