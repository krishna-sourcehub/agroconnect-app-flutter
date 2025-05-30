import 'dart:convert';
import 'package:agroconnect/screens/profile/views/user_editProfile_screen.dart';
import 'package:agroconnect/screens/profile/views/user_edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../utils/toast_util.dart';
import '../../auth/views/auth_management.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}


// class _UserProfileScreenState extends State<UserProfileScreen> {
//   String name = "", phoneNumber = "", email = "", brandName = "", photoUrl = "", typeOfUser = "";
//   bool isEditing = false;
//   bool isLoading = true;
//
//   late TextEditingController nameController;
//   late TextEditingController phoneController;
//   late TextEditingController emailController;
//   late TextEditingController brandController;
//
//   @override
//   void initState() {
//     super.initState();
//     getProfileData();
//   }
//
//   Future<void> getProfileData() async {
//     try {
//       var sessionToken = await secureStorage.read(key: "sessionToken");
//
//       final response = await http.get(
//         Uri.parse("$backendURL/user/getProfile"),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $sessionToken',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final userData = jsonDecode(response.body)["userData"];
//
//         name = userData["name"] ?? '';
//         email = userData["email"] ?? '';
//         phoneNumber = userData["phoneNumber"] ?? '';
//         typeOfUser = userData["typeOfUser"] ?? '';
//         brandName = userData["brandName"] ?? '';
//         photoUrl = userData["photoURL"] ?? '';
//
//         nameController = TextEditingController(text: name);
//         phoneController = TextEditingController(text: phoneNumber);
//         emailController = TextEditingController(text: email);
//         brandController = TextEditingController(text: brandName);
//       } else {
//         ToastUtil.show("Failed to load profile");
//       }
//     } catch (e) {
//       ToastUtil.show("Something went wrong");
//     }
//
//     setState(() {
//       isLoading = false; // ✅ Now we can build safely
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               if (isEditing) {
//                 // Save profile logic here
//                 setState(() {
//                   name = nameController.text;
//                   email = emailController.text;
//                   phoneNumber = phoneController.text;
//                   brandName = brandController.text;
//                   isEditing = false;
//                 });
//                 ToastUtil.show("Profile updated");
//               } else {
//                 setState(() => isEditing = true);
//               }
//             },
//             child: Text(isEditing ? "Save" : "Edit", style: const TextStyle(color: Colors.blue)),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: photoUrl.isNotEmpty
//                   ? NetworkImage(photoUrl)
//                   : const AssetImage('assets/images/primary/farmer.png') as ImageProvider,
//             ),
//             const SizedBox(height: 16),
//             isEditing
//                 ? TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name'))
//                 : Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             isEditing
//                 ? TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email'))
//                 : Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
//             const SizedBox(height: 24),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.store),
//               title: const Text('Brand Name'),
//               subtitle: isEditing
//                   ? TextField(controller: brandController, decoration: const InputDecoration(labelText: 'Brand Name'))
//                   : Text(brandName),
//             ),
//             ListTile(
//               leading: const Icon(Icons.phone),
//               title: const Text('Phone'),
//               subtitle: isEditing
//                   ? TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone'))
//                   : Text(phoneNumber),
//             ),
//             ListTile(
//               leading: const Icon(Icons.person),
//               title: const Text('User Type'),
//               subtitle: Text(typeOfUser),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _UserProfileScreenState extends State<UserProfileScreen> {
  String name = "";
  String typeOfUser = "";
  String phoneNumber = "";
  String email = "";
  String brandName = "";
  String photoUrl = "";

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
        final responseData = jsonDecode(response.body);
        final userData = responseData["userData"];

        setState(() {
          name = userData["name"] ?? '';
          email = userData["email"] ?? '';
          phoneNumber = userData["phoneNumber"] ?? '';
          typeOfUser = userData["typeOfUser"] ?? '';
          brandName = userData["brandName"] ?? '';
          photoUrl = userData["photoURL"] ?? '';
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

  @override
  void initState() {
    super.initState();
    getProfileData(); // ✅ Call it here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Profile'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: TextButton(
              onPressed: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDataEditProfileScreen(
                      name: name,
                      email: email,
                      phoneNumber: phoneNumber,
                      brandName: brandName,
                      photoUrl: photoUrl,
                      typeOfUser: typeOfUser,
                    ),
                  ),
                );

                if (updated == true) {
                  getProfileData(); // Refresh the profile after edit
                }
              },
              child: const Text("Edit", style: TextStyle(color: Colors.redAccent)),
            ),

          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : const AssetImage('assets/images/primary/farmer.png')
                          as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Brand Name'),
              subtitle: Text(brandName),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(phoneNumber),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Type'),
              subtitle: Text(typeOfUser),
            ),
          ],
        ),
      ),
    );
  }
}
