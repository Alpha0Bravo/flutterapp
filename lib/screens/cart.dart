import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  late CollectionReference _cartRef;

  List<DocumentSnapshot> _cartItems = [];
  double _totalAmount = 0.0; // Variable for total amount

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('cart');
    _loadCartItems();
  }

  // Load the cart items from Firestore
  Future<void> _loadCartItems() async {
    QuerySnapshot snapshot = await _cartRef.get();
    setState(() {
      _cartItems = snapshot.docs;
      _calculateTotal(); // Recalculate total whenever items are loaded
    });
  }

  // Remove an item from the cart
  Future<void> _removeItem(String itemId) async {
    await _cartRef.doc(itemId).delete();
    _loadCartItems(); // Refresh the cart items after removing
  }

  // Calculate the total amount of all items in the cart
  void _calculateTotal() {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item['price']?.toDouble() ?? 0.0;
    }
    setState(() {
      _totalAmount = total; // Update the total amount
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
      ),
      body: _cartItems.isEmpty
          ? Center(child: Text('Votre panier est vide'))
          : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                var item = _cartItems[index];
                String itemId = item.id;
                String imageUrl = item['imageUrl'] ?? '';
                String name = item['name'] ?? 'No name';
                String size = item['size'] ?? 'No size';
                double price = item['price']?.toDouble() ?? 0.0;

                return ListTile(
                  leading: Image.network(imageUrl),
                  title: Text(name),
                  subtitle: Text('Taille: $size\nPrix: \$${price.toString()}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () async {
                      await _removeItem(
                          itemId); // Remove the item from the cart
                    },
                  ),
                );
              },
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Total: \$${_totalAmount.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: () {
                // Implement action like checkout or payment
                print('Proceed to checkout');
              },
              child: Text('Passer à la caisse'),
            ),
          ],
        ),
      ),
    );
  }
}
