// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:online_hunt_news/helpers&Widgets/loading.dart';
// import 'package:online_hunt_news/models/apiUserModel.dart';
// import 'package:online_hunt_news/models/followingModel.dart';
// import 'package:online_hunt_news/pages/followScreen/author_details.dart';
// import 'package:online_hunt_news/services/userServices.dart';
// import 'package:online_hunt_news/utils/next_screen.dart';

// class HandleFollowing extends StatefulWidget {
//   final String operation;
//   final ApiUserModel apiUserModel;
//   const HandleFollowing({Key? key, required this.operation, required this.apiUserModel}) : super(key: key);

//   @override
//   State<HandleFollowing> createState() => _HandleFollowingState();
// }

// class _HandleFollowingState extends State<HandleFollowing> {
//   UserServices _userServices = UserServices();
//   List<ApiUserModel> users = [];
//   List<FollowingModel> followingStats = [];
//   bool gettingFollowing = true;
//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(widget.operation == 'get_followers' ? 'followers'.tr() : 'following'.tr(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: gettingFollowing
//             ? Center(
//                 child: Loading(spinkit: SpinKitRotatingCircle(color: Theme.of(context).primaryColor)),
//               )
//             : users.isEmpty
//             ? Center(
//                 child: Text(
//                   '${widget.operation == 'get_followers' ? 'no followers'.tr() : 'not following'.tr()}',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               )
//             : ListView.separated(
//                 padding: EdgeInsets.only(top: 10, left: 10, right: 10),
//                 itemCount: users.length,
//                 separatorBuilder: (BuildContext context, int index) {
//                   return SizedBox(height: 10);
//                 },
//                 itemBuilder: (BuildContext context, int index) {
//                   ApiUserModel singleUser = users[index];
//                   return InkWell(
//                     onTap: () => nextScreen(context, AuthorDetails(apiUserModel: singleUser)),
//                     child: Container(
//                       padding: EdgeInsets.all(7),
//                       decoration: BoxDecoration(color: Theme.of(context).primaryColorLight, borderRadius: BorderRadius.circular(5.0)),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           singleUser.avatar!.isEmpty
//                               ? Container(
//                                   height: 50,
//                                   width: 50,
//                                   alignment: Alignment.center,
//                                   child: Icon(Icons.person, size: 24),
//                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).scaffoldBackgroundColor),
//                                 )
//                               : Container(
//                                   height: 50,
//                                   width: 50,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                     image: DecorationImage(
//                                       image: CachedNetworkImageProvider(
//                                         singleUser.avatar!.contains('https') ? singleUser.avatar! : 'https://onlinehunt.in/news/${singleUser.avatar}',
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                           SizedBox(width: 10),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(singleUser.userName!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                               Text(singleUser.email!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }

//   getData() async {
//     await _userServices.getFollowing(widget.apiUserModel.id, widget.operation).then((value) {
//       followingStats = value;
//     });
//     followingStats.forEach((element) async {
//       users.add(await _userServices.userDetails(widget.operation == 'get_followers' ? element.followerId! : element.followingId!));
//     });

//     Future.delayed(Duration(seconds: 2)).then((value) {
//       setState(() {
//         gettingFollowing = false;
//       });
//     });

//     // print(users.length);
//   }
// }
