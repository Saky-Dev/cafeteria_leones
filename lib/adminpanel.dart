import 'package:cafeteria_leones/addsaucer.dart';
import 'package:cafeteria_leones/bankdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mac_address/mac_address.dart';

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
  final delivery_name_ctrl = TextEditingController();
  
  Future<void> getDeliveryData() async{
    String macAddress = '';

    try {
      macAddress = await GetMac.macAddress;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A ocurrido un error')));
      return;
    }

    try {
      var doc = await FirebaseFirestore.instance
        .collection('Admin')
        .doc(macAddress)
        .get();
      
      delivery_name_ctrl.text = doc.get('delivery_name');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDelivery() async {
    String macAddress = '';

    try {
      macAddress = await GetMac.macAddress;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A ocurrido un error')));
      return;
    }

    await FirebaseFirestore.instance
      .collection('Admin')
      .doc(macAddress)
      .update({'delivery_name' : delivery_name_ctrl.text}) // <-- Updated data
      .then((_) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Se ha actualizado')))
      }).catchError((error) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al actualizar')))
      });
  }

  void toBankData() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BankData()));
  }

  void toAddSaucer() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSaucer()));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getDeliveryData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(118, 71, 151, 1),
          toolbarHeight: MediaQuery.of(context).size.height / 5,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomLeft,
              child: const Text(
                'Administrador',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Expanded(
                      child: TextFormField(
                        controller: delivery_name_ctrl,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Repartidor',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    ),
                    const SizedBox(width: 30,),
                    ElevatedButton(
                      onPressed: () { },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                        primary: const Color.fromRGBO(118, 71, 151, 1)
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: ElevatedButton(
                  onPressed: updateDelivery,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    primary: const Color.fromRGBO(118, 71, 151, 1),
                    padding: const EdgeInsets.symmetric(vertical: 15)
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(fontSize: 18),
                  )
                ),
              ),
              const SizedBox(height: 50,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 4,
                child: GridView.count(
                  primary: false,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: ((MediaQuery.of(context).size.width / 3) / (MediaQuery.of(context).size.height / 15)),
                  children: [
                    ElevatedButton(
                      onPressed: toAddSaucer,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        primary: const Color.fromRGBO(165, 110, 203, 1)
                      ),
                      child: const Text(
                        'Agregar nuevo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          primary: const Color.fromRGBO(165, 110, 203, 1)
                      ),
                      child: const Text(
                        'Ver platillos',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          primary: const Color.fromRGBO(165, 110, 203, 1)
                      ),
                      child: const Text(
                        'Ventas',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: toBankData,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          primary: const Color.fromRGBO(165, 110, 203, 1)
                      ),
                      child: const Text(
                        'Datos bancarios',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    )
                  ],
                )
              )
            ],
          ),
        ),
    );
  }
}
