import 'package:agroconnect/route/route_constants.dart';
import 'package:agroconnect/screens/userdata/address/update_user_data.dart';
import 'package:agroconnect/screens/userdata/address/user_form_address_address.dart';
import 'package:agroconnect/screens/userdata/user_form_data.dart';
import 'package:agroconnect/screens/userdata/validate_userdata.dart';
import 'package:agroconnect/utils/toast_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../constants.dart';

class UserAddressScreen extends StatefulWidget {
  final dynamic email;

  final dynamic name;

  final dynamic phoneNumber;

  final dynamic typeOfUser;

  final dynamic brandName;

  const UserAddressScreen({
    Key? key,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.typeOfUser,
    required this.brandName,
  }) : super(key: key);

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  final GlobalKey<UserAddressFormDataState> _userAddressFormKey =
      GlobalKey<UserAddressFormDataState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/primary/address_screen.jpg",
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              fit: BoxFit.fitHeight,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Center(
                    child: Text(
                      "Address Information",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // const Text(
                  //   "Please enter your valid data in order to create an account.",
                  // ),
                  const SizedBox(height: defaultPadding),
                  UserAddressFormData(key: _userAddressFormKey),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                    onPressed: () async {
                      final formState = _userAddressFormKey.currentState;

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
                        final email = widget.email;
                        final name = widget.typeOfUser;
                        final typeOfUser = widget.typeOfUser;
                        final phoneNumber = widget.phoneNumber;
                        final doorOrShopNo = formState.doorOrShopNo;
                        final street = formState.street;
                        final country = formState.country;
                        final city = formState.city;
                        final district = formState.district;
                        final taluk = formState.taluk;
                        final postalCode = formState.postalCode;
                        final state = formState.state;
                        final brandName = widget.brandName;
                        try {
                          print(
                            "functionCalled $email $name $phoneNumber $typeOfUser",
                          );
                          final updateProfile =
                              await backendServiceUpdateProfie()
                                  .updateUserProfile(
                                    email: email,
                                    phoneNumber: phoneNumber,
                                    typeOfUser: typeOfUser,
                                    name: name,
                                    doorOrShopNo: doorOrShopNo,
                                    country: country,
                                    city: city,
                                    state: state,
                                    taluk: taluk,
                                    street: street,
                                    postalCode: postalCode,
                                    district: district,
                                    brandName: brandName,
                                  );

                          print("erene $updateProfile");
                          if (updateProfile['status'] == false) {
                            ToastUtil.show(updateProfile['message']);
                            return;
                          }

                          ToastUtil.show("User Profile Updated Successfully");

                          Navigator.pushNamed(context, entryPointScreenRoute);
                        } catch (e) {
                          print("error $e");
                          ToastUtil.show(e.toString());
                          ToastUtil.show("Server Error");
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
