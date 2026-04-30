import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importante tener esta dependencia
import 'screens/home_screen.dart';

void main() async {
  // 1. Asegurar que los widgets estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar Firebase (En Web usará la config del index.html)
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCbcmidLYvSvfzL3pjePIh6lB3PD2bWyUs",
        appId: "1:476796278010:web:fa118d4069703f42c7e543",
        messagingSenderId: "476796278010",
        projectId: "bdcrudboutique",
        storageBucket: "bdcrudboutique.firebasestorage.app",
      ),
    );
    print("Conexión a Firebase exitosa");
  } catch (e) {
    print("Error al conectar a Firebase: $e");
  }

  runApp(const MoonSweetApp());
}

class MoonSweetApp extends StatelessWidget {
  const MoonSweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moon Sweet Boutique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC8A2C8)),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}