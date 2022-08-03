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
            children: [],
          ),
        )
    );
  }
}