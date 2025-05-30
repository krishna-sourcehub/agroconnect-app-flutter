import 'package:agroconnect/screens/auth/views/password_form_data.dart';
import 'package:agroconnect/screens/auth/views/validators.dart';
import 'package:agroconnect/utils/toast_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agroconnect/constants.dart';
import 'package:agroconnect/route/route_constants.dart';
import 'package:flutter_svg/svg.dart';

import 'auth_management.dart';
import 'components/login_form.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomPasswordRecoveryScreen extends StatefulWidget {
  const CustomPasswordRecoveryScreen({super.key});

  @override
  State<CustomPasswordRecoveryScreen> createState() =>
      _CustomPasswordRecoveryScreenState();
}

class _CustomPasswordRecoveryScreenState
    extends State<CustomPasswordRecoveryScreen> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<PasswordFormState> _passwordFormKey =
      GlobalKey<
        PasswordFormState
      >(); // This key is used for accessing the form state

  String _email = '';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/images/primary/loginScreen.jpg", fit: BoxFit.cover, height: 400, width: 400,),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Password Recovery",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Reset password link will sent to mail",
                  ),
                  const SizedBox(height: defaultPadding),
                  PasswordForm(key: _passwordFormKey),
                  // const Text(
                  //   "Log in with your data that you intered during your registration.",
                  // ),
                  const SizedBox(height: defaultPadding),

                  SizedBox(height: defaultPadding * 2),
                  ElevatedButton(
                    onPressed: () async {
                      final formState = _passwordFormKey.currentState;

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

                        try {
                          final authService = AuthService();
                          final resetMailStatus = await authService
                              .sendPasswordResetMail(email: formState.email);

                          if (resetMailStatus['status'] == "false") {
                            ToastUtil.show(resetMailStatus["message"]!);
                          } else {
                            ToastUtil.show(resetMailStatus['message']!);
                            await Future.delayed(Duration(seconds: 1));
                            Navigator.pushNamed(context, logInScreenRoute);

                          }

                          // Navigate to next screen
                        } catch (e) {
                          ToastUtil.show("Server Error");
                          print("error $e");
                        }
                      }
                    },

                    child: const Text("Send Password Recovery Mail"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Go to Login Page"),
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero), // Remove internal padding
                          minimumSize: MaterialStateProperty.all(Size(0, 0)),   // Remove minimum button size
                          // tapTargetSize: MaterialTapTargetSize.shrinkWrap,      // Shrink touch area
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, logInScreenRoute);
                        },
                        child: const Text("Log in"),
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
