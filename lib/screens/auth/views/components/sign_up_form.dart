import 'package:agroconnect/screens/auth/views/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

// class SignUpForm extends StatelessWidget {
//   const SignUpForm({
//     super.key,
//     required this.formKey,
//   });
//
//   final GlobalKey<FormState> formKey;
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             onSaved: (emal) {
//               // Email
//             },
//             validator: emaildValidator.call,
//             textInputAction: TextInputAction.next,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: "Email address",
//               prefixIcon: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
//                 child: SvgPicture.asset(
//                   "assets/icons/Message.svg",
//                   height: 24,
//                   width: 24,
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .color!
//                         .withOpacity(0.3),
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: defaultPadding),
//           TextFormField(
//             onSaved: (pass) {
//               // Password
//             },
//             validator: passwordValidator.call,
//             obscureText: true,
//             decoration: InputDecoration(
//               hintText: "Password",
//               prefixIcon: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
//                 child: SvgPicture.asset(
//                   "assets/icons/Lock.svg",
//                   height: 24,
//                   width: 24,
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .color!
//                         .withOpacity(0.3),
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final _loginFormKey = GlobalKey<FormState>();
  bool securePassword = true;
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          TextFormField(
            validator: AppValidators.email,
            onSaved: (value) => _email = value!.trim(),
            decoration: InputDecoration(
              hintText: "Email address",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.75,
                ),
                child: SvgPicture.asset(
                  "assets/icons/Message.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            validator: AppValidators.password,
            onSaved: (value) => _password = value!.trim(),
            obscureText: securePassword,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.75,
                ),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    securePassword = !securePassword;
                  });
                },
                icon:
                    securePassword
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validate() => _loginFormKey.currentState?.validate() ?? false;

  void save() => _loginFormKey.currentState?.save();

  String get email => _email;

  String get password => _password;
}
