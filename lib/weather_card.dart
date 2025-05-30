import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting sunrise/sunset times



class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final main = weatherData['main'];
    final weather = weatherData['weather'][0];
    final wind = weatherData['wind'];
    final sys = weatherData['sys'];

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📍 ${weatherData['name']}, ${sys['country']}", style: Theme.of(context).textTheme.titleLarge),
            Text("🌡️ ${main['temp']}°C — ${weather['description']}", style: const TextStyle(fontSize: 16)),
            Text("💧 Humidity: ${main['humidity']}%"),
            Text("🌬 Wind: ${wind['speed']} m/s"),
          ],
        ),
      ),
    );
  }
}


// class WeatherCard extends StatelessWidget {
//   final Map<String, dynamic> weatherData;
//
//   const WeatherCard({required this.weatherData, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final main = weatherData['main'];
//     final weather = weatherData['weather'][0];
//     final wind = weatherData['wind'];
//     final sys = weatherData['sys'];
//
//     // Convert Unix timestamp to readable time
//     String formatTime(int timestamp) {
//       final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
//       return DateFormat.jm().format(time); // e.g., 6:45 AM
//     }
//
//     return Card(
//       margin: const EdgeInsets.all(16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "📍 ${weatherData['name']}, ${sys['country']}",
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Image.network(
//                   "https://openweathermap.org/img/wn/${weather['icon']}@2x.png",
//                   scale: 1.5,
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   "${main['temp'].toStringAsFixed(1)}°C",
//                   style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             Text(
//               "🌤️ ${weather['description']}",
//               style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("💧 Humidity: ${main['humidity']}%"),
//                 Text("🌬 Wind: ${wind['speed']} m/s"),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("🌅 Sunrise: ${formatTime(sys['sunrise'])}"),
//                 Text("🌇 Sunset: ${formatTime(sys['sunset'])}"),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
