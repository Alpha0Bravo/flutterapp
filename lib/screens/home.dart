import 'package:flutter/material.dart';
import 'package:flutterapp/screens/vets_list_page.dart';
import 'package:flutterapp/screens/profile.dart'; // Importer la page Profil
import 'package:flutterapp/widgets/bottom_navigation_bar.dart';

import 'cart.dart'; // Import de la BottomNavigationBar

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Liste des pages correspondantes
  final List<Widget> _pages = [
    VetsListPage(), // Page Acheter
    CartPage(), // Page Panier
    ProfilePage(), // Page Profil
  ];

  // Change de page lorsque l'utilisateur clique sur un élément de la BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vêtements App')),
      body: _pages[_currentIndex], // Affiche la page correspondante à l'index
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
