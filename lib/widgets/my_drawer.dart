import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/enum/routes.dart';
import 'package:kuyumcu_stok/extension/route_extension.dart';

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
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.homeScreen.nameDefinition, (route) => false);
            },
            icon: const Icon(Icons.house),
            iconSize: 40,
            alignment: Alignment.center,
          ),
          ListTile(
            title: const Text('Altınlar'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.goldProductsInventoryScreen.nameDefinition,
                  (route) => false);
            },
          ),
          ListTile(
            title: const Text('Altın Satış İşlemi'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context,
                  Routes.goldSaleScreen.nameDefinition, (route) => false);
            },
          ),
          ListTile(
            title: const Text('Girilen Altınlar'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.goldProductEntriesScreen.nameDefinition,
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
