import 'package:agroconnect/screens/auth/views/auth_management.dart';
import 'package:agroconnect/screens/custom_api/common/current_market_price_screen.dart';
import 'package:agroconnect/screens/custom_api/common/mapScreen.dart';
import 'package:agroconnect/screens/custom_api/common/marketListScreen.dart';
import 'package:agroconnect/screens/custom_api/farmer/getProduct_userId.dart';
import 'package:agroconnect/screens/custom_product/auction_product_list_Screen.dart';
import 'package:agroconnect/screens/custom_product/regular_product_screen.dart';
import 'package:agroconnect/screens/product/views/addProductScreen.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agroconnect/constants.dart';
import 'package:agroconnect/route/screen_export.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}
//
// class _EntryPointState extends State<EntryPoint> {
//   String? typeOfUser = "";
//   bool _isLoading = true;
//   late List<NavItem> navItems;
//
//   void _loadUserType() async {
//     String? userType = await secureStorage.read(key: "typeOfUser");
//
//     if (userType == null || userType.isEmpty) {
//       if (mounted) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => LoginSelectionScreen()),
//               (Route<dynamic> route) => false,
//         );      }
//       return;
//     }
//
//     setState(() {
//       print("typeOfUser $typeOfUser");
//       typeOfUser = userType;
//       _isLoading = false;
//     });
//   }
//
//
//
//
//   // final List _pages = [
//   //
//   //   const HomeScreen(),
//   //   // const DiscoverScreen(),
//   //   const RegularProductListScreen(),
//   //
//   //   // BookmarkScreen(),
//   //   // EmptyCartScreen(), // if Cart is empty
//   //   // const CartScreen(),
//   //   AddProductScreen(),
//   //   // GetProductUserId(),
//   //   MarketListScreen(),
//   //   AuctionProductListScreen(),
//   //   MandiScreen(),
//   //   const ProfileScreen(),
//   // ];
//
//
//   List<Widget> getPages() {
//     if (typeOfUser == "farmer") {
//       return [
//         const HomeScreen(),
//         // const RegularProductListScreen(),
//         AddProductScreen(),
//         MarketListScreen(),
//         // AuctionProductListScreen(),
//         MandiScreen(),
//         const ProfileScreen(),
//       ];
//     } else if (typeOfUser == "merchant") {
//       return [
//         const HomeScreen(),
//         const RegularProductListScreen(),
//         const AuctionProductListScreen(),
//         MarketListScreen(),
//         MandiScreen(),
//         const ProfileScreen(),
//       ];
//     } else {
//       return [const Center(child: CircularProgressIndicator())];
//     }
//   }
//
//   int _currentIndex = 0;
//
//
//
//   List<NavItem> getNavItemsForUser(String role) {
//     if (role == 'farmer') {
//       return [
//         NavItem(page: HomeScreen(), item: BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home")),
//         NavItem(page: AddProductScreen(), item: BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: "Add")),
//         NavItem(page: MarketListScreen(), item: BottomNavigationBarItem(icon: Icon(Icons.map_sharp), label: "Markets")),
//         NavItem(page: MandiScreen(), item: BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_sharp), label: "Price")),
//         NavItem(page: ProfileScreen(), item: BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle), label: "Price")),
//
//       ];
//     } else {
//       return [
//         NavItem(page: HomeScreen(), item: BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home")),
//         NavItem(page: RegularProductListScreen(), item: BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Products")),
//         NavItem(page: RegularProductListScreen(), item: BottomNavigationBarItem(icon: Icon(Icons.hardware_outlined), label: "Auction")),
//         NavItem(page: MarketListScreen(), item: BottomNavigationBarItem(icon: Icon(Icons.map_sharp), label: "Markets")),
//         NavItem(page: MandiScreen(), item: BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_sharp), label: "Price")),
//         NavItem(page: ProfileScreen(), item: BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle), label: "Price")),
//       ];
//     }
//   }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserType();
//     navItems = getNavItemsForUser(typeOfUser!);
//   }
//
//   // void _loadUserType() async {
//   //   String? userType = await secureStorage.read(key: "typeOfUser");
//   //   setState(() {
//   //     typeOfUser = userType;
//   //   });
//   //
//   //   if (typeOfUser == null || typeOfUser!.isEmpty) {
//   //     Navigator.pushNamed(context, logInSelectionScreenRoute);
//   //   }
//   // }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     List<Widget> pages = getPages();
//
//     // Only show navigation bar if there are 2 or more pages
//     if (pages.length < 2) {
//       return const Scaffold(
//         body: Center(child: Text("Invalid user or insufficient pages.")),
//       );
//     }
//
//     return Scaffold(
//       body: pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: navItems.map((nav) => nav.item).toList(),
//       ),
//     );
//   }
//
//
//
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   final pages = getPages();
//   //   // if (_isLoading) {
//   //   //   return const Scaffold(
//   //   //     body: Center(child: CircularProgressIndicator()),
//   //   //   );
//   //   // }
//   //
//   //
//   //
//   //
//   //   // svgIcon moved outside build() so it can be reused
//   //   SvgPicture svgIcon(String src, {Color? color}) {
//   //     return SvgPicture.asset(
//   //       src,
//   //       height: 24,
//   //       colorFilter: ColorFilter.mode(
//   //         color ??
//   //             Theme.of(context).iconTheme.color!.withOpacity(
//   //               Theme.of(context).brightness == Brightness.dark ? 0.3 : 1,
//   //             ),
//   //         BlendMode.srcIn,
//   //       ),
//   //     );
//   //   }
//   //
//   //   BottomNavigationBarItem _navItem(String iconName, String label) {
//   //     return BottomNavigationBarItem(
//   //       icon: svgIcon("assets/images/primary/$iconName.svg"),
//   //       activeIcon: svgIcon(
//   //         "assets/images/primary/$iconName.svg",
//   //         color: primaryColor,
//   //       ),
//   //       label: label,
//   //     );
//   //   }
//   //
//   //   List<BottomNavigationBarItem> getBottomNavItems() {
//   //     if (typeOfUser == "farmer") {
//   //       return [
//   //         _navItem("home", "Home"),
//   //         _navItem("product", "Products"),
//   //         _navItem("add", "Add Product"),
//   //         _navItem("map", "Map"),
//   //         _navItem("auction", "Auction"),
//   //         _navItem("price", "Mandi"),
//   //         _navItem("Profile", "Profile"),
//   //       ];
//   //     } else if (typeOfUser == "merchant") {
//   //       return [
//   //         _navItem("home", "Home"),
//   //         _navItem("product", "Products"),
//   //         _navItem("map", "Map"),
//   //         _navItem("price", "Mandi"),
//   //         _navItem("Profile", "Profile"),
//   //       ];
//   //     } else {
//   //       return [];
//   //     }
//   //   }
//   //
//   //
//   //
//   //
//   //   // Ensure _currentIndex is in bounds
//   //   if (_currentIndex >= pages.length) {
//   //     _currentIndex = 0;
//   //   }
//   //
//   //   // SvgPicture svgIcon(String src, {Color? color}) {
//   //   //   return SvgPicture.asset(
//   //   //     src,
//   //   //     height: 24,
//   //   //     colorFilter: ColorFilter.mode(
//   //   //       color ??
//   //   //           Theme.of(context).iconTheme.color!.withOpacity(
//   //   //             Theme.of(context).brightness == Brightness.dark ? 0.3 : 1,
//   //   //           ),
//   //   //       BlendMode.srcIn,
//   //   //     ),
//   //   //   );
//   //   // }
//   //
//   //
//   //
//   //   return Scaffold(
//   //
//       appBar: AppBar(
//         // pinned: true,
//         // floating: true,
//         // snap: true,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         leading: const SizedBox(),
//         leadingWidth: 0,
//         centerTitle: false,
//         title: Row(
//           children: [
//             // Icon(Icons.cast_connected),
//             Text(
//               "Agroconnect",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.green,
//               ),
//             ),
//           ],
//         ),
//         // title: SvgPicture.asset(
//         //   "assets/images/freepik__a-logo-featuring-paddy-on-the-left-and-an-old-weig__13327.png",
//         //   colorFilter: ColorFilter.mode(
//         //     Theme.of(context).iconTheme.color!,
//         //     BlendMode.srcIn,
//         //   ),
//         //   height: 20,
//         //   width: 100,
//         // ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Navigator.pushNamed(context, searchScreenRoute);
//             },
//             icon: SvgPicture.asset(
//               "assets/icons/Search.svg",
//               height: 24,
//               colorFilter: ColorFilter.mode(
//                 Theme.of(context).textTheme.bodyLarge!.color!,
//                 BlendMode.srcIn,
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               // Navigator.pushNamed(context, notificationsScreenRoute);
//             },
//             icon: SvgPicture.asset(
//               "assets/icons/Notification.svg",
//               height: 24,
//               colorFilter: ColorFilter.mode(
//                 Theme.of(context).textTheme.bodyLarge!.color!,
//                 BlendMode.srcIn,
//               ),
//             ),
//           ),
//         ],
//       ),
//   //     // body: _pages[_currentIndex],
//   //     body: PageTransitionSwitcher(
//   //       duration: defaultDuration,
//   //       transitionBuilder: (child, animation, secondAnimation) {
//   //         return FadeThroughTransition(
//   //           animation: animation,
//   //           secondaryAnimation: secondAnimation,
//   //           child: child,
//   //         );
//   //       },
//   //       // child: _pages[_currentIndex],
//   //       child: getPages()[_currentIndex],
//   //
//   //     ),
//   //     bottomNavigationBar: Container(
//   //       padding: const EdgeInsets.only(top: defaultPadding / 2),
//   //       color:
//   //           Theme.of(context).brightness == Brightness.light
//   //               ? Colors.white
//   //               : const Color(0xFF101015),
//   //       child: BottomNavigationBar(
//   //         currentIndex: _currentIndex,
//   //         onTap: (index) {
//   //           if (index != _currentIndex) {
//   //             setState(() {
//   //               _currentIndex = index;
//   //             });
//   //           }
//   //         },
//   //         backgroundColor:
//   //             Theme.of(context).brightness == Brightness.light
//   //                 ? Colors.white
//   //                 : const Color(0xFF101015),
//   //         type: BottomNavigationBarType.fixed,
//   //         // selectedLabelStyle: TextStyle(color: primaryColor),
//   //         selectedFontSize: 12,
//   //         selectedItemColor: primaryColor,
//   //         unselectedItemColor: Colors.transparent,
//   //         items: getBottomNavItems(),
//   //         // items: [
//   //         //   BottomNavigationBarItem(
//   //         //     icon: svgIcon("assets/images/primary/home.svg"),
//   //         //     activeIcon: svgIcon(
//   //         //       "assets/images/primary/home.svg",
//   //         //       color: primaryColor,
//   //         //     ),
//   //         //     label: "Home",
//   //         //   ),
//   //         //
//   //         //   // BottomNavigationBarItem(
//   //         //   //   icon: svgIcon("assets/icons/Category.svg"),
//   //         //   //   activeIcon: svgIcon(
//   //         //   //     "assets/icons/Category.svg",
//   //         //   //     color: primaryColor,
//   //         //   //   ),
//   //         //   //   label: "Discover",
//   //         //   // ),
//   //         //   BottomNavigationBarItem(
//   //         //     icon: svgIcon("assets/images/primary/product.svg"),
//   //         //     activeIcon: svgIcon(
//   //         //       "assets/images/primary/product.svg",
//   //         //       color: primaryColor,
//   //         //     ),
//   //         //     label: "Products",
//   //         //   ),
//   //         //   // BottomNavigationBarItem(
//   //         //   //   icon: svgIcon("assets/icons/Bag.svg"),
//   //         //   //   activeIcon: svgIcon("assets/icons/Bag.svg", color: primaryColor),
//   //         //   //   label: "Cart",
//   //         //   // ),
//   //         //   BottomNavigationBarItem(
//   //         //     icon: svgIcon("assets/images/primary/add.svg"),
//   //         //     activeIcon: svgIcon(
//   //         //       "assets/images/primary/add.svg",
//   //         //       color: primaryColor,
//   //         //     ),
//   //         //     label: "Add Product",
//   //         //   ),
//   //         //   // BottomNavigationBarItem(
//   //         //   //   icon: svgIcon("assets/icons/Profile.svg"),
//   //         //   //   activeIcon: Icon(Icons.access_time_filled_outlined),
//   //         //   //   label: "Profile",
//   //         //   // ),
//   //         //   BottomNavigationBarItem(
//   //         //     icon: svgIcon("assets/images/primary/map.svg"),
//   //         //     activeIcon: svgIcon(
//   //         //       "assets/images/primary/map.svg",
//   //         //       color: primaryColor,
//   //         //     ),
//   //         //     label: "Map",
//   //         //   ),
//   //         //   BottomNavigationBarItem(
//   //         //     icon: svgIcon("assets/images/primary/auction.svg"),
//   //         //     activeIcon: svgIcon(
//   //         //       "assets/images/primary/auction.svg",
//   //         //       color: primaryColor,
//   //         //     ),
//   //         //     label: "Auction",
//   //         //   ),
//   //         //   BottomNavigationBarItem(
//   //         //     icon: svgIcon("assets/images/primary/price.svg"),
//   //         //     activeIcon: svgIcon(
//   //         //       "assets/images/primary/price.svg",
//   //         //       color: primaryColor,
//   //         //     ),
//   //         //     label: "Mandi",
//   //         //   ),
//   //         //
//   //         //   BottomNavigationBarItem(
//   //         //     icon: svgIcon("assets/icons/Profile.svg"),
//   //         //     activeIcon: svgIcon(
//   //         //       "assets/icons/Profile.svg",
//   //         //       color: primaryColor,
//   //         //     ),
//   //         //     label: "Profile",
//   //         //   ),
//   //         // ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }
//
//
//
// class NavItem {
//   final Widget page;
//   final BottomNavigationBarItem item;
//
//   NavItem({required this.page, required this.item});
// }



class _EntryPointState extends State<EntryPoint> {
  String? typeOfUser;
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  void _loadUserType() async {
    String? userType = await secureStorage.read(key: "typeOfUser");

    if (userType == null || userType.isEmpty) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginSelectionScreen()),
              (Route<dynamic> route) => false,
        );
      }
      return;
    }

    setState(() {
      typeOfUser = userType;
      _isLoading = false;
    });
  }

  SvgPicture svgIcon(String src, {Color? color}) {
    return SvgPicture.asset(
      src,
      height: 24,
      colorFilter: ColorFilter.mode(
        color ?? Colors.grey,
        BlendMode.srcIn,
      ),
    );
  }

  BottomNavigationBarItem _navItem(String iconName, String label) {
    return BottomNavigationBarItem(
      icon: svgIcon("assets/images/primary/$iconName.svg"),
      activeIcon: svgIcon("assets/images/primary/$iconName.svg", color: primaryColor),
      label: label,
    );
  }

  List<BottomNavigationBarItem> getBottomNavItems() {
    if (typeOfUser == "farmer") {
      return [
        _navItem("home", "Home"),
        _navItem("add", "Add"),
        _navItem("map", "Markets"),
        _navItem("price", "Price"),
        _navItem("Profile", "Profile"),
      ];
    } else if (typeOfUser == "merchant") {
      return [
        _navItem("home", "Home"),
        _navItem("product", "Products"),
        _navItem("auction", "Auction"),
        _navItem("map", "Markets"),
        _navItem("price", "Price"),
        _navItem("Profile", "Profile"),
      ];
    } else {
      return [];
    }
  }

  List<Widget> getPages() {
    if (typeOfUser == "farmer") {
      return [
        const HomeScreen(),
        AddProductScreen(),
        MarketListScreen(),
        MandiScreen(),
        const ProfileScreen(),
      ];
    } else if (typeOfUser == "merchant") {
      return [
        const HomeScreen(),
        const RegularProductListScreen(),
        const AuctionProductListScreen(),
        MarketListScreen(),
        MandiScreen(),
        const ProfileScreen(),
      ];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || typeOfUser == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final pages = getPages();
    final navItems = getBottomNavItems();

    return Scaffold(
      appBar:AppBar(
        // floating: true,
        // pinned: true,
        // snap: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        // title: Row(
        //   children: [
        //     // Icon(Icons.cast_connected),
        //     Text(
        //       "Agroconnect",
        //       style: TextStyle(
        //         fontSize: 28,
        //         fontWeight: FontWeight.w600,
        //         color: Colors.green,
        //       ),
        //     ),
        //   ],
        // ),
        // title: SvgPicture.asset(
        //   "assets/images/primary/Argoconnect-logo.png",
        //   colorFilter: ColorFilter.mode(
        //     Theme.of(context).iconTheme.color!,
        //     BlendMode.srcIn,
        //   ),
        //   height: 20,
        //   width: 100,
        // ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 2.0,
            maxScale: 2.0,
            child: Image.asset(
              "assets/images/primary/agroconnect_logo.png",
              height: 200,
              width: 120,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // title:Image.asset(
        //   "assets/images/primary/agroconnect_ogo.png",
        //   fit: BoxFit.contain,
        //   height: 200,
        //   width: 200,
        //   // color: Theme.of(context).iconTheme.color, // Optional: to apply tint
        // ),
          actions: [
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, searchScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.bodyLarge!.color!,
                BlendMode.srcIn,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, notificationsScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Notification.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.bodyLarge!.color!,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ) ,

      body: PageTransitionSwitcher(
        duration: defaultDuration,
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: navItems,
      ),
    );
  }
}
