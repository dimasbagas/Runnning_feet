import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug di pojok kanan atas
      home: Firstpage(), // Menetapkan Firstpage sebagai halaman awal
    );
  }
}

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1FB69A), 
        child: SafeArea( 
          child: Center( 
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Image.asset(
                  'assets/image/logo.png'
                ),
                const Text("RunningFeet",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFE7F20)
                ),),
                const SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "Control your exercise activity tracking with various health statistics",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffffffff)
                  ),
                ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}