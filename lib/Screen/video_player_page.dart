import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  // video player설정
  final String? videoUrl = '';
  VideoPlayerController? _videoController;
  Future<void>? _initVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(videoUrl!);
    _initVideoPlayerFuture = _videoController?.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('동영상 코너입니다'),
    );
  }
}
