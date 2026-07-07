
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_hunt_news/blocs/live_news_bloc.dart';
import 'package:online_hunt_news/cards/iptv_item_card.dart';
import 'package:online_hunt_news/models/apiUserModel.dart';
import 'package:online_hunt_news/models/api_live_news.dart';
import 'package:online_hunt_news/models/iptv_like_model.dart';
import 'package:online_hunt_news/services/iptv_services.dart';
import 'package:provider/provider.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

import '../../helpers&Widgets/loading.dart';
import '../../services/userServices.dart';

class IptvList extends StatefulWidget {
  IptvList({Key? key}) : super(key: key);

  @override
  State<IptvList> createState() => _IptvListState();
}

class _IptvListState extends State<IptvList> with AutomaticKeepAliveClientMixin {
  IptvServices iptvServices = IptvServices();
  ScrollController scrollController = ScrollController();
  UserServices _userServices = UserServices();

  UserModel? apiUser;
  // List<IptvModel> iptvs = [];
  bool gettingIptvs = true;
  bool _isLoadingMore = false;
  List<String> fileNames = [];

  String uid = '';
  List<bool> handlingLikes = [];
  List<bool> liked = [];
  List<IptvLikeModel> likeId = [];
  UserServices userServices = UserServices();
  // IptvServices iptvServices = IptvServices();
  @override
  void initState() {
    super.initState();
    // getIptvs(false);

    Future.delayed(Duration(milliseconds: 300)).then((value) {
      context.read<LiveNewsBloc>().getApiData(mounted, context);
    });
  }

  _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange && _isLoadingMore == false) {
      print('loadingData');
      // getIptvs(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lb = context.watch<LiveNewsBloc>();
    return lb.loading == true
        ? Center(
            child: Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor)),
          )
        : lb.data.isEmpty
        ? RefreshIndicator(
            onRefresh: () => refresh(context),
            child: ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'no iptvs'.tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: () => refresh(context),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: lb.data.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 15);
              },
              itemBuilder: (BuildContext context, int index) {
                LiveNews item = lb.data[index];
                return IptvItemCard(item: item);
              },
            ),
          );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: GestureDetector(onTap: () => print(lb.data.length ), child: Text('iptv'.tr())),
    //   ),
    //   body:
    // );
  }

  Future refresh(BuildContext context) async {
    context.read<LiveNewsBloc>().onRefresh(mounted, context: context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
