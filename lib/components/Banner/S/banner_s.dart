import 'package:flutter/material.dart';

import '../../network_image_with_loader.dart';


import 'package:flutter/material.dart';

class BannerS extends StatelessWidget {
  const BannerS({
    super.key,
    required this.image,
    required this.press,
    required this.children,
  });

  final String image;
  final VoidCallback press;
  final List<Widget> children;

  bool get _isNetworkImage => image.startsWith('http');

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.56,
      child: GestureDetector(
        onTap: press,
        child: Stack(
          children: [
            _isNetworkImage
                ? Image.network(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            )
                : Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(color: Colors.black45),
            ...children,
          ],
        ),
      ),
    );
  }
}

// class BannerS extends StatelessWidget {
//   const BannerS(
//       {super.key,
//       required this.image,
//       required this.press,
//       required this.children});
//
//   final String image;
//   final VoidCallback press;
//   final List<Widget> children;
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 2.56,
//       child: GestureDetector(
//         onTap: press,
//         child: Stack(
//           children: [
//             NetworkImageWithLoader(image, radius: 0),
//             Container(color: Colors.black45),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }
// }
