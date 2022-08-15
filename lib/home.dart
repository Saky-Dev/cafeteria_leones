import 'package:cafeteria_leones/consumerinformation.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.purple,
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
  void seeBasket() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar')),
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Color.fromRGBO(164, 111, 201, 1),
        child: ListView(
          padding: EdgeInsets.only(top: 40),
          children: [
            ExpansionTile(
              backgroundColor: const Color.fromRGBO(118, 71, 151, 1),
              title: const Text(
                'Buscar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
              ),
              children: [
                ListTile(
                  title: const Text(
                    'Todo el menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    'Platillos',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    'Bebidas',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    'Botanas',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                  onTap: () {},
                )
              ],
            ),
            ListTile(
              title: const Text(
                'Canasta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
              ),
              onTap: () { },
            ),
            ListTile(
              title: const Text(
                'Usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsumerInformation()));
              },
            ),
            ListTile(
              title: const Text(
                'Compras',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
              ),
              onTap: () { },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10
              ),
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: const Color.fromRGBO(157, 118, 185, 1),
                ),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  const Icon(Icons.search),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: seeBasket,
        tooltip: 'ShoppingBasket',
        child: Icon(Icons.shopping_basket),
        backgroundColor: const Color.fromRGBO(165, 110, 202, 1),
      )
    );
  }
}
