import 'package:agroconnect/route/route_constants.dart';
import 'package:agroconnect/screens/userdata/address/update_user_data.dart';
import 'package:agroconnect/screens/userdata/address/user_form_address_address.dart';
import 'package:agroconnect/screens/userdata/user_form_data.dart';
import 'package:agroconnect/screens/userdata/validate_userdata.dart';
import 'package:agroconnect/utils/toast_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants.dart';

class GetupiidScreen extends StatefulWidget {
  const GetupiidScreen({super.key});

  @override
  State<GetupiidScreen> createState() => _GetupiidScreenState();
}

class _GetupiidScreenState extends State<GetupiidScreen> {
  final GlobalKey<UserAddressFormDataState> _userAddressFormKey =
      GlobalKey<UserAddressFormDataState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _upiController = TextEditingController();
  final RegExp upiPattern = RegExp(r'^[\w.-]+@[\w]+$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/primary/upi-image-2.jpg",
              // height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              // fit: BoxFit.fitHeight,
            fit: BoxFit.fill,
              height: 350,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Center(
                    child: Text(
                      "Payment Information",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  // const SizedBox(height: defaultPadding / 2),
                  // const Text(
                  //   "Please enter your valid data in order to create an account.",
                  // ),
                  const SizedBox(height: defaultPadding * 2),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _upiController,
                          decoration: const InputDecoration(
                            labelText: "Enter your UPI ID",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'UPI ID is required';
                            } else if (!upiPattern.hasMatch(value.trim())) {
                              return 'Enter a valid UPI ID (e.g. name@bank)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Text(
                        //   "Please Enter Valid UPI Id, Payment are transfer via UPI Id",
                        //   style: TextStyle(color: Colors.blue),
                        // ),
                        //
                        // const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        ToastUtil.show("Please enter a valid UPI ID");
                        return;
                      }

                      final upiId = _upiController.text.trim();

                      try {
                        final updateProfile = await backendServiceUpdateProfie()
                            .updateUPIId(
                              UPIId: upiId, // 👈 Send UPI ID to backend
                            );

                        if (updateProfile['status'] == false) {
                          ToastUtil.show(updateProfile['message']);
                          return;
                        }

                        ToastUtil.show(updateProfile['message']);
                        Navigator.pushNamed(context, entryPointScreenRoute);
                      } catch (e) {
                        print("error $e");
                        ToastUtil.show("Server Error");
                      }
                    },

                    child: const Text("Continue"),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text("Do you have an account?"),
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.pushNamed(context, logInScreenRoute);
                  //       },
                  //       child: const Text("Log in"),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
