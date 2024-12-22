import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import nécessaire
import 'firebase_options.dart';
import 'screens/login.dart'; // Import de la page de login
import 'screens/home.dart';
import 'screens/profile.dart'; // Import de la page principale avec la BottomNavigationBar

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vêtements App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(), // Route d'authentification
        '/home': (context) => HomePage(), // Page principale après connexion
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Vérifie si l'utilisateur est connecté
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return HomePage(); // Si l'utilisateur est connecté, afficher la page principale
          }
          return LoginPage(); // Sinon, afficher la page de connexion
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
