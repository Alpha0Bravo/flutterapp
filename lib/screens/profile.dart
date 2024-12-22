import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_clothing_page.dart'; // Import the AddClothingPage

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? login;
  String? password;
  String? birthday;
  String? address;
  String? postalCode;
  String? city;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final data = userDoc.data();
      setState(() {
        login = data?['login'];
        password = data?['password'];
        birthday = data?['birthday'];
        address = data?['address'];
        postalCode = data?['postalCode'];
        city = data?['city'];
      });
    }
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).update({
          'birthday': birthday,
          'address': address,
          'postalCode': postalCode,
          'city': city,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil mis à jour avec succès')),
        );
      }
    }
  }

  void _logout() {
    _auth.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: login == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Login (readonly)
                    TextFormField(
                      initialValue: login,
                      decoration: InputDecoration(labelText: 'Login'),
                      readOnly: true,
                    ),
                    SizedBox(height: 10),

                    // Password (obfuscated)
                    TextFormField(
                      initialValue: password,
                      decoration: InputDecoration(labelText: 'Mot de passe'),
                      obscureText: true,
                      readOnly: true,
                    ),
                    SizedBox(height: 10),

                    // Birthday
                    TextFormField(
                      initialValue: birthday,
                      decoration: InputDecoration(labelText: 'Anniversaire'),
                      onSaved: (value) => birthday = value,
                    ),
                    SizedBox(height: 10),

                    // Address
                    TextFormField(
                      initialValue: address,
                      decoration: InputDecoration(labelText: 'Adresse'),
                      onSaved: (value) => address = value,
                    ),
                    SizedBox(height: 10),

                    // Postal Code (numeric input)
                    TextFormField(
                      initialValue: postalCode,
                      decoration: InputDecoration(labelText: 'Code postal'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => postalCode = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un code postal';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Veuillez entrer uniquement des chiffres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    // City
                    TextFormField(
                      initialValue: city,
                      decoration: InputDecoration(labelText: 'Ville'),
                      onSaved: (value) => city = value,
                    ),
                    SizedBox(height: 20),

                    // Save Button
                    ElevatedButton(
                      onPressed: _saveUserData,
                      child: Text('Valider'),
                    ),
                    SizedBox(height: 10),

                    // Add Clothing Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddClothingPage(),
                          ),
                        );
                      },
                      child: Text('Ajouter un nouveau vêtement'),
                    ),
                    SizedBox(height: 10),

                    // Logout Button
                    TextButton(
                      onPressed: _logout,
                      child: Text('Se déconnecter'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
