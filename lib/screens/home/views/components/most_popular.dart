import 'package:flutter/material.dart';
import 'package:agroconnect/components/product/secondary_product_card.dart';
import 'package:agroconnect/models/product_model.dart';

import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';
import '../../../../controllers/products.dart';
import '../../../../models/regular_product_model.dart';
import '../../../../route/route_constants.dart';

// class MostPopular extends StatelessWidget {
//   const MostPopular({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: defaultPadding / 2),
//         Padding(
//           padding: const EdgeInsets.all(defaultPadding),
//           child: Text(
//             "Most popular",
//             style: Theme.of(context).textTheme.titleSmall,
//           ),
//         ),
//         // While loading use 👇
//         // SeconderyProductsSkelton(),
//         SizedBox(
//           height: 114,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             // Find demoPopularProducts on models/ProductModel.dart
//             itemCount: demoPopularProducts.length,
//             itemBuilder: (context, index) => Padding(
//               padding: EdgeInsets.only(
//                 left: defaultPadding,
//                 right: index == demoPopularProducts.length - 1
//                     ? defaultPadding
//                     : 0,
//               ),
//               child: SecondaryProductCard(
//                 image: demoPopularProducts[index].image,
//                 brandName: demoPopularProducts[index].brandName,
//                 title: demoPopularProducts[index].title,
//                 price: demoPopularProducts[index].price,
//                 priceAfetDiscount: demoPopularProducts[index].priceAfetDiscount,
//                 dicountpercent: demoPopularProducts[index].dicountpercent,
//                 press: () {
//                   Navigator.pushNamed(context, productDetailsScreenRoute,
//                       arguments: index.isEven);
//                 },
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:agroconnect/components/product/product_card.dart';
// import 'package:agroconnect/route/route_constants.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import '../../../constants.dart';
// import '../../controllers/products.dart';
// import '../../models/regular_product_model.dart';





// class MostPopular extends StatefulWidget {
//   const MostPopular({super.key});
//
//   @override
//   State<MostPopular> createState() => _MostPopularState();
// }
//
// class _MostPopularState extends State<MostPopular> {
//   late Future<List<BackendProduct>> _productsFuture;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//
//     // Optional: auto-refresh every 60 seconds
//     Future.delayed(const Duration(seconds: 60), () {
//       if (!mounted) return; // <--- Prevents the error
//       _refreshProducts();
//     });
//   }
//
//   void _loadProducts() {
//     _productsFuture = fetchBackendProducts();
//   }
//
//   Future<void> _refreshProducts() async {
//     setState(() {
//       _loadProducts();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: defaultPadding / 2),
//         Padding(
//           padding: const EdgeInsets.all(defaultPadding),
//           child: Text(
//             "Most popular",
//             style: Theme.of(context).textTheme.titleSmall,
//           ),
//         ),
//         // While loading use 👇
//         // SeconderyProductsSkelton(),
//         SizedBox(
//           height: 114,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             // Find demoPopularProducts on models/ProductModel.dart
//             itemCount: products.length,
//             itemBuilder: (context, index) => Padding(
//               padding: EdgeInsets.only(
//                 left: defaultPadding,
//                 right: index == products.length - 1
//                     ? defaultPadding
//                     : 0,
//               ),
//               // child: ProductCard(
//               //   productCardThumbNail: product.productCardThumbNail,
//               //   isFilePath: product.isFilePath,
//               //   image: product.imageUrl ?? "https://via.placeholder.com/150",
//               //   brandName: product.brandName,
//               //   title: product.productTitle,
//               //   price: product.pricePerUnit,
//               //   priceAfetDiscount: product.discountPrice,
//               //   dicountpercent: product.discountPercent ?? 0,
//               //   press: () {
//               //     Navigator.pushNamed(
//               //       context,
//               //       productDetailsScreenRoute,
//               //       arguments: product,
//               //     );
//               //   },
//               // ),
//               child: SecondaryProductCard(
//                 image: products[index].image,
//                 brandName: demoPopularProducts[index].brandName,
//                 title: demoPopularProducts[index].title,
//                 price: demoPopularProducts[index].price,
//                 priceAfetDiscount: demoPopularProducts[index].priceAfetDiscount,
//                 dicountpercent: demoPopularProducts[index].dicountpercent,
//                 press: () {
//                   Navigator.pushNamed(context, productDetailsScreenRoute,
//                       arguments: index.isEven);
//                 },
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }


// class MostPopular extends StatefulWidget {
//   const MostPopular({super.key});
//
//   @override
//   State<MostPopular> createState() => _MostPopularState();
// }

// class _MostPopularState extends State<MostPopular> {
//   late Future<List<BackendProduct>> _productsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//
//     // Optional: auto-refresh every 60 seconds
//     Future.delayed(const Duration(seconds: 60), () {
//       if (!mounted) return; // <--- Prevents the error
//       _refreshProducts();
//     });
//   }
//
//   void _loadProducts() {
//     _productsFuture = fetchBackendProducts();
//   }
//
//   Future<void> _refreshProducts() async {
//     setState(() {
//       _loadProducts();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         color: Colors.green,
//         onRefresh: _refreshProducts, // 👈 Swipe down to refresh
//         child: FutureBuilder<List<BackendProduct>>(
//           future: _productsFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator(
//                 color: Colors.green,
//               ));
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//
//             final products = snapshot.data ?? [];
//
//             return CustomScrollView(
//               physics: const AlwaysScrollableScrollPhysics(), // 👈 Ensure pull even if not scrollable
//               slivers: [
//                 SliverPadding(
//                   padding: const EdgeInsets.all(defaultPadding),
//                   sliver: SliverGrid(
//                     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                       maxCrossAxisExtent: 200.0,
//                       mainAxisSpacing: defaultPadding,
//                       crossAxisSpacing: defaultPadding,
//                       childAspectRatio: 0.66,
//                     ),
//                     delegate: SliverChildBuilderDelegate(
//                           (context, index) {
//                         final product = products[index];
//                         return ProductCard(
//                           productCardThumbNail: product.productCardThumbNail,
//                           isFilePath: product.isFilePath,
//                           image: product.imageUrl ?? "https://via.placeholder.com/150",
//                           brandName: product.brandName,
//                           title: product.productTitle,
//                           price: product.pricePerUnit,
//                           priceAfetDiscount: product.discountPrice,
//                           dicountpercent: product.discountPercent ?? 0,
//                           press: () {
//                             Navigator.pushNamed(
//                               context,
//                               productDetailsScreenRoute,
//                               arguments: product,
//                             );
//                           },
//                         );
//                       },
//                       childCount: products.length,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



class MostPopular extends StatefulWidget {
  const MostPopular({super.key});

  @override
  State<MostPopular> createState() => _MostPopularState();
}

class _MostPopularState extends State<MostPopular> {
  late Future<List<BackendProduct>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();

    // Optional: auto-refresh every 60 seconds
    Future.delayed(const Duration(seconds: 60), () {
      if (!mounted) return;
      _refreshProducts();
    });
  }

  void _loadProducts() {
    _productsFuture = fetchBackendProducts(); // your API function
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BackendProduct>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.green));
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading products: ${snapshot.error}"));
        }

        final products = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: defaultPadding / 2),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                "Most popular",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SizedBox(
              height: 190, // Adjusted for card height
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: index == products.length - 1 ? defaultPadding : 0,
                    ),
                    child:  ProductCard(
                      productCardThumbNail: product.productCardThumbNail,
                      isFilePath: product.isFilePath,
                      image: product.imageUrl ?? "https://via.placeholder.com/150",
                      brandName: product.brandName,
                      title: product.productTitle,
                      price: product.pricePerUnit,
                      priceAfetDiscount: product.discountPrice,
                      dicountpercent: product.discountPercent ?? 0,
                      press: () {
                        Navigator.pushNamed(
                          context,
                          productDetailsScreenRoute,
                          arguments: product,
                        );
                      },
                    ),
                    // child: SecondaryProductCard(
                    //   image: product.imageUrl ?? "https://via.placeholder.com/150",
                    //   brandName: product.brandName,
                    //   title: product.productTitle,
                    //   price: product.pricePerUnit,
                    //   priceAfetDiscount: product.discountPrice,
                    //   dicountpercent: product.discountPercent ?? 0,
                    //   press: () {
                    //     Navigator.pushNamed(
                    //       context,
                    //       productDetailsScreenRoute,
                    //       arguments: product,
                    //     );
                    //   },
                    // ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
