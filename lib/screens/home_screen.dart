import 'package:flutter/material.dart';
import 'crud_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo circular
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFC8A2C8), // Lila
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const Center(
                child: Text(
                  'M',
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Moon Sweet Boutique',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 40),
            // Botón Productos
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CrudScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC8A2C8),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
// FORMA CORRECTA PARA BOTONES:
side: const BorderSide(color: Colors.black, width: 1),                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Productos', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}