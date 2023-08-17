import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<StatefulWidget> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            icon: const Icon(Icons.house),
            iconSize: 40,
            alignment: Alignment.center,
          ),
          ListTile(
            title: const Text('Altınlar'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/gold-products-inventory-screen', (route) => false);
            },
          ),
          ListTile(
            title: const Text('Pırlantalar'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/diamond-products-screen', (route) => false);
            },
          ),
          ListTile(
            title: const Text('Altın Satış İşlemi'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/gold-sale-screen', (route) => false);
            },
          ),
          ListTile(
            title: const Text('Satılan Alınlar'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/gold-products-sold-screen', (route) => false);
            },),

        ],
      ),
    );
  }
}
