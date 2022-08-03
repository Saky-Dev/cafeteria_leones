import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                onPressed: () {  },
                child: const Text('Entrar'),
              )
            ],
          ),
        )
    );
  }
}