import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_hunt_news/blocs/theme_bloc.dart';
import 'package:online_hunt_news/cards/sliver_card.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/categoryModel.dart';
import 'package:online_hunt_news/models/custom_color.dart';
import 'package:online_hunt_news/models/metaModel.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/services/category_services.dart';
import 'package:online_hunt_news/utils/empty.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../helpers&Widgets/key.dart';

class CategoryBasedArticles extends StatefulWidget {
  final String? category;
  final String? categoryId;
  final Category? categoryModel;
  // final String? categoryImage;
  final String tag;
  CategoryBasedArticles({Key? key, required this.category, required this.tag, this.categoryId, this.categoryModel}) : super(key: key);

  @override
  _CategoryBasedArticlesState createState() => _CategoryBasedArticlesState();
}

class _CategoryBasedArticlesState extends State<CategoryBasedArticles> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionName = 'contents';
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  bool _isLoadingMore = false;

  List<DocumentSnapshot> _snap = [];
  List<PostModel> posts = [];
  Metamodel? metaData;
  int currentPage = 1;
  int totalPages = 1;
  bool _hasData = false;
  CategoryServices categoryServices = CategoryServices();
  late List adsList;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    // _getData();
    getApiCategories(mounted);
  }

  onRefresh() {
    setState(() {
      _snap.clear();
      posts.clear();
      currentPage = 1;
      totalPages = 1;
      _isLoading = true;
      _lastVisible = null;
    });
    // _getData();
    getApiCategories(mounted);
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        if (mounted) {
          setState(() => _isLoading = true);
        }
        if (metaData!.total == posts.length) {
          print('no more data');
          return;
        } else {
          getApiCategories(mounted);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tb = context.watch<ThemeBloc>();
    return Scaffold(
      body: RefreshIndicator(
        child: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              backgroundColor: tb.darkTheme == false ? CustomColor().sliverHeaderColorLight : CustomColor().sliverHeaderColorDark,
              expandedHeight: MediaQuery.of(context).size.height * 0.20,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                background: Hero(
                  tag: widget.tag,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Theme.of(context).primaryColor, Theme.of(context).scaffoldBackgroundColor],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Text('${widget.category!}'),
                    SizedBox(width: 5),
                    posts.isNotEmpty
                        ? Text(
                            '${'page'.tr()} ${metaData!.currentPage} ${'of'.tr()} ${metaData!.totalPages}',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                titlePadding: EdgeInsets.only(left: 20, bottom: 15, right: 20),
              ),
            ),
            // _isLoading == true?Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor),size: 12,):
            _hasData == false || posts.isEmpty
                ? SliverFillRemaining(
                    child: _isLoading == true
                        ? Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor), size: 12)
                        : Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.30),
                              EmptyPage(icon: Icons.note_add, message: 'no articles found'.tr(), message1: ''),
                            ],
                          ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == posts.length) {
                          return _buildProgressIndicator();
                        }
                        return SliverCard(apiArticle: posts[index], heroTag: 'categorybased$index', categoryName: widget.categoryModel!.name);
                      }, childCount: posts.length),
                    ),
                  ),
          ],
        ),
        onRefresh: () async => onRefresh(),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(opacity: _isLoadingMore ? 1.0 : 0.0, child: new Loading()),
      ),
    );
  }

  Future getApiCategories(mounted) async {
    // setState(() => _hasData = true);
    Map<String, dynamic> response = {};
    // List<ApiArticle> dummyList = [];
    int language = await returnCategoryId();
    // List<ApiCategories> apiCategories = [];
    if (mounted && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
    }
    try {
      await categoryServices
          .getCategoriesWithPosts(widget.categoryModel!.id, currentPage)
          .then((value) {
            response = jsonDecode(value.body);
            print(response['posts'].length);
          })
          .whenComplete(() {
            for (int i = 0; i < response['posts'].length; i++) {
              posts.add(PostModel.fromJson(response['posts'][i]));
            }
            metaData = Metamodel.fromJson(response['meta']);
            totalPages = metaData!.totalPages;
          });

      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasData = true;
          _isLoadingMore = false;

          currentPage++;

          print('no more items');
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
