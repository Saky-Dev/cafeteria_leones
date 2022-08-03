import 'package:flutter/material.dart';
import 'package:cafeteria_leones/consumerlogin.dart';
import 'package:cafeteria_leones/sellerlogin.dart';
import 'dart:math';

class MenuLogin extends StatelessWidget {
  const MenuLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'WorkSans'
      ),
      home: const MenuLoginInterface(),
    );
  }
}

class MenuLoginInterface extends StatefulWidget {
  const MenuLoginInterface({Key? key}) : super(key: key);
  @override
  State<MenuLoginInterface> createState() => _MenuLoginInterface();
}

class _MenuLoginInterface extends State<MenuLoginInterface> {
  void toConsumerLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsumerLogin()));
  }

  void toSellerLogin() {
    String code = '';
    int aux = 0;

    for(int i = 0; i < 6; i++) {
      aux = Random().nextInt(10);
      code += aux.toString();
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => SellerLogin(access_code: code)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: toConsumerLogin,
              child: Container(
                padding: const EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width - 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color.fromRGBO(157, 118, 185, 1),
                  ),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/shopping.jpg',
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        'Entrar como comprador',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: toSellerLogin,
              child: Container(
                padding: const EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width - 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color.fromRGBO(157, 118, 185, 1),
                  ),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        'Entrar como vendedor',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    Image.asset(
                      'assets/images/delivery.jpg',
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
