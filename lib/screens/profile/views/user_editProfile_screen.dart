import 'package:flutter/material.dart';
import '../../../constants.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String brandName;
  final String photoUrl;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.brandName,
    required this.photoUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController brandController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    emailController = TextEditingController(text: widget.email);
    brandController = TextEditingController(text: widget.brandName);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    brandController.dispose();
    super.dispose();
  }

  void _submitChanges() async {
    // Make your HTTP PUT or POST call to update profile here
    Navigator.pop(context, true); // return true to refresh the profile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // You can also add image picker for profile picture
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: brandController,
              decoration: const InputDecoration(labelText: 'Brand Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
