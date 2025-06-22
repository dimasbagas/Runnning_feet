import 'package:flutter/material.dart';

class Running extends StatefulWidget {
  const Running({super.key});

  @override
  State<Running> createState() => _RunningState();
}

class _RunningState extends State<Running> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mulai Berlari")),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Selamat Berlari 🏃‍♂️",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {},
                child: Text("mulai"),
              ),
              SizedBox(height: 30),
              Text("Riwayat Titik Lokasi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Divider(),
              Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text("index"),
                  ),
                  title: Text("lat:"),
                  subtitle: Text("Lot:"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
