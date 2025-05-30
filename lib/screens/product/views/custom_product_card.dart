import 'dart:io';

import 'package:flutter/material.dart';

import '../../../constants.dart';

class CustomProductCard extends StatelessWidget {


  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final VoidCallback press;
  final bool isFilePath;

  final String? imageUrl;
  final bool isImage;
  final bool isVideo;
  final List<String> mediaList;
  final List<bool> isVideoList;
  final List<bool> isFilePathList;

  final String productTitle;
  final double pricePerUnit;
  final double totalPrice;
  final double? discountPrice;
  final int? discountPercent;
  final String sellerId;
  final String category;
  final String productName;
  final String description;
  final String unit;
  final double stock;
  final int remainingStock;
  final bool delivery;
  final bool isOrganic;
  final double rating;
  final int ratingCount;
  final bool auctionStatus;
  final bool isSoled;
  final bool isAuctionCompleted;
  final String productId;
  final List<dynamic> comments;
  final String? auctionStartTime;
  final String? auctionEndTime;
  final double? auctionStartAmount;
  final String productReleasedTime;
  final Map<String, dynamic> sellerData;
  final Map<String, dynamic> address;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> media;
  final String? productSoldTime;


  const CustomProductCard({
    super.key,
    required this.image,
    required this.productTitle,
    required this.sellerId,
    required this.category,
    required this.productName,
    required this.description,
    required this.unit,
    required this.stock,
    required this.remainingStock,
    required this.address,
    required this.media,
    required this.pricePerUnit,
    required this.totalPrice,
    required this.delivery,
    required this.isOrganic,
    required this.auctionStatus,
    this.auctionStartTime,
    this.auctionEndTime,
    required this.isSoled,
    required this.isAuctionCompleted,
    this.auctionStartAmount,
    required this.productReleasedTime,
    required this.productId,
    required this.sellerData,
    required this.comments,
    required this.rating,
    required this.ratingCount,
    required this.createdAt,
    required this.updatedAt,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    required this.press,
    required this.isFilePath,
    this.imageUrl,
    required this.isImage,
    required this.isVideo,
    required this.mediaList,
    required this.isVideoList,
    required this.isFilePathList,
    this.discountPrice,
    this.discountPercent,
    this.productSoldTime
  });



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
                  isFilePath
                      ? Image.file(
                    File(image),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                      : Image.network(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      );
                    },
                    errorBuilder:
                        (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
                  ),
                ),

                // NetworkImageWithLoader(image, radius: defaultBorderRadious),
                if (dicountpercent != null)
                  Positioned(
                    right: defaultPadding / 2,
                    top: defaultPadding / 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2,
                      ),
                      height: 16,
                      decoration: const BoxDecoration(
                        color: errorColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(defaultBorderRadious),
                        ),
                      ),
                      child: Text(
                        "$dicountpercent% off",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2,
                vertical: defaultPadding / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brandName.toUpperCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(fontSize: 12),
                  ),
                  const Spacer(),
                  priceAfetDiscount != null
                      ? Row(
                    children: [
                      Text(
                        "\$$priceAfetDiscount",
                        style: const TextStyle(
                          color: Color(0xFF31B0D8),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: defaultPadding / 4),
                      Text(
                        "\$$price",
                        style: TextStyle(
                          color:
                          Theme.of(context).textTheme.bodyMedium!.color,
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  )
                      : Text(
                    "\$$price",
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
