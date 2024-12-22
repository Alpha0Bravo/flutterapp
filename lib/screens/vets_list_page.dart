import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'clothing_detail.dart';

class VetsListPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _clothesStream =
      FirebaseFirestore.instance.collection('clothes').snapshots();

  // Function to add an item to the cart
  Future<void> _addToCart(String itemId, String name, String imageUrl,
      String category, String size, double price, String brand) async {
    User user = _auth.currentUser!; // Get the current user
    CollectionReference cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart');

    // Check if the cart collection exists and create it with the selected item
    QuerySnapshot cartSnapshot = await cartRef.get();
    if (cartSnapshot.docs.isEmpty) {
      // If the cart is empty, create a new document with the item
      await cartRef.add({
        'itemId': itemId,
        'name': name,
        'imageUrl': imageUrl,
        'category': category,
        'size': size,
        'price': price,
        'brand': brand,
      });
    } else {
      // Otherwise, just add the selected item to the cart
      await cartRef.add({
        'itemId': itemId,
        'name': name,
        'imageUrl': imageUrl,
        'category': category,
        'size': size,
        'price': price,
        'brand': brand,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des Vêtements')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _clothesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur de récupération des données'));
          }

          final clothesList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: clothesList.length,
            itemBuilder: (context, index) {
              var clothes = clothesList[index];
              var itemId = clothes.id;
              var name = clothes['name'] ?? 'Nom non disponible';
              var imageUrl =
                  clothes['imageUrl'] ?? 'https://via.placeholder.com/150';
              var category = clothes['category'] ?? 'Catégorie non spécifiée';
              var size = clothes['size'] ?? 'Taille non spécifiée';
              var price = clothes['price'] ?? 'Prix non spécifié';
              var brand = clothes['brand'] ?? 'Marque non spécifiée';

              return ListTile(
                leading: Image.network(imageUrl),
                title: Text(name),
                subtitle: Text(
                    '$category - Taille: $size - Prix: $price - Marque: $brand'), // Affichage de la marque
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    _addToCart(itemId, name, imageUrl, category, size, price,
                        brand); // Add to cart
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ajouté au panier')));
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClothesDetailPage(
                        name: name,
                        imageUrl: imageUrl,
                        category: category,
                        size: size,
                        price: price,
                        brand: brand, // Passage du champ brand
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
