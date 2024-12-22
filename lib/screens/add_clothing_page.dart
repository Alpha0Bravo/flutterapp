import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddClothingPage extends StatefulWidget {
  @override
  _AddClothingPageState createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sizeController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController(); // Image URL input field
  String? _category;

  // Function to save clothing data to Firestore
  Future<void> _saveClothingData() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Save data to Firestore
        await FirebaseFirestore.instance.collection('clothes').add({
          'name': _nameController.text,
          'imageUrl': _imageUrlController.text, // Use the entered image URL
          'category': _category ?? 'Haut', // Default category if not selected
          'size': _sizeController.text,
          'brand': _brandController.text,
          'price': double.tryParse(_priceController.text) ?? 0.0,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vêtement ajouté avec succès!')));
        Navigator.pop(context); // Go back to profile page
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'ajout du vêtement')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un nouveau vêtement')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image URL input
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'URL de l\'image'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une URL d\'image';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Category field (non-editable)
              TextFormField(
                initialValue: _category ?? 'Sélectionnée automatiquement',
                decoration: InputDecoration(labelText: 'Catégorie'),
                readOnly: true,
              ),
              SizedBox(height: 16),

              // Size field
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(labelText: 'Taille'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une taille';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Brand field
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(labelText: 'Marque'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une marque';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Price field
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: _saveClothingData,
                child: Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
