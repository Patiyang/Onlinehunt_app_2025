import 'dart:async';
import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/live_news.dart';
import 'package:online_hunt_news/services/live_news_service.dart';

import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../helpers&Widgets/loading.dart';

class IptvVideo extends StatefulWidget {
  final LiveNews? iptvModel;
  final int? id;
  IptvVideo({Key? key, this.iptvModel, this.id}) : super(key: key);

  @override
  State<IptvVideo> createState() => _IptvVideoState();
}

class _IptvVideoState extends State<IptvVideo> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  late YoutubePlayerController _controller;
  bool success = false;
  bool loadingVideo = true;

  LiveNews? iptvModel;
  LiveNewsService liveNewsService = LiveNewsService();
  @override
  void initState() {
    super.initState();
    // initializePlayer();
    checkModelAvailability();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    if (chewieController != null && videoPlayerController != null) {
      chewieController!.dispose();
      videoPlayerController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: iptvModel!.url!.contains('youtube')
          ? AppBar(
              // toolbarHeight:iptvModel!.url!.contains('youtube')? _controller.value.isFullScreen ? 0 : 50:chewieController!.isFullScreen?0:50,
              toolbarHeight: loadingVideo == true
                  ? 0
                  : _controller.value.isFullScreen
                  ? 0
                  : 50,
              // backgroundColor:loadingVideo == true?Colors.transparent:iptvModel!.url!.contains('youtube')?_controller.value.isFullScreen ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent:chewieController!.isFullScreen ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text(iptvModel!.title!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              actions: [
                IconButton(
                  onPressed: () {
                    HelperClass().handleContentShare(context, null, liveNews: iptvModel);
                  },
                  icon: Icon(Icons.share),
                ),
              ],
            )
          : AppBar(
              toolbarHeight: loadingVideo == true
                  ? 0
                  : chewieController!.isFullScreen
                  ? 0
                  : 50,
              elevation: 0,
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text(iptvModel!.title!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
      body: loadingVideo == true
          ? Center(
              child: Loading(
                text: '${'please wait'.tr()}...',
                spinkit: SpinKitSpinningCircle(color: Theme.of(context).primaryColor),
              ),
            )
          : success == false
          ? Center(
              child: Text('unable to load video'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            )
          : iptvModel!.url!.contains('youtube')
          ? Center(
              child: YoutubePlayer(controller: _controller, showVideoProgressIndicator: true, progressIndicatorColor: Theme.of(context).primaryColor),
            )
          : Chewie(controller: chewieController!),
    );
  }

  checkModelAvailability() async {
    if (widget.iptvModel == null) {
      await liveNewsService.getLive(widget.id!).then((value) {
        Map<String, dynamic> response = jsonDecode(value!.body);

        iptvModel = LiveNews.fromJson(response['data']);
        initializePlayer();
      });
    } else {
      iptvModel = widget.iptvModel;
      initializePlayer();
    }
  }

  initializePlayer() async {
    if (iptvModel!.url!.contains('youtube')) {
      try {
        // iptvModel = await IptvServices().getSingleIptv(widget.id!);
        _controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(iptvModel!.url!)!,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            forceHD: false,
            loop: true,
            controlsVisibleAtStart: true,
            isLive: true,
            showLiveFullscreenButton: true,
          ),
        );

        Timer.periodic(Duration(seconds: 1), (t) {});
        setState(() {
          loadingVideo = false;
          success = true;
        });
        _controller.addListener(() {
          if (_controller.value.isFullScreen) {
            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
            setState(() {});
          } else {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
            setState(() {});
          }
        });
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        // iptvModel = iptvModel;
        videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(iptvModel!.url!));

        await videoPlayerController!.initialize();

        chewieController = ChewieController(videoPlayerController: videoPlayerController!, autoPlay: true, looping: true, isLive: true);
        setState(() {
          loadingVideo = false;
          success = true;
        });
      } catch (e) {
        // Fluttertoast.showToast(msg: 'error encountered');
        setState(() {
          loadingVideo = false;
          success = false;
        });
        print(e.toString());
      }
    }
  }
}
