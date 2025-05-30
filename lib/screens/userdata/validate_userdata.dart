import 'package:agroconnect/constants.dart';
import 'package:agroconnect/utils/dependcies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorage = FlutterSecureStorage();

class backendService {
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
}
