import 'package:agroconnect/constants.dart';
import 'package:agroconnect/utils/dependcies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorage = FlutterSecureStorage();

class userBackendService {
  /// Backend login
  Future<Map<String, dynamic>> verifyUserDetail({
    required String email,
    required String phoneNumber,
    required String brandName,
  }) async {
    try {
      String? sessionToken;
      final tokenStatus = await UserDependencies().getSessionToken();

      if (tokenStatus['status'] == true) {
        sessionToken = tokenStatus['sessionToken'];
      } else {
        return {'status': false, "reason": "sessionExpired"};
      }

      final response = await http.post(
        Uri.parse("$backendURL/user/verifyUserDetail"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sessionToken',
        },
        body: jsonEncode({
          'email': email,
          'phoneNumber': phoneNumber,
          'brandName': brandName,
        }),
      );

      final responseData = jsonDecode(response.body);

      print("phone $phoneNumber");

      print("responseData $responseData");

      if (response.statusCode == 200) {
        return {'status': true};
      } else {
        if (responseData['reason'] == "phoneAlreadyExists") {
          return {
            'status': false,
            'message':
                "Phone Number Already Exists, Please use another Phone Number",
          };
        }
        if (responseData['reason'] == "emailAlreadyExists") {
          return {
            'status': false,
            'message': "Email Already Exists, Please use another Email",
          };
        }
        if (responseData['reason'] == "brandAlreadyExists") {
          return {
            'status': false,
            'message': "Brand Name Already Exists, Please use another Brand Name",
          };
        }

        return {'status': false, 'message': 'server Error'};
      }
    } catch (e) {
      print('❌ Backend login error: $e');
      return {'status': false, 'message': 'Network error. Please try again.'};
    }
  }



  Future<Map<String, dynamic>> updateUserProfile({
    required String email,
    required String phoneNumber,
    // required String typeOfUser,
    required String name,
    // required String doorOrShopNo,
    // required String country,
    // required String city,
    // required String state,
    // required String taluk,
    // required String street,
    // required int postalCode,
    // required String district,
    required String brandName
  }) async {
    print("functionentered");
    try {
      String? sessionToken;
      final tokenStatus = await UserDependencies().getSessionToken();

      if (tokenStatus['status'] == true) {
        sessionToken = tokenStatus['sessionToken'];
      } else {
        return {'status': false, "reason": "sessionExpired"};
      }

      final response = await http.post(
        Uri.parse("$backendURL/user/updateProfile"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sessionToken',
        },
        body: jsonEncode({
          "email": email,
          "phoneNumber": phoneNumber,
          // "typeOfUser": typeOfUser,
          "name": name,
          "brandName":brandName

          // 'address': [{
          //   'doorOrShopNo': doorOrShopNo,
          //   "country": country,
          //   "city": city,
          //   "state": state,
          //   "street": street,
          //   "postalCode": postalCode,
          //   "district": district,
          //   "taluk": taluk,
          // }]
    }),
      );

      final responseData = jsonDecode(response.body);
      print("object $responseData");
      if (response.statusCode == 200) {
        // await secureStorage.write(key: "typeOfUser", value: typeOfUser);
        // await secureStorage.write(key: "profileStatus", value: "true");
        return {'status': true};
      } else {
        if (responseData['reason'] == "phoneAlreadyExists") {
          return {
            'status': false,
            'message':
            "Phone Number Already Exists, Please use another Phone Number",
          };
        }
        if (responseData['reason'] == "emailAlreadyExists") {
          return {
            'status': false,
            'message': "Email Already Exists, Please use another Email",
          };
        }

        if (responseData['reason'] == "brandAlreadyExists") {
          return {
            'status': false,
            'message': "Brand Name Already Exists, Please use another Brand Name",
          };
        }

        return {'status': false, 'message': 'server Error'};
      }
    } catch (e) {
      print('❌ Backend Profile error: $e');
      return {'status': false, 'message': 'Network error. Please try again.'};
    }
  }





}
