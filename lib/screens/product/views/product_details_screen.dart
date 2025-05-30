import 'package:agroconnect/screens/product/views/product_description_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:agroconnect/components/buy_full_ui_kit.dart';
import 'package:agroconnect/components/cart_button.dart';
import 'package:agroconnect/components/custom_modal_bottom_sheet.dart';
import 'package:agroconnect/components/product/product_card.dart';
import 'package:agroconnect/constants.dart';
import 'package:agroconnect/screens/product/views/product_returns_screen.dart';

import 'package:agroconnect/route/screen_export.dart';

import '../../../models/regular_product_model.dart';
import 'components/notify_me_card.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../../components/review_card.dart';
import 'media_slider.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final BackendProduct product;
  final bool isProductAvailable = true;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          isProductAvailable
              ? CartButton(
                price: product.pricePerUnit, // Using product price dynamically
                press: () {
                  customModalBottomSheet(
                    context,
                    height: MediaQuery.of(context).size.height * 0.92,
                    child: ProductBuyNowScreen(product: product,),
                  );
                },
              )
              :
              /// If product is not available, show NotifyMeCard
              NotifyMeCard(isNotify: false, onChanged: (value) {}),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,

              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Bookmark.svg",
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
              pinned: true,
              expandedHeight: 75,
              title: Text("Product Detail"),

            ),
            // Show product images dynamically from the mediaList of BackendProduct
            // ProductImages(
            //   images: product.mediaList,
            //   isVideoList: product.isVideoList,
            //   isFilePathList: product.isFilePathList,
            // ),

            SliverToBoxAdapter(

              child: MediaSlider(
                mediaList: product.mediaList,
                isVideoList: product.isVideoList,
                isFilePathList: product.isFilePathList,
              ),
            ),
            // Product info with dynamic values from BackendProduct
            ProductInfo(
              brand: product.brandName,
              // Dynamic brand
              title: product.productTitle,
              // Dynamic title
              isAvailable: isProductAvailable,
              description: product.description,
              rating: product.rating,
              // Placeholder rating, update dynamically as needed
              numOfReviews:
                  product.ratingCount, // Placeholder number of reviews, update dynamically as needed
            ),
            ProductListTile(
              svgSrc: "assets/icons/Product.svg",
              title: "Product Details",
              isShowBottomBorder: true,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: ProductTextDetailSection(product: product,)
                );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Delivery.svg",
              title: "Shipping Information",
              press: () {
                // customModalBottomSheet(
                //   context,
                //   height: MediaQuery.of(context).size.height * 0.92,
                //   child: const BuyFullKit(
                //     images: ["assets/screens/Shipping information.png"],
                //   ),
                // );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Return.svg",
              title: "Returns",
              isShowBottomBorder: true,
              press: () {
                // customModalBottomSheet(
                //   context,
                //   height: MediaQuery.of(context).size.height * 0.92,
                //   child: const ProductReturnsScreen(),
                // );
              },
            ),
            // const SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.all(defaultPadding),
            //     child: ReviewCard(
            //       rating: 4.3,
            //       // Placeholder rating, adjust dynamically as needed
            //       numOfReviews: 128,
            //       // Placeholder number of reviews, update dynamically as needed
            //       numOfFiveStar: 80,
            //       numOfFourStar: 30,
            //       numOfThreeStar: 5,
            //       numOfTwoStar: 4,
            //       numOfOneStar: 1,
            //     ),
            //   ),
            // ),
            ProductListTile(
              svgSrc: "assets/icons/Chat.svg",
              title: "Reviews",
              isShowBottomBorder: true,
              press: () {
                // Navigator.pushNamed(context, productReviewsScreenRoute);
              },
            ),
            // SliverPadding(
            //   padding: const EdgeInsets.all(defaultPadding),
            //   sliver: SliverToBoxAdapter(
            //     child: Text(
            //       "You may also like",
            //       style: Theme.of(context).textTheme.titleSmall!,
            //     ),
            //   ),
            // ),
            // SliverToBoxAdapter(
            //   child: SizedBox(
            //     height: 220,
            //     child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: 5,
            //       itemBuilder:
            //           (context, index) => Padding(
            //             padding: EdgeInsets.only(
            //               left: defaultPadding,
            //               right: index == 4 ? defaultPadding : 0,
            //             ),
            //             child: ProductCard(
            //               productCardThumbNail:"https://via.placeholder.com/150",
            //                              image: productDemoImg2,
            //               // You might want to show another image dynamically
            //               title: "Sleeveless Tiered Dobby Swing Dress",
            //               // Dynamic title can be added
            //               brandName: "LIPSY LONDON",
            //               // Dynamic brand name
            //               price: 24.65,
            //               // Use dynamic price
            //               priceAfetDiscount: index.isEven ? 20.99 : null,
            //               dicountpercent: index.isEven ? 25 : null,
            //               press: () {},
            //               isFilePath: true, // Adjust if needed
            //             ),
            //           ),
            //     ),
            //   ),
            // ),
            // const SliverToBoxAdapter(child: SizedBox(height: defaultPadding)),
          ],
        ),
      ),
    );
  }
}
