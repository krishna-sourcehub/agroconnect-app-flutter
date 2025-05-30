import 'dart:convert';
import 'dart:io';
import 'package:agroconnect/constants.dart';
import 'package:agroconnect/utils/dependcies.dart';
import 'package:agroconnect/utils/toast_util.dart';
import 'package:http/http.dart' as http;
import 'package:agroconnect/models/regular_product_model.dart';

Future<List<BackendProduct>> fetchBackendProducts() async {
  String? sessionToken;
  final tokenStatus = await UserDependencies().getSessionToken();

  if (tokenStatus['status'] == true) {
    sessionToken = tokenStatus['sessionToken'];
  } else {
    throw Exception("Session expired");
  }

  final response = await http.get(
    Uri.parse("$backendURL/product/getAllProducts"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $sessionToken',
    },
  );

  if (response.statusCode == 200) {
    final List data = json.decode(response.body)['data'];

    // Use the async constructor properly
    return await Future.wait(
      data.map((json) => BackendProduct.fromJsonAsync(json)),
    );
  } else {
    throw Exception('Failed to load products');
  }
}



Future<List<BackendProduct>> fetchBackendAuctionProducts() async {
  String? sessionToken;
  final tokenStatus = await UserDependencies().getSessionToken();

  if (tokenStatus['status'] == true) {
    sessionToken = tokenStatus['sessionToken'];
  } else {
    throw Exception("Session expired");
  }

  final response = await http.get(
    Uri.parse("$backendURL/product/auction/getAllAuctionProducts"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $sessionToken',
    },
  );

  if (response.statusCode == 200) {
    final List data = json.decode(response.body)['data'];

    if(data.isEmpty){
      ToastUtil.show("No Auction Products");
      return Future.wait(
        data.map((json) => BackendProduct.fromJsonAsync(json)),
      );;
    }
    // Use the async constructor properly
    return await Future.wait(
      data.map((json) => BackendProduct.fromJsonAsync(json)),
    );
  } else {
    throw Exception('Failed to load products');
  }
}
