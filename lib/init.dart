import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

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
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        pathImage: 'assets/images/meet.jpg',
        description: '¡Descansa mientas esperas!',
        styleDescription: const TextStyle(
            color: Colors.black,
            fontSize: 28
        ),
        backgroundColor: Colors.white,
      ),
    );

    slides.add(
      Slide(
        pathImage: 'assets/images/deliveryservice.jpg',
        description: 'Llega al lugar donde estes',
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 28
        ),
        backgroundColor: const Color.fromRGBO(232, 234, 246, 1),
      ),
    );
  }

  void onDonePress() {

  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      onDonePress: onDonePress,
      showSkipBtn: false,
      showPrevBtn: false,
      showNextBtn: false,
      showDoneBtn: true,
      autoScroll: true,
      autoScrollInterval: const Duration(seconds: 3),
      doneButtonStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(117, 72, 146, 1))
      ),
    );
  }
}
