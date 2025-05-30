import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoService {
  // Request storage permission
  Future<void> requestPermissions() async {
    await Permission.storage.request();
  }

  // Generate a thumbnail from the video file
  Future<void> generateThumbnail(String videoPath) async {
    try {
      final String? thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        imageFormat: ImageFormat.PNG,
        maxWidth: 1280,
        maxHeight: 720,
        quality: 75,
      );
      print('Thumbnail generated at: $thumbnailPath');
    } catch (e) {
      print('Error generating thumbnail: $e');
    }
  }
}
