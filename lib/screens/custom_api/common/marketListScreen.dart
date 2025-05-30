import 'dart:convert';

import 'package:agroconnect/constants.dart';
import 'package:agroconnect/screens/custom_api/common/mapScreen.dart';
import 'package:agroconnect/screens/userdata/validate_userdata.dart';
import 'package:agroconnect/utils/dependcies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MarketListScreen extends StatefulWidget {
  const MarketListScreen({super.key});

  @override
  State<MarketListScreen> createState() => _MarketListScreenState();
}

// API function
Future<List<dynamic>> fetchMarketData() async {
  String sessionToken;
  final sessionTokenStatus = await UserDependencies().getSessionToken();
  if (sessionTokenStatus['status'] != true) {
    throw Exception('Failed to load data');
  }
  sessionToken = sessionTokenStatus['sessionToken'];
  final url = Uri.parse('$backendURL/market/getMarketPlace');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $sessionToken',
  };

  final body = jsonEncode({"country": "india", "state": "tamilNadu"});

  final response = await http.post(url, headers: headers, body: body);
  print("response ${json.decode(response.body)}");
  if (response.statusCode == 200 || response.statusCode == 201) {
    final decoded = json.decode(response.body);
    return decoded['data']; // Return list of districts
  } else {
    final decoded = json.decode(response.body);
    print("error $decoded");
    throw Exception('Failed to load data');
  }
}

class _MarketListScreenState extends State<MarketListScreen> {
  late Future<List<dynamic>> futureMarketData;

  @override
  void initState() {
    super.initState();
    futureMarketData = fetchMarketData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(
        child: Text("Market Places", style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w800, fontSize: 24 ),
          textAlign:TextAlign.center,

        ),
      )),
      body: FutureBuilder<List<dynamic>>(
        future: futureMarketData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No markets found."));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final district = data[index];
                final districtName = district['district'];
                final markets = district['markets'] as List<dynamic>;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          districtName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        ...markets.map((market) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    market['name'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MapScreen(markets: markets),
                              ),
                            );
                          },
                          icon: const Icon(Icons.map),
                          label: const Text("View All on Map"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
