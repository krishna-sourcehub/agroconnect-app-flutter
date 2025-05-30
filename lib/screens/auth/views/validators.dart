import 'package:form_field_validator/form_field_validator.dart';

class AppValidators {
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
}
