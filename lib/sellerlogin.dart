import 'package:flutter/material.dart';

class SellerLogin extends StatelessWidget {
  const SellerLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'WorkSans'
      ),
      home: const SellerLoginInterface(),
    );
  }
}

class SellerLoginInterface extends StatefulWidget {
  const SellerLoginInterface({Key? key}) : super(key: key);
  @override
  State<SellerLoginInterface> createState() => _SellerLoginInterface();
}

class _SellerLoginInterface extends State<SellerLoginInterface> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        )
    );
  }
}