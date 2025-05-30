// For demo only
import 'package:agroconnect/constants.dart';

class ProductModel {
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;

  ProductModel({
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
  });


}

List<ProductModel> demoPopularProducts = [
  ProductModel(
    image: productDemoImg1,
    title: "Mountain Warehouse for Women",
    brandName: "Lipsy london",
    price: 540,
    priceAfetDiscount: 420,
    dicountpercent: 20,
  ),
  ProductModel(
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 800,
  ),
  ProductModel(
    image: productDemoImg5,
    title: "FS - Nike Air Max 270 Really React",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 390.36,
    dicountpercent: 40,
  ),
  ProductModel(
    image: productDemoImg6,
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200.8,
    dicountpercent: 5,
  ),
  ProductModel(
    image: "https://i.imgur.com/tXyOMMG.png",
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 390.36,
    dicountpercent: 40,
  ),
  ProductModel(
    image: "https://i.imgur.com/h2LqppX.png",
    title: "white satin corset top",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200.8,
    dicountpercent: 5,
  ),
];
List<ProductModel> demoFlashSaleProducts = [
  // ProductModel(
  //   image: productDemoImg5,
  //   title: "FS - Nike Air Max 270 Really React",
  //   brandName: "Lipsy london",
  //   price: 650.62,
  //   priceAfetDiscount: 390.36,
  //   dicountpercent: 40,
  // ),
  // ProductModel(
  //   image: productDemoImg6,
  //   title: "Green Poplin Ruched Front",
  //   brandName: "Lipsy london",
  //   price: 1264,
  //   priceAfetDiscount: 1200.8,
  //   dicountpercent: 5,
  // ),
  // ProductModel(
  //   image: productDemoImg4,
  //   title: "Mountain Beta Warehouse",
  //   brandName: "Lipsy london",
  //   price: 800,
  //   priceAfetDiscount: 680,
  //   dicountpercent: 15,
  // ),

  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_78377459_YZ2gxe46PJmgtpXjeHC5l6qQOLtIfpe3.jpg",
    title: "Poplin Brinjal",
    brandName: "Karan Dealers",
    price: 650.62,
    priceAfetDiscount: 590.36,
    // dicountpercent: 24,
  ),
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_48277707_7XLxwwN9uxbUegkHP6i720vsU2QVvZKt.jpg",
    title: "Banana",
    brandName: "Latha Mandi",
    price: 400,
    priceAfetDiscount: 360,
    dicountpercent: 20,
  ),
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_57208390_l5pqvCkHwBccUmgl4qca5Wx5JnFblIAN.jpg",
    title: "Pumpkin",
    brandName: "LMR Sellers",
    price: 654,
  ),
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_54046243_E0MxyAFfHsed2HV3S5xgzf3ari63p5wu.jpg",
    title: "carbage",
    brandName: "Ravi Traders",
    price: 250,
  ),
];
List<ProductModel> demoBestSellersProducts = [
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_41563624_7uwpAWialLFinOCfM6U5LpGxLu6Jkqvi.jpg",
    title: "Special Capsicum",
    brandName: "Madurai Mandi",
    price: 650.62,
    priceAfetDiscount: 390.36,
    // dicountpercent: 40,
  ),
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_46449393_47rDU1uFWYOhZucunfZq6XliGiPsWPfQ.jpg",
    title: "CaliFlower",
    brandName: "Chennai Traders",
    price: 1264,
    priceAfetDiscount: 1200.8,
    // dicountpercent: 5,
  ),
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_81358744_jhqbbirZJjXq1x7hMvtdshFdcFuIIAps.jpg",
    title: "Mountain Ginger",
    brandName: "SME EXPORTS",
    price: 800,
    priceAfetDiscount: 680,
    // dicountpercent: 15,
  ),
];


List<ProductModel> demoBestAuctionProducts = [
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_78377459_YZ2gxe46PJmgtpXjeHC5l6qQOLtIfpe3.jpg",
    title: "Poplin Brinjal",
    brandName: "Karan Dealers",
    price: 650.62,
    priceAfetDiscount: 590.36,
    // dicountpercent: 24,
  ),
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_81358744_jhqbbirZJjXq1x7hMvtdshFdcFuIIAps.jpg",
    title: "Mountain Ginger",
    brandName: "SME EXPORTS",
    price: 800,
    priceAfetDiscount: 680,
    // dicountpercent: 15,
  ),
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_46449393_47rDU1uFWYOhZucunfZq6XliGiPsWPfQ.jpg",
    title: "CaliFlower",
    brandName: "Chennai Traders",
    price: 1264,
    priceAfetDiscount: 1200.8,
    // dicountpercent: 5,
  ),

  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_57208390_l5pqvCkHwBccUmgl4qca5Wx5JnFblIAN.jpg",
    title: "Pumpkin",
    brandName: "LMR Sellers",
    price: 654,
  ),
];


List<ProductModel> kidsProducts = [
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_41563624_7uwpAWialLFinOCfM6U5LpGxLu6Jkqvi.jpg",
    title: "Special Capsicum",
    brandName: "Madurai Mandi",
    price: 650.62,
    priceAfetDiscount: 390.36,
    // dicountpercent: 40,
  ),
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_78377459_YZ2gxe46PJmgtpXjeHC5l6qQOLtIfpe3.jpg",
    title: "Poplin Brinjal",
    brandName: "Karan Dealers",
    price: 650.62,
    priceAfetDiscount: 590.36,
    // dicountpercent: 24,
  ),
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_48277707_7XLxwwN9uxbUegkHP6i720vsU2QVvZKt.jpg",
    title: "Banana",
    brandName: "Latha Mandi",
    price: 400,
    priceAfetDiscount: 360,
    dicountpercent: 20,
  ),
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_57208390_l5pqvCkHwBccUmgl4qca5Wx5JnFblIAN.jpg",
    title: "Pumpkin",
    brandName: "LMR Sellers",
    price: 654,
  ),
  ProductModel(
    image: "https://fjkepdwtiwjvzvuonvch.supabase.co/storage/v1/object/public/agroconnect/vegetables/240_F_54046243_E0MxyAFfHsed2HV3S5xgzf3ari63p5wu.jpg",
    title: "carbage",
    brandName: "Ravi Traders",
    price: 250,
  ),
];
