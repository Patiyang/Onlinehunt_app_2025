import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_hunt_news/services/app_service.dart';

class Article {
  String? category;
  String? contentType;
  String? title;
  String? description;
  String? thumbnailImagelUrl;
  String? youtubeVideoUrl;
  String? videoID;
  int? loves;
  String? sourceUrl;
  String? date;
  String? timestamp;
  int? views;
  String? uid;
  bool? verified;
  String? selectedLanguage;
  String? state;
  String? district;
  String? articleType;
  String? author;

  Article({
    this.category,
    this.contentType,
    this.title,
    this.description,
    this.thumbnailImagelUrl,
    this.youtubeVideoUrl,
    this.videoID,
    this.loves,
    this.sourceUrl,
    this.date,
    this.timestamp,
    this.views,
    this.uid,
    this.verified,
    this.selectedLanguage,
    this.state,
    this.district,
    this.articleType,
    this.author,
  });

  factory Article.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return Article(
      category: d['category'],
      contentType: d['content type'],
      title: d['title'],
      description: d['description'],
      thumbnailImagelUrl: d['image url'],
      youtubeVideoUrl: d['youtube url'],
      videoID: d['content type'] == 'video' ? AppService.getYoutubeVideoIdFromUrl(d['youtube url']) : '',
      loves: d['loves'],
      sourceUrl: d['source'],
      date: d['date'],
      timestamp: d['timestamp'],
      views: d['views'] ?? null,
      uid: d['uid'] ?? '',
      verified: d['verified'] ?? false,
      selectedLanguage: d['selectedLanguage'] ?? '',
      state: d['state'] ?? '',
      district: d['district'] ?? '',
      articleType: d['articleType'] ?? '',
      author: d['author'] ?? 'Online Hunt',
    );
  }

  // factory Article.fromJson(Map<String, dynamic> json) => new Article();
}
