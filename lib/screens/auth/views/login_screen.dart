import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agroconnect/constants.dart';
import 'package:agroconnect/route/route_constants.dart';

import 'auth_management.dart';
import 'components/login_form.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<LogInFormState> _loginFormKey =
      GlobalKey<
        LogInFormState
      >(); // This key is used for accessing the form state

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/images/primary/loginflow1.jpg", fit: BoxFit.cover, height: 350,),
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
                    "Log in with your data that you intered during your registration.",
                  ),
                  const SizedBox(height: defaultPadding),
                  LogInForm(key: _loginFormKey),
                  Align(
                    child: TextButton(
                      child: const Text("Forgot password"),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          passwordRecoveryScreenRoute,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    // height:
                    //     size.height > 700 ? size.height * 0.1 : defaultPadding,
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final formState = _loginFormKey.currentState;

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

                      if (formState.validate()) {
                        formState.save();
                        final email = formState.email;
                        final password = formState.password;

                        try {
                          final authService = AuthService();
                          final user = await authService.loginWithEmailPassword(
                            email: formState.email,
                            password: formState.password,
                          );

                          Fluttertoast.showToast(
                            msg: "Login successful",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black87,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text("Login successful")),
                          // );

                          String? profileStatus = await secureStorage.read(
                            key: 'profileStatus',
                          );
                          String? typeOfUser = await secureStorage.read(
                            key: 'typeOfUser',
                          );

                          String? UPIUpdateStatus = await secureStorage.read(
                            key: 'UPIUpdateStatus',
                          );

                          if (profileStatus != "true" ||
                              typeOfUser == "" ||
                              typeOfUser == null) {
                            Navigator.pushNamed(
                              context,
                              userDataInfoScreenRoute,
                              arguments: {
                                'email': formState.email,
                                'phoneNumber': null,
                              },
                            );
                          } else {
                            if (typeOfUser == "farmer") {
                              if (UPIUpdateStatus != "true" ||
                                  UPIUpdateStatus == "" ||
                                  UPIUpdateStatus == null) {
                                Navigator.pushNamed(
                                  context,
                                  getupiIdScreenRoute,
                                );
                              }
                            }
                            else{
                              Navigator.pushNamed(context, entryPointScreenRoute);

                            }

                          }

                          // Navigate to next screen
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: e.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black87,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text(e.toString())),
                          // );
                        }
                      }
                    },

                    // onPressed: () async {
                    //   if (_formKey.currentState!.validate()) {
                    //     _formKey.currentState!.save();
                    //
                    //     final loginFormState =
                    //         _formKey.currentState as FormState;
                    //     // final formWidget = _formKey.currentWidget as LogInForm;
                    //     final formState = _loginFormKey.currentState!;
                    //     // final email = (formWidget as LogInFormState).email;
                    //     // final password = (formWidget as LogInFormState).password;
                    //
                    //     final email = formState.email;
                    //     final password = formState.password;
                    //
                    //     try {
                    //       final authService = AuthService();
                    //       final user = await authService.loginWithEmailPassword(
                    //         email: email,
                    //         password: password,
                    //       );
                    //
                    //       // if (user != null) {
                    //       //   Navigator.pushReplacementNamed(context, entryPointScreenRoute);
                    //       // }
                    //     } catch (e) {
                    //       ScaffoldMessenger.of(
                    //         context,
                    //       ).showSnackBar(SnackBar(content: Text(e.toString())));
                    //     }
                    //   }
                    // },

                    // onPressed: () {
                    //   if (_formKey.currentState!.validate()) {
                    //     Navigator.pushNamedAndRemoveUntil(
                    //         context,
                    //         entryPointScreenRoute,
                    //         ModalRoute.withName(logInScreenRoute));
                    //   }
                    // },
                    child: const Text("Log in"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, signUpScreenRoute);
                        },
                        child: const Text("Sign up"),
                      ),
                    ],
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
