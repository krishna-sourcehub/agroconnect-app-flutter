import 'package:form_field_validator/form_field_validator.dart';


class UserAddressValidators {
  static final email = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    PatternValidator(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      errorText: 'Enter a valid email address',
    ),
  ]);

  static final password = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 characters'),
  ]);

  static final name = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    PatternValidator(
      r"^[a-zA-Z\s]+$",
      errorText: 'Only alphabets and spaces are allowed',
    ),
  ]);


  static final typeOfUser = MultiValidator([
    RequiredValidator(errorText: 'User Type is required'),
    PatternValidator(
      r'^[a-zA-Z\s]+$',
      errorText: 'Only alphabets and spaces are allowed',
    ),
  ]);


  static final phone = MultiValidator([
    RequiredValidator(errorText: 'Phone number is required'),
    PatternValidator(
      r'^[6-9]\d{9}$',
      errorText: 'Enter a valid 10-digit phone number',
    ),
  ]);

  static final doorShopNo = MultiValidator([
    RequiredValidator(errorText: 'Door/Shop number is required'),
    PatternValidator(
      r'^[a-zA-Z0-9\s\-\/]+$',
      errorText: 'Invalid characters in Door/Shop number',
    ),
  ]);

  static final streetName = MultiValidator([
    RequiredValidator(errorText: 'Street name is required'),
    PatternValidator(
      r"^[a-zA-Z0-9\s\.,\-]+$",
      errorText: 'Only letters, numbers, commas, periods, and hyphens allowed',
    ),
  ]);

  static final taluk = MultiValidator([
    RequiredValidator(errorText: 'Taluk is required'),
    PatternValidator(
      r'^[a-zA-Z\s]+$',
      errorText: 'Only alphabets and spaces allowed',
    ),
  ]);

  static final district = MultiValidator([
    RequiredValidator(errorText: 'District is required'),
    PatternValidator(
      r'^[a-zA-Z\s]+$',
      errorText: 'Only alphabets and spaces allowed',
    ),
  ]);

  static final postalCode = MultiValidator([
    RequiredValidator(errorText: 'Postal code is required'),
    PatternValidator(
      r'^[1-9][0-9]{5}$',
      errorText: 'Enter a valid 6-digit postal code',
    ),
  ]);

}

