import 'package:agroconnect/screens/userdata/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../constants.dart';

class UserFormData extends StatefulWidget {
  final String? email;

  final String? phoneNumber;

  // const UserFormData({super.key})
  const UserFormData({Key? key, this.email, this.phoneNumber})
    : super(key: key);

  @override
  State<UserFormData> createState() => UserFormDataState();
}

class UserFormDataState extends State<UserFormData> {
  final _userDataFormKey = GlobalKey<FormState>(); // GlobalKey for Form

  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  late bool phoneNumberEnableStatus;
  late bool emailEnableStatus;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email ?? '');
    _phoneController = TextEditingController(text: widget.phoneNumber ?? '');
    emailEnableStatus = widget.email == null;
    phoneNumberEnableStatus = widget.phoneNumber == null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _typeOfUser = '';
  bool isValidPhoneNumber = true;
  String phoneErrorText = '';
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _userTypeError;
  late String _brandName;
  String? _brandNameError;

  bool phoneNumberValidation(_phoneNumber) {
    final number = _phoneNumber ?? '';

    if (number.trim().isEmpty) {
      setState(() {
        phoneErrorText = "Phone number is required";
        isValidPhoneNumber = false;
      });

      return false;
    }

    final pattern = RegExp(r'^\+?[1-9]\d{1,3}[\s\-]?[6-9]\d{9}$');
    print("number:$number");
    if (!pattern.hasMatch(number)) {
      setState(() {
        phoneErrorText = "Enter a valid 10-digit phone number";
        isValidPhoneNumber = false;
      });

      return false;
    }

    phoneErrorText = '';
    isValidPhoneNumber = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _userDataFormKey,
      // Use _userDataFormKey only for the entire Form widget
      child: Column(
        children: [
          // Name Field
          TextFormField(
            validator: UserDataValidators.name,
            onSaved: (value) => _name = value!.trim(),
            decoration: InputDecoration(
              labelText: "Full Name",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                if (value.trim().isEmpty) {
                  _nameError = 'Name is required';
                } else if (value.trim().length < 3) {
                  _nameError = 'Name must be at least 3 characters';
                } else {
                  _nameError = null;
                }
              });
            },
          ),
          const SizedBox(height: 16),

          // Email Field
          TextFormField(
            enabled: emailEnableStatus,
            controller: _emailController,
            // initialValue: widget.email ?? '',
            validator: UserDataValidators.email,
            onSaved: (value) => _email = value!.trim(),
            decoration: InputDecoration(
              labelText: "Email Address",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                if (value.trim().isEmpty) {
                  _emailError = 'Email is required';
                } else if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value.trim())) {
                  _emailError = 'Enter a valid email';
                } else {
                  _emailError = null;
                }
              });
            },
          ),
          const SizedBox(height: 16),

          // IntlPhoneField(
          //   // validator: UserDataValidators.phone,
          //   decoration: InputDecoration(
          //     labelText: 'Phone Number',
          //     border: OutlineInputBorder(),
          //     errorBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: !isValidPhoneNumber ? Colors.red : Colors.white,
          //       ),
          //     ),
          //     focusedErrorBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: !isValidPhoneNumber ? Colors.red : Colors.indigoAccent,
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: !isValidPhoneNumber ? Colors.red : Colors.white,
          //       ),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: !isValidPhoneNumber ? Colors.red : Colors.white,
          //       ),
          //     ),
          //     errorText: !isValidPhoneNumber ? phoneErrorText : '',
          //     labelStyle: TextStyle(
          //       color: !isValidPhoneNumber ? Colors.red : Colors.black,
          //     ),
          //   ),
          //   initialCountryCode: 'IN',
          //   onChanged: (phone) {
          //     _phoneNumber = phone.completeNumber;
          //     phoneNumberValidation(_phoneNumber);
          //   },
          //   onSaved: (phone) {
          //     _phoneNumber = phone?.completeNumber ?? '';
          //     phoneNumberValidation(_phoneNumber);
          //   },
          // ),
          IntlPhoneField(
            onChanged: (phone) {
              // field.didChange(phone);
              _phoneNumber = phone.completeNumber;
              // field.validate();
            },
            onSaved: (phone) {
              setState(() {
                if (phone != null) {
                  print("phone (raw): $phone");
                  print("phone.completeNumber: ${phone.completeNumber}");
                  _phoneNumber = phone.completeNumber;
                }
              });
            },
            initialValue: widget.phoneNumber ?? '',
            controller: _phoneController,
            enabled: phoneNumberEnableStatus,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              // errorText: field.errorText,
            ),
            initialCountryCode: 'IN',
            dropdownIconPosition: IconPosition.trailing,
            validator: (phone) {
              if (phone == null || phone.number.isEmpty) {
                return 'Enter a valid phone number';
              }
              return null;
            },
          ),

          // FormField<PhoneNumber>(
          //   validator: (phone) {
          //     print("validate phone $phone");
          //     final number = phone?.number ?? '';
          //     if (number.trim().isEmpty) return 'Phone number is required';
          //     final pattern = RegExp(r'^[6-9]\d{9}$');
          //     if (!pattern.hasMatch(number))
          //       return 'Enter a valid 10-digit phone number';
          //     return null;
          //   },
          //   builder:
          //       (field) => Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           IntlPhoneField(
          //             onChanged: (phone) {
          //               field.didChange(phone);
          //               _phoneNumber = phone.completeNumber;
          //               field.validate();
          //             },
          //             onSaved: (phone) {
          //               setState(() {
          //                 if (phone != null) {
          //                   print("phone (raw): $phone");
          //                   print(
          //                     "phone.completeNumber: ${phone.completeNumber}",
          //                   );
          //                   _phoneNumber = phone.completeNumber;
          //                 }
          //               });
          //             },
          //             initialValue: widget.phoneNumber ?? '',
          //             controller: _phoneController,
          //             enabled: phoneNumberEnableStatus,
          //             decoration: InputDecoration(
          //               labelText: 'Phone Number',
          //               border: OutlineInputBorder(),
          //               errorText: field.errorText,
          //             ),
          //             initialCountryCode: 'IN',
          //             dropdownIconPosition: IconPosition.trailing,
          //           ),
          //         ],
          //       ),
          // ),
          const SizedBox(height: 16),

          DropdownButtonFormField2<String>(
            // onMenuStateChange: (value) {
            //   validate();
            // },
            value: _typeOfUser.isNotEmpty ? _typeOfUser : null,
            isExpanded: true,
            onChanged: (newValue) {
              setState(() {
                _typeOfUser = newValue!;
                // Manual validation
                if (_typeOfUser.trim().isEmpty) {
                  _userTypeError = 'User Type is required';
                } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(_typeOfUser)) {
                  _userTypeError = 'Only alphabets and spaces are allowed';
                } else {
                  _userTypeError = null;
                }
              });
            },
            onSaved: (newValue) {
              setState(() {
                _typeOfUser = newValue!;
                // Manual validation
                if (_typeOfUser.trim().isEmpty) {
                  _userTypeError = 'User Type is required';
                } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(_typeOfUser)) {
                  _userTypeError = 'Only alphabets and spaces are allowed';
                } else {
                  _userTypeError = null;
                }
              });
            },
            items:
                ['Merchant', 'Farmer']
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
            decoration: InputDecoration(
              labelText: 'User Type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: TextStyle(fontWeight: FontWeight.w300),
              errorText: _userTypeError, // Show the error manually
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 345,
              offset: const Offset(0, -5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'User Type is required';
              }

              // Run pattern validation manually
              final pattern = RegExp(r'^[a-zA-Z\s]+$');
              if (!pattern.hasMatch(value)) {
                return 'Only alphabets and spaces are allowed';
              }

              return null;
            },
            hint: const Text('Select user type'),
          ),
          SizedBox(height: 20),
          TextFormField(
            // enabled: emailEnableStatus,
            // controller: _emailController,
            // initialValue: widget.email ?? '',
            validator: UserDataValidators.brandName,
            onSaved: (value) => _brandName = value!.trim(),
            decoration: InputDecoration(
              labelText: "Brand Name",
              border: OutlineInputBorder(),
              hintText:
                  _typeOfUser == "Merchant"
                      ? "Enter Shop or Brand Name"
                      : "Enter Farm or Product Brand Name",
            ),
            onChanged: (value) {
              setState(() {
                if (value.trim().isEmpty) {
                  _brandNameError = 'Brand Name is required';
                } else {
                  _brandNameError = null;
                }
              });
            },
          ),
          const SizedBox(height: 10),

          // User Type Field
          // DropdownButtonFormField<String>(
          //   value: _typeOfUser.isNotEmpty ? _typeOfUser : null,
          //   isExpanded: true,
          //   onChanged: (newValue) {
          //     setState(() {
          //       _typeOfUser = newValue!;
          //     });
          //   },
          //   items:
          //       ['Merchant', 'Farmer']
          //           .map(
          //             (item) => DropdownMenuItem<String>(
          //               value: item,
          //               child: Text(item),
          //             ),
          //           )
          //           .toList(),
          //   decoration: InputDecoration(
          //     labelText: 'User Type',
          //     border: OutlineInputBorder(),
          //   ),
          //   validator: (value) {
          //     if (value == null || value.trim().isEmpty) {
          //       return 'User Type is required';
          //     }
          //
          //     // Run pattern validation manually
          //     final pattern = RegExp(r'^[a-zA-Z\s]+$');
          //     if (!pattern.hasMatch(value)) {
          //       return 'Only alphabets and spaces are allowed';
          //     }
          //
          //     return null;
          //   },
          // ),
          // const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool validate() {
    return _userDataFormKey.currentState?.validate() ?? false;
  }

  void save() {
    _userDataFormKey.currentState?.save();
  }

  String get email => _email;

  String get name => _name;

  String get phoneNumber => _phoneNumber;

  String get typeOfUser => _typeOfUser.toLowerCase();

  String get brandName => _brandName;
}
