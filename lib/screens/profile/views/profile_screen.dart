import 'dart:convert';

import 'package:agroconnect/screens/auth/views/auth_management.dart';
import 'package:agroconnect/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:agroconnect/components/list_tile/divider_list_tile.dart';
import 'package:agroconnect/components/network_image_with_loader.dart';
import 'package:agroconnect/constants.dart';
import 'package:agroconnect/route/screen_export.dart';
import 'package:http/http.dart' as http;

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String photoUrl = '';

  Future<void> getProfileData() async {
    try {
      var sessionToken = await secureStorage.read(key: "sessionToken");

      final response = await http.get(
        Uri.parse("$backendURL/user/getProfile"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sessionToken',
        },
      );

      if (response.statusCode == 200) {
        // Correct: decode the response body
        final responseData = jsonDecode(response.body);

        final userData = responseData["userData"];
        print("sessionToken $sessionToken");

        print("photoUrl ${userData['photoURL']}");

        setState(() {
          name = userData["name"] ?? '';
          email = userData["email"] ?? '';
          photoUrl = userData['photoURL'] ?? '';
        });
      } else {
        print("Failed to fetch profile: ${response.statusCode}");
        ToastUtil.show("Failed to load profile");
      }
    } catch (e) {
      print("Error fetching profile: $e");
      ToastUtil.show("Something went wrong");
    }
  }

  Future<void> init() async {
    await getProfileData();
    print("photoUrl $photoUrl");

  }

  void logout() async {
    try {
      await secureStorage.deleteAll();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginSelectionScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      debugPrint("error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    init(); // Safe async call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ProfileCard(
            name: name,
            email: email,
            imageSrc: photoUrl.isEmpty
                ? "assets/images/primary/farmer.png"
                : photoUrl,


            // imageSrc: photoUrl.isEmpty?Image.asset("assets/images/primary/farmer.png"),
            // proLableText: "Sliver",
            // isPro: true, if the user is pro
            press: () {
              Navigator.pushNamed(context, userProfileScreenRoute);
            },
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //       horizontal: defaultPadding, vertical: defaultPadding * 1.5),
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: const AspectRatio(
          //       aspectRatio: 1.8,
          //       child:
          //           NetworkImageWithLoader("https://i.imgur.com/dz0BBom.png"),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              "Account",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ProfileMenuListTile(
            text: "Orders",
            svgSrc: "assets/icons/Order.svg",
            press: () {
              // Navigator.pushNamed(context, ordersScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Returns",
            svgSrc: "assets/icons/Return.svg",
            press: () {},
          ),
          ProfileMenuListTile(
            text: "Wishlist",
            svgSrc: "assets/icons/Wishlist.svg",
            press: () {},
          ),
          ProfileMenuListTile(
            text: "Addresses",
            svgSrc: "assets/icons/Address.svg",
            press: () {
              // Navigator.pushNamed(context, addressesScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Payment",
            svgSrc: "assets/icons/card.svg",
            press: () {
              // Navigator.pushNamed(context, emptyPaymentScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Wallet",
            svgSrc: "assets/icons/Wallet.svg",
            press: () {
              // Navigator.pushNamed(context, walletScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Text(
              "Personalization",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          DividerListTileWithTrilingText(
            svgSrc: "assets/icons/Notification.svg",
            title: "Notification",
            trilingText: "Off",
            press: () {
              // Navigator.pushNamed(context, enableNotificationScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Preferences",
            svgSrc: "assets/icons/Preferences.svg",
            press: () {
              // Navigator.pushNamed(context, preferencesScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Text(
              "Settings",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: "Language",
            svgSrc: "assets/icons/Language.svg",
            press: () {
              // Navigator.pushNamed(context, selectLanguageScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Location",
            svgSrc: "assets/icons/Location.svg",
            press: () {},
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Text(
              "Help & Support",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: "Get Help",
            svgSrc: "assets/icons/Help.svg",
            press: () {
              // Navigator.pushNamed(context, getHelpScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "FAQ",
            svgSrc: "assets/icons/FAQ.svg",
            press: () {},
            isShowDivider: false,
          ),
          const SizedBox(height: defaultPadding),

          // Log Out
          ListTile(
            onTap: () {
              logout();
            },
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/Logout.svg",
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(errorColor, BlendMode.srcIn),
            ),
            title: const Text(
              "Log Out",
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          ),
        ],
      ),
    );
  }
}

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: [
//           ProfileCard(
//             name: "Sepide",
//             email: "theflutterway@gmail.com",
//             imageSrc: "https://i.imgur.com/IXnwbLk.png",
//             // proLableText: "Sliver",
//             // isPro: true, if the user is pro
//             press: () {
//               // Navigator.pushNamed(context, userInfoScreenRoute);
//             },
//           ),
//           // Padding(
//           //   padding: const EdgeInsets.symmetric(
//           //       horizontal: defaultPadding, vertical: defaultPadding * 1.5),
//           //   child: GestureDetector(
//           //     onTap: () {},
//           //     child: const AspectRatio(
//           //       aspectRatio: 1.8,
//           //       child:
//           //           NetworkImageWithLoader("https://i.imgur.com/dz0BBom.png"),
//           //     ),
//           //   ),
//           // ),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
//             child: Text(
//               "Account",
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//           ),
//           const SizedBox(height: defaultPadding / 2),
//           ProfileMenuListTile(
//             text: "Orders",
//             svgSrc: "assets/icons/Order.svg",
//             press: () {
//               // Navigator.pushNamed(context, ordersScreenRoute);
//             },
//           ),
//           ProfileMenuListTile(
//             text: "Returns",
//             svgSrc: "assets/icons/Return.svg",
//             press: () {},
//           ),
//           ProfileMenuListTile(
//             text: "Wishlist",
//             svgSrc: "assets/icons/Wishlist.svg",
//             press: () {},
//           ),
//           ProfileMenuListTile(
//             text: "Addresses",
//             svgSrc: "assets/icons/Address.svg",
//             press: () {
//               // Navigator.pushNamed(context, addressesScreenRoute);
//             },
//           ),
//           ProfileMenuListTile(
//             text: "Payment",
//             svgSrc: "assets/icons/card.svg",
//             press: () {
//               // Navigator.pushNamed(context, emptyPaymentScreenRoute);
//             },
//           ),
//           ProfileMenuListTile(
//             text: "Wallet",
//             svgSrc: "assets/icons/Wallet.svg",
//             press: () {
//               // Navigator.pushNamed(context, walletScreenRoute);
//             },
//           ),
//           const SizedBox(height: defaultPadding),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: defaultPadding, vertical: defaultPadding / 2),
//             child: Text(
//               "Personalization",
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//           ),
//           DividerListTileWithTrilingText(
//             svgSrc: "assets/icons/Notification.svg",
//             title: "Notification",
//             trilingText: "Off",
//             press: () {
//               // Navigator.pushNamed(context, enableNotificationScreenRoute);
//             },
//           ),
//           ProfileMenuListTile(
//             text: "Preferences",
//             svgSrc: "assets/icons/Preferences.svg",
//             press: () {
//               // Navigator.pushNamed(context, preferencesScreenRoute);
//             },
//           ),
//           const SizedBox(height: defaultPadding),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: defaultPadding, vertical: defaultPadding / 2),
//             child: Text(
//               "Settings",
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//           ),
//           ProfileMenuListTile(
//             text: "Language",
//             svgSrc: "assets/icons/Language.svg",
//             press: () {
//               // Navigator.pushNamed(context, selectLanguageScreenRoute);
//             },
//           ),
//           ProfileMenuListTile(
//             text: "Location",
//             svgSrc: "assets/icons/Location.svg",
//             press: () {},
//           ),
//           const SizedBox(height: defaultPadding),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: defaultPadding, vertical: defaultPadding / 2),
//             child: Text(
//               "Help & Support",
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//           ),
//           ProfileMenuListTile(
//             text: "Get Help",
//             svgSrc: "assets/icons/Help.svg",
//             press: () {
//               // Navigator.pushNamed(context, getHelpScreenRoute);
//             },
//           ),
//           ProfileMenuListTile(
//             text: "FAQ",
//             svgSrc: "assets/icons/FAQ.svg",
//             press: () {},
//             isShowDivider: false,
//           ),
//           const SizedBox(height: defaultPadding),
//
//           // Log Out
//           ListTile(
//             onTap: () {},
//             minLeadingWidth: 24,
//             leading: SvgPicture.asset(
//               "assets/icons/Logout.svg",
//               height: 24,
//               width: 24,
//               colorFilter: const ColorFilter.mode(
//                 errorColor,
//                 BlendMode.srcIn,
//               ),
//             ),
//             title: const Text(
//               "Log Out",
//               style: TextStyle(color: errorColor, fontSize: 14, height: 1),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
