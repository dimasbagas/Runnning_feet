import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api extends StatefulWidget {
  const Api({super.key});

  @override
  State<Api> createState() => _ApiState();
}

class _ApiState extends State<Api> {
  Future<Map<String, dynamic>>? _weatherData;
  @override
  void initState() {
    super.initState();
    _weatherData = getDataFromAPI();
  }

  Future<Map<String, dynamic>> getDataFromAPI() async {
    try {
      final response = await http.get(Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=Pamekasan&appid=44be9e79396d022e0b9503a4fe80ea26&units=metric"  
      ));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Gagal memuat status cuaca. Status code: ${response.statusCode}'
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cuaca Pamekasan"),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _weatherData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              final main = data['main'];
              final weather = data['weather'][0];
              final temperature = main['temp'];
              final humidity = main['humidity'];
              final description = weather['description'];
              final weatherDescription = weather['weather'][0]['description'];
              final cityName = weather['name'];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kota: $cityName',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10), 
                  Text(
                    'Suhu: ${main['temp']} °C',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Deskripsi Cuaca: $weatherDescription',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kelembaban: ${main['humidity']}%',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Langit: ${main['main']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Suhu: $temperature °C',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Kelembapan: $humidity %',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Deskripsi: $description',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              );
            } else {
              return const Text('Tidak ada data cuaca yang tersedia.');
            }
          }
        )
      ),
    );
  }
}