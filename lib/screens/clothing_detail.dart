import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClothesDetailPage extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String category;
  final String size;
  final dynamic price; // Changed to dynamic because price is a number
  final String brand;

  ClothesDetailPage({
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.size,
    required this.price,
    required this.brand,
  });

  // Function to add the item to the cart
  Future<void> _addToCart(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Reference to the user's cart collection
        var cartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart');

        // Add the item to the cart
        await cartRef.add({
          'name': name,
          'imageUrl': imageUrl,
          'category': category,
          'size': size,
          'price': price,
          'brand': brand,
        });

        // Show a confirmation snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name ajouté au panier !')),
        );
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout au panier')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Veuillez vous connecter pour ajouter au panier')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détail du Vêtement')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Constrain the image size
              Center(
                child: Image.network(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16),
              Text(name, style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 8),
              Text('Catégorie: $category'),
              Text('Taille: $size'),
              Text('Prix: $price €'),
              Text('Marque: $brand'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    _addToCart(context), // Call the add to cart function
                child: Text('Ajouter au panier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
