import 'package:agroconnect/components/product/product_card.dart' show ProductCard;
import 'package:flutter/material.dart';
import 'package:agroconnect/models/product_model.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class BestSellers extends StatelessWidget {
  const BestSellers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Best sellers",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // Find demoBestSellersProducts on models/ProductModel.dart
            itemCount: demoBestSellersProducts.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == demoBestSellersProducts.length - 1
                    ? defaultPadding
                    : 0,
              ),
              child: ProductCard(
                productCardThumbNail: demoBestSellersProducts[index].image,
                isFilePath: false,
                image: demoBestSellersProducts[index].image ?? "https://via.placeholder.com/150",
                brandName: demoBestSellersProducts[index].brandName,
                title: demoBestSellersProducts[index].title,
                price: demoBestSellersProducts[index].price,
                priceAfetDiscount: demoBestSellersProducts[index].priceAfetDiscount,
                dicountpercent: demoBestSellersProducts[index].dicountpercent ?? 0,
                press: () {
                  // Navigator.pushNamed(
                  //   context,
                  //   productDetailsScreenRoute,
                  //   arguments: product,
                  // );
                },
              ),
              // child: ProductCard(
              //   productCardThumbNail:"https://via.placeholder.com/150",
              //   image: demoBestSellersProducts[index].image,
              //   brandName: demoBestSellersProducts[index].brandName,
              //   title: demoBestSellersProducts[index].title,
              //   price: demoBestSellersProducts[index].price,
              //   priceAfetDiscount:
              //       demoBestSellersProducts[index].priceAfetDiscount,
              //   dicountpercent: demoBestSellersProducts[index].dicountpercent,
              //   press: () {
              //     Navigator.pushNamed(context, productDetailsScreenRoute,
              //         arguments: index.isEven);
              //   }, isFilePath: false,
              // ),
            ),
          ),
        )
      ],
    );
  }
}
