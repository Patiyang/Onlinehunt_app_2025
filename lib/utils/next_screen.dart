import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/pages/article_details.dart';

nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreeniOS(context, page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(context, page) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenPopup(context, page) {
  Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (context) => page));
}

void navigateToDetailsScreen(context, PostModel article, String? heroTag, String categoryId) {
  // if (article.videoUrl!.isNotEmpty) {
  //   // Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(
  //   //     builder: (context) => VideoArticleDetails(data: article, categoryId: categoryId, articleId: article.id),
  //   //   ),
  //   // );
  //   print('video');
  //   Fluttertoast.showToast(msg: 'msg');
  // } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetails(post: article, tag: heroTag, articleId: article.id.toString()),
      ),
    );
  // }
}

void navigateToDetailsScreenByReplace(context, PostModel article, String? heroTag, bool? replace, String categoryId) {
  if (replace == null || replace == false) {
    navigateToDetailsScreen(context, article, heroTag, categoryId);
  } else {
    // if (article.videoUrl!.isNotEmpty) {
    //   print(article.videoUrl);
    //   // Navigator.pushReplacement(
    //   //   context,
    //   //   MaterialPageRoute(builder: (context) => VideoArticleDetails(data: article)),
    //   // );
    // } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ArticleDetails(post: article, tag: heroTag, articleId: article.id.toString()),
        ),
      );
    // }
  }
}
