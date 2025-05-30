import 'package:flutter/material.dart';
import 'package:agroconnect/components/product/product_card.dart';
import 'package:agroconnect/route/route_constants.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../constants.dart';
import '../../controllers/products.dart';
import '../../models/regular_product_model.dart';

// class RegularProductListScreen extends StatefulWidget {
//   const RegularProductListScreen({super.key});
//
//   @override
//   State<RegularProductListScreen> createState() => _RegularProductListScreenState();
// }

// class _RegularProductListScreenState extends State<RegularProductListScreen> {
//
//   bool checkIsVideo(String url) {
//     final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
//     return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
//   }
//
//
//   Future<String> generateThumbnail(String media) async {
//     var imageUrl='https://via.placeholder.com/150';
//     final isVideo = checkIsVideo(media);
//
//     if (isVideo) {
//       final thumb = await VideoThumbnail.thumbnailFile(
//         video: media,
//         imageFormat: ImageFormat.JPEG,
//         maxHeight: 100,
//         quality: 75,
//       );
//       if (thumb != null) {
//         imageUrl ??= thumb; // Use only the first thumbnail
//       }
//     }
//     else{
//       imageUrl=media;
//     }
//     return imageUrl;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<BackendProduct>>(
//         future: fetchBackendProducts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           final products = snapshot.data ?? [];
//
//           return CustomScrollView(
//             slivers: [
//               SliverPadding(
//                 padding: const EdgeInsets.all(defaultPadding),
//                 sliver: SliverGrid(
//                   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                     maxCrossAxisExtent: 200.0,
//                     mainAxisSpacing: defaultPadding,
//                     crossAxisSpacing: defaultPadding,
//                     childAspectRatio: 0.66,
//                   ),
//                   delegate: SliverChildBuilderDelegate(
//                         (context, index) async {
//                       final product = products[index];
//                       return ProductCard(
//                         isFilePath: product.isFilePath,
//                         image: await generateThumbnail(product.imageUrl?? "https://via.placeholder.com/150") , // fallback
//                         brandName: product.brandName,
//                         title: product.productTitle,
//                         price: product.pricePerUnit,
//                         priceAfetDiscount: product.discountPrice, // use actual discounted value
//                         dicountpercent: product.discountPercent ?? 0,
//
//                         press: () {
//                           Navigator.pushNamed(
//                             context,
//                             productDetailsScreenRoute,
//                             arguments: product,  // Pass the product as an argument
//                           );
//                         },
//
//                       );
//
//                     } as NullableIndexedWidgetBuilder,
//                     childCount: products.length,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class RegularProductListScreen extends StatelessWidget {
//   const RegularProductListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<BackendProduct>>(
//         future: fetchBackendProducts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           final products = snapshot.data ?? [];
//
//           print("object======= $products[0].productCardThumbNail");
//
//           return CustomScrollView(
//             slivers: [
//               SliverPadding(
//                 padding: const EdgeInsets.all(defaultPadding),
//                 sliver: SliverGrid(
//                   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                     maxCrossAxisExtent: 200.0,
//                     mainAxisSpacing: defaultPadding,
//                     crossAxisSpacing: defaultPadding,
//                     childAspectRatio: 0.66,
//                   ),
//                   delegate: SliverChildBuilderDelegate((context, index) {
//                     final product = products[index];
//                     return ProductCard(
//                       productCardThumbNail: product.productCardThumbNail,
//                       isFilePath: product.isFilePath,
//                       image:
//                           product.imageUrl ?? "https://via.placeholder.com/150",
//                       // fallback
//                       brandName: product.brandName,
//                       title: product.productTitle,
//                       price: product.pricePerUnit,
//                       priceAfetDiscount: product.discountPrice,
//                       // use actual discounted value
//                       dicountpercent: product.discountPercent ?? 0,
//
//                       press: () {
//                         Navigator.pushNamed(
//                           context,
//                           productDetailsScreenRoute,
//                           arguments: product, // Pass the product as an argument
//                         );
//                       },
//                     );
//                   }, childCount: products.length),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }


class RegularProductListScreen extends StatefulWidget {
  const RegularProductListScreen({super.key});

  @override
  State<RegularProductListScreen> createState() => _RegularProductListScreenState();
}

class _RegularProductListScreenState extends State<RegularProductListScreen> {
  late Future<List<BackendProduct>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();

    // Optional: auto-refresh every 60 seconds
    Future.delayed(const Duration(seconds: 60), () {
      if (!mounted) return; // <--- Prevents the error
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
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: _refreshProducts, // 👈 Swipe down to refresh
        child: FutureBuilder<List<BackendProduct>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(
                color: Colors.green,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final products = snapshot.data ?? [];

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // 👈 Ensure pull even if not scrollable
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: defaultPadding,
                      crossAxisSpacing: defaultPadding,
                      childAspectRatio: 0.80,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final product = products[index];
                        return ProductCard(
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
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
