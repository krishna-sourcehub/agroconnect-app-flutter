import 'package:agroconnect/screens/userdata/address/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:country_state_city_picker_2/country_state_city_picker.dart';
import '../../../../constants.dart';

class UserAddressFormData extends StatefulWidget {
  const UserAddressFormData({super.key});

  @override
  State<UserAddressFormData> createState() => UserAddressFormDataState();
}

class UserAddressFormDataState extends State<UserAddressFormData> {
  final _userAddressFormKey = GlobalKey<FormState>(); // GlobalKey for Form
  String _doorOrShopNo = '';
  String _street = '';
  String _taluk = '';
  String _district = '';

  String _city = '';
  String _state = '';
  String _country = '';
  int _postalCode = 0;
  String? _locationError;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _userAddressFormKey,
      // Use _userDataFormKey only for the entire Form widget
      child: Column(
        children: [
          // door shop no Field
          TextFormField(
            validator: UserAddressValidators.doorShopNo,
            onSaved: (value) => _doorOrShopNo = value!.trim(),
            decoration: InputDecoration(
              labelText: "Door/Shop No",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectState(
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),

                decoration: InputDecoration(
                  counterStyle: TextStyle(fontSize: 34),

                  prefixStyle: TextStyle(fontSize: 32),
                  alignLabelWithHint: true,
                  suffixStyle: TextStyle(fontSize: 34),
                  floatingLabelStyle: TextStyle(fontSize: 32),
                  labelStyle:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ) ,

                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  ),
                  contentPadding: EdgeInsets.all(5.0)
                ),

                spacing: 25.0,

                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),

                selectedCountryLabel: "Country",
                selectedCityLabel: "City",

                onCountryChanged: (value) {
                  setState(() {
                    _country = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    _state = value;
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    _city = value;
                  });
                },
              ),
              if (_locationError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(
                    _locationError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Street Field
          TextFormField(
            validator: UserAddressValidators.streetName,
            onSaved: (value) => _street = value!.trim(),
            decoration: InputDecoration(
              labelText: "Street Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            validator: UserAddressValidators.district,
            onSaved: (value) => _district = value!.trim(),
            decoration: InputDecoration(
              labelText: "District Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            validator: UserAddressValidators.taluk,
            onSaved: (value) => _taluk = value!.trim(),
            decoration: InputDecoration(
              labelText: "Taluk Name",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            validator: UserAddressValidators.postalCode,
            onSaved: (value) {
              if (value != null && value.trim().isNotEmpty) {
                _postalCode = int.parse(value.trim());
              }
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Postal Code",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool isValidLocation() {
    if (_country == null ||
        _state == null ||
        _city == null ||
        _country == "" ||
        _city == "" ||
        _state == "") {
      setState(() {
        _locationError = "Country, State, and City are required.";
      });
      return false;
    } else {
      setState(() {
        _locationError = null;
      });
      return true;
    }
  }

  bool validate() {
    final isFormValid = _userAddressFormKey.currentState?.validate() ?? false;
    final isLocationValid = isValidLocation();

    if (isFormValid && isLocationValid) {
      _userAddressFormKey.currentState?.save();
      return true;
    }
    return false;
  }

  void save() {
    _userAddressFormKey.currentState?.save();
  }

  String get doorOrShopNo => _doorOrShopNo;

  String get street => _street;

  String get district => _district;

  String get city => _city;

  String get state => _state;

  String get country => _country;

  String get taluk => _taluk;

  int get postalCode => _postalCode;
}
