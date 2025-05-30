import 'dart:ffi';

import 'package:agroconnect/constants.dart';
import 'package:agroconnect/utils/Notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorage = FlutterSecureStorage();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        print('🟢 Firebase ID Token: $idToken');

        final backendResponse = await logInToBackend(
          idToken: idToken.toString(),
          endpointUrl: "$backendURL/auth/login",
        );

        if (backendResponse['status'] == true) {
          await secureStorage.write(
            key: 'sessionToken',
            value: backendResponse['sessionToken'],
          );

          await secureStorage.write(
            key: 'profileStatus',
            value: backendResponse['profileStatus'].toString(),
          );
          await secureStorage.write(
            key: 'typeOfUser',
            value: backendResponse['typeOfUser'],
          );
          final sessionToken = await secureStorage.read(key: 'sessionToken');
          final typeOfUser = await secureStorage.read(key: 'typeOfUser');
          final profileStatus = await secureStorage.read(key: 'profileStatus');

          print(
            '✅ Login successful. Session token: ${backendResponse['sessionToken']}',
          );
          print(' secureToken:$sessionToken');
          print('typeOfUser: $typeOfUser');
          print('profileStatus: $profileStatus');
          // You can store the sessionToken or profileStatus here
        } else {
          if (backendResponse['reason'] == 'userNotFound') {
            throw backendResponse['reason'] ??
                'Account Not Found, Please Create an Account and Continue';
          } else {
            throw backendResponse['reason'] ?? 'Backend login failed';
          }
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      // Firebase Auth-specific error messages
      if (e.code == 'too-many-requests') {
        throw "Too many failed attempts. Please wait a while and try again.";
      } else if (e.code == 'wrong-password') {
        throw "Incorrect password. Try again.";
      } else if (e.code == 'user-not-found') {
        throw "No account found with that email.";
      } else {
        throw e.message ?? "Login failed. Please try again.";
      }
    } catch (e) {
      print("Unexpected error: $e");
      throw "Login failed. Please try again.";
    }
  }

  /// Backend login
  Future<Map<String, dynamic>> logInToBackend({
    required String idToken,
    required String endpointUrl,
  }) async {
    var deviceToken = await secureStorage.read(key: "deviceToken");
    if (deviceToken == null || deviceToken == "") {
      NotificationService().init();
      deviceToken = await secureStorage.read(key: "deviceToken");
    }

    try {
      final response = await http.post(
        Uri.parse(endpointUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: json.encode({"deviceToken": deviceToken}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'status': true,
          'sessionToken': responseData['sessionToken'],
          'profileStatus': responseData['profileStatus'],
          'typeOfUser': responseData['typeOfUser'],
        };
      } else {
        return {
          'status': false,
          'reason': responseData['reason'] ?? 'Unknown error from server',
        };
      }
    } catch (e) {
      print('❌ Backend login error: $e');
      return {'status': false, 'reason': 'Network error. Please try again.'};
    }
  }

  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    print("this function is called now");
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        print('🟢 Firebase ID Token: $idToken');

        final backendResponse = await signInToBackend(
          idToken: idToken.toString(),
          endpointUrl: "$backendURL/auth/signup",
          bodyData: {'email': email},
        );

        if (backendResponse['status'] == true) {
          await secureStorage.write(
            key: 'sessionToken',
            value: backendResponse['sessionToken'],
          );

          await secureStorage.write(
            key: 'profileStatus',
            value: backendResponse['profileStatus'].toString(),
          );
          await secureStorage.write(
            key: 'typeOfUser',
            value: backendResponse['typeOfUser']?.toString() ?? "undefined",
          );

          await secureStorage.write(
            key: 'UPIUpdateStatus',
            value: backendResponse['UPIUpdateStatus'].toString(),
          );

          final sessionToken = await secureStorage.read(key: 'sessionToken');
          final profileStatus = await secureStorage.read(key: 'profileStatus');
          final UPIUpdateStatus = await secureStorage.read(
            key: 'UPIUpdateStatus',
          );

          print(
            '✅ Account created successfully. Session token: ${backendResponse['sessionToken']}',
          );
          print(' secureToken:$sessionToken');
          print('profileStatus: $profileStatus');
          print('UPIUpdateStatus: $UPIUpdateStatus');

          // You can store the sessionToken or profileStatus here
        } else {
          if (backendResponse['reason'] == 'emailAlreadyExists') {
            throw backendResponse['reason'] ??
                'User Account already Exists, Please continue with login';
          } else {
            throw backendResponse['reason'] ?? 'Backend login failed';
          }
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      // Firebase Auth-specific error messages
      if (e.code == 'too-many-requests') {
        throw "Too many failed attempts. Please wait a while and try again.";
      } else if (e.code == 'wrong-password') {
        throw "Incorrect password. Try again.";
      } else if (e.code == 'user-not-found') {
        throw "No account found with that email.";
      } else {
        throw e.message ?? "Login failed. Please try again.";
      }
    } catch (e) {
      print("Unexpected error: $e");
      throw "Account creation failed. Please try again.";
    }
  }

  /// Backend login
  Future<Map<String, dynamic>> signInToBackend({
    required String idToken,
    required String endpointUrl,
    required Map<String, dynamic> bodyData,
  }) async {
    try {
      print("backed called now");
      print("jsonEncode: " + jsonEncode(bodyData));
      final response = await http.post(
        Uri.parse(endpointUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(bodyData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'status': true,
          'sessionToken': responseData['sessionToken'],
          'profileStatus': responseData['profileStatus'],
        };
      } else {
        print(jsonDecode(response.body).toString());
        return {
          'status': false,
          'reason': responseData['reason'] ?? 'Unknown error from server',
        };
      }
    } catch (e) {
      print('❌ Backend login error: $e');
      return {'status': false, 'reason': 'Network error. Please try again.'};
    }
  }

  Future<Map<String, String>> sendPasswordResetMail({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent to $email");
      return {
        "status": "true",
        "message": "Password reset email sent successfully.",
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        return {
          "status": "false",
          "reason": "serverBusy",
          "message":
              "Too many failed attempts. Please wait a while and try again.",
        };
      } else if (e.code == 'user-not-found') {
        return {
          "status": "false",
          "reason": "userNotFound",
          "message": "No account found with that email.",
        };
      } else {
        return {
          "status": "false",
          "reason": "firebaseError",
          "message": e.message ?? "Password reset failed. Please try again.",
        };
      }
    } catch (e) {
      print("Unexpected error: $e");
      return {
        "status": "false",
        "reason": "unexpectedError",
        "message": "Something went wrong. Please try again.",
      };
    }
  }

  Future<Map<String, dynamic>> validateSignUpPhoneNumberAndSentOtp({
    required String phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$backendURL/auth/signup/sendOtp"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"toPhoneNumber": phoneNumber}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'status': true,
          'message': 'Please Verify SMS, OTP Send Successfully',
        };
      } else if (responseData['reason'] == 'userExists') {
        print(jsonDecode(response.body).toString());
        return {
          'status': false,
          'reason': responseData['reason'] ?? 'Unknown error from server',
          'message': "Phone Number Already Exists, Please Enter another Number",
        };
      } else if (responseData['reason'] == 'errorSendOTP') {
        print(jsonDecode(response.body).toString());
        return {
          'status': false,
          'reason': responseData['reason'] ?? 'Unknown error from server',
          'message': responseData['reason'],
        };
      } else {
        print(jsonDecode(response.body).toString());
        return {
          'status': false,
          'reason': responseData['reason'] ?? 'Unknown error from server',
          'message': "Unknown error from server",
        };
      }
    } catch (e) {
      print("Unexpected error: $e");
      return {
        "status": "false",
        "reason": "unexpectedError",
        "message": "Something went wrong. Please try again.",
      };
    }
  }

  Future<Map<String, dynamic>> validateLogInPhoneNumberAndSentOtp({
    required String phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$backendURL/auth/signin/sendOtp"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"toPhoneNumber": phoneNumber}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'status': true,
          'message': 'Please Verify SMS, OTP Send Successfully',
        };
      } else if (responseData['reason'] == 'userNotExists') {
        print(jsonDecode(response.body).toString());
        return {
          'status': false,
          'reason': responseData['reason'] ?? 'Unknown error from server',
          'message': "Phone Number Not Exists, Please Continue with Sign Up",
        };
      } else if (responseData['reason'] == 'errorSendOTP') {
        print(jsonDecode(response.body).toString());
        return {
          'status': false,
          'reason': responseData['reason'] ?? 'Unknown error from server',
          'message': responseData['reason'],
        };
      } else {
        print(jsonDecode(response.body).toString());
        return {
          'status': false,
          'reason': responseData['reason'] ?? 'Unknown error from server',
          'message': "Unknown error from server",
        };
      }
    } catch (e) {
      print("Unexpected error: $e");
      return {
        "status": "false",
        "reason": "unexpectedError",
        "message": "Something went wrong. Please try again.",
      };
    }
  }

  Future<Map<String, dynamic>> verifyPhoneNumberOtp({
    required String phoneNumber,
    required int OTP,
  }) async {
    try {
      var deviceToken = await secureStorage.read(key: "deviceToken");
      if (deviceToken == null || deviceToken == "") {
        await NotificationService().init();
        deviceToken = await secureStorage.read(key: "deviceToken");
      }

      final response = await http.post(
        Uri.parse("$backendURL/auth/SMS/verifyOtp"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "toPhoneNumber": phoneNumber,
          "otp": OTP,
          "deviceToken": deviceToken,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await secureStorage.write(
          key: 'sessionToken',
          value: responseData['sessionToken'],
        );

        await secureStorage.write(
          key: 'profileStatus',
          value: responseData['profileStatus'].toString(),
        );

        await secureStorage.write(
          key: 'UPIUpdateStatus',
          value: responseData['UPIUpdateStatus'].toString(),
        );

        await secureStorage.write(
          key: 'typeOfUser',
          value: responseData['typeOfUser']?.toString() ?? "undefined",
        );
        return {'status': true, 'message': 'OTP Verified Successfully'};
      } else if (responseData['reason'] == 'otpExpired') {
        print(responseData.toString());
        return {
          'status': false,
          'reason': responseData['reason'] ?? 'Unknown error from server',
          'message': "OTP Expired, Please Try again",
        };
      } else if (responseData['reason'] == 'invalidOtp') {
        print(responseData.toString());
        return {
          'status': false,
          'reason': responseData['reason'] ?? 'Unknown error from server',
          'message': "Invalid OTP, Please Enter Valid OTP",
        };
      } else {
        print(responseData.toString());
        return {
          'status': false,
          'reason': responseData['reason'] ?? 'Unknown error from server',
          'message': "Unknown error from server",
        };
      }
    } catch (e) {
      print("Unexpected error: $e");
      return {
        "status": false,
        "reason": "unexpectedError",
        "message": "Something went wrong. Please try again.",
      };
    }
  }
}
