import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agroconnect/constants.dart';
import 'package:agroconnect/route/route_constants.dart';

import 'auth_management.dart';
import 'components/login_form.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupSelectionScreen extends StatefulWidget {
  const SignupSelectionScreen({super.key});

  @override
  State<SignupSelectionScreen> createState() => SignupSelectionScreenState();
}

class SignupSelectionScreenState extends State<SignupSelectionScreen> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<LogInFormState> _loginFormKey =
  GlobalKey<
      LogInFormState
  >(); // This key is used for accessing the form state

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/primary/merchant.jpg",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0), // ← This makes it look dull
              colorBlendMode: BlendMode.hardLight,
            ),
          ),

          // 🔹 Gradient overlay (e.g., dark at bottom)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, -0.5),
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent, // 0.0
                    Colors.white.withOpacity(0.3), // 0.4
                    Colors.green.withOpacity(0.8), // 0.7
                    Colors.green.withOpacity(0.9), // 1.0
                  ],
                  stops: [0.3, 0.4, 0.5, 1.0], // Controls spread of each color
                ),
              ),
            ),
          ),

          // 🔹 Main content scrollable
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 500), // Add some top padding
                    Text(
                      "Welcome back!",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        color: Colors.white, // Ensure visibility on dark bg
                      ),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    const Text(
                      "Log in with your data that you entered during registration.",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: defaultPadding*2),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, logInScreenRoute);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Rounded corners
                          // side: const BorderSide(
                          //   // color: Colors.white,  // Border color
                          //   // width: 2,             // Border width
                          // ),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: const Size.fromHeight(50), // optional: makes height uniform
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.mail_outline),
                          SizedBox(width: 10),
                          Text("Register with with Email"),
                        ],
                      ),
                    ),

                    const SizedBox(height: defaultPadding),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, phoneNumberSignupScreenRoute);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepOrangeAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Rounded corners
                          // side: const BorderSide(
                          //   // color: Colors.white,  // Border color
                          //   // width: 2,             // Border width
                          // ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.phone_outlined),
                          // SizedBox(width: 8),
                          Text("Register with Phone Number"),
                        ],
                        spacing: 8,
                      ),
                    ),

                    const SizedBox(height: defaultPadding / 2),

                    SizedBox(
                        height:defaultPadding
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("You already have an account?",
                            style: TextStyle(color: Colors.white)),
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, logInSelectionScreenRoute);
                          },
                          child: const Text("Sign In", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w700),),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // return Scaffold(
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         Image.asset("assets/images/login_dark.png", fit: BoxFit.cover),
    //         Padding(
    //           padding: const EdgeInsets.all(defaultPadding),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "Welcome back!",
    //                 style: Theme.of(context).textTheme.headlineSmall,
    //               ),
    //               const SizedBox(height: defaultPadding / 2),
    //               const Text(
    //                 "Continue Log in with your data that you intered during your registration.",
    //               ),
    //               const SizedBox(height: defaultPadding),
    //               LogInForm(key: _loginFormKey),
    //               Align(
    //                 child: TextButton(
    //                   child: const Text("Forgot password"),
    //                   onPressed: () {
    //                     Navigator.pushNamed(
    //                       context,
    //                       passwordRecoveryScreenRoute,
    //                     );
    //                   },
    //                 ),
    //               ),
    //               SizedBox(
    //                 height:
    //                 size.height > 700 ? size.height * 0.1 : defaultPadding,
    //               ),
    //               ElevatedButton(
    //                 onPressed: () async {
    //                   final formState = _loginFormKey.currentState;
    //
    //                   if (formState == null) {
    //                     Fluttertoast.showToast(
    //                       msg: "Form not ready yet. Try again.",
    //                       toastLength: Toast.LENGTH_SHORT,
    //                       gravity: ToastGravity.BOTTOM,
    //                       backgroundColor: Colors.black87,
    //                       textColor: Colors.white,
    //                       fontSize: 16.0,
    //                     );
    //
    //                     // ScaffoldMessenger.of(context).showSnackBar(
    //                     //   SnackBar(
    //                     //     content: Text("Form not ready yet. Try again."),
    //                     //   ),
    //                     // );
    //                     return;
    //                   }
    //
    //                   if (formState.validate()) {
    //                     formState.save();
    //                     final email = formState.email;
    //                     final password = formState.password;
    //
    //                     try {
    //                       final authService = AuthService();
    //                       final user = await authService.loginWithEmailPassword(
    //                         email: formState.email,
    //                         password: formState.password,
    //                       );
    //
    //                       Fluttertoast.showToast(
    //                         msg: "Login successful",
    //                         toastLength: Toast.LENGTH_SHORT,
    //                         gravity: ToastGravity.BOTTOM,
    //                         backgroundColor: Colors.black87,
    //                         textColor: Colors.white,
    //                         fontSize: 16.0,
    //                       );
    //                       // ScaffoldMessenger.of(context).showSnackBar(
    //                       //   SnackBar(content: Text("Login successful")),
    //                       // );
    //
    //                       String? profileStatus = await secureStorage.read(
    //                         key: 'profileStatus',
    //                       );
    //                       String? typeOfUser = await secureStorage.read(
    //                         key: 'typeOfUser',
    //                       );
    //
    //                       if (profileStatus != "true" ||
    //                           typeOfUser == "" ||
    //                           typeOfUser == null) {
    //                         Navigator.pushNamed(
    //                           context,
    //                           userDataInfoScreenRoute,
    //                           arguments: {
    //                             'email': formState.email,
    //                             'phoneNumber': null,
    //                           },
    //                         );
    //                       } else {
    //                         Navigator.pushNamed(context, entryPointScreenRoute);
    //                       }
    //
    //                       // Navigate to next screen
    //                     } catch (e) {
    //                       Fluttertoast.showToast(
    //                         msg: e.toString(),
    //                         toastLength: Toast.LENGTH_SHORT,
    //                         gravity: ToastGravity.BOTTOM,
    //                         backgroundColor: Colors.black87,
    //                         textColor: Colors.white,
    //                         fontSize: 16.0,
    //                       );
    //                       // ScaffoldMessenger.of(context).showSnackBar(
    //                       //   SnackBar(content: Text(e.toString())),
    //                       // );
    //                     }
    //                   }
    //                 },
    //
    //                 // onPressed: () async {
    //                 //   if (_formKey.currentState!.validate()) {
    //                 //     _formKey.currentState!.save();
    //                 //
    //                 //     final loginFormState =
    //                 //         _formKey.currentState as FormState;
    //                 //     // final formWidget = _formKey.currentWidget as LogInForm;
    //                 //     final formState = _loginFormKey.currentState!;
    //                 //     // final email = (formWidget as LogInFormState).email;
    //                 //     // final password = (formWidget as LogInFormState).password;
    //                 //
    //                 //     final email = formState.email;
    //                 //     final password = formState.password;
    //                 //
    //                 //     try {
    //                 //       final authService = AuthService();
    //                 //       final user = await authService.loginWithEmailPassword(
    //                 //         email: email,
    //                 //         password: password,
    //                 //       );
    //                 //
    //                 //       // if (user != null) {
    //                 //       //   Navigator.pushReplacementNamed(context, entryPointScreenRoute);
    //                 //       // }
    //                 //     } catch (e) {
    //                 //       ScaffoldMessenger.of(
    //                 //         context,
    //                 //       ).showSnackBar(SnackBar(content: Text(e.toString())));
    //                 //     }
    //                 //   }
    //                 // },
    //
    //                 // onPressed: () {
    //                 //   if (_formKey.currentState!.validate()) {
    //                 //     Navigator.pushNamedAndRemoveUntil(
    //                 //         context,
    //                 //         entryPointScreenRoute,
    //                 //         ModalRoute.withName(logInScreenRoute));
    //                 //   }
    //                 // },
    //                 child: const Text("Log in"),
    //               ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   const Text("Don't have an account?"),
    //                   TextButton(
    //                     onPressed: () {
    //                       Navigator.pushNamed(context, signUpScreenRoute);
    //                     },
    //                     child: const Text("Sign up"),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
