import 'dart:async';
import 'package:agroconnect/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:agroconnect/constants.dart';
import 'package:agroconnect/route/route_constants.dart';
import 'package:pinput/pinput.dart';

import 'auth_management.dart';

class PhoneNumberOtpVerifyScreen extends StatefulWidget {
  final String phoneNumber;

  const PhoneNumberOtpVerifyScreen({required this.phoneNumber, Key? key})
    : super(key: key);

  @override
  State<PhoneNumberOtpVerifyScreen> createState() =>
      _PhoneNumberOtpVerifyState();
}

class _PhoneNumberOtpVerifyState extends State<PhoneNumberOtpVerifyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phoneNumber = '';

  String _otpCode = '';
  bool freezeButton = true;

  // Timer-related
  late Timer _timer;
  int _remainingTime = 60;
  bool _showResendButton = false;

  @override
  void initState() {
    super.initState();
    _phoneNumber = widget.phoneNumber;
    startOtpTimer();
  }

  void startOtpTimer() {
    _remainingTime = 60;
    _showResendButton = false;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        timer.cancel();
        setState(() {
          _showResendButton = true;
        });
        // Auto-navigate or enable resend logic
        // Navigator.pushReplacementNamed(context, '/login'); // Uncomment if you want auto-navigate
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PinTheme defaultTheme = PinTheme(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      height: 65,
      width: 50,
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/images/primary/farmerwithsmartphonehd.jpg", fit: BoxFit.cover,
            height: 350,),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Log in with your data that you entered during registration.",
                  ),
                  const SizedBox(height: 80),

                  /// FORM FOR PHONE INPUT
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Pinput(
                          hapticFeedbackType: HapticFeedbackType.heavyImpact,
                          defaultPinTheme: defaultTheme,
                          focusedPinTheme: defaultTheme.copyBorderWith(
                            border: Border.all(color: Colors.green, width: 2),
                          ),
                          errorPinTheme: defaultTheme.copyBorderWith(
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.disabled,
                          // disable frontend validation
                          length: 4,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          onCompleted: (pin) {
                            _otpCode = pin; // store pin and validate on submit
                          },
                        ),

                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  freezeButton ? Colors.green : Colors.grey,
                            ),
                            onPressed:
                                freezeButton
                                    ? () async {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        _formKey.currentState?.save();

                                        try {
                                          if (_otpCode.length == 4) {
                                            // Ensure OTP is numeric before parsing
                                            if (RegExp(
                                              r'^\d{4}$',
                                            ).hasMatch(_otpCode)) {
                                              final response =
                                                  await AuthService()
                                                      .verifyPhoneNumberOtp(
                                                        phoneNumber:
                                                            _phoneNumber,
                                                        OTP: int.parse(
                                                          _otpCode,
                                                        ),
                                                      );
                                              setState(() {
                                                freezeButton = false;
                                              });

                                              if (response['status'] == true) {
                                                setState(() {
                                                  freezeButton = true;
                                                });
                                                ToastUtil.show(
                                                  response["message"],
                                                );
                                                ToastUtil.show(
                                                  "Login Successfully",
                                                );

                                                String? profileStatus =
                                                    await secureStorage.read(
                                                      key: 'profileStatus',
                                                    );
                                                String? typeOfUser =
                                                    await secureStorage.read(
                                                      key: 'typeOfUser',
                                                    );
                                                String? UPIUpdateStatus =
                                                    await secureStorage.read(
                                                      key: 'UPIUpdateStatus',
                                                    );

                                                if (profileStatus != "true" ||
                                                    typeOfUser == "" ||
                                                    typeOfUser == null) {
                                                  Navigator.pushNamed(
                                                    context,
                                                    userDataInfoScreenRoute,
                                                    arguments: {
                                                      'email': null,
                                                      'phoneNumber':
                                                      _phoneNumber.substring(3),
                                                    },
                                                  );
                                                } else {
                                                  if (typeOfUser == "farmer") {
                                                    if (UPIUpdateStatus !=
                                                            "true" ||
                                                        UPIUpdateStatus == "" ||
                                                        UPIUpdateStatus ==
                                                            null) {
                                                      Navigator.pushNamed(
                                                        context,
                                                        getupiIdScreenRoute,
                                                      );
                                                    }
                                                  } else {
                                                    Navigator.pushNamed(
                                                      context,
                                                      entryPointScreenRoute,
                                                    );
                                                  }
                                                }

                                                // Navigate to next screen if needed
                                              } else {
                                                setState(() {
                                                  freezeButton = true;
                                                });
                                                ToastUtil.show(
                                                  response["message"],
                                                );
                                              }
                                            } else {
                                              ToastUtil.show(
                                                "OTP must be numeric",
                                              );
                                            }
                                          } else {
                                            ToastUtil.show(
                                              "Enter a valid 4-digit OTP",
                                            );
                                          }
                                        } catch (e) {
                                          setState(() {
                                            freezeButton = true;
                                          });
                                          debugPrint("Error occurred: $e");
                                          ToastUtil.show(
                                            "An error occurred. Please try again.",
                                          );
                                        }
                                      } else {
                                        ToastUtil.show(
                                          "Please enter a valid phone number",
                                        );
                                      }
                                    }
                                    : null,
                            child: const Text("Verify OTP"),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Center(
                          child: Text(
                            _showResendButton
                                ? "Didn't receive the code?"
                                : 'Resend available in $_remainingTime seconds',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        if (_showResendButton)
                          Center(
                            child: TextButton(
                              onPressed: () async {
                                final response = await AuthService()
                                    .validateLogInPhoneNumberAndSentOtp(
                                      phoneNumber: _phoneNumber,
                                    );
                                if (response['status'] == true) {
                                  startOtpTimer();
                                  ToastUtil.show("OTP Successfully Resend");
                                } else {
                                  debugPrint("$response");
                                  ToastUtil.show("Resend OTP Failed");
                                }
                              },

                              child: const Text("Resend OTP"),
                            ),
                          ),

                        SizedBox(height: 10),

                        const SizedBox(height: 16),
                        SizedBox(
                          height:
                              size.height > 700
                                  ? size.height * 0.1
                                  : defaultPadding,
                        ),

                        // /// LOGIN BUTTON
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     if (_formKey.currentState?.validate() ??
                        //         false) {
                        //       _formKey.currentState?.save();
                        //
                        //       try {
                        //         final response = await AuthService()
                        //             .verifyPhoneNumberOtp(
                        //           phoneNumber: _phoneNumber,
                        //           OTP: 1, // or actual OTP if already available
                        //         );
                        //
                        //         if (response['status'] == true) {
                        //           ToastUtil.show(response["message"]);
                        //           // You may navigate to OTP entry screen here
                        //         } else {
                        //           ToastUtil.show(response["message"]);
                        //         }
                        //       } catch (e) {
                        //         debugPrint("Error occurred: $e");
                        //         ToastUtil.show(
                        //             "An error occurred. Please try again.");
                        //       }
                        //     } else {
                        //       ToastUtil.show(
                        //           "Please enter a valid phone number");
                        //     }
                        //   },
                        //   child: const Text("Log in"),
                        // ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     const Text("Don't have an account?"),
                        //     TextButton(
                        //       onPressed: () {
                        //         Navigator.pushNamed(
                        //             context, signUpScreenRoute);
                        //       },
                        //       child: const Text("Sign up"),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:agroconnect/screens/auth/views/validators.dart';
// import 'package:agroconnect/utils/toast_util.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:agroconnect/constants.dart';
// import 'package:agroconnect/route/route_constants.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:intl_phone_field/phone_number.dart';
//
// import 'auth_management.dart';
//
// class PhoneNumberOtpVerifyScreen extends StatefulWidget {
//   const PhoneNumberOtpVerifyScreen({required phoneNumber, super.key});
//
//   @override
//   State<PhoneNumberOtpVerifyScreen> createState() => PhoneNumberOtpVerifyState();
// }
//
// class PhoneNumberOtpVerifyState extends State<PhoneNumberOtpVerifyScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String _phoneNumber = '';
//
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Image.asset("assets/images/login_dark.png", fit: BoxFit.cover),
//             Padding(
//               padding: const EdgeInsets.all(defaultPadding),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Welcome back!",
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                   const SizedBox(height: defaultPadding / 2),
//                   const Text(
//                     "Log in with your data that you entered during registration.",
//                   ),
//                   const SizedBox(height: defaultPadding),
//
//                   /// FORM FOR PHONE INPUT
//                   Form(
//                     key: _formKey,
//                     child: FormField<PhoneNumber>(
//                       validator: (phone) {
//                         print("validate $phone");
//                         final number = phone?.number ?? '';
//                         if (number.trim().isEmpty) {
//                           return 'Phone number is required';
//                         }
//                         // final pattern = RegExp(r'^[6-9]\d{9}$');
//                         final pattern = RegExp(r'^\d{10}$');
//
//                         if (!pattern.hasMatch(number)) {
//                           return 'Enter a valid 10-digit phone number';
//                         }
//                         return null;
//                       },
//                       builder: (field) => Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           IntlPhoneField(
//                             onChanged: (phone) {
//                               field.didChange(phone);
//                               _phoneNumber = phone.completeNumber;
//                             },
//                             onSaved: (phone) {
//                               field.didChange(phone);
//                               if (phone != null) {
//                                 _phoneNumber = phone.completeNumber;
//                               }
//                             },
//                             initialValue: '',
//                             decoration: InputDecoration(
//                               labelText: 'Phone Number',
//                               border: const OutlineInputBorder(),
//                               errorText: field.errorText,
//                               focusColor: Colors.green,
//                               // floatingLabelStyle: TextStyle(color: Colors.green),
//                               // labelStyle: TextStyle(color: Colors.grey)
//                             ),
//                             initialCountryCode: 'IN',
//                             dropdownIconPosition: IconPosition.trailing,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   SizedBox(
//                     height: size.height > 700
//                         ? size.height * 0.1
//                         : defaultPadding,
//                   ),
//
//                   /// LOGIN BUTTON
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (_formKey.currentState?.validate() ?? false) {
//                         _formKey.currentState?.save();
//
//                         try {
//                           final response = await AuthService()
//                               .verifyPhoneNumberOtp(
//                             phoneNumber: _phoneNumber, OTP: null,
//                           );
//
//                           if (response['status'] == true) {
//                             ToastUtil.show(response["message"]);
//                             // Optionally navigate to OTP verification screen
//                           } else {
//                             ToastUtil.show(response["message"]);
//                           }
//                         } catch (e) {
//                           debugPrint("Error occurred: $e");
//                           ToastUtil.show("An error occurred. Please try again.");
//                         }
//                       } else {
//                         ToastUtil.show("Please enter a valid phone number");
//                       }
//                     },
//                     child: const Text("Log in"),
//                   ),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Don't have an account?"),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, signUpScreenRoute);
//                         },
//                         child: const Text("Sign up"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // import 'dart:ffi';
// //
// // import 'package:agroconnect/screens/auth/views/validators.dart';
// // import 'package:agroconnect/utils/toast_util.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:agroconnect/constants.dart';
// // import 'package:agroconnect/route/route_constants.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:intl_phone_field/intl_phone_field.dart';
// // import 'package:intl_phone_field/phone_number.dart';
// //
// // import 'auth_management.dart';
// // import 'components/login_form.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// //
// // class PhoneNumberLoginScreen extends StatefulWidget {
// //   const PhoneNumberLoginScreen({super.key});
// //
// //   @override
// //   State<PhoneNumberLoginScreen> createState() => PhoneNumberLoginState();
// // }
// //
// // class PhoneNumberLoginState extends State<PhoneNumberLoginScreen> {
// //   // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// //
// //   // This key is used for accessing the form state
// //
// //   String _phoneNumber = '';
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final Size size = MediaQuery
// //         .of(context)
// //         .size;
// //
// //     return Scaffold(
// //         body: SingleChildScrollView(
// //         child: Column(
// //         children: [
// //         Image.asset("assets/images/login_dark.png", fit: BoxFit.cover),
// //     Padding(
// //     padding: const EdgeInsets.all(defaultPadding),
// //     child: Column(
// //     crossAxisAlignment: CrossAxisAlignment.start,
// //     children: [
// //     Text(
// //     "Welcome back!",
// //     style: Theme.of(context).textTheme.headlineSmall,
// //     ),
// //     const SizedBox(height: defaultPadding / 2),
// //     const Text(
// //     "Log in with your data that you intered during your registration.",
// //     ),
// //     const SizedBox(height: defaultPadding),
// //     Form(
// //     key: _formKey,
// //     child: FormField<PhoneNumber>(
// //     validator: (phone) {
// //     final number = phone?.number ?? '';
// //     if (number.trim().isEmpty)
// //     return 'Phone number is required';
// //     final pattern = RegExp(r'^[6-9]\d{9}$');
// //     if (!pattern.hasMatch(number))
// //     return 'Enter a valid 10-digit phone number';
// //     return null;
// //     },
// //     builder:
// //     (field) => Column(
// //     crossAxisAlignment: CrossAxisAlignment.start,
// //     children: [
// //     IntlPhoneField(
// //     onChanged: (phone) {
// //     field.didChange(phone);
// //     _phoneNumber = phone.completeNumber;
// //     },
// //     onSaved: (phone) {
// //     if (phone != null) {
// //     _phoneNumber = phone.completeNumber;
// //     }
// //     },
// //     initialValue: '',
// //     decoration: InputDecoration(
// //     labelText: 'Phone Number',
// //     border: OutlineInputBorder(),
// //     errorText: field.errorText,
// //     ),
// //     initialCountryCode: 'IN',
// //     dropdownIconPosition: IconPosition.trailing,
// //     ),
// //     ],
// //     ),
// //     ),
// //     ),
// //
// //     const SizedBox(height: 16),
// //     // Align(
// //     //   child: TextButton(
// //     //     child: const Text("Forgot password"),
// //     //     onPressed: () {
// //     //       Navigator.pushNamed(
// //     //         context,
// //     //         passwordRecoveryScreenRoute,
// //     //       );
// //     //     },
// //     //   ),
// //     // ),
// //     SizedBox(
// //     height:
// //     size.height > 700 ? size.height * 0.1 : defaultPadding,
// //     ),
// //     ElevatedButton(
// //     onPressed: () async {
// //     if (_formKey.currentState?.validate() ?? false) {
// //     _formKey.currentState?.save();
// //     final formState= _formKey.currentState;
// //     if (formState == null) {
// //     Fluttertoast.showToast(
// //     msg: "Form not ready yet. Try again.",
// //     toastLength: Toast.LENGTH_SHORT,
// //     gravity: ToastGravity.BOTTOM,
// //     backgroundColor: Colors.black87,
// //     textColor: Colors.white,
// //     fontSize: 16.0,
// //     );
// //
// //
// //     try {
// //     final response= await AuthService().validateLogInPhoneNumberAndSentOtp(phoneNumber: formState.phoneNumber);
// //       if(response['status']==true){
// //         ToastUtil.show(response["message"]);
// //       }
// //       else{
// //         ToastUtil.show(response["message"]);
// //       }
// //
// //
// //     } catch (e) {
// //
// //       debugPrint("Error Occurred $e");
// //       ToastUtil.show("Error Occurred");
// //
// //
// //     }
// //     }
// //
// //     // // final formState = _loginFormKey.currentState;
// //     //
// //     // if (formState == null) {
// //     //   Fluttertoast.showToast(
// //     //     msg: "Form not ready yet. Try again.",
// //     //     toastLength: Toast.LENGTH_SHORT,
// //     //     gravity: ToastGravity.BOTTOM,
// //     //     backgroundColor: Colors.black87,
// //     //     textColor: Colors.white,
// //     //     fontSize: 16.0,
// //     //   );
// //     //
// //     //   // ScaffoldMessenger.of(context).showSnackBar(
// //     //   //   SnackBar(
// //     //   //     content: Text("Form not ready yet. Try again."),
// //     //   //   ),
// //     //   // );
// //     //   return;
// //     // }
// //     //
// //     // if (formState.validate()) {
// //     //   formState.save();
// //     //   final email = formState.email;
// //     //   final password = formState.password;
// //     //
// //     //   try {
// //     //     final authService = AuthService();
// //     //     final user = await authService.loginWithEmailPassword(
// //     //       email: formState.email,
// //     //       password: formState.password,
// //     //     );
// //     //
// //     //     Fluttertoast.showToast(
// //     //       msg: "Login successful",
// //     //       toastLength: Toast.LENGTH_SHORT,
// //     //       gravity: ToastGravity.BOTTOM,
// //     //       backgroundColor: Colors.black87,
// //     //       textColor: Colors.white,
// //     //       fontSize: 16.0,
// //     //     );
// //     //     // ScaffoldMessenger.of(context).showSnackBar(
// //     //     //   SnackBar(content: Text("Login successful")),
// //     //     // );
// //     //
// //     //     String? profileStatus = await secureStorage.read(
// //     //       key: 'profileStatus',
// //     //     );
// //     //     String? typeOfUser = await secureStorage.read(
// //     //       key: 'typeOfUser',
// //     //     );
// //     //
// //     //     if (profileStatus != "true" ||
// //     //         typeOfUser == "" ||
// //     //         typeOfUser == null) {
// //     //       Navigator.pushNamed(
// //     //         context,
// //     //         userDataInfoScreenRoute,
// //     //         arguments: {
// //     //           'email': formState.email,
// //     //           'phoneNumber': null,
// //     //         },
// //     //       );
// //     //     } else {
// //     //       Navigator.pushNamed(context, entryPointScreenRoute);
// //     //     }
// //
// //     // Navigate to next screen
// //     //     } catch (e) {
// //     //       Fluttertoast.showToast(
// //     //         msg: e.toString(),
// //     //         toastLength: Toast.LENGTH_SHORT,
// //     //         gravity: ToastGravity.BOTTOM,
// //     //         backgroundColor: Colors.black87,
// //     //         textColor: Colors.white,
// //     //         fontSize: 16.0,
// //     //       );
// //     //       // ScaffoldMessenger.of(context).showSnackBar(
// //     //       //   SnackBar(content: Text(e.toString())),
// //     //       // );
// //     //     }
// //     //   }
// //     // },
// //
// //     // onPressed: () async {
// //     //   if (_formKey.currentState!.validate()) {
// //     //     _formKey.currentState!.save();
// //     //
// //     //     final loginFormState =
// //     //         _formKey.currentState as FormState;
// //     //     // final formWidget = _formKey.currentWidget as LogInForm;
// //     //     final formState = _loginFormKey.currentState!;
// //     //     // final email = (formWidget as LogInFormState).email;
// //     //     // final password = (formWidget as LogInFormState).password;
// //     //
// //     //     final email = formState.email;
// //     //     final password = formState.password;
// //     //
// //     //     try {
// //     //       final authService = AuthService();
// //     //       final user = await authService.loginWithEmailPassword(
// //     //         email: email,
// //     //         password: password,
// //     //       );
// //     //
// //     //       // if (user != null) {
// //     //       //   Navigator.pushReplacementNamed(context, entryPointScreenRoute);
// //     //       // }
// //     //     } catch (e) {
// //     //       ScaffoldMessenger.of(
// //     //         context,
// //     //       ).showSnackBar(SnackBar(content: Text(e.toString())));
// //     //     }
// //     //   }
// //     // },
// //
// //     // onPressed: () {
// //     //   if (_formKey.currentState!.validate()) {
// //     //     Navigator.pushNamedAndRemoveUntil(
// //     //         context,
// //     //         entryPointScreenRoute,
// //     //         ModalRoute.withName(logInScreenRoute));
// //     //   }
// //     // },
// //     child: const Text("Log in"),
// //     ),
// //     Row(
// //     mainAxisAlignment: MainAxisAlignment.center,
// //     children: [
// //     const Text("Don't have an account?"),
// //     TextButton(
// //     onPressed: () {
// //     Navigator.pushNamed(context, signUpScreenRoute);
// //     },
// //     child: const Text("Sign up"),
// //     ),
// //     ],
// //     ),
// //     ],
// //     ),
// //     ),
// //     ],
// //     ),
// //     ),
// //     );
// //     }
// //   }
