import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    super.key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    required this.press,
    required this.isFilePath,
    required this.productCardThumbNail
  });

  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final VoidCallback press;
  final bool isFilePath;
  // final String media;
  var imageUrl = 'https://via.placeholder.com/150';
 final productCardThumbNail;


  // Future<void> init() async {
  //   await generateThumbnail(media);
  // }
  //
  // bool checkIsVideo(String url) {
  //   final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
  //   return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  // }
  //
  // Future<String> generateThumbnail(String media) async {
  //   final isVideo = checkIsVideo(media);
  //
  //   if (isVideo) {
  //     final thumb = await VideoThumbnail.thumbnailFile(
  //       video: media,
  //       imageFormat: ImageFormat.JPEG,
  //       maxHeight: 100,
  //       quality: 75,
  //     );
  //     if (thumb != null) {
  //       imageUrl ??= thumb; // Use only the first thumbnail
  //     }
  //   } else {
  //     imageUrl = media;
  //   }
  //   return imageUrl;
  // }


  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(140, 220),
        maximumSize: const Size(140, 220),
        padding: const EdgeInsets.all(8),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                  child:
                  productCardThumbNail != null && Uri.tryParse(productCardThumbNail)?.isAbsolute == false
                      ? Image.file(
                    File(productCardThumbNail),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                      : Image.network(
                    productCardThumbNail ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator(strokeWidth: 1.5));
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  )

                ),

                // NetworkImageWithLoader(image, radius: defaultBorderRadious),
                // if (dicountpercent != null)
                //   Positioned(
                //     right: defaultPadding / 2,
                //     top: defaultPadding / 2,
                //     child: Container(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: defaultPadding / 2,
                //       ),
                //       height: 16,
                //       decoration: const BoxDecoration(
                //         color: errorColor,
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(defaultBorderRadious),
                //         ),
                //       ),
                //       // child: Text(
                //       //   "$dicountpercent% off",
                //       //   style: const TextStyle(
                //       //     color: Colors.white,
                //       //     fontSize: 10,
                //       //     fontWeight: FontWeight.w500,
                //       //   ),
                //       // ),
                //     ),
                //   ),
              ],
            ),
          ),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: defaultPadding / 2,
          //       vertical: defaultPadding ,
          //     ),
          //     child: SingleChildScrollView(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         mainAxisAlignment: MainAxisAlignment.start, // Helps distribute space
          //
          //         children: [
          //           Text(
          //             brandName.toUpperCase(),
          //             style: Theme.of(
          //               context,
          //             ).textTheme.bodyMedium!.copyWith(fontSize: 10),
          //           ),
          //           const SizedBox(height: defaultPadding / 2),
          //           Text(
          //             title,
          //             maxLines: 2,
          //             overflow: TextOverflow.ellipsis,
          //             style: Theme.of(
          //               context,
          //             ).textTheme.titleSmall!.copyWith(fontSize: 12),
          //           ),
          //       SizedBox(height: 20,),
          //           // const Spacer(),
          //           priceAfetDiscount != null
          //               ? Row(
          //                 children: [
          //                   Text(
          //                     "\₹$priceAfetDiscount",
          //                     style: const TextStyle(
          //                       color: Color(0xFF31B0D8),
          //                       fontWeight: FontWeight.w500,
          //                       fontSize: 12,
          //                     ),
          //                   ),
          //                   const SizedBox(width: defaultPadding / 4),
          //                   Text(
          //                     "\₹$price",
          //                     style: TextStyle(
          //                       color:
          //                           Theme.of(context).textTheme.bodyMedium!.color,
          //                       fontSize: 10,
          //                       decoration: TextDecoration.lineThrough,
          //                     ),
          //                   ),
          //                 ],
          //               )
          //               : Text(
          //                 "₹$price",
          //                 style: const TextStyle(
          //                   color: Color(0xFF31B0D8),
          //                   fontWeight: FontWeight.w500,
          //                   fontSize: 12,
          //                 ),
          //               ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2,
                vertical: defaultPadding / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    brandName.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 12),
                  ),
                  // const Spacer(),
                  // priceAfetDiscount != null
                  //     ? Row(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     Text(
                  //       "₹$priceAfetDiscount",
                  //       style: const TextStyle(
                  //         color: Color(0xFF31B0D8),
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 12,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 6),
                  //     Text(
                  //       "₹$price",
                  //       style: TextStyle(
                  //         color: Theme.of(context).textTheme.bodyMedium!.color,
                  //         fontSize: 10,
                  //         decoration: TextDecoration.lineThrough,
                  //       ),
                  //     ),
                  //   ],
                  // )
                  //     :
              Text(
                    "₹$price",
                    style: const TextStyle(
                      color: Color(0xFF31B0D8),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}


// ClipRRect(
// borderRadius: BorderRadius.circular(defaultBorderRadious),
// child:
// isFilePath
// ? Image.file(
// File(productCardThumbNail),
// fit: BoxFit.cover,
// width: double.infinity,
// height: double.infinity,
// )
//     :
// Image.network(
// productCardThumbNail,
// fit: BoxFit.cover,
// width: double.infinity,
// height: double.infinity,
// loadingBuilder: (context, child, loadingProgress) {
// if (loadingProgress == null) return child;
// return Center(
// child: CircularProgressIndicator(
// strokeWidth: 1.5,
// ),
// );
// },
// errorBuilder:
// (context, error, stackTrace) =>
// const Icon(Icons.broken_image),
// ),
// ),
