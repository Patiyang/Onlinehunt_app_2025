import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/models/apiComment.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/services/comment_services.dart';
import 'package:online_hunt_news/services/userServices.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/sign_in_bloc.dart';
import '../helpers&Widgets/key.dart';
import '../helpers&Widgets/loading.dart';
import '../utils/empty.dart';
import '../utils/sign_in_dialog.dart';
import '../utils/toast.dart';

class CommentsPage extends StatefulWidget {
  final String? articleId;
  const CommentsPage({Key? key, required this.articleId}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionName = 'contents';
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<ApiComment> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var textCtrl = TextEditingController();
  bool? _hasData;
  CommentServices _commentServices = CommentServices();
  int _lastIndex = 0;
  int currentPage = 1;
  String? userId;
  @override
  void initState() {
    getUserDetails();
    // controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    // _getData();
    _getApiData(false);
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent && controller!.position.outOfRange) {
        setState(() => _isLoading = true);
        _getApiData(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('comments').tr(),
        titleSpacing: 0,
        actions: [IconButton(icon: Icon(Feather.rotate_cw, size: 22), onPressed: () => _getApiData(false))],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading == true
                ? Loading(text: 'please wait'.tr())
                : RefreshIndicator(
                    child: _hasData == false
                        ? ListView(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                              EmptyPage(icon: LineIcons.comments, message: 'no comments found'.tr(), message1: 'be the first to comment'.tr()),
                            ],
                          )
                        : ListView.separated(
                            padding: EdgeInsets.all(15),
                            controller: controller,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: _data.length,
                            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                            itemBuilder: (_, int index) {
                              return _commentCard(_data[index]);
                              // if (index < _data.length) {
                              //   return _commentCard(_data[index]);
                              // }
                              // return Opacity(
                              //   opacity: _isLoading ? 1.0 : 0.0,
                              //   child: _lastVisible == null
                              //       ? LoadingCard(height: 100)
                              //       : Center(
                              //           child: SizedBox(width: 32.0, height: 32.0, child: new CupertinoActivityIndicator()),
                              //         ),
                              // );
                            },
                          ),
                    onRefresh: () async {
                      _getApiData(false);
                    },
                  ),
          ),
          Divider(height: 1, color: Color.fromARGB(66, 29, 25, 25)),
          SafeArea(
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 8, bottom: 10, right: 20, left: 20),
              width: double.infinity,
              color: Theme.of(context).primaryColorLight,
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).splashColor, borderRadius: BorderRadius.circular(25)),
                child: TextFormField(
                  decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 0),
                    contentPadding: EdgeInsets.only(left: 15, top: 10, right: 5),
                    border: InputBorder.none,
                    hintText: 'write a comment'.tr(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, size: 20),
                      onPressed: () {
                        handleSubmit();
                      },
                    ),
                  ),
                  controller: textCtrl,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentCard(ApiComment d) {
    return InkWell(
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              child: FutureBuilder(
                future: getImageUrl(d.userId),
                initialData: Config().noImage,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // Fluttertoast.showToast(msg: snapshot.data.toString());
                  String image = snapshot.data ?? Config().noImage;
                  return image.contains('noImage.png')
                      ? CircleAvatar(radius: 25, backgroundColor: Colors.grey[300], child: Image.asset(image, height: 30))
                      : CircleAvatar(radius: 25, backgroundColor: Colors.grey[300], backgroundImage: CachedNetworkImageProvider(image));
                },
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 3),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.grey[700], width: 0.5),
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                d.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              // context.read<CommentsBloc>().flagList.contains(d.timestamp)
                              //     ? Text('comment flagged').tr()
                              Text(
                                d.comment!,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColorDark),
                              ),
                            ],
                          ),
                        ),
                        userId == d.userId ? IconButton(onPressed: () => handleDelete(d), icon: Icon(Icons.delete)) : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      d.createdAt!,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  openPopupDialog(ApiComment d) {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(20),
          children: [
            sb.uid == d.id
                ? ListTile(
                    title: Text('delete').tr(),
                    leading: Icon(Icons.delete),
                    onTap: () => print('object'), //handleDelete(d),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  Future handleDelete(ApiComment d) async {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openToast(context, 'no internet'.tr());
      } else {
        _commentServices
            .deleteComment(d.id!)
            .then((value) {
              print(value.request);
            })
            .whenComplete(() => _getApiData(false));
        // _getApiData();
      }
    });
  }

  Future handleSubmit() async {
    final SignInBloc sb = context.read<SignInBloc>();
    if (sb.guestUser == true) {
      openSignInDialog(context);
    } else {
      if (textCtrl.text.isEmpty) {
        print('Comment is empty');
      } else {
        await AppService().checkInternet().then((hasInternet) {
          if (hasInternet == false) {
            openToast(context, 'no internet'.tr());
          } else {
            var apiBody = {
              "api_key": "$apiKey",
              "parent_id": "0",
              "post_id": widget.articleId,
              "user_id": userId,
              "email": sb.email,
              "name": sb.name,
              "comment": textCtrl.text,
              "ip_address": "--",
              "like_count": "0",
              "status": "1",
              // "created_at": DateTime.now().toString().substring(0, 19)
            };

            _commentServices.createComment('comments', apiBody).whenComplete(() => _getApiData(true));

            textCtrl.clear();
            FocusScope.of(context).requestFocus(new FocusNode());
          }
        });
      }
    }
  }

  void _getApiData(bool adding) async {
    _data = [];
    print(currentPage);
    List response = [];
    List<ApiComment> comments = [];

    setState(() {
      _isLoading = true;
    });

    try {
      await _commentServices
          .getComments(widget.articleId!, currentPage)
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            for (int i = 0; i < response.length; i++) {
              comments.add(ApiComment.fromJson(response[i]));
            }
            _lastIndex = _lastIndex + 4;
          })
          .catchError((onError) {});
      comments.forEach((element) {
        if (!_data.contains(element)) {
          _data.add(element);
        }
      });
      await getUserDetails();
      setState(() {
        if (adding == true) {
          currentPage++;
        }
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  getUserDetails() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await UserServices().getUserDetails().then((value) {
      print(value.id);
      if (value.id == null) {
        userId = sp.getString('uid');
      } else {
        userId = value.id!;
      }
    });
  }

  Future printIps() async {
    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        print('${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      }
    }
  }

  Future<String> getImageUrl(userId) async {
    String userImage = Config().noImage;
    await UserServices().getUserById(userId).then((value) {
      userImage = value.avatar!;
    });

    return userImage.isEmpty ? Config().noImage : userImage;
  }
}
