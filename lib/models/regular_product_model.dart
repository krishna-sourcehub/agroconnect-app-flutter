import 'dart:core';
import 'package:video_thumbnail/video_thumbnail.dart';


class BackendProduct {
  final String? imageUrl;
  final bool isImage;
  final bool isVideo;
  final bool isFilePath;
  final List<String> mediaList;
  final List<bool> isVideoList;
  final List<bool> isFilePathList;

  final String productTitle;
  final double pricePerUnit;
  final double totalPrice;
  final String brandName;
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
  final bool isSold;
  final bool isAuctionCompleted;
  final String productId;
  final List<dynamic> comments;
  final String? auctionStartTime;
  final String? auctionEndTime;
  final double? auctionStartAmount;
  final String productReleasedTime;
  final String? productSoldTime;
  final Map<String, dynamic> sellerData;
  final Map<String, dynamic> address;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> media;

  final String ? productCardThumbNail;

  BackendProduct( {
    this.productSoldTime,
    required this.imageUrl,
    required this.isImage,
    required this.isVideo,
    required this.isFilePath,
    required this.pricePerUnit,
    required this.brandName,
    this.discountPrice,
    this.discountPercent,
    required this.mediaList,
    required this.isVideoList,
    required this.isFilePathList,
    required this.productTitle,
    required this.sellerId,
    required this.category,
    required this.productName,
    required this.description,
    required this.unit,
    required this.stock,
    required this.remainingStock,
    required this.address,
    required this.totalPrice,
    required this.delivery,
    required this.isOrganic,
    required this.auctionStatus,
    this.auctionStartTime,
    this.auctionEndTime,
    required this.isSold,
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
    required this.media,
    required this.productCardThumbNail
  });

  /// ✅ Async factory constructor for parsing JSON with async video thumbnail logic
  static Future<BackendProduct> fromJsonAsync(Map<String, dynamic> json) async {
    final mediaList = List<String>.from(json['media'] ?? []);
    List<bool> isVideoList = [];
    List<bool> isFilePathList = [];


    String? imageUrl;
    bool isFilePath = false;
    String? productCardThumbNail;

    final isVideo = checkIsVideo(mediaList[0]);
    final isImage = checkIsImage(mediaList[0]);


    if (isVideo) {
      final thumb = await VideoThumbnail.thumbnailFile(
        video: mediaList[0],
        imageFormat: ImageFormat.JPEG,
        maxHeight: 100,
        quality: 75,
      );
      if (thumb != null) {
        isFilePath = true;
        productCardThumbNail ??= thumb; // Use only the first thumbnail
      }
    } else {
      if (isImage && productCardThumbNail == null) {
        productCardThumbNail = mediaList[0];
      }
    }




    for (var media in mediaList) {
      final isVideo = checkIsVideo(media);
      final isImage = checkIsImage(media);

      if (isVideo) {
        final thumb = await VideoThumbnail.thumbnailFile(
          video: media,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 100,
          quality: 75,
        );
        if (thumb != null) {
          isFilePath = true;
          imageUrl ??= thumb; // Use only the first thumbnail
        }
        isVideoList.add(true);
        isFilePathList.add(true);
      } else {
        isVideoList.add(false);
        isFilePathList.add(false);
        if (isImage && imageUrl == null) {
          imageUrl = media;
        }
      }
    }

    double price = (json['pricePerUnit'] as num).toDouble();
    double? discounted = (json['totalPrice'] as num).toDouble();

    int? percent;
    if (discounted < price) {
      percent = ((1 - (discounted / price)) * 100).round();
    }

    return BackendProduct(
      productCardThumbNail:productCardThumbNail,
      imageUrl: imageUrl,
      isImage: _hasImage(mediaList),
      isVideo: _hasVideo(mediaList),
      isFilePath: isFilePath,
      pricePerUnit: price,
      totalPrice: discounted,
      brandName: json['sellerData']?['name'] ?? 'Unknown',
      discountPrice: discounted < price ? discounted : null,
      discountPercent: percent,
      mediaList: mediaList,
      isVideoList: isVideoList,
      isFilePathList: isFilePathList,
      productTitle: json['productTitle'] ?? '',
      sellerId: json['sellerId'] ?? '',
      category: json['category'] ?? '',
      productName: json['productName'] ?? '',
      description: json['description'] ?? '',
      unit: json['unit'] ?? '',
      stock: (json['stock'] as num).toDouble(),
      remainingStock: json['remainingStock'] ?? 0,
      address: Map<String, dynamic>.from(json['address'] ?? {}),
      delivery: json['delivery'] ?? false,
      isOrganic: json['isOrganic'] ?? false,
      auctionStatus: json['auctionStatus'] ?? false,
      auctionStartTime: json['auctionStartTime'],
      auctionEndTime: json['auctionEndTime'],
      isSold: json['isSold'] ?? false,
      isAuctionCompleted: json['isAuctionCompleted'] ?? false,
      auctionStartAmount: (json['auctionStartAmount'] as num?)?.toDouble(),
      productReleasedTime: json['productReleasedTime'] ?? '',
      productId: json['productId'] ?? '',
      sellerData: Map<String, dynamic>.from(json['sellerData'] ?? {}),
      comments: List<dynamic>.from(json['comments'] ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['ratingCount'] ?? 0,
      createdAt: json['createdAt'] ?? DateTime.now(),
      updatedAt: json['updatedAt'] ?? DateTime.now(),
      media: json['media'],
    );
  }

  /// ✅ File type checkers
  static bool checkIsImage(String url) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.gif'];
    return imageExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  static bool checkIsVideo(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
    return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  static bool _hasImage(List<String> mediaList) {
    return mediaList.any((media) => checkIsImage(media));
  }

  static bool _hasVideo(List<String> mediaList) {
    return mediaList.any((media) => checkIsVideo(media));
  }
}



// class BackendProduct {
//   final String? imageUrl;
//   final bool isImage;
//   final bool isVideo;
//   final bool isFilePath;
//   final List<String> mediaList;
//   final List<bool> isVideoList;
//   final List<bool> isFilePathList;
//
//   final String productTitle;
//   final double pricePerUnit;
//   final double totalPrice;
//   final String brandName;
//   final double? discountPrice;
//   final int? discountPercent;
//   final String sellerId;
//   final String category;
//   final String productName;
//   final String description;
//   final String unit;
//   final double stock;
//   final int remainingStock;
//   final bool delivery;
//   final bool isOrganic;
//   final double rating;
//   final int ratingCount;
//   final bool auctionStatus;
//   final bool isSold;
//   final bool isAuctionCompleted;
//   final String productId;
//   final List<dynamic> comments;
//   final String? auctionStartTime;
//   final String? auctionEndTime;
//   final double? auctionStartAmount;
//   final String productReleasedTime;
//   final String? productSoldTime;
//   final Map<String, dynamic> sellerData;
//   final Map<String, dynamic> address;
//   final String createdAt;
//   final String updatedAt;
//   final List<dynamic> media;
//
//   BackendProduct( {
//     this.productSoldTime,
//     required this.imageUrl,
//     required this.isImage,
//     required this.isVideo,
//     required this.isFilePath,
//     required this.pricePerUnit,
//     required this.brandName,
//     this.discountPrice,
//     this.discountPercent,
//     required this.mediaList,
//     required this.isVideoList,
//     required this.isFilePathList,
//     required this.productTitle,
//     required this.sellerId,
//     required this.category,
//     required this.productName,
//     required this.description,
//     required this.unit,
//     required this.stock,
//     required this.remainingStock,
//     required this.address,
//     required this.totalPrice,
//     required this.delivery,
//     required this.isOrganic,
//     required this.auctionStatus,
//     this.auctionStartTime,
//     this.auctionEndTime,
//     required this.isSold,
//     required this.isAuctionCompleted,
//     this.auctionStartAmount,
//     required this.productReleasedTime,
//     required this.productId,
//     required this.sellerData,
//     required this.comments,
//     required this.rating,
//     required this.ratingCount,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.media,
//   });
//
//   /// ✅ Async factory constructor for parsing JSON with async video thumbnail logic
//   static Future<BackendProduct> fromJsonAsync(Map<String, dynamic> json) async {
//     final mediaList = List<String>.from(json['media'] ?? []);
//     List<bool> isVideoList = [];
//     List<bool> isFilePathList = [];
//
//     String? imageUrl;
//     bool isFilePath = false;
//
//     for (var media in mediaList) {
//       final isVideo = checkIsVideo(media);
//       final isImage = checkIsImage(media);
//
//       if (isVideo) {
//         final thumb = await VideoThumbnail.thumbnailFile(
//           video: media,
//           imageFormat: ImageFormat.JPEG,
//           maxHeight: 100,
//           quality: 75,
//         );
//         if (thumb != null) {
//           isFilePath = true;
//           imageUrl ??= thumb; // Use only the first thumbnail
//         }
//         isVideoList.add(true);
//         isFilePathList.add(true);
//       } else {
//         isVideoList.add(false);
//         isFilePathList.add(false);
//         if (isImage && imageUrl == null) {
//           imageUrl = media;
//         }
//       }
//     }
//
//     double price = (json['pricePerUnit'] as num).toDouble();
//     double? discounted = (json['totalPrice'] as num).toDouble();
//
//     int? percent;
//     if (discounted < price) {
//       percent = ((1 - (discounted / price)) * 100).round();
//     }
//
//     return BackendProduct(
//       imageUrl: imageUrl,
//       isImage: _hasImage(mediaList),
//       isVideo: _hasVideo(mediaList),
//       isFilePath: isFilePath,
//       pricePerUnit: price,
//       totalPrice: discounted,
//       brandName: json['sellerData']?['name'] ?? 'Unknown',
//       discountPrice: discounted < price ? discounted : null,
//       discountPercent: percent,
//       mediaList: mediaList,
//       isVideoList: isVideoList,
//       isFilePathList: isFilePathList,
//       productTitle: json['productTitle'] ?? '',
//       sellerId: json['sellerId'] ?? '',
//       category: json['category'] ?? '',
//       productName: json['productName'] ?? '',
//       description: json['description'] ?? '',
//       unit: json['unit'] ?? '',
//       stock: (json['stock'] as num).toDouble(),
//       remainingStock: json['remainingStock'] ?? 0,
//       address: Map<String, dynamic>.from(json['address'] ?? {}),
//       delivery: json['delivery'] ?? false,
//       isOrganic: json['isOrganic'] ?? false,
//       auctionStatus: json['auctionStatus'] ?? false,
//       auctionStartTime: json['auctionStartTime'],
//       auctionEndTime: json['auctionEndTime'],
//       isSold: json['isSold'] ?? false,
//       isAuctionCompleted: json['isAuctionCompleted'] ?? false,
//       auctionStartAmount: (json['auctionStartAmount'] as num?)?.toDouble(),
//       productReleasedTime: json['productReleasedTime'] ?? '',
//       productId: json['productId'] ?? '',
//       sellerData: Map<String, dynamic>.from(json['sellerData'] ?? {}),
//       comments: List<dynamic>.from(json['comments'] ?? []),
//       rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
//       ratingCount: json['ratingCount'] ?? 0,
//       createdAt: json['createdAt'] ?? DateTime.now(),
//       updatedAt: json['updatedAt'] ?? DateTime.now(),
//       media: json['media'],
//     );
//   }
//
//   /// ✅ File type checkers
//   static bool checkIsImage(String url) {
//     final imageExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.gif'];
//     return imageExtensions.any((ext) => url.toLowerCase().endsWith(ext));
//   }
//
//   static bool checkIsVideo(String url) {
//     final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
//     return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
//   }
//
//   static bool _hasImage(List<String> mediaList) {
//     return mediaList.any((media) => checkIsImage(media));
//   }
//
//   static bool _hasVideo(List<String> mediaList) {
//     return mediaList.any((media) => checkIsVideo(media));
//   }
// }

// import 'dart:core';
//
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'dart:io';
//
// class BackendProduct {
//   final String? imageUrl;
//   final bool isImage;
//   final bool isVideo;
//   final bool isFilePath;
//   List<String> mediaList;
//   List<bool> isVideoList;
//   List<bool> isFilePathList;
//
//   final String productTitle;
//   final double pricePerUnit;
//   final double totalPrice;
//   final String brandName;
//   final double? discountPrice;
//   final int? discountPercent;
//   final String sellerId;
//   final String category;
//   final String productName;
//   final String description;
//   final String unit;
//   final double stock;
//   final int remainingStock;
//   final bool delivery;
//   final bool isOrganic;
//   final double rating;
//   final int ratingCount;
//   final bool auctionStatus;
//   final bool isSoled;
//   final bool isAuctionCompleted;
// final String productId;
// final String comments[];
//   final String? auctionStartTime;
//   final String? auctionEndTime;
//   final double? auctionStartAmount;
//   final String productReleasedTime;
//   final {}sellerData;
//   final {}address;
//   final String media[];
//
//   BackendProduct({
//     required this.imageUrl,
//     required this.isImage,
//     required this.isVideo,
//     required this.isFilePath,
//     required this.pricePerUnit,
//     required this.brandName,
//     this.discountPrice,
//     this.discountPercent,
//     required this.mediaList,
//     required this.isVideoList,
//     required this.isFilePathList,
//     required this.productTitle,
//     required this.sellerId,
//     required this.category,
//     required this.productName,
//     required this.description,
//     required this.unit,
//     required this.stock,
//     required this.remainingStock,
//     required this.address,
//     required this.media,
//     required this.pricePerUnit,
//     required this.totalPrice,
//     required this.delivery,
//     required this.isOrganic,
//     required this.auctionStatus,
//     this.auctionStartTime,
//     this.auctionEndTime,
//     required this.isSoled,
//     this.isAuctionCompleted,
//     this.auctionStartAmount,
//     required this.productReleasedTime,
//     required this.productId,
//     required this.sellerData,
//     required this.comments,
//     required this.rating,
//     required this.ratingCount,
//   });
//
//   /// ✅ Async factory replacement
//   static Future<BackendProduct> fromJsonAsync(Map<String, dynamic> json) async {
//     // Initialize media-related lists
//     final mediaList = List<String>.from(json['media'] ?? []);
//     List<bool> isVideoList = [];
//     List<bool> isFilePathList = [];
//
//     String? imageUrl;
//     bool isFilePath = false;
//
//     for (var media in mediaList) {
//       // Check if the media is a video and generate thumbnail
//       final isVideo = checkIsVideo(media);
//       final isImage = checkIsImage(media);
//
//       if (isVideo) {
//         final thumb = await VideoThumbnail.thumbnailFile(
//           video: media,
//           imageFormat: ImageFormat.JPEG,
//           maxHeight: 100,
//           quality: 75,
//         );
//         if (thumb != null) {
//           isFilePath = true;
//           imageUrl = thumb; // Store the thumbnail file path
//         }
//         isVideoList.add(true);
//         isFilePathList.add(true);
//       } else {
//         isVideoList.add(false);
//         isFilePathList.add(false);
//         if (isImage) {
//           imageUrl = media; // Direct image URL
//         }
//       }
//     }
//
//     double price = (json['pricePerUnit'] as num).toDouble();
//     double? discounted = json['totalPrice'] != null
//         ? (json['totalPrice'] as num).toDouble()
//         : null;
//
//     int? percent;
//     if (discounted != null && discounted < price) {
//       percent = (((1 - (discounted / price)) * 100).round());
//     }
//
//     return BackendProduct(
//       imageUrl: imageUrl,
//       isImage: _hasImage(mediaList), // Helper method renamed
//       isVideo: _hasVideo(mediaList), // Helper method renamed
//       isFilePath: isFilePath,
//       productTitle: json['productTitle'],
//       pricePerUnit: price,
//       brandName: json['sellerData']?['name'] ?? "Brand",
//       discountPrice: discounted,
//       discountPercent: percent,
//       mediaList: mediaList,
//       isVideoList: isVideoList,
//       isFilePathList: isFilePathList,
//     );
//   }
//
//   static bool checkIsImage(String url) {
//     final imageExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.gif'];
//     return imageExtensions.any((ext) => url.toLowerCase().endsWith(ext));
//   }
//
//   static bool checkIsVideo(String url) {
//     final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
//     return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
//   }
//
//   // Helper function to check if the media list contains any images
//   static bool _hasImage(List<String> mediaList) {
//     return mediaList.any((media) => checkIsImage(media));
//   }
//
//   // Helper function to check if the media list contains any videos
//   static bool _hasVideo(List<String> mediaList) {
//     return mediaList.any((media) => checkIsVideo(media));
//   }
// }
