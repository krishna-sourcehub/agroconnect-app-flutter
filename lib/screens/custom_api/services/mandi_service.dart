import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchMarketPrices({
  required String state,
  required String district,
  required String arrivalDate,
  int offset = 0,
  int limit = 100,
}) async {
  print("Function Called");
  final queryParams = {
    'api-key': '579b464db66ec23bdd00000165c1e2348cb744b75665146ffd6511ef',
    'format': 'json',
    'limit': '$limit',
    'offset': '$offset',
    'filters[State]': state,
    'filters[District]': district,
    'filters[Arrival_Date]': arrivalDate
  };

// Manually build the URI to preserve square brackets
  final uri = Uri.parse(
    'https://api.data.gov.in/resource/35985678-0d79-46b4-9ed6-6f13308a1d24?${queryParams.entries.map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}').join('&')}',
  );
  // final uri = Uri.https('api.data.gov.in', '/resource/35985678-0d79-46b4-9ed6-6f13308a1d24', {
  //   'api-key': '579b464db66ec23bdd00000165c1e2348cb744b75665146ffd6511ef',
  //   'format': 'json',
  //   'limit': '$limit',
  //   'offset': "$offset",
  //   'filters%5BState%5D': "Tamil%20Nadu",
  //   'filters%5BDistrict%5D': "Kallakuruchi",
  //   'filters%5BArrival_Date%5D': "24%2F05%2F2025",
  // });
  print("uri $uri");
  final response = await http.get(uri);
  print("Market Data ${response.body}");
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['records'] ?? []);
  } else {
    throw Exception('Failed to fetch data: ${response.statusCode}');
  }
}
