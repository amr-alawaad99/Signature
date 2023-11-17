import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';

class MediaViewerFromURL extends StatelessWidget {
  final AssetType assetType;
  String url;
  MediaViewerFromURL({super.key, required this.url, required this.assetType});

  late VideoPlayerController videoPlayerController = VideoPlayerController.networkUrl(Uri.dataFromString(url));
  late ChewieController chewieController = ChewieController(videoPlayerController: videoPlayerController, aspectRatio: 16/9);

  @override
  void dispose(){
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(assetType == AssetType.image) {
      return Scaffold(
      body: Center(
        // using builder instead of just a PhotoView so it doesn't scroll to next page when moving in a zoomed image
        child: PhotoViewGallery.builder(
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(url),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          itemCount: 1,
        ),
      ),
    );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: VideoPlayerView(url: url, dataSourceType: DataSourceType.network,),
        ),
      );
    }
  }
}

/// Video Player
class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    required this.url,
    required this.dataSourceType,
  });

  final String url;

  final DataSourceType dataSourceType;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController;

  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    switch (widget.dataSourceType) {
      case DataSourceType.asset:
        _videoPlayerController = VideoPlayerController.asset(widget.url);
        break;
      case DataSourceType.network:
        _videoPlayerController = VideoPlayerController.network(widget.url);
        break;
      case DataSourceType.file:
        _videoPlayerController = VideoPlayerController.file(File(widget.url));
        break;
      case DataSourceType.contentUri:
        _videoPlayerController =
            VideoPlayerController.contentUri(Uri.parse(widget.url));
        break;
    }

    _videoPlayerController.initialize().then(
          (_) => setState(
            () => _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController, 
              aspectRatio: _videoPlayerController.value.aspectRatio,
              allowedScreenSleep: false,
              deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,],
              deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,]
            ),
          ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerController.value.isInitialized?
    SafeArea(
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        child: Chewie(controller: _chewieController),
      ),
    )
        : const SizedBox.shrink();
  }
}

