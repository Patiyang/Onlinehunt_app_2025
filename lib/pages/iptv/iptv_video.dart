import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_hunt_news/models/iptv_model.dart';
import 'package:online_hunt_news/services/iptv_services.dart';
import 'package:video_player/video_player.dart';

import '../../helpers&Widgets/loading.dart';

class IptvVideo extends StatefulWidget {
  final IptvModel? iptvModel;
  final String? id;
  IptvVideo({Key? key, this.iptvModel, this.id}) : super(key: key);

  @override
  State<IptvVideo> createState() => _IptvVideoState();
}

class _IptvVideoState extends State<IptvVideo> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  bool success = false;
  bool loadingVideo = true;

  IptvModel? iptvModel;
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoPlayerController!.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('video'.tr())),
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
          : Chewie(controller: chewieController!),
    );
  }

  initializePlayer() async {
    if (widget.iptvModel == null) {
      try {
        iptvModel = await IptvServices().getSingleIptv(widget.id!);

        videoPlayerController = VideoPlayerController.network(iptvModel!.iptvUrl!);

        await videoPlayerController!.initialize();

        chewieController = ChewieController(videoPlayerController: videoPlayerController!, autoPlay: true, looping: true);
        setState(() {
          loadingVideo = false;
          success = true;
        });
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        iptvModel = widget.iptvModel;
        videoPlayerController = VideoPlayerController.network(iptvModel!.iptvUrl!);

        await videoPlayerController!.initialize();

        chewieController = ChewieController(videoPlayerController: videoPlayerController!, autoPlay: true, looping: true);
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
