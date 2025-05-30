import 'dart:io';

import 'package:agroconnect/screens/profile/views/user_form_data.dart';
import 'package:agroconnect/screens/profile/views/validate_userdata.dart';
import 'package:agroconnect/screens/userdata/user_form_data.dart';
import 'package:agroconnect/screens/userdata/validate_userdata.dart';
import 'package:agroconnect/utils/toast_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:agroconnect/screens/userdata/user_form_data.dart';
import 'package:agroconnect/route/route_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';
import '../../../utils/dependcies.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // ✅ for MediaType


class UserDataEditProfileScreen extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final String brandName;
  final String photoUrl;
  final String typeOfUser;

  const UserDataEditProfileScreen({
    Key? key,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.brandName,
    required this.photoUrl,
    required this.typeOfUser,
  }) : super(key: key);

  @override
  State<UserDataEditProfileScreen> createState() => _UserDataEditProfileState();
}

class _UserDataEditProfileState extends State<UserDataEditProfileScreen> {

  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      setState(() {
        _imageFile = file;
        photoUrl = ''; // clear remote photo URL if a new local one is selected
      });
      await _uploadAvatar(file); // call upload
    }
  }

  Future<void> _uploadAvatar(File imageFile) async {

    String? sessionToken;
    final tokenStatus = await UserDependencies().getSessionToken();

    if (tokenStatus['status'] == true) {
      sessionToken = tokenStatus['sessionToken'];
    }
    // else {
    //   return {'status': false, "reason": "sessionExpired"};
    // }

    final int maxSizeInBytes = 3 * 1024 * 1024; // 3MB

    if (imageFile.lengthSync() > maxSizeInBytes) {
      ToastUtil.show("Image must be less than 3MB");
      return;
    }

    final uri = Uri.parse('$backendURL/user/upload/avatar');


    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'avatar',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'), // or image/png
        ),
      );
    request.headers['Authorization'] = 'Bearer $sessionToken';


    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        ToastUtil.show("Avatar uploaded successfully");

        // If your API returns the new URL:
        // final newUrl = jsonDecode(responseData)['avatarUrl'];
        // setState(() {
        //   photoUrl = newUrl;
        // });

      } else {
        ToastUtil.show("Failed to upload avatar");
      }
    } catch (e) {
      print("Upload error: $e");
      ToastUtil.show("Error uploading avatar");
    }
  }


  final GlobalKey<UserProfileFormDataState> _userFormKey =
      GlobalKey<UserProfileFormDataState>();
  late String name;
  late String phoneNumber;
  late String email;
  late String brandName;
  late String photoUrl;
  late String typeOfUser;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController brandController;

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phoneNumber);
    emailController = TextEditingController(text: widget.email);
    brandController = TextEditingController(text: widget.brandName);
    photoUrl = widget.photoUrl;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    brandController.dispose();
    super.dispose();
  }

  // void _submitChanges() async {
  //   // Make your HTTP PUT or POST call to update profile here
  //   Navigator.pop(context, true); // return true to refresh the profile
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) as ImageProvider
                        : (photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : const AssetImage('assets/images/primary/farmer.png')
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _showImageSourceDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CircleAvatar(
            //   radius: 50,
            //   backgroundImage:
            //       photoUrl.isNotEmpty
            //           ? NetworkImage(photoUrl)
            //           : const AssetImage('assets/images/primary/farmer.png')
            //               as ImageProvider,
            // ),
            // Image.asset(
            //   "assets/images/primary/merchant4.jpg",
            //   // height: MediaQuery.of(context).size.height * 0.35,
            //   width: double.infinity,
            //   // fit: BoxFit.fitHeight,
            //   fit: BoxFit.cover,
            //   height: 350,
            // ),
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
                  UserProfileFormData(
                    key: _userFormKey,
                    email: widget.email,
                    phoneNumber: widget.phoneNumber,
                    brandName: widget.brandName,
                    typeOfUser: widget.typeOfUser,
                    name: widget.name,
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
                        final name = formState.name;
                        try {
                          final userDetail = await userBackendService()
                              .updateUserProfile(
                                email: email,
                                phoneNumber: phoneNumber,
                                brandName: brandName,
                                name: name,
                              );
                          print("userDetail $userDetail");
                          if (userDetail['status'] == false) {
                            ToastUtil.show(userDetail['message']);
                            return;
                          }
                          ToastUtil.show("User Detail updated Successfully");

                          Navigator.pop(context);
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
                    child: const Text("Submit"),
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
