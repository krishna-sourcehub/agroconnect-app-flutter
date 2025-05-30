import 'dart:convert';
import 'dart:io';
import 'package:agroconnect/constants.dart';
import 'package:agroconnect/route/route_constants.dart';
import 'package:agroconnect/screens/auth/views/auth_management.dart';
import 'package:agroconnect/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

import '../../userdata/address/user_form_address_address.dart';

class AddProductScreen extends StatefulWidget {
  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  String? category;
  String? productName;
  String? unit;
  String? isOrganic;
  String? delivery;
  String? auctionStatus;
  double? pricePerUnit;
  int? stock;
  double totalPrice = 0;
  DateTime? auctionStartTime;
  DateTime? auctionEndTime;
  double? auctionStartAmount;
  String? productTitle;
  String? description;
  String? useExistingAddress;
  List<File> mediaFiles = [];
  TextEditingController auctionStartAmountController = TextEditingController();
  bool _isLoading = false;

  Future<DateTime?> pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<UserAddressFormDataState> _userAddressFormKey =
  GlobalKey<UserAddressFormDataState>();

  // Simulate dependent dropdown
  Map<String, List<String>> productMap = {
    'Vegetables': ['Carrot', 'Tomato'],
    'Fruits': ['Apple', 'Banana'],
    'Diary': ['Milk', 'Curd'],
  };

  // Future<void> pickMediaFiles() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     allowMultiple: true, // Allow selecting multiple files
  //     type: FileType.custom, // Use FileType.custom for custom extensions
  //     allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'], // Specify custom allowed extensions (images + videos)
  //   );
  //
  //   if (result != null) {
  //     print(result.files); // Debugging: Print picked files
  //     setState(() {
  //       mediaFiles = result.paths.map((path) => File(path!)).toList();
  //     });
  //   }
  // }

  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB

  Future<void> pickMediaOption() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              pickFromCamera();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              pickFromGallery();
            },
          ),
        ],
      ),
    );
  }

  Future<void> pickFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize <= maxFileSize) {
        setState(() {
          mediaFiles.add(file);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected file exceeds 10MB size limit.')),
        );
      }
    }
  }

  Future<void> pickFromGallery() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles != null) {
      final List<File> validFiles = [];

      for (var file in pickedFiles) {
        final f = File(file.path);
        final fileSize = await f.length();
        if (fileSize <= maxFileSize) {
          validFiles.add(f);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('One or more files exceed 10MB and were skipped.')),
          );
        }
      }

      setState(() {
        mediaFiles.addAll(validFiles);
      });
    }
  }




  void calculateTotalPrice() {
    if (pricePerUnit != null && stock != null) {
      setState(() {
        totalPrice = pricePerUnit! * stock!;
      });
    }
  }

  // Future<void> submitForm() async {
  //   final address = _userAddressFormKey.currentState; // or however you expose it
  //   address?.validate();
  //   address?.save();
  //   final sessionToken = await secureStorage.read(key: "sessionToken");
  //   final uri = Uri.parse('$backendURL/product/addProduct');
  //   print("object $uri");
  //   var request = http.MultipartRequest('POST', uri);
  //   request.headers['Authorization'] = 'Bearer $sessionToken';
  //
  //   print("auctionStartTime $auctionStartTime");
  //   print("auctionEndTime $auctionEndTime");
  //
  //   request.fields.addAll({
  //     'category': category ?? '',
  //     'productName': productName ?? '',
  //     'description': description ?? '',
  //     'unit': unit ?? '',
  //     'stock': (stock != null ? stock.toString() : '0'),  // If stock is not null, convert to String. Otherwise, use '0'
  //     'pricePerUnit': pricePerUnit?.toStringAsFixed(2) ?? '0.00',
  //     'isOrganic': isOrganic == null ? '' : (isOrganic == 'Yes'
  //         ? 'true'
  //         : 'false'),
  //     'delivery': delivery == null ? '' : (delivery == 'Yes'
  //         ? 'true'
  //         : 'false'),
  //     'useExistingAddress': (useExistingAddress == 'Yes').toString(),
  //     // 'useExistingAddress': useExistingAddress == null
  //     //     ? ''
  //     //     : (useExistingAddress == 'Yes' ? 'true' : 'false'),
  //     'totalPrice': totalPrice.toString(),
  //     'auctionStatus': auctionStatus == null ? '' : (auctionStatus == 'Yes'
  //         ? 'true'
  //         : 'false'),
  //     'auctionStartTime': auctionStartTime?.toIso8601String() ?? '',
  //     'auctionEndTime': auctionEndTime?.toIso8601String() ?? '',
  //     'auctionStartAmount': (int.tryParse(auctionStartAmountController.text) ??
  //         0).toString(),
  //     'productTitle': productTitle ?? '',
  //
  //   });
  //
  //   if (useExistingAddress == 'No' && address != null) {
  //     request.fields['address']= jsonEncode({
  //       "doorOrShopNo": address.doorOrShopNo,
  //       "state": address.state,
  //       "country": address.country,
  //       "taluk": address.taluk,
  //       "district": address.district,
  //       "street": address.street,
  //       "postalCode": address.postalCode,
  //       "city": address.city,
  //     });
  //   }
  //
  //   for (var file in mediaFiles) {
  //     final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
  //     final fileStream = http.ByteStream(file.openRead());
  //     final fileLength = await file.length();
  //
  //     request.files.add(
  //       http.MultipartFile(
  //         'media', // field name
  //         fileStream,
  //         fileLength,
  //         filename: file.path
  //             .split('/')
  //             .last,
  //         contentType: MediaType.parse(mimeType),
  //       ),
  //     );
  //   }
  //
  //   final response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print("Upload successful!");
  //   } else {
  //     print(
  //       "Upload failed with status: ${response.statusCode} ${response.request}",
  //     );
  //     final responseBody = await response.stream.bytesToString();
  //     print("Upload failed with status: ${response.statusCode}");
  //     print("Response body: $responseBody");
  //     print("Request Body: ${request.fields}");
  //
  //   }
  // }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate() || !_userAddressFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final address = _userAddressFormKey.currentState;
      address?.validate();
      address?.save();

      final sessionToken = await secureStorage.read(key: "sessionToken");
      final uri = Uri.parse('$backendURL/product/addProduct');
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $sessionToken';

      request.fields.addAll({
        'category': category ?? '',
        'productName': productName ?? '',
        'description': description ?? '',
        'unit': unit ?? '',
        'stock': stock?.toString() ?? '0',
        'pricePerUnit': pricePerUnit?.toStringAsFixed(2) ?? '0.00',
        'isOrganic': isOrganic == 'Yes' ? 'true' : 'false',
        'delivery': delivery == 'Yes' ? 'true' : 'false',
        'useExistingAddress': (useExistingAddress == 'Yes').toString(),
        'totalPrice': totalPrice.toString(),
        'auctionStatus': auctionStatus == 'Yes' ? 'true' : 'false',
        'auctionStartTime': auctionStartTime?.toIso8601String() ?? '',
        'auctionEndTime': auctionEndTime?.toIso8601String() ?? '',
        'auctionStartAmount':
        (int.tryParse(auctionStartAmountController.text) ?? 0).toString(),
        'productTitle': productTitle ?? '',
      });

      if (useExistingAddress == 'No' && address != null) {
        request.fields['address'] = jsonEncode({
          "doorOrShopNo": address.doorOrShopNo,
          "state": address.state,
          "country": address.country,
          "taluk": address.taluk,
          "district": address.district,
          "street": address.street,
          "postalCode": address.postalCode,
          "city": address.city,
        });
      }

      for (var file in mediaFiles) {
        final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
        final fileStream = http.ByteStream(file.openRead());
        final fileLength = await file.length();

        request.files.add(
          http.MultipartFile(
            'media',
            fileStream,
            fileLength,
            filename: file.path.split('/').last,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final response = await request.send();

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        ToastUtil.show("Product Added Successfully");
        // ✅ Navigate to home page on success
      Navigator.popAndPushNamed(context, entryPointScreenRoute);
      } else {
        final responseBody = await response.stream.bytesToString();
        debugPrint("error Message $responseBody");
        ToastUtil.show("Failed to add product:$responseBody");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ToastUtil.show("An error occurred while submitting the product.");
      print("Error in submitForm: $e");
    }
  }

  String toIsoString(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  String formatDateTime(DateTime dt) {
    final date = DateFormat('dd-MM-yyyy').format(dt);
    final time = DateFormat('HH:mm:ss').format(dt);
    return 'Date: $date\nTime: $time';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(
        child: Text("Add Product", style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w800, fontSize: 24 ),
          textAlign:TextAlign.center,

        ),
      )),
      body: Stack(
        children:[ Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: category,
                  items:
                  productMap.keys
                      .map(
                        (cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat)),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      category = value;
                      productName = null;

                      // Dynamically set default unit based on selected category
                      if (value == 'Diary') {
                        unit = 'litre';
                      } else {
                        unit = 'kg';
                      }
                    });
                  },
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                // SizedBox(height: 10,),

                // if (category != null)
                //   SizedBox(height: 10,),
                // DropdownButtonFormField<String>(
                //     value: productName,
                //     items:
                //     productMap[category]!
                //         .map(
                //           (name) =>
                //           DropdownMenuItem(
                //             value: name,
                //             child: Text(name),
                //           ),
                //     )
                //         .toList(),
                //     onChanged: (value) => setState(() => productName = value),
                //     decoration: InputDecoration(labelText: 'Product Name'),
                //   ),

                category != null && productMap[category] != null
                    ? Column(
                  children: [
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: productName,
                      items: productMap[category]!
                          .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                          .toList(),
                      onChanged: (value) => setState(() => productName = value),
                      decoration: InputDecoration(labelText: 'Product Name'),
                    ),
                  ],
                )
                    : SizedBox.shrink(),


                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Product Title'),
                  onChanged: (val) => productTitle = val,
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (val) => description = val,
                ),
                SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Stock'),
                  onChanged: (val) {
                    stock = int.tryParse(val);
                    calculateTotalPrice();
                  },
                ),
                SizedBox(height:10 ,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price Per Unit'),
                  onChanged: (val) {
                    pricePerUnit = double.tryParse(val);
                    calculateTotalPrice();
                  },
                ),
                SizedBox(height: 10),

                Text('Total Price: ₹${totalPrice.toStringAsFixed(2)}'),
                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: pickMediaOption,
                  child: Text('Upload Product Media Files'),
                ),
                SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: unit,
                  // items: ["kg", "litre"]
                  //     .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  //     .toList(),
                  items: ["kg", "litre"]
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: null,
                  decoration: InputDecoration(labelText: 'Select the Unit'),
                ),

                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: delivery,
                  items:
                  ["Yes", "No"]
                      .map(
                        (cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat)),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      delivery = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Delivery Available'),
                ),
                SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: isOrganic,
                  items:
                  ["Yes", "No"]
                      .map(
                        (cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat)),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      isOrganic = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Organic Product'),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: auctionStatus,
                  items:
                  ["Yes", "No"]
                      .map(
                        (cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat)),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      auctionStatus = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Auction Product'),
                ),
                SizedBox(height: 10),

                auctionStatus == "Yes"
                    ? Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await pickDateTime(context);
                        if (picked != null) {
                          setState(() => auctionStartTime = picked);
                        }
                      },
                      child: Text(
                        auctionStartTime == null
                            ? 'Pick Auction Start Time'
                            : formatDateTime(auctionStartTime!),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await pickDateTime(context);
                        if (picked != null) {
                          setState(() => auctionEndTime = picked);
                        }
                      },
                      child: Text(
                        auctionEndTime == null
                            ? 'Pick Auction End Time'
                            : formatDateTime(auctionEndTime!),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: auctionStartAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Auction Start Amount',
                      ),
                    ),
                  ],
                )
                    : SizedBox.shrink(), // ✅ else, return an empty widget


                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: useExistingAddress,
                  items:
                  ["Yes", "No"]
                      .map(
                        (cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat)),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      useExistingAddress = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Use Existing Address'),
                ),
                SizedBox(height: 10),

                useExistingAddress == "No"
                    ? UserAddressFormData(key: _userAddressFormKey)
                    : SizedBox.shrink(),

                ElevatedButton(onPressed: submitForm, child: Text('Add Product')),
              ],
            ),
          ),
        ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ]

      ),
    );
  }
}
