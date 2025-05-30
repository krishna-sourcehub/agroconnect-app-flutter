import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agroconnect/components/cart_button.dart';
import 'package:agroconnect/constants.dart';
import 'package:agroconnect/models/regular_product_model.dart';
import 'package:agroconnect/utils/dependcies.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

// class ProductBuyNowScreen extends StatefulWidget {
//   const ProductBuyNowScreen({required this.product, super.key});
//   final BackendProduct product;
//
//   @override
//   State<ProductBuyNowScreen> createState() => _ProductBuyNowScreenState();
// }
//
// class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
//   int _quantity = 1;
//   late double _unitPrice;
//   int _remainingStock = 20;
//   final TextEditingController _quantityController = TextEditingController();
//
//   VideoPlayerController? _videoController;
//   bool _isVideo = false;
//   bool _isMuted = false;
//   bool _isLoading = true;
//
//   String? imageUrl;
//
//   @override
//   void initState() {
//     super.initState();
//     _unitPrice = widget.product.totalPrice;
//     _remainingStock = int.tryParse(widget.product.remainingStock.toString()) ?? 20;
//     _quantityController.text = _quantity.toString();
//     _initializeMedia();
//   }
//
//   bool checkIsVideo(String url) {
//     return ['.mp4', '.mov', '.avi', '.mkv', '.webm'].any((ext) => url.toLowerCase().endsWith(ext));
//   }
//
//   Future<void> _initializeMedia() async {
//     final mediaUrl = widget.product.mediaList.first;
//     _isVideo = checkIsVideo(mediaUrl);
//
//     if (_isVideo) {
//       _videoController = VideoPlayerController.network(mediaUrl);
//       await _videoController!.initialize();
//       _videoController!.setLooping(true);
//       _videoController!.play();
//       setState(() => _isLoading = false);
//     } else {
//       imageUrl = mediaUrl;
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<Map<String, dynamic>> submitOrder() async {
//     try {
//       final tokenStatus = await UserDependencies().getSessionToken();
//       if (tokenStatus['status'] != true) return {'status': false, 'reason': 'sessionExpired'};
//
//       final response = await http.post(
//         Uri.parse("$backendURL/product/order/addOrder"),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${tokenStatus['sessionToken']}',
//         },
//         body: jsonEncode({
//           "productId": widget.product.productId,
//           "unit": widget.product.unit,
//           "orderedStock": _quantity,
//           "address": {
//             "doorOrShopNo": "1",
//             "street": "true",
//             "city": "chennai",
//             "taluk": "chennai",
//             "district": "chennai",
//             "state": "Tamil Nadu",
//             "postalCode": 600001,
//             "country": "india",
//           },
//         }),
//       );
//
//       final responseData = jsonDecode(response.body);
//       if (response.statusCode == 200) return {'status': true};
//
//       final reason = responseData['reason'];
//       return {
//         'status': false,
//         'message': reason == "insufficientStock"
//             ? "Out of stock"
//             : reason == "notOrderedProduct"
//             ? "Not available ordered product"
//             : "Server error"
//       };
//     } catch (e) {
//       return {'status': false, 'message': 'Network error. Please try again.'};
//     }
//   }
//
//   void _toggleMute() {
//     setState(() {
//       _isMuted = !_isMuted;
//       _videoController?.setVolume(_isMuted ? 0 : 1);
//     });
//   }
//
//   void _togglePlayPause() {
//     setState(() {
//       if (_videoController!.value.isPlaying) {
//         _videoController!.pause();
//       } else {
//         _videoController!.play();
//       }
//     });
//   }
//
//   void _goFullScreen() {
//     if (_videoController != null) {
//       Navigator.push(context, MaterialPageRoute(
//         builder: (_) => FullScreenVideoPlayer(controller: _videoController!),
//       ));
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }
//
//   double get _totalPrice => _quantity * _unitPrice;
//
//   @override
//   Widget build(BuildContext context) {
//     final product = widget.product;
//
//     return Scaffold(
//       bottomNavigationBar: CartButton(
//         price: _totalPrice,
//         title: "Add to cart",
//         subTitle: "Total price",
//         press: () {
//   submitOrder();
//         },
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(defaultPadding),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const BackButton(),
//                 Text(product.productName, style: Theme.of(context).textTheme.titleSmall),
//                 IconButton(
//                   onPressed: () {},
//                   icon: SvgPicture.asset("assets/icons/Bookmark.svg"),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: CustomScrollView(
//               slivers: [
//                 SliverToBoxAdapter(
//                   child: _isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
//                     child: AspectRatio(
//                       aspectRatio: _isVideo
//                           ? (_videoController?.value.aspectRatio ?? 16 / 9)
//                           : 1.05,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           _isVideo
//                               ? VideoPlayer(_videoController!)
//                               : Image.network(imageUrl!, fit: BoxFit.cover),
//                           if (_isVideo)
//                             Positioned(
//                               bottom: 10,
//                               left: 10,
//                               right: 10,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(
//                                       _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                                       color: Colors.white,
//                                     ),
//                                     onPressed: _togglePlayPause,
//                                   ),
//                                   IconButton(
//                                     icon: Icon(
//                                       _isMuted ? Icons.volume_off : Icons.volume_up,
//                                       color: Colors.white,
//                                     ),
//                                     onPressed: _toggleMute,
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.fullscreen, color: Colors.white),
//                                     onPressed: _goFullScreen,
//                                   ),
//                                 ],
//                               ),
//                             )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Additional UI: price, quantity, etc.
//               ],
//             ),
//           ),
//
//
//         ],
//       ),
//     );
//   }
// }
//
// // Fullscreen video player page
// class FullScreenVideoPlayer extends StatefulWidget {
//   final VideoPlayerController controller;
//
//   const FullScreenVideoPlayer({required this.controller, super.key});
//
//   @override
//   State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
// }
//
// class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
//   bool _isMuted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _isMuted = widget.controller.value.volume == 0;
//   }
//
//   void _togglePlayPause() {
//     setState(() {
//       widget.controller.value.isPlaying
//           ? widget.controller.pause()
//           : widget.controller.play();
//     });
//   }
//
//   void _toggleMute() {
//     setState(() {
//       _isMuted = !_isMuted;
//       widget.controller.setVolume(_isMuted ? 0 : 1);
//     });
//   }
//
//   void _exitFullScreen() {
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           Center(
//             child: AspectRatio(
//               aspectRatio: widget.controller.value.aspectRatio,
//               child: VideoPlayer(widget.controller),
//             ),
//           ),
//           Container(
//             color: Colors.black45,
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                   onPressed: _togglePlayPause,
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     _isMuted ? Icons.volume_off : Icons.volume_up,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                   onPressed: _toggleMute,
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.fullscreen_exit, color: Colors.white, size: 30),
//                   onPressed: _exitFullScreen,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'dart:convert';
import 'dart:io';

import 'package:agroconnect/models/regular_product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agroconnect/components/cart_button.dart';
import 'package:agroconnect/components/custom_modal_bottom_sheet.dart';
import 'package:agroconnect/components/network_image_with_loader.dart';
import 'package:agroconnect/screens/product/views/added_to_cart_message_screen.dart';
import 'package:agroconnect/screens/product/views/components/product_list_tile.dart';
import 'package:agroconnect/screens/product/views/location_permission_store_availability_screen.dart';
import 'package:agroconnect/screens/product/views/size_guide_screen.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../constants.dart';
import '../../../utils/dependcies.dart';
import 'components/product_quantity.dart';
import 'components/selected_colors.dart';
import 'components/selected_size.dart';
import 'components/unit_price.dart';

class ProductBuyNowScreen extends StatefulWidget {
  const ProductBuyNowScreen({required this.product, super.key});

  final BackendProduct product;

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  int _remainingStock = 20; // default fallback if parsing fails

  Future<Map<String, dynamic>> submitOrder() async {
    try {
      String? sessionToken;
      final tokenStatus = await UserDependencies().getSessionToken();

      if (tokenStatus['status'] == true) {
        sessionToken = tokenStatus['sessionToken'];
      } else {
        return {'status': false, "reason": "sessionExpired"};
      }

      final response = await http.post(
        Uri.parse("$backendURL/product/order/addOrder"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sessionToken',
        },
        body: jsonEncode({
          "productId": widget.product.productId,
          "unit": widget.product.unit,
          "orderedStock": _quantity,
          "address": {
            "doorOrShopNo": "1",
            "street": "true",
            "city": "chennai",
            "taluk": "chennai",
            "district": "chennai",
            "state": "Tamil Nadu",
            "postalCode": 600001,
            "country": "india",
          },
        }),
      );

      final responseData = jsonDecode(response.body);

      // print("phone $phoneNumber");

      print("responseData $responseData");

      if (response.statusCode == 200) {
        print("Ordered successfully");
        return {'status': true};
      } else {
        if (responseData['reason'] == "insufficientStock") {
          print("Out of stock");
          return {'status': false, 'message': "Out of stock"};
        }

        if (responseData['reason'] == "notOrderedProduct") {
          print("not available ordered product");
          return {
            'status': false,
            'message': "not available ordered product",
          };
        }

        return {'status': false, 'message': 'server Error'};
      }
    } catch (e) {
      print('❌ Backend login error: $e');
      return {'status': false, 'message': 'Network error. Please try again.'};
    }
  }

  @override
  void initState() {
    super.initState();
    _unitPrice = widget.product.pricePerUnit;
    _quantityController.text = _quantity.toString();
    _remainingStock =
        int.tryParse(widget.product.remainingStock.toString()) ?? 20;

    _initMedia();
  }

  Future<void> _initMedia() async {
    final mediaUrl = widget.product.mediaList[0];
    isVideo = checkIsVideo(mediaUrl);

    if (isVideo) {
      _videoController = VideoPlayerController.network(mediaUrl);
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play(); // autoplay
      setState(() {
        _isLoading = false;
      });
    } else {
      imageUrl = mediaUrl;
      setState(() {
        _isLoading = false;
      });
    }
  }

  VideoPlayerController? _videoController;
  bool _isVideo = false;
  String? _thumbnailPath;
  int _quantity = 1;
  late double _unitPrice;

  double get _totalPrice => _quantity * _unitPrice;
  final TextEditingController _quantityController = TextEditingController();

  String? imageUrl;
  bool isVideo = false;
  bool _isLoading = true;

  Future<void> init() async {
    String mediaUrl = widget.product.mediaList.first;

    setState(() {
      _isVideo = checkIsVideo(mediaUrl);
    });

    if (_isVideo) {
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: mediaUrl,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 300,
        quality: 75,
      );

      if (thumbnail != null) {
        setState(() {
          _thumbnailPath = thumbnail;
        });
      }

      _videoController = VideoPlayerController.network(mediaUrl);
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play();

      setState(() {});
    } else {
      setState(() {
        imageUrl = mediaUrl;
      });
    }

    _unitPrice = widget.product.totalPrice;
    _quantityController.text = _quantity.toString();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  bool checkIsVideo(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
    return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  Future<void> generateThumbnail(String media) async {
    var imageUrl = 'https://via.placeholder.com/150';
    final isVideo = checkIsVideo(media);

    if (isVideo) {
      // isFileVideo=true;
      final thumb = await VideoThumbnail.thumbnailFile(
        video: media,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 100,
        quality: 75,
      );
      if (thumb != null) {
        imageUrl ??= thumb; // Use only the first thumbnail
      }
    } else {
      imageUrl = media;
    }
    imageUrl = media;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      // bottomNavigationBar: CartButton(
      //   price: 269.4,
      //   title: "Add to cart",
      //   subTitle: "Total price",
      //   press: () {
      //     customModalBottomSheet(
      //       context,
      //       isDismissible: false,
      //       child: const AddedToCartMessageScreen(),
      //     );
      //   },
      // ),
      bottomNavigationBar: CartButton(
        price: _totalPrice,
        title: "Place Order",
        subTitle: "Total price",
        press: () async {

          final orderStatus=await submitOrder();
          debugPrint("Orderstatus $orderStatus");
          // customModalBottomSheet(
          //   context,
          //   isDismissible: false,
          //   child: const AddedToCartMessageScreen(),
          // );
        },
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding / 2,
              vertical: defaultPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Text(
                  product.productName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Bookmark.svg",
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                    ),
                    child: AspectRatio(
                      aspectRatio:
                          isVideo
                              ? (_videoController?.value.aspectRatio ?? 16 / 9)
                              : 1.05,
                      child:
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : isVideo
                              ? VideoPlayer(_videoController!)
                              : Image.network(
                                imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) =>
                                        const Icon(Icons.broken_image),
                              ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: UnitPrice(
                            price: product.totalPrice,
                            // priceAfterDiscount: 134.7,
                          ),
                        ),





                        // ProductQuantity(
                        //   numOfItem: 2,
                        //   onIncrement: () {},
                        //   onDecrement: () {},
                        // ),
                      ],
                    ),
                  ),
                ),
                // const SliverToBoxAdapter(child: Divider()),

                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Product Description", style: TextStyle(color: Colors.lightGreen, fontSize: 20, fontWeight: FontWeight.w600),),
                        SizedBox(height: defaultPadding,),
                        Row(
                          spacing: 4,
                          children: [
                            Text("Per Unit Price:",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                            Text("${product.pricePerUnit}"),
                          ],
                        ),

                        Row(
                          spacing: 4,
                          children: [

                            Text("Total Unit Price: ",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                            Text("${product.totalPrice}"),


                          ],
                        ),

                        Row(
                          spacing: 4,
                          children: [
                            Text("Total Units: ",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                            Text("${product.stock}"),
                          ],
                        ),

                        Row(
                          spacing: 4,
                          children: [
                            Text("Remaining Units: ",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                            Text("${product.remainingStock}"),
                          ],
                        ),

                        SizedBox(height: 30,),



                        const Text(
                          "Quantity",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.lightGreen,),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Slider(
                                secondaryActiveColor: Colors.green,
                                activeColor: Colors.green,
                                thumbColor: Colors.green,
                                inactiveColor: Colors.grey,
                                value: _quantity.toDouble(),
                                min: 1,
                                max: _remainingStock.toDouble(),
                                divisions: _remainingStock - 1,
                                label: _quantity.toString(),
                                onChanged: (value) {
                                  setState(() {
                                    _quantity = value.toInt();
                                    _quantityController.text =
                                        _quantity.toString();
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                                onSubmitted: (value) {
                                  final input = int.tryParse(value);
                                  if (input != null &&
                                      input >= 1 &&
                                      input <= _remainingStock) {
                                    setState(() {
                                      _quantity = input;
                                    });
                                  } else {
                                    // Revert to current value if invalid
                                    _quantityController.text =
                                        _quantity.toString();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),

                // SliverToBoxAdapter(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Text(
                //         "Unit",
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //       Row(
                //         children: [
                //           Expanded(
                //             flex: 3,
                //             child: TextField(
                //               controller: _quantityController,
                //               keyboardType: TextInputType.number,
                //               textAlign: TextAlign.center,
                //               decoration: const InputDecoration(
                //                 border: OutlineInputBorder(),
                //                 isDense: true,
                //                 contentPadding: EdgeInsets.symmetric(
                //                   vertical: 10,
                //                 ),
                //               ),
                //               // onSubmitted: (value) {
                //               //   final input = int.tryParse(value);
                //               //   if (input != null && input >= 1 && input <= _remainingStock) {
                //               //     setState(() {
                //               //       _quantity = input;
                //               //     });
                //               //   } else {
                //               //     // Revert to current value if invalid
                //               //     _quantityController.text = _quantity.toString();
                //               //   }
                //               // },
                //             ),
                //           ),
                //
                //           Expanded(
                //             flex: 1,
                //             child: TextField(
                //               controller: _quantityController,
                //               keyboardType: TextInputType.number,
                //               textAlign: TextAlign.center,
                //               decoration: const InputDecoration(
                //                 border: OutlineInputBorder(),
                //                 isDense: true,
                //                 contentPadding: EdgeInsets.symmetric(
                //                   vertical: 10,
                //                 ),
                //               ),
                //               onSubmitted: (value) {
                //                 final input = int.tryParse(value);
                //                 if (input != null &&
                //                     input >= 1 &&
                //                     input <= _remainingStock) {
                //                   setState(() {
                //                     _quantity = input;
                //                   });
                //                 } else {
                //                   // Revert to current value if invalid
                //                   _quantityController.text =
                //                       _quantity.toString();
                //                 }
                //               },
                //             ),
                //           ),
                //         ],
                //       ),
                //
                //       Text("Unit, kg"),
                //       Text("address, kg"),
                //     ],
                //   ),
                // ),
                //
                // // SliverToBoxAdapter(
                // //   child: SelectedColors(
                // //     colors: const [
                // //       Color(0xFFEA6262),
                // //       Color(0xFFB1CC63),
                // //       Color(0xFFFFBF5F),
                // //       Color(0xFF9FE1DD),
                // //       Color(0xFFC482DB),
                // //     ],
                // //     selectedColorIndex: 2,
                // //     press: (value) {},
                // //   ),
                // // ),
                // // SliverToBoxAdapter(
                // //   child: SelectedSize(
                // //     sizes: const ["S", "M", "L", "XL", "XXL"],
                // //     selectedIndex: 1,
                // //     press: (value) {},
                // //   ),
                // // ),
                // // SliverPadding(
                // //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                // //   sliver: ProductListTile(
                // //     title: "Size guide",
                // //     svgSrc: "assets/icons/Sizeguid.svg",
                // //     isShowBottomBorder: true,
                // //     press: () {
                // //       customModalBottomSheet(
                // //         context,
                // //         height: MediaQuery.of(context).size.height * 0.9,
                // //         child: const SizeGuideScreen(),
                // //       );
                // //     },
                // //   ),
                // // ),
                // // SliverPadding(
                // //   padding: const EdgeInsets.symmetric(
                // //     horizontal: defaultPadding,
                // //   ),
                // //   sliver: SliverToBoxAdapter(
                // //     child: Column(
                // //       crossAxisAlignment: CrossAxisAlignment.start,
                // //       children: [
                // //         const SizedBox(height: defaultPadding / 2),
                // //         Text(
                // //           "Store pickup availability",
                // //           style: Theme.of(context).textTheme.titleSmall,
                // //         ),
                // //         const SizedBox(height: defaultPadding / 2),
                // //         const Text(
                // //           "Select a size to check store availability and In-Store pickup options.",
                // //         ),
                // //       ],
                // //     ),
                // //   ),
                // // ),
                // // SliverPadding(
                // //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                // //   sliver: ProductListTile(
                // //     title: "Check stores",
                // //     svgSrc: "assets/icons/Stores.svg",
                // //     isShowBottomBorder: true,
                // //     press: () {
                // //       customModalBottomSheet(
                // //         context,
                // //         height: MediaQuery.of(context).size.height * 0.92,
                // //         child: const LocationPermissonStoreAvailabilityScreen(),
                // //       );
                // //     },
                // //   ),
                // // ),
                // const SliverToBoxAdapter(
                //   child: SizedBox(height: defaultPadding),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
