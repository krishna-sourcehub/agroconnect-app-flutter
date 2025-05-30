import 'dart:convert';

import 'package:agroconnect/screens/home/views/components/auction_product.dart';
import 'package:flutter/material.dart';
import 'package:agroconnect/components/Banner/S/banner_s_style_1.dart';
import 'package:agroconnect/components/Banner/S/banner_s_style_5.dart';
import 'package:agroconnect/constants.dart';
import 'package:agroconnect/route/screen_export.dart';

import '../../../utils/Notification.dart';
import '../../../weather_card.dart';
import 'components/best_sellers.dart';
import 'components/flash_sale.dart';
import 'components/most_popular.dart';
import 'components/offer_carousel_and_categories.dart';
import 'components/popular_products.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<Map<String, dynamic>?> getWeatherData() async {
    print("🔍 Entered getWeatherData()");

    final uri = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?lat=11.6643&lon=78.1460&appid=$weatherAPIKey&units=metric",
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Weather Data: $data");
        return data;
      } else {
        print("❌ Server error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Network error: $e");
      return null;
    }
  }




  @override
  void initState() {
    super.initState();
    NotificationService().init();
    _loadWeather(); // ✅ call async logic here
  }

  void _loadWeather() async {
    await getWeatherData(); // async method safely called
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverToBoxAdapter(
            //   child: FutureBuilder<Map<String, dynamic>?>(
            //     future: getWeatherData(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const Padding(
            //           padding: EdgeInsets.all(16),
            //           child: Center(child: CircularProgressIndicator()),
            //         );
            //       } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            //         return const Padding(
            //           padding: EdgeInsets.all(16),
            //           child: Text("Error loading weather"),
            //         );
            //       } else {
            //         return WeatherCard(weatherData: snapshot.data!);
            //       }
            //     },
            //   ),
            // ),
            const SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            const SliverToBoxAdapter(child: PopularProducts()),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
              sliver: SliverToBoxAdapter(child: FlashSale()),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // While loading use 👇
                  // const BannerMSkelton(),‚
                  BannerSStyle1(
                    title: "New \narrival",
                    subtitle: "SEASONAL SALE",
                    discountParcent: 50,
                    press: () {
                      // Navigator.pushNamed(context, onSaleScreenRoute);
                    },
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  // We have 4 banner styles, all in the pro version
                ],
              ),
            ),
            const SliverToBoxAdapter(child: BestSellers()),
             SliverToBoxAdapter(child: MostPopular()),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding * 1.5),

                  const SizedBox(height: defaultPadding / 4),
                  // While loading use 👇
                  // const BannerSSkelton(),
                  BannerSStyle5(
                    // title: "Black \nfriday",
                    title: "Ready For Sale",
                    subtitle: "Special Diary Products",
                    // bottomText: "Collection".toUpperCase(),
                    press: () {
                      // Navigator.pushNamed(context, onSaleScreenRoute);
                    },
                  ),
                  const SizedBox(height: defaultPadding / 4),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: AuctionProductHome()),
          ],
        ),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             const SliverToBoxAdapter(child: OffersCarouselAndCategories()),
//             const SliverToBoxAdapter(child: PopularProducts()),
//             const SliverPadding(
//               padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
//               sliver: SliverToBoxAdapter(child: FlashSale()),
//             ),
//             SliverToBoxAdapter(
//               child: Column(
//                 children: [
//                   // While loading use 👇
//                   // const BannerMSkelton(),‚
//                   BannerSStyle1(
//                     title: "New \narrival",
//                     subtitle: "SPECIAL OFFER",
//                     discountParcent: 50,
//                     press: () {
//                       Navigator.pushNamed(context, onSaleScreenRoute);
//                     },
//                   ),
//                   const SizedBox(height: defaultPadding / 4),
//                   // We have 4 banner styles, all in the pro version
//                 ],
//               ),
//             ),
//             const SliverToBoxAdapter(child: BestSellers()),
//             const SliverToBoxAdapter(child: MostPopular()),
//             SliverToBoxAdapter(
//               child: Column(
//                 children: [
//                   const SizedBox(height: defaultPadding * 1.5),
//
//                   const SizedBox(height: defaultPadding / 4),
//                   // While loading use 👇
//                   // const BannerSSkelton(),
//                   BannerSStyle5(
//                     title: "Black \nfriday",
//                     subtitle: "50% Off",
//                     bottomText: "Collection".toUpperCase(),
//                     press: () {
//                       Navigator.pushNamed(context, onSaleScreenRoute);
//                     },
//                   ),
//                   const SizedBox(height: defaultPadding / 4),
//                 ],
//               ),
//             ),
//             const SliverToBoxAdapter(child: BestSellers()),
//           ],
//         ),
//       ),
//     );
//   }
// }
