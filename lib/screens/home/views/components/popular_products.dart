import 'package:flutter/material.dart';
import 'package:agroconnect/components/product/product_card.dart';
import 'package:agroconnect/models/product_model.dart';
import 'package:agroconnect/route/screen_export.dart';

import '../../../../constants.dart';
import '../../../../controllers/products.dart';
import '../../../../models/regular_product_model.dart';
// class PopularProducts extends StatefulWidget {
//   const PopularProducts({super.key});
//
//   @override
//   State<PopularProducts> createState() => _PopularProductsState();
// }



// class _PopularProductsState extends State<PopularProducts> {
//   late Future<List<BackendProduct>> _productsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//
//     // Optional: auto-refresh every 60 seconds
//     Future.delayed(const Duration(seconds: 60), () {
//       if (!mounted) return;
//       _refreshProducts();
//     });
//   }
//
//   void _loadProducts() {
//     _productsFuture = fetchBackendProducts(); // your API function
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
//     return const Placeholder();
//   }
// }

// class PopularProducts extends StatelessWidget {
//   const PopularProducts({
//     super.key,
//   });
//   late Future<List<BackendProduct>> _productsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//
//     // Optional: auto-refresh every 60 seconds
//     Future.delayed(const Duration(seconds: 60), () {
//       if (!mounted) return;
//       _refreshProducts();
//     });
//   }
//
//   void _loadProducts() {
//     _productsFuture = fetchBackendProducts(); // your API function
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
//     return FutureBuilder<List<BackendProduct>>(
//         future: _productsFuture,
//         builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(child: CircularProgressIndicator(color: Colors.green));
//       } else if (snapshot.hasError) {
//         return Center(child: Text("Error loading products: ${snapshot.error}"));
//       }
//
//       final products = snapshot.data ?? [];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: defaultPadding / 2),
//         Padding(
//           padding: const EdgeInsets.all(defaultPadding),
//           child: Text(
//             "Popular products",
//             style: Theme.of(context).textTheme.titleSmall,
//           ),
//         ),
//         // While loading use 👇
//         // const ProductsSkelton(),
//         SizedBox(
//           height: 220,
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
//               // child: ProductCard(
//               //   productCardThumbNail:"https://via.placeholder.com/150",
//               //   isFilePath: false,
//               //   image: demoPopularProducts[index].image,
//               //   brandName: demoPopularProducts[index].brandName,
//               //   title: demoPopularProducts[index].title,
//               //   price: demoPopularProducts[index].price,
//               //   priceAfetDiscount: demoPopularProducts[index].priceAfetDiscount,
//               //   dicountpercent: demoPopularProducts[index].dicountpercent,
//               //   press: () {
//               //     Navigator.pushNamed(context, productDetailsScreenRoute,
//               //         arguments: index.isEven);
//               //   },
//               // ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }


class PopularProducts extends StatefulWidget {
  const PopularProducts({super.key});

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  late Future<List<BackendProduct>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();

    // Optional auto-refresh every 60s
    Future.delayed(const Duration(seconds: 60), () {
      if (!mounted) return;
      _refreshProducts();
    });
  }

  void _loadProducts() {
    _productsFuture = fetchBackendProducts();
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
                "Popular products",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SizedBox(
              height: 190,
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
                    child: ProductCard(
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
