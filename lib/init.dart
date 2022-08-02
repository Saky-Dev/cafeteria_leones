import 'package:flutter/material.dart';

class Init extends StatelessWidget {
  const Init({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafeteria Leones',
      theme: ThemeData(
        fontFamily: 'WorkSans',
        primarySwatch: Colors.deepPurple,
      ),
      home: const Slider(),
    );
  }
}

class Slider extends StatefulWidget {
  const Slider({Key? key}) : super(key: key);
  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/meet.jpg',
              width: MediaQuery.of(context).size.width - 40,
            ),
            const Text(
              '¡Descansa mientras esperas!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 28,
                fontWeight: FontWeight.w400
              ),
            )
          ],
        ),
      ),
    );
  }
}
