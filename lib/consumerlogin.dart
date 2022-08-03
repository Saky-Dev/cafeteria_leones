import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> registerStudent() async {
    bool exist = false;
    String name = name_ctrl.text;
    String school_id = school_id_ctrl.text;

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
              'delivery_place': ''
            });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Se ha iniciado sesión')));
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