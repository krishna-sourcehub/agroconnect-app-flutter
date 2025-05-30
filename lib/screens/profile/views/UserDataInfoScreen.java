import 'package:agroconnect/screens/userdata/user_form_data.dart';
import 'package:agroconnect/screens/userdata/validate_userdata.dart';
import 'package:agroconnect/utils/toast_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:agroconnect/screens/userdata/user_form_data.dart';
import 'package:agroconnect/route/route_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants.dart';

class UserDataInfoScreen extends StatefulWidget {
  final String? email;
  final String? phoneNumber;

  const UserDataInfoScreen({
    Key? key,
    required this.email,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<UserDataInfoScreen> createState() => _UserDataInfoScreenState();
}

class _UserDataInfoScreenState extends State<UserDataInfoScreen> {
  final GlobalKey<UserFormDataState> _userFormKey =
      GlobalKey<UserFormDataState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/primary/merchant4.jpg",
              // height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              // fit: BoxFit.fitHeight,
              fit: BoxFit.cover,
              height: 350,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "User Information",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  // const SizedBox(height: defaultPadding / 2),
                  // const Text(
                  //   "Please enter your valid data in order to create an account.",
                  // ),
                  const SizedBox(height: defaultPadding),
                  // UserFormData(key: _userFromKey),
                  UserFormData(
                    key: _userFormKey,
                    email: widget.email,
                    phoneNumber: widget.phoneNumber,
                  ),
                  const SizedBox(height: defaultPadding),
                  // Row(
                  //   children: [
                  //     Checkbox(onChanged: (value) {}, value: false),
                  //     Expanded(
                  //       child: Text.rich(
                  //         TextSpan(
                  //           text: "I agree with the",
                  //           children: [
                  //             TextSpan(
                  //               recognizer:
                  //               TapGestureRecognizer()
                  //                 ..onTap = () {
                  //                   Navigator.pushNamed(
                  //                     context,
                  //                     termsOfServicesScreenRoute,
                  //                   );
                  //                 },
                  //               text: " Terms of service ",
                  //               style: const TextStyle(
                  //                 color: primaryColor,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //             const TextSpan(text: "& privacy policy."),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: defaultPadding * 1),
                  ElevatedButton(
                    onPressed: () async {
                      final formState = _userFormKey.currentState;

                      if (formState == null) {
                        Fluttertoast.showToast(
                          msg: "Form not ready yet. Try again.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black87,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text("Form not ready yet. Try again."),
                        //   ),
                        // );
                        return;
                      }

                      if (formState != null && formState.validate()) {
                        formState.save();
                        print(
                          "email ${formState.name}, ${formState.typeOfUser}",
                        );
                        final email = formState.email;
                        final phoneNumber = formState.phoneNumber;
                        final brandName = formState.brandName;
                        try {
                          final userDetail = await backendService()
                              .verifyUserDetail(
                                email: email,
                                phoneNumber: phoneNumber,
                                brandName: brandName,
                              );
                          print("userDetail $userDetail");
                          if (userDetail['status'] == false) {
                            ToastUtil.show(userDetail['message']);
                            return;
                          }
                          ToastUtil.show("User Detail Verified Successfully");

                          Navigator.pushNamed(
                            context,
                            userAddressScreenRoute,
                            arguments: {
                              'email': formState.email,
                              'name': formState.name,
                              'phoneNumber': formState.phoneNumber,
                              'typeOfUser': formState.typeOfUser,
                              'brandName':formState.brandName
                            },
                          );
                        } catch (e) {
                          print("object $e");
                          ToastUtil.show(e.toString());
                        }
                        // Continue with further actions
                        // For example: navigating to another screen
                      }
                    },

                    // onPressed: () {
                    //   // There is 2 more screens while user complete their profile
                    //   // afre sign up, it's available on the pro version get it now
                    //   // 🔗 https://theflutterway.gumroad.com/l/fluttershop
                    //   Navigator.pushNamed(context, entryPointScreenRoute);
                    // },
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
