import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/key.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/apiCategoriesModel.dart';
import 'package:online_hunt_news/models/languageModel.dart';
import 'package:online_hunt_news/services/category_services.dart';
import 'package:online_hunt_news/services/post_service.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:provider/src/provider.dart';
import 'package:path/path.dart' as path;

import '../../helpers&Widgets/helper_class.dart';
import '../../services/general_settings_sservices.dart';

class SingleArticle extends StatefulWidget {
  final ApiArticle? article;
  const SingleArticle({Key? key, this.article}) : super(key: key);

  @override
  _SingleArticleState createState() => _SingleArticleState();
}

class _SingleArticleState extends State<SingleArticle> {
  List<String> states = [];
  List<dynamic> districts = [];
  List<String> contentTypes = ['image'.tr(), 'video'.tr()];
  List<String> languages = ['english'.tr(), 'hindi'.tr(), 'kannada'.tr()];
  // List<String> languages = ['english'.tr(),]
  String refernce = '';
  // String selectedState = '';
  // String selectedDistrict = '';
  String selectedContentType = '';
  // String selectedCategory = '';
  // String selectedLanguage = '';
  ApiCategories? selectedCategory;
  ApiLanguages? selectedLanguage;
  List<ApiCategories> apiCategories = [];
  List<ApiLanguages> apiLanguages = [];
  CategoryServices categoryServices = CategoryServices();
  PostServices postServices = PostServices();
  var _articleData;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final youtubeVideoUrl = new TextEditingController();
  final imageUrl = new TextEditingController();

  final imageThumbNailUrl = new TextEditingController();
  final videoThumbNailUrl = new TextEditingController();

  final articleTitleController = new TextEditingController();
  final sourceUrl = new TextEditingController();
  final description = new TextEditingController();
  final summary = new TextEditingController();
  final keywords = new TextEditingController();
  final imageDescription = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  Config config = new Config();
  String? _timestamp;
  String? _date;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future getDate() async {
    DateTime now = DateTime.now();
    String _d = DateFormat('dd MMMM yy').format(now);
    String _t = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      _timestamp = _t;
      _date = _d;
    });
  }
  //image Uploading

  String? imageUploadUrl;
  File? imageFile;
  String? fileName;
  bool loading = false;
  bool imageUpload = true;
  bool loadingFutures = true;

  File? videoFile;
  String? videoFileName;
  String? videoUploadUrl;
  bool videoUpload = true;
  @override
  void initState() {
    super.initState();
    // getStates(widget.article!.state);
    getDate();
    Future.wait([getPresentCategories(), getPresentLanguages()]).whenComplete(() {
      getArticleParameters();
      setState(() {
        loadingFutures = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('article details'.tr()),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back)),
      ),
      body: loadingFutures
          ? Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor))
          : Container(
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Colors.white),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      borderRadius: BorderRadius.circular(9),
                                      isExpanded: false,
                                      hint: Text('select category type'.tr(), style: TextStyle(overflow: TextOverflow.ellipsis)),
                                      value: selectedContentType.isNotEmpty ? selectedContentType : null,
                                      onChanged: (String? val) {
                                        setState(() {
                                          selectedContentType = val ?? '';
                                        });
                                      },
                                      items: contentTypes
                                          .map((contentTypeSelected) => DropdownMenuItem(child: Text(contentTypeSelected), value: contentTypeSelected))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Colors.white),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<ApiCategories>(
                                      borderRadius: BorderRadius.circular(9),
                                      isExpanded: false,
                                      hint: Text('select category'.tr()),
                                      value: selectedCategory != null ? selectedCategory : null,
                                      onChanged: (val) {
                                        setState(() {
                                          selectedCategory = val;
                                        });
                                      },
                                      items: apiCategories
                                          .map((caegorySelected) => DropdownMenuItem(child: Text(caegorySelected.categoryName!), value: caegorySelected))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Colors.white),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<ApiLanguages>(
                              borderRadius: BorderRadius.circular(9),
                              isExpanded: false,
                              hint: Text('select article language'.tr(), style: TextStyle(overflow: TextOverflow.ellipsis)),
                              value: selectedLanguage != null ? selectedLanguage : null,
                              onChanged: (val) {
                                setState(() {
                                  selectedLanguage = val;
                                });
                              },
                              items: apiLanguages
                                  .map((languageSelected) => DropdownMenuItem(child: Text(languageSelected.languageName!), value: languageSelected))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8),
                      child: TextFormField(
                        controller: articleTitleController,
                        validator: (v) {
                          if (v!.isEmpty) return 'article title cannot be empty'.tr();
                          return null;
                        },
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          labelText: 'enter the article title'.tr(),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: selectedContentType == contentTypes[0],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('upload Image'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                          Switch(
                            value: imageUpload,
                            onChanged: (val) {
                              setState(() {
                                imageUpload = val;
                              });
                              print(imageUpload);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    Visibility(
                      visible: selectedContentType == contentTypes[1],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('upload video'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 17,
                            child: Switch(
                              value: videoUpload,
                              onChanged: (val) {
                                setState(() {
                                  videoUpload = val;
                                });
                                print(videoUpload);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    videoUpload == false && selectedContentType == contentTypes[1]
                        ? Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: videoThumbNailUrl,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'video thumbnail cannot be empty'.tr();
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                                hintText: 'enter video thumbnail url'.tr(),
                              ),
                            ),
                          )
                        : imageUpload == false && selectedContentType == contentTypes[0]
                        ? Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: imageThumbNailUrl,
                              validator: (v) {
                                if (imageUpload == false) {
                                  if (v!.isEmpty) {
                                    return 'The image thumbnail URL cannot be empty';
                                  }
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                                hintText: 'enter thumbnail url'.tr(),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8), child: selectedContentTypeWidget()),
                    SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8),
                    //   child: TextFormField(
                    //     controller: sourceUrl,
                    //     decoration: InputDecoration(
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(9),
                    //           borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    //         ),
                    //         labelText: 'enter source url(optional)'.tr()),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8),
                    //   child: TextFormField(
                    //     controller: keywords,
                    //     validator: (v) {
                    //       if (v!.isEmpty) return 'keywords cannot be empty'.tr();
                    //     },
                    //     decoration: InputDecoration(
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(9),
                    //           borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    //         ),
                    //         labelText: 'enter keywords'.tr()),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8),
                    //   child: TextFormField(
                    //     controller: summary,
                    //     maxLines: 4,
                    //     validator: (v) {
                    //       if (v!.isEmpty) return 'summary cannot be empty'.tr();
                    //     },
                    //     decoration: InputDecoration(
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(9),
                    //           borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    //         ),
                    //         labelText: 'enter the summary'.tr()),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8),
                      child: TextFormField(
                        controller: description,
                        maxLines: 9,
                        validator: (v) {
                          if (v!.isEmpty) return 'the article description cannot be empty'.tr();
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          labelText: 'enter the description'.tr(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                    loading == true
                        ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white))
                        : MaterialButton(
                            onPressed: () {
                              uploadArticle();
                            },
                            child: Text(
                              'update'.tr(),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Future pickImage() async {
    final _imagePicker = ImagePicker();
    var imagepicked = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (imagepicked != null) {
      setState(() {
        imageFile = File(imagepicked.path);
        fileName = (imageFile!.path);
      });
    } else {
      print('No image selected!');
    }
  }

  Future pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ['mp4', 'webp'], type: FileType.custom);
    if (result != null) {
      videoFile = File(result.files.single.path!);
      setState(() {
        videoFileName = (path.basename(videoFile!.path));
      });
    } else {
      print('video not selected');
    }
  }

  Widget selectedContentTypeWidget() {
    if (selectedContentType != '') {
      if (selectedContentType == contentTypes[1]) {
        return videoUpload == false
            ? SizedBox.shrink()
            : Column(
                children: [
                  ElevatedButton(
                    onPressed: () => pickVideo(),
                    child: Text('pick video'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  videoFileName == null ? SizedBox.shrink() : Text('$videoFileName', style: TextStyle(fontWeight: FontWeight.w600), maxLines: 3),
                ],
              );
      } else {
        return imageUpload == false
            ? SizedBox.shrink()
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: Theme.of(context).primaryColor),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          LoadingCard(height: 230),
                          imageFile == null
                              ? Image.network(imageUploadUrl ?? '', fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: 230)
                              : Image.file(imageFile!, fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: 230),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Theme.of(context).primaryColor),
                                  color: Colors.white,
                                ),
                                child: IconButton(icon: Icon(Feather.edit), onPressed: () => pickImage()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: imageDescription,
                    validator: (v) {
                      if (v!.isEmpty) return 'image description cannot be empty'.tr();
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      labelText: 'image description'.tr(),
                    ),
                  ),
                ],
              );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  uploadArticle() {
    if (selectedContentType == '' || selectedCategory == '' || selectedLanguage == '') {
      if (selectedContentType == '') {
        Fluttertoast.showToast(msg: 'you need to pick a content type'.tr());
      } else if (selectedCategory == '') {
        Fluttertoast.showToast(msg: 'you need to pick a news category'.tr());
      } else if (selectedLanguage == '') {
        Fluttertoast.showToast(msg: 'you need to specify a language first'.tr());
      }
    } else {
      if (selectedContentType == contentTypes[0]) {
        if (formKey.currentState!.validate()) {
          saveToDatabase();
          // if (selectedState.isEmpty) {
          //   Fluttertoast.showToast(msg: 'you need to pick a state'.tr());
          // } else if (selectedDistrict.isEmpty) {
          //   Fluttertoast.showToast(msg: 'you need to pick a district'.tr());
          // }

          // else {
          //   //
          //   print('object');
          // }
        }
      } else {
        if (formKey.currentState!.validate()) {
          // if (selectedState.isEmpty) {
          //   Fluttertoast.showToast(msg: 'you need to pick a state'.tr());
          // } else if (selectedDistrict.isEmpty) {
          //   Fluttertoast.showToast(msg: 'you need to pick a district'.tr());
          // }
          if (imageUpload == true) {
            if (imageFile != null) {
              uploadPicture().whenComplete(() => saveToDatabase());
              // Fluttertoast.showToast(msg: "you need to pick an image first".tr());
            } else {
              setState(() {
                loading = true;
              });
              saveToDatabase();
            }
          } else {
            setState(() {
              loading = true;
            });
            saveToDatabase();
          }
        }
      }
    }
  }

  // Future saveToDatabase() async {
  //   // final SignInBloc sb = context.read<SignInBloc>();
  //   // final DocumentReference ref = firestore.collection('contents').doc(widget.article!.timestamp);
  //   // _articleData = {
  //   //   'category': getCategory(),
  //   //   'content type': getContentType(),
  //   //   'title': articleTitleController.text,
  //   //   'description': description.text,
  //   //   'image url': selectedContentType == contentTypes[0]
  //   //       ? videoThumbNailUrl.text
  //   //       : imageUpload == true
  //   //           ? imageUploadUrl
  //   //           : imageThumbNailUrl.text,
  //   //   'youtube url': youtubeVideoUrl.text,
  //   //   'loves': 0,
  //   //   'source': sourceUrl.text == '' ? null : sourceUrl.text,
  //   //   'date': _date,
  //   //   'timestamp': widget.article!.timestamp,
  //   //   'views': 0,
  //   //   'uid': sb.uid,
  //   //   // 'verified': false,
  //   //   'selectedLanguage': getLanguage(),
  //   //   'district': selectedDistrict,
  //   //   'state': selectedState,
  //   // };
  //   // await ref.update(_articleData).whenComplete(() => openSnacbar(scaffoldKey, 'updated successfully'.tr())).whenComplete(() {
  //   //   setState(() {
  //   //     loading = false;
  //   //   });
  //   // });
  // }
  Future saveToDatabase() async {
    // final SignInBloc sb = context.read<SignInBloc>();
    // final DocumentReference ref = firestore.collection('contents').doc(_timestamp);
    var bytes = utf8.encode(articleTitleController.text); // data being hashed
    var digest = sha1.convert(bytes);

    print("sha 1 value: ${digest.toString()}");
    print(DateTime.now().toString().substring(0, 19));
    _articleData = {
      "api_key": "$apiKey",
      "id": widget.article!.id,
      "lang_id": selectedLanguage!.languageId,
      "title": articleTitleController.text,
      "title_slug": articleTitleController.text,
      "title_hash": digest.toString(),
      "keywords": keywords.text,
      "summary": summary.text,
      "content": description.text,
      "category_id": selectedCategory!.categoyId,
      "image_big": null,
      "image_default": null,
      "image_slider": null,
      "image_mid": null,
      "image_small": null,
      "image_mime": "jpg",
      "image_storage": "local",
      "optional_url": sourceUrl.text,
      "pageviews": widget.article!.pageViews,
      "need_auth": widget.article!.need_auth,
      "is_slider": widget.article!.is_slider,
      "slider_order": widget.article!.slider_order,
      "is_featured": widget.article!.isFeatured,
      "featured_order": widget.article!.featured_order,
      "is_recommended": widget.article!.is_recommended,
      "is_breaking": widget.article!.is_breaking,
      "is_scheduled": widget.article!.is_scheduled,
      "visibility": await getGeneralSettings() == '0' ? '1' : "0",
      "show_right_column": widget.article!.showRight,
      "post_type": "article",
      "video_path": "",
      "video_storage": "local",
      "image_url": selectedContentType == contentTypes[0] && imageUpload == true
          ? imageFile == null
                ? widget.article!.imageUrl
                : imageUploadUrl
          : imageThumbNailUrl.text,
      "video_url": selectedContentType == contentTypes[1] && videoUpload == true
          ? videoFile == null
                ? widget.article!.videoUrl
                : '${HelperClass.fileUpload}${path.basename(videoFile!.path)}'
          : videoThumbNailUrl.text,
      "video_embed_code": "",
      "user_id": widget.article!.userId,
      "status": "1",
      "feed_id": 0,
      "post_url": sourceUrl.text,
      "show_post_url": "0",
      "image_description": imageDescription.text,
      "show_item_numbers": "1",
      "updated_at": DateTime.now().toString().substring(0, 19),
      "created_at": widget.article!.createdAt,
    };

    await postServices
        .updatePosts('posts', _articleData)
        .then((value) {
          Map mapRes = jsonDecode(value.body);

          if (value.statusCode == 200) {
            if (mapRes['status'] == true) {
              Fluttertoast.showToast(msg: mapRes['message']);
            } else {
              Fluttertoast.showToast(msg: mapRes['message']);
            }
          } else {}
        })
        .whenComplete(() {
          setState(() {
            loading = false;
          });
        });
  }

  Future uploadPicture() async {
    setState(() {
      loading = true;
    });
    final SignInBloc sb = context.read<SignInBloc>();
    Reference storageReference = FirebaseStorage.instance.ref().child('User Uploads/${sb.uid}');
    UploadTask uploadTask = storageReference.putFile(imageFile!);

    await uploadTask.whenComplete(() async {
      var _url = await storageReference.getDownloadURL();
      var _imageUrl = _url.toString();
      setState(() {
        imageUploadUrl = _imageUrl;
      });
    });
  }

  String getContentType() {
    if (selectedContentType == 'video'.tr()) {
      return 'video';
    } else if (selectedContentType == 'image'.tr()) {
      return 'image';
    } else {
      return '';
    }
  }

  Future getPresentCategories() async {
    List response = [];
    List<ApiCategories> dummyList = [];
    try {
      await categoryServices
          .getCategories()
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            response.forEach((element) {
              dummyList.add(ApiCategories.fromJson(element));
            });
          });
      dummyList.forEach((element) {
        apiCategories.add(element);
        // if (element.languageId == language) {

        // }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getPresentLanguages() async {
    List response = [];
    List<ApiLanguages> dummyList = [];
    try {
      await categoryServices
          .getCategories()
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            response.forEach((element) {
              dummyList.add(ApiLanguages.fromJson(element));
            });
          });
      dummyList.forEach((element) {
        apiLanguages.add(element);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  getArticleParameters() {
    selectedCategory = apiCategories.where((element) => element.categoyId == widget.article!.categoryId ? true : false).first;
    selectedContentType = widget.article!.videoUrl!.isEmpty ? 'image'.tr() : 'video'.tr();
    selectedLanguage = apiLanguages.where((element) => element.languageId == widget.article!.langId ? true : false).first;
    articleTitleController.text = widget.article!.title ?? '';
    sourceUrl.text = widget.article!.postUrl ?? '';
    description.text = widget.article!.content ?? '';
    summary.text = widget.article!.summary ?? '';
    youtubeVideoUrl.text = widget.article!.videoUrl ?? '';
    imageUploadUrl = widget.article!.imageUrl;
    keywords.text = widget.article!.keywords ?? '';
    imageDescription.text = widget.article!.imageDesc ?? '';
    videoThumbNailUrl.text = widget.article!.videoUrl ?? '';
  }

  Future getGeneralSettings() async {
    String approveUserUploaded = '0';
    try {
      await GeneralSettingsServices().getGeneralSettings().then((value) {
        if (value.isNotEmpty) {
          print(value[0].postApproval);
          approveUserUploaded = value[0].postApproval!;
        }
      });
    } catch (e) {
      print(e.toString());
    }
    return approveUserUploaded;
  }
}
