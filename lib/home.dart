import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'WorkSans'
      ),
      home: const HomeInterface(),
    );
  }
}

class HomeInterface extends StatefulWidget {
  const HomeInterface({Key? key}) : super(key: key);
  @override
  State<HomeInterface> createState() => _HomeInterface();
}

class _HomeInterface extends State<HomeInterface> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Welcome')
            ],
          ),
        )
    );
  }
}
