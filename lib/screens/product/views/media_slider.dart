import 'dart:io';

import 'package:agroconnect/screens/product/views/videoPlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_player/video_player.dart';

class MediaSlider extends StatefulWidget {
  final List<String> mediaList;
  final List<bool> isVideoList;
  final List<bool> isFilePathList;

  const MediaSlider({
    super.key,
    required this.mediaList,
    required this.isVideoList,
    required this.isFilePathList,
  });

  @override
  State<MediaSlider> createState() => _MediaSliderState();
}

class _MediaSliderState extends State<MediaSlider> {
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, bool> _isInitialized = {};
  final Map<int, bool> _isPlaying = {};

  int _currentIndex = 0; // 👈 Add this to track current page

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeVideo(int index, String url) async {
    if (_videoControllers.containsKey(index)) return;

    final controller =
        url.startsWith("http")
            ? VideoPlayerController.network(url)
            : VideoPlayerController.file(File(url));

    await controller.initialize();

    setState(() {
      _videoControllers[index] = controller;
      _isInitialized[index] = true;
      _isPlaying[index] = false;
    });
  }

  // void _togglePlayPause(int index) {
  //   final controller = _videoControllers[index];
  //   if (controller == null || !_isInitialized[index]!) return;
  //
  //   if (_isPlaying[index]!) {
  //     controller.pause();
  //   } else {
  //     controller.play();
  //   }
  //
  //   setState(() {
  //     _isPlaying[index] = !_isPlaying[index]!;
  //   });
  // }

  void _togglePlayPause(int index) {
    final controller = _videoControllers[index];
    if (controller == null) return;

    setState(() {
      for (int i = 0; i < _isPlaying.length; i++) {
        if (i != index && _isPlaying[i] == true) {
          _videoControllers[i]?.pause();
          _isPlaying[i] = false;
        }
      }

      if (controller.value.isPlaying) {
        controller.pause();
        _isPlaying[index] = false;
      } else {
        controller.play();
        _isPlaying[index] = true;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: widget.mediaList.length,
          itemBuilder: (context, index, _) {
            final url = widget.mediaList[index];
            final isVideo = widget.isVideoList[index];

            if (isVideo) {
              _initializeVideo(index, url);
              final controller = _videoControllers[index];

              if (controller == null || !_isInitialized[index]!) {
                return const Center(child: CircularProgressIndicator());
              }
              return GestureDetector(
                onTap: () => _togglePlayPause(index),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller.value.size.width*30,
                        height: controller.value.size.height*30,
                        child: VideoPlayer(controller),
                      ),
                    ),
                    if (!_isPlaying[index]!)
                      const Icon(
                        Icons.play_circle_fill,
                        size: 64,
                        color: Colors.white70,
                      ),
                  ],
                ),
              );

              // return FittedBox(
              //   fit: BoxFit.cover,
              //   child: SizedBox(
              //     height: 100,
              //     width: 150,
              //     child:VideoPlayer(controller) ,
              //   )
              //
              // );

              // return GestureDetector(
              //   onTap: () => _togglePlayPause(index),
              //   child: Stack(
              //     alignment: Alignment.center,
              //     children: [
              //       AspectRatio(
              //         aspectRatio: controller.value.aspectRatio,
              //         child: VideoPlayer(controller),
              //       ),
              //       if (!_isPlaying[index]!)
              //         const Icon(
              //           Icons.play_circle_fill,
              //           size: 64,
              //           color: Colors.white70,
              //         ),
              //     ],
              //   ),
              // );
            } else {
              return url.startsWith("http")
                  ? Image.network(
                    url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                  : Image.file(
                    File(url),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
            }
          },
          options: CarouselOptions(
            // height: 300,
            autoPlay: false,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            // viewportFraction: 1.0,
            enableInfiniteScroll: true,
            animateToClosest: true,
            disableCenter: false,
            pauseAutoPlayOnTouch: true,
            // height: 200,
            // onPageChanged: (index, reason) {
            //   setState(() {
            //     _currentIndex = index;
            //   });
            // },
            onPageChanged: (index, reason) {
              setState(() {
                // Pause all video players
                for (int i = 0; i < _videoControllers.length; i++) {
                  final controller = _videoControllers[i];
                  if (controller != null && controller.value.isPlaying) {
                    controller.pause();
                    _isPlaying[i] = false;
                  }
                }

                _currentIndex = index;
              });
            },
          ),
        ),

        /// 👇 Index Indicator at Bottom Center
        Positioned(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1} / ${widget.mediaList.length}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          bottom: 10,
          // left: 10,
          right: 10,
        ),
      ],
    );
  }
}

// class MediaSlider extends StatefulWidget {
//   final List<String> mediaList;
//   final List<bool> isVideoList;
//   final List<bool> isFilePathList;
//
//   const MediaSlider({
//     super.key,
//     required this.mediaList,
//     required this.isVideoList,
//     required this.isFilePathList,
//   });
//
//   @override
//   State<MediaSlider> createState() => _MediaSliderState();
// }
//
// class _MediaSliderState extends State<MediaSlider> {
//   final Map<int, VideoPlayerController> _videoControllers = {};
//   final Map<int, bool> _isInitialized = {};
//   final Map<int, bool> _isPlaying = {};
//
//   @override
//   void dispose() {
//     for (var controller in _videoControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   Future<String> _generateThumbnail(String videoUrl) async {
//     return await VideoThumbnail.thumbnailFile(
//       video: videoUrl,
//       imageFormat: ImageFormat.JPEG,
//       maxHeight: 200,
//       quality: 75,
//     ) ??
//         '';
//   }
//
//   void _initializeVideo(int index, String url) async {
//     if (_videoControllers.containsKey(index)) return;
//
//     final controller = url.startsWith("http")
//         ? VideoPlayerController.network(url)
//         : VideoPlayerController.file(File(url));
//
//     await controller.initialize();
//
//     setState(() {
//       _videoControllers[index] = controller;
//       _isInitialized[index] = true;
//       _isPlaying[index] = false;
//     });
//   }
//
//   void _togglePlayPause(int index) {
//     final controller = _videoControllers[index];
//     if (controller == null || !_isInitialized[index]!) return;
//
//     if (_isPlaying[index]!) {
//       controller.pause();
//     } else {
//       controller.play();
//     }
//
//     setState(() {
//       _isPlaying[index] = !_isPlaying[index]!;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider.builder(
//       itemCount: widget.mediaList.length,
//       itemBuilder: (context, index, _) {
//         final url = widget.mediaList[index];
//         final isVideo = widget.isVideoList[index];
//
//         if (isVideo) {
//           _initializeVideo(index, url);
//           final controller = _videoControllers[index];
//
//           if (controller == null || !_isInitialized[index]!) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           return GestureDetector(
//             onTap: () => _togglePlayPause(index),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 AspectRatio(
//                   aspectRatio: controller.value.aspectRatio,
//                   child: VideoPlayer(controller),
//                 ),
//                 if (!_isPlaying[index]!)
//                   const Icon(Icons.play_circle_fill,
//                       size: 64, color: Colors.white70),
//               ],
//             ),
//           );
//         } else {
//           return url.startsWith("http")
//               ? Image.network(url, fit: BoxFit.cover, width: double.infinity)
//               : Image.file(File(url), fit: BoxFit.cover, width: double.infinity);
//         }
//       },
//       options: CarouselOptions(
//         // height: 300,
//         autoPlay: false,
//         // enlargeCenterPage: true,
//         // viewportFraction: 1.0,
//         enableInfiniteScroll: false,
//         enlargeCenterPage: true,
//         aspectRatio: 16 / 9,
//       ),
//     );
//   }
// }

// class MediaSlider extends StatelessWidget {
//   final List<String> mediaList;
//   final List<bool> isVideoList;
//   final List<bool> isFilePathList;
//
//   const MediaSlider({
//     super.key,
//     required this.mediaList,
//     required this.isVideoList,
//     required this.isFilePathList,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider.builder(
//       itemCount: mediaList.length,
//       itemBuilder: (context, index, realIdx) {
//         final media = mediaList[index];
//         final isVideo = isVideoList[index];
//
//         if (isVideo) {
//           return _buildVideoThumbnail(media, context);
//         } else {
//           return _buildImage(media);
//         }
//       },
//       options: CarouselOptions(
//         autoPlay: false,
//         enlargeCenterPage: true,
//         aspectRatio: 16 / 9,
//       ),
//     );
//   }
//
//   Widget _buildImage(String url) {
//     return url.startsWith("http")
//         ? Image.network(url, fit: BoxFit.cover, width: double.infinity)
//         : Image.file(File(url), fit: BoxFit.cover, width: double.infinity);
//   }
//
//   Widget _buildVideoThumbnail(String videoUrl, BuildContext context) {
//     return FutureBuilder<String>(
//       future: _generateVideoThumbnail(videoUrl),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
//           return const Center(child: Icon(Icons.error, size: 40));
//         }
//
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => VideoPlayerScreen(videoUrl: videoUrl)),
//             );
//           },
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Image.file(
//                 File(snapshot.data!),
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//               ),
//               const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<String> _generateVideoThumbnail(String videoUrl) async {
//     return await VideoThumbnail.thumbnailFile(
//       video: videoUrl,
//       imageFormat: ImageFormat.JPEG,
//       maxHeight: 200,
//       quality: 75,
//     ) ??
//         '';
//   }
// }

// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'dart:io';
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
// import 'package:video_player/video_player.dart';
//
// class MediaSlider extends StatelessWidget {
//   final List<String> mediaList;
//   final List<bool> isVideoList;
//   final List<bool> isFilePathList;
//
//   const MediaSlider({
//     super.key,
//     required this.mediaList,
//     required this.isVideoList,
//     required this.isFilePathList,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300,
//       child: PageView.builder(
//         itemCount: mediaList.length,
//         itemBuilder: (context, index) {
//           final isVideo = isVideoList[index];
//           final url = mediaList[index];
//
//           if (isVideo) {
//             return Stack(
//               alignment: Alignment.center,
//               children: [
//                 Image.asset(
//                   'assets/icons/video_placeholder.jpg', // Show placeholder/thumb
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//                 IconButton(
//                   iconSize: 64,
//                   icon: const Icon(Icons.play_circle_fill, color: Colors.white),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => VideoPlayerScreen(videoUrl: url),
//                       ),
//                     );
//                   },
//                 )
//               ],
//             );
//           } else {
//             return Image.network(
//               url,
//               fit: BoxFit.cover,
//               width: double.infinity,
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
//
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerScreen({super.key, required this.videoUrl});
//
//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   ChewieController? _chewieController;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _chewieController = ChewieController(
//             videoPlayerController: _controller,
//             autoPlay: true,
//             looping: false,
//           );
//         });
//       });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Video")),
//       body: _chewieController != null && _controller.value.isInitialized
//           ? Chewie(controller: _chewieController!)
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }

// class MediaSlider extends StatelessWidget {
//   final List<String> mediaList;
//   final List<bool> isVideoList; // A list to check if the media is a video
//   final List<bool> isFilePathList; // A list to check if the media is a file path
//
//   MediaSlider({
//     required this.mediaList,
//     required this.isVideoList,
//     required this.isFilePathList,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider.builder(
//       itemCount: mediaList.length,
//       itemBuilder: (BuildContext context, int index, int realIndex) {
//         final media = mediaList[index];
//         final isVideo = isVideoList[index];
//         final isFilePath = isFilePathList[index];
//
//         if (isVideo) {
//           // Show video thumbnail for video media
//           return _buildVideoThumbnail(media);
//         } else {
//           // Show image for image media
//           return _buildImage(media);
//         }
//       },
//       options: CarouselOptions(
//         autoPlay: false,
//         aspectRatio: 16/9,
//         enlargeCenterPage: true,
//         enableInfiniteScroll: true,
//       ),
//     );
//   }
//
//   // Widget to display image
//   Widget _buildImage(String url) {
//     return Image.network(
//       url,
//       fit: BoxFit.cover,
//       width: double.infinity,
//       height: double.infinity,
//     );
//   }
//
//   // Widget to display video thumbnail
//   // Widget _buildVideoThumbnail(String videoUrl) {
//   //   return FutureBuilder<String>(
//   //     future: _generateVideoThumbnail(videoUrl), // Generate video thumbnail
//   //     builder: (context, snapshot) {
//   //       if (snapshot.connectionState == ConnectionState.waiting) {
//   //         return Center(child: CircularProgressIndicator());
//   //       }
//   //
//   //       if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
//   //         return Center(child: Icon(Icons.error));
//   //       }
//   //
//   //       return Stack(
//   //         alignment: Alignment.center,
//   //         children: [
//   //           Image.file(
//   //             File(snapshot.data!), // Local file path
//   //             fit: BoxFit.cover,
//   //             width: double.infinity,
//   //             height: double.infinity,
//   //           ),
//   //           Icon(
//   //             Icons.play_circle_fill,
//   //             size: 64,
//   //             color: Colors.white.withOpacity(0.7),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//
//   // Function to generate a thumbnail from a video URL (You need a package like `video_thumbnail` for this)
//   Widget _buildVideoThumbnail(String videoUrl) {
//     return FutureBuilder<String>(
//       future: _generateVideoThumbnail(videoUrl),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
//           return Center(child: Icon(Icons.error));
//         }
//
//         return _InPlaceVideoPlayer(
//           videoUrl: videoUrl,
//           thumbnailPath: snapshot.data!,
//         );
//       },
//     );
//   }
//
//   Future<String> _generateVideoThumbnail(String videoUrl) async {
//     final thumbnail = await VideoThumbnail.thumbnailFile(
//       video: videoUrl,
//       imageFormat: ImageFormat.JPEG,
//       maxHeight: 100,
//       quality: 75,
//     );
//     return thumbnail ?? ''; // Return the thumbnail path or URL
//   }
// }
//

// class _InPlaceVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final String thumbnailPath;
//
//   const _InPlaceVideoPlayer({
//     required this.videoUrl,
//     required this.thumbnailPath,
//   });
//
//   @override
//   State<_InPlaceVideoPlayer> createState() => _InPlaceVideoPlayerState();
// }
//
// class _InPlaceVideoPlayerState extends State<_InPlaceVideoPlayer> {
//   bool _isPlaying = false;
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.videoUrl.startsWith('http')
//         ? VideoPlayerController.network(widget.videoUrl)
//         : VideoPlayerController.file(File(widget.videoUrl));
//   }
//
//   void _playVideo() async {
//     await _controller.initialize();
//     _controller.play();
//     setState(() => _isPlaying = true);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _isPlaying
//         ? AspectRatio(
//       aspectRatio: _controller.value.aspectRatio,
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           VideoPlayer(_controller),
//           IconButton(
//             icon: Icon(Icons.fullscreen, color: Colors.white),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => VideoPlayerScreen(videoPath: widget.videoUrl),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     )
//         : GestureDetector(
//       onTap: _playVideo,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Image.file(
//             File(widget.thumbnailPath),
//             fit: BoxFit.cover,
//             width: double.infinity,
//             height: double.infinity,
//           ),
//           Icon(
//             Icons.play_circle_fill,
//             size: 64,
//             color: Colors.white.withOpacity(0.7),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String videoPath; // can be file path or network
//
//   VideoPlayerScreen({required this.videoPath});
//
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = widget.videoPath.startsWith('http')
//         ? VideoPlayerController.network(widget.videoPath)
//         : VideoPlayerController.file(File(widget.videoPath));
//
//     _controller.initialize().then((_) {
//       setState(() {});
//       _controller.play(); // auto play
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: VideoPlayer(_controller),
//         )
//             : CircularProgressIndicator(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.white,
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           color: Colors.black,
//         ),
//         onPressed: () {
//           setState(() {
//             _controller.value.isPlaying ? _controller.pause() : _controller.play();
//           });
//         },
//       ),
//     );
//   }
// }

// class _InPlaceVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final String thumbnailPath;
//
//   const _InPlaceVideoPlayer({
//     required this.videoUrl,
//     required this.thumbnailPath,
//   });
//
//   @override
//   State<_InPlaceVideoPlayer> createState() => _InPlaceVideoPlayerState();
// }
//
// class _InPlaceVideoPlayerState extends State<_InPlaceVideoPlayer> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.videoUrl.startsWith('http')
//         ? VideoPlayerController.network(widget.videoUrl)
//         : VideoPlayerController.file(File(widget.videoUrl));
//
//     _controller.addListener(() {
//       // Redraw UI when play/pause or end of video
//       if (mounted) setState(() {});
//     });
//
//     _controller.initialize().then((_) {
//       setState(() {
//         _isInitialized = true;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _togglePlayPause() {
//     if (!_controller.value.isInitialized) return;
//
//     if (_controller.value.isPlaying) {
//       _controller.pause();
//     } else {
//       _controller.play();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isInitialized) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return GestureDetector(
//       onTap: _togglePlayPause,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           ),
//
//           if (!_controller.value.isPlaying)
//             Icon(
//               Icons.play_circle_fill,
//               size: 64,
//               color: Colors.white.withOpacity(0.7),
//             ),
//
//           Positioned(
//             bottom: 8,
//             right: 8,
//             child: IconButton(
//               icon: const Icon(Icons.fullscreen, color: Colors.white),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => VideoPlayerScreen(videoPath: widget.videoUrl),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
