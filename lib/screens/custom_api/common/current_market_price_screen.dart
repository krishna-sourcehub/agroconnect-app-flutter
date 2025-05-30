// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../services/debouncer.dart';
// import '../services/mandi_service.dart';
//
// class MandiScreen extends StatefulWidget {
//   @override
//   _MandiScreenState createState() => _MandiScreenState();
// }
//
// class _MandiScreenState extends State<MandiScreen> {
//   final _debouncer = Debouncer(milliseconds: 500);
//
//   final _commodityController = TextEditingController();
//   final _marketController = TextEditingController();
//   final _state = TextEditingController();
//   final _district = TextEditingController();
//
//   List<Map<String, dynamic>> _data = [];
//   DateTime _selectedDate = DateTime.now();
//   String _commoditySearch = "";
//   String _marketSearch = "";
//
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initial data fetch can be skipped or controlled by user
//   }
//
//   Future<void> _loadData() async {
//     if (_state.text.isEmpty || _district.text.isEmpty) {
//       setState(() => _data = []);
//       return;
//     }
//
//     setState(() => _isLoading = true);
//     final formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);
//     final results = await fetchMarketPrices(
//       state: _state.text,
//       district: _district.text,
//       arrivalDate: formattedDate,
//     );
//
//     setState(() {
//       _data = _filterCustom(results);
//       _isLoading = false;
//     });
//   }
//
//   List<Map<String, dynamic>> _filterCustom(List<Map<String, dynamic>> records) {
//     final commodity = _commoditySearch.toLowerCase();
//     final market = _marketSearch.toLowerCase();
//
//     return records.where((record) {
//       final c = (record['Commodity'] ?? '').toLowerCase();
//       final m = (record['Market'] ?? '').toLowerCase();
//       return c.contains(commodity) && m.contains(market);
//     }).toList();
//   }
//
//   void _onSearchChanged() {
//     _debouncer.run(() {
//       setState(() {
//         _commoditySearch = _commodityController.text;
//         _marketSearch = _marketController.text;
//       });
//       _loadData();
//     });
//   }
//
//   void _clearFilters() {
//     _state.clear();
//     _district.clear();
//     _commodityController.clear();
//     _marketController.clear();
//     setState(() {
//       _commoditySearch = "";
//       _marketSearch = "";
//       _selectedDate = DateTime.now();
//     });
//     _loadData();
//   }
//
//   Widget _buildSearchField({
//     required TextEditingController controller,
//     required String label,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: SizedBox(
//         height: 60,
//         child: TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             labelText: label,
//             border: const OutlineInputBorder(),
//           ),
//           onChanged: (_) => _onSearchChanged(), // uses the class-wide method
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Mandi Prices')),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Search Fields
//               _buildSearchField(controller: _state, label: 'Search State'),
//               _buildSearchField(controller: _district, label: 'Search District'),
//               _buildSearchField(controller: _commodityController, label: 'Search Commodity'),
//               _buildSearchField(controller: _marketController, label: 'Search Market'),
//               const SizedBox(height: 10),
//
//               // Date and Clear Filter
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text("Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}"),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       DateTime? picked = await showDatePicker(
//                         context: context,
//                         initialDate: _selectedDate,
//                         firstDate: DateTime(2021),
//                         lastDate: DateTime.now(),
//                       );
//                       if (picked != null) {
//                         setState(() => _selectedDate = picked);
//                         _loadData();
//                       }
//                     },
//                     child: const Text('Pick Date'),
//                   ),
//                 ],
//               ),
//
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: _clearFilters,
//                   child: const Text("Clear Filters"),
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               // Data List
//               SizedBox(
//                 height: 400,
//                 child: _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : _data.isEmpty
//                     ? const Center(child: Text('No data'))
//                     : ListView.builder(
//                   itemCount: _data.length,
//                   itemBuilder: (_, i) {
//                     final item = _data[i];
//                     return Card(
//                       child: ListTile(
//                         title: Text("${item['Commodity']} (${item['Variety']})"),
//                         subtitle: Text("${item['Market']} - ₹${item['Modal_Price']}"),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//


import 'dart:ffi';

import 'package:agroconnect/screens/custom_api/services/mandi_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agroconnect/screens/custom_api/services/mandi_service.dart';

class MandiScreen extends StatefulWidget {
  const MandiScreen({super.key});

  @override
  State<MandiScreen> createState() => _MandiScreenState();
}

class _MandiScreenState extends State<MandiScreen> {
  String? selectedState;
  String? selectedDistrict;
  DateTime selectedDate = DateTime.now();
  TextEditingController commodityController = TextEditingController();
  TextEditingController marketController = TextEditingController();

  List<Map<String, dynamic>> marketData = [];
  bool isLoading = false;
  String? errorMessage;
  final List<String> stateItems = [
    'Tamil Nadu', 'Kerala', 'Gujarat', 'Maharashtra'
  ];

  final Map<String, List<String>> districtMap = {
    'Tamil Nadu': [
      "Ariyalur", "Chengalpattu", "Chennai", "Coimbatore", "Cuddalore",
      "Dharmapuri", "Dindigul", "Erode", "Kallakurichi", "Kanchipuram",
      "Karur", "Krishnagiri", "Madurai", "Mayiladuthurai", "Nagapattinam",
      "Kanyakumari", "Namakkal", "Perambalur", "Pudukkottai", "Ramanathapuram",
      "Ranipet", "Salem", "Sivaganga", "Tenkasi", "Thanjavur", "Theni",
      "Thiruvallur", "Thiruvarur", "Thoothukudi", "Tiruchirappalli", "Tirunelveli",
      "Tirupathur", "Tiruppur", "Tiruvannamalai", "The Nilgiris", "Vellore",
      "Viluppuram", "Virudhunagar"
    ],
    'Kerala': ['Thiruvananthapuram', 'Kochi'],
    'Gujarat': ['Ahmedabad', 'Surat'],
    'Maharashtra': ['Mumbai', 'Pune']
  };


  // String? selectedState;
  // String? selectedDistrict;

  // List<String> get districtItems {
  //   return stateDistrictMap[selectedState] ?? [];
  // }


  Future<void> getMarketPriceData() async {
    if (selectedState == null || selectedDistrict == null) {
      setState(() => errorMessage = 'Please select both state and district.');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      marketData = [];
    });

    try {
      final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      final data = await fetchMarketPrices(
        state: selectedState!,
        district: selectedDistrict!,
        arrivalDate: formattedDate,
      );

      // Filter locally by commodity and market
      final filtered = data.where((item) {
        final commodityInput = commodityController.text.toLowerCase().trim();
        final marketInput = marketController.text.toLowerCase().trim();

        final itemCommodity = (item['Commodity'] ?? '')
            .toString()
            .toLowerCase();
        final itemMarket = (item['Market'] ?? '').toString().toLowerCase();

        return itemCommodity.contains(commodityInput) &&
            itemMarket.contains(marketInput);
      }).toList();

      setState(() {
        marketData = filtered;
      });
    } catch (e) {
      setState(() => errorMessage = 'Error fetching data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Center(
          child: Text("Mandi Market Prices", style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w800, fontSize: 24 ),
            textAlign:TextAlign.center,

          ),
        )),
        body: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                children: [




                  DropdownSearch<String>(
                    popupProps: PopupProps.menu(showSearchBox: true),
                    items: stateItems,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Select State",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    selectedItem: selectedState,
                    onChanged: (value) {
                      setState(() {
                        selectedState = value;
                        selectedDistrict = null; // Reset district
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownSearch<String>(
                    popupProps: PopupProps.menu(showSearchBox: true),
                    items: selectedState == null ? [] : districtMap[selectedState]!,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Select District",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    selectedItem: selectedDistrict,
                    onChanged: (value) {
                      setState(() {
                        selectedDistrict = value;
                      });
                    },
                  ),

          // DropdownButtonFormField<String>(
          //   decoration: InputDecoration(
          //     labelText: 'Select State',
          //     border: OutlineInputBorder(),
          //   ),
          //   value: selectedState,
          //   items: stateDistrictMap.map((item) => DropdownMenuItem(
          //     value: item,
          //     child: Text(item),
          //   )).toList(),
          //   // onChanged: (value) => setState(() => selectedState = value),
          //   onChanged: (value) {
          //     setState(() {
          //       selectedState = value;
          //       selectedDistrict = null; // reset district on state change
          //     });
          //   },

        // DropdownButtonFormField<String>(
        //   decoration: InputDecoration(
        //     labelText: 'Select a District',
        //     border: OutlineInputBorder(),
        //   ),
        //   value: selectedDistrict,
        //   items: districtItems.map((item) {
        //     return DropdownMenuItem(
        //       value: item,
        //       child: Text(item),
        //     );
        //   }).toList(),
        //   onChanged: (value) {
        //     setState(() {
        //       selectedDistrict = value;
        //     });
        //   },
        // ),

        const SizedBox(height: 10),

        // DropdownButtonFormField<String>(
        //   decoration: InputDecoration(
        //     labelText: 'Select District',
        //     border: OutlineInputBorder(),
        //   ),
        //   value: selectedDistrict,
        //   items: districtItems.map((item) => DropdownMenuItem(
        //     value: item,
        //     child: Text(item),
        //   )).toList(),
        //   onChanged: (value) => setState(() => selectedDistrict = value),
        // ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(child: Text(
                "Arrival Date: ${DateFormat('dd/MM/yyyy').format(
                    selectedDate)}")),
            TextButton(onPressed: _pickDate, child: const Text("Pick Date")),
          ],
        ),

        TextField(
          controller: commodityController,
          decoration: const InputDecoration(
            labelText: 'Filter by Commodity',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        TextField(
          controller: marketController,
          decoration: const InputDecoration(
            labelText: 'Filter by Market',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        ElevatedButton(
          onPressed: getMarketPriceData,
          child: const Text("Get Market Data"),
        ),

        if (errorMessage != null) ...[
    const SizedBox(height: 10),
    Text(errorMessage!, style: const TextStyle(color: Colors.red)),
    ],

    const SizedBox(height: 20),
    if (isLoading)
    const CircularProgressIndicator()
    else if (marketData.isEmpty)
    const Text("No data found.")
    else
    ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: marketData.length,
    itemBuilder: (context, index) {
    final item = marketData[index];
    return Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: ListTile(
    title: Text("${item['Commodity']} (${item['Variety']})"),
    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text("Market: ${item['Market']}"),
    Text("Variety: ${item['Variety']}"),
    Text("District: ${item['District']}"),
    Text("Price per Kg: ₹${(int.parse(item['Modal_Price']) / 100).toStringAsFixed(2)}"),
    Text("Unit: Quintal(100kg)"),
    Text("Max Price: ₹${item['Max_Price']}"),
    Text("Min Price: ₹${item['Min_Price']}"),
    Text("Price: ₹${item['Modal_Price']}"),
    Text("Date: ${item['Arrival_Date']}"),
    ],
    ),
    ),
    );
    },
    ),
    ],
    ),
    ),
    ),
    );
  }
}
