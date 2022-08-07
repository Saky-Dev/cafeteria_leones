import 'package:flutter/material.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'WorkSans'
      ),
      home: const AdminPanelInterface(),
    );
  }
}

class AdminPanelInterface extends StatefulWidget {
  const AdminPanelInterface({Key? key}) : super(key: key);
  @override
  State<AdminPanelInterface> createState() => _AdminPanelInterface();
}

class _AdminPanelInterface extends State<AdminPanelInterface> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Buscar')),
        backgroundColor: Colors.white,
        body: const Text('Admin Panel'),
    );
  }
}
