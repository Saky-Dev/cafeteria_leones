import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SellerLogin extends StatelessWidget {
  const SellerLogin({Key? key, required this.access_code}) : super(key: key);
  final String access_code;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'WorkSans'
      ),
      home: SellerLoginInterface(access_code: access_code),
    );
  }
}

class SellerLoginInterface extends StatefulWidget {
  const SellerLoginInterface({Key? key, required this.access_code}) : super(key: key);
  final String access_code;

  @override
  State<SellerLoginInterface> createState() => _SellerLoginInterface();
}

class _SellerLoginInterface extends State<SellerLoginInterface> {
  void valid() {
    widget.access_code;
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
                'Nuevo Administrador',
                style: TextStyle(
                  fontSize: 24
                ),
              ),
              const SizedBox(height: 120),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Código',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Text(
                  '*Ingresa el código de acceso*',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'SourceSansPro'
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