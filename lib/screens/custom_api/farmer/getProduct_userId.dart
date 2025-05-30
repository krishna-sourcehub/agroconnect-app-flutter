import 'dart:convert';
import 'package:agroconnect/utils/toast_util.dart';
import 'package:agroconnect/utils/dependcies.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';

class GetProductUserId extends StatefulWidget {
  const GetProductUserId({super.key});

  @override
  State<GetProductUserId> createState() => _GetProductUserIdState();
}

class _GetProductUserIdState extends State<GetProductUserId> {
  bool isLoading = false;
  String? errorMessage;
  List<dynamic>? products;

  Future<Map<String, dynamic>> getUserProductByUserId() async {
    try {
      setState(() {
        isLoading = true; // Set loading to true
        errorMessage = null; // Reset error message
      });

      print("Function called");

      // Retrieve the session token
      var getSessionToken = await UserDependencies().getSessionToken();

      // Check if the session is valid
      if (getSessionToken["status"] != true) {
        throw Exception("Session Expired");
      }

      String sessionToken = getSessionToken["sessionToken"];

      // Make the HTTP request
      final response = await http.get(
        Uri.parse("$backendURL/product/getAllProductByuserId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sessionToken',
        },
      );

      // Decode the response
      final responseData = jsonDecode(response.body);

      print("responseData: $responseData");

      // Check for successful response
      if (response.statusCode == 200) {
        // Extract the 'data' field which contains the list of products
        List<dynamic> productData = responseData['data']; // This is the list of products

        // Update the UI with the product data
        setState(() {
          products = productData; // Store the products in the state
        });

        return {'status': true, 'data': productData}; // Return the product data
      } else {
        print("Exception Error $response");
        throw Exception("Backend Server Error");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        errorMessage = e.toString(); // Show error message
      });
      ToastUtil.show("Server Error");
      return {'status': false, 'message': e.toString()};
    } finally {
      setState(() {
        isLoading = false; // Set loading to false once the request is complete
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get User Product"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          isLoading
              ? CircularProgressIndicator() // Show loading indicator while waiting
              : errorMessage != null
              ? Text(
            "Error: $errorMessage",
            style: TextStyle(color: Colors.red),
          ) // Show error message if any
              : products == null
              ? Text("No products available.") // No products available yet
              : Expanded(
            child: ListView.builder(
              itemCount: products!.length,
              itemBuilder: (context, index) {
                var product = products![index];
                return ListTile(
                  title: Text(product['productName'] ?? 'Unknown Product'),
                  subtitle: Text("Price: \$${product['pricePerUnit']}"),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getUserProductByUserId(); // Call the function when pressed
        },
        child: Icon(Icons.keyboard_arrow_down_outlined),
      ),
    );
  }
}
