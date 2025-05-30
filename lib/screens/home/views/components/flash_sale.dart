import 'package:agroconnect/components/product/product_card.dart' show ProductCard;
import 'package:flutter/material.dart';
import 'package:agroconnect/route/route_constants.dart';

import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';

class FlashSale extends StatelessWidget {
  const FlashSale({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // While loading show 👇
        // const BannerMWithCounterSkelton(),
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          // text: "Super Flash Sale \n50% Off",
          text: "Super Flash Sale",
          press: () {},
        ),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Flash sale",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading show 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // Find demoFlashSaleProducts on models/ProductModel.dart
            itemCount: demoFlashSaleProducts.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == demoFlashSaleProducts.length - 1
                    ? defaultPadding
                    : 0,
              ),
              child: ProductCard(
                productCardThumbNail: demoFlashSaleProducts[index].image,
                isFilePath: false,
                image: demoFlashSaleProducts[index].image ?? "https://via.placeholder.com/150",
                brandName: demoFlashSaleProducts[index].brandName,
                title: demoFlashSaleProducts[index].title,
                price: demoFlashSaleProducts[index].price,
                priceAfetDiscount: demoFlashSaleProducts[index].priceAfetDiscount,
                dicountpercent: demoFlashSaleProducts[index].dicountpercent ?? 0,
                press: () {
                  // Navigator.pushNamed(
                  //   context,
                  //   productDetailsScreenRoute,
                  //   arguments: product,
                  // );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
