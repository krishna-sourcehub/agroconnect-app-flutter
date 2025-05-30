import 'package:agroconnect/models/regular_product_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';

class ProductTextDetailSection extends StatelessWidget {
  final BackendProduct product;

  const ProductTextDetailSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final seller = product.sellerData;
    final productLocation= product.address;
    final String? photoURL = seller['photoURL'];


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(),
                  Text(
                    "Product Details",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: defaultPadding),

              /// Description / Story
              Text("Story", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),

              const SizedBox(height: 24),

              /// Basic Details
              Text("Details", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _detailText("Category", product.category),
              _detailText("Product Name", product.productName),
              _detailText("Product Title", product.productTitle ?? "N/A"),
              _detailText("Brand Name", product.brandName ?? "N/A"),
              _detailText("Unit", product.unit),
              _detailText("Price Per Unit", "₹${product.pricePerUnit}/${product.unit}"),
              _detailText("Total Price", "₹${product.totalPrice}"),
              _detailText("Stock", product.stock.toString()),
              _detailText("Remaining Stock", product.remainingStock.toString()),
              _detailText("Delivery Available", product.delivery ? "Yes" : "No"),
              _detailText("Organic", product.isOrganic ? "Yes" : "No"),
              _detailText("Released Time",DateFormat('MMMM d, y – h:mm a').format(DateTime.parse(product.productReleasedTime))),
              _detailText("Updated Time", DateFormat('MMMM d, y – h:mm a').format(DateTime.parse(product.updatedAt))),

              ...[
                if (product.auctionStatus)
                  _detailText(
                    "Auction Start Time",
                    DateFormat('MMMM d, y – h:mm a').format(
                      DateTime.parse(product.auctionStartTime ?? ''),
                    ),
                  ),
                if (product.auctionStatus)
                  _detailText("Auction Start Amount", product.auctionStartAmount.toString()),
                if (product.auctionStatus)
                  _detailText(
                    "Auction End Time",
                    DateFormat('MMMM d, y – h:mm a').format(
                      DateTime.parse(product.auctionEndTime ?? ''),
                    ),
                  ),
              ],




              const SizedBox(height: 24),

              /// Location
              Text("Product Location", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _detailText("Taluk", productLocation['taluk']),
              _detailText("District", productLocation['district']),
              _detailText("State", productLocation['state']),
              _detailText("Postal Code", productLocation['postalCode'].toString()),
              _detailText("Country", productLocation['country']),

              const SizedBox(height: 24),

              /// Seller Info
              Text("Seller Info", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: (photoURL != null && photoURL.isNotEmpty)
                        ? NetworkImage(photoURL)
                        : null,
                    child: (photoURL == null || photoURL.isEmpty)
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    seller['name'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to display label-value pairs
  Widget _detailText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
