import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/helpers&Widgets/key.dart';
import 'package:online_hunt_news/models/apiUserModel.dart';
import 'package:online_hunt_news/services/userServices.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:uuid/uuid.dart';

class SignInBloc extends ChangeNotifier {
  SignInBloc() {
    checkSignIn();
    checkGuestUser();
    initPackageInfo();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = GoogleSignIn.instance;
  final FacebookAuth _fbAuth = FacebookAuth.instance;
  final String defaultUserImageUrl =
      'https://www.oxfordglobal.co.uk/nextgen-omics-series-us/wp-content/uploads/sites/16/2020/03/Jianming-Xu-e5cb47b9ddeec15f595e7000717da3fe.png';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserServices _userServices = UserServices();

  bool _guestUser = false;
  bool get guestUser => _guestUser;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _name;
  String? get name => _name;

  String? _uid;
  String? get uid => _uid;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  String? _idToken;
  String? get idToken => _idToken;

  String? _userType;
  String? get userType => _userType;

  String? _state;
  String? get state => _state;

  List<String>? _district;
  List<String>? get district => _district;

  String? _signInProvider;
  String? get signInProvider => _signInProvider;

  String? timestamp;

  String _appVersion = '0.0';
  String get appVersion => _appVersion;

  String _packageName = '';
  String get packageName => _packageName;

  void initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    _packageName = packageInfo.packageName;
    notifyListeners();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googlSignIn.attemptLightweightAuthentication();
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.idToken, idToken: googleAuth.idToken);
        // Fluttertoast.showToast(msg: googleUser.id);

        User userDetails = (await _firebaseAuth.signInWithCredential(credential)).user!;

        this._name = userDetails.displayName;
        this._email = userDetails.email;
        this._imageUrl = userDetails.photoURL;
        this._uid = '';
        this._signInProvider = 'google';
        this._idToken = googleUser.id;
        this._userType = 'google';

        _hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future signInwithFacebook() async {
    User currentUser;

    final LoginResult facebookLoginResult = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
    if (facebookLoginResult.status == LoginStatus.success) {
      final _accessToken = await FacebookAuth.instance.accessToken;
      if (_accessToken != null) {
        try {
          final AuthCredential credential = FacebookAuthProvider.credential(_accessToken.tokenString);
          final User user = (await _firebaseAuth.signInWithCredential(credential)).user!;
          assert(user.email != null);
          assert(user.displayName != null);
          assert(!user.isAnonymous);
          await user.getIdToken();
          currentUser = _firebaseAuth.currentUser!;
          assert(user.uid == currentUser.uid);
          Fluttertoast.showToast(msg: credential.providerId);
          print(credential.token);
          this._name = user.displayName;
          this._email = user.email;
          this._imageUrl = user.photoURL;
          this._uid = user.uid;
          this._signInProvider = 'facebook';
          this._idToken = credential.providerId;
          this._userType = 'facebook';
          _hasError = false;
          notifyListeners();
        } catch (e) {
          _hasError = true;
          _errorCode = e.toString();
          notifyListeners();
        }
      }
    } else {
      _hasError = true;
      _errorCode = 'cancel or error';
      notifyListeners();
    }
  }

  Future signInWithApple() async {
    final _firebaseAuth = FirebaseAuth.instance;
    final result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName]),
    ]);

    if (result.status == AuthorizationStatus.authorized) {
      try {
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential!.identityToken!),
          accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;

        this._uid = firebaseUser!.uid;
        this._name = '${appleIdCredential.fullName!.givenName} ${appleIdCredential.fullName!.familyName}';
        this._email = appleIdCredential.email ?? 'null';
        this._imageUrl = firebaseUser.photoURL ?? defaultUserImageUrl;
        this._signInProvider = 'apple';

        print(firebaseUser);
        _hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    } else if (result.status == AuthorizationStatus.error) {
      _hasError = true;
      _errorCode = 'Appple Sign In Error! Please try again';
      notifyListeners();
    } else if (result.status == AuthorizationStatus.cancelled) {
      _hasError = true;
      _errorCode = 'Sign In Cancelled!';
      notifyListeners();
    }
  }

  Future signUpwithEmailPassword(userName, userEmail, userPassword) async {
    try {
      UserModel apiUserModel = await UserServices().signUpUser(userEmail, userPassword,userName);
      this._name = apiUserModel.userName;
      this._uid = apiUserModel.id;
      this._imageUrl = defaultUserImageUrl;
      this._email = apiUserModel.email;
      this._signInProvider = 'email';
      this._idToken = apiUserModel.token;
      this._imageUrl = apiUserModel.avatar!.contains('https') ? apiUserModel.avatar : "${HelperClass.avatarIp}${apiUserModel.avatar}";

      this._userType = 'registered';

      // final User? user = (await _firebaseAuth.createUserWithEmailAndPassword(email: userEmail, password: userPassword)).user!;
      // assert(user != null);
      // await user!.getIdToken();
      // this._name = userName;
      // this._uid = user.uid;
      // this._imageUrl = defaultUserImageUrl;
      // this._email = user.email;
      // this._signInProvider = 'email';
      // this._idToken = null;
      // this._userType = 'registered';
      _hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }

  Future signInwithEmailPassword(userEmail, userPassword) async {
    try {
      // final User? user = (await _firebaseAuth.signInWithEmailAndPassword(email: userEmail, password: userPassword)).user!;
      // assert(user != null);
      // await user!.getIdToken();
      // final User currentUser = _firebaseAuth.currentUser!;
      UserModel apiUserModel = await UserServices().signInUser(userEmail, userPassword);
      this._name = apiUserModel.userName;
      this._uid = apiUserModel.id;
      this._imageUrl = defaultUserImageUrl;
      this._email = apiUserModel.email;
      this._signInProvider = 'email';
      this._idToken = apiUserModel.token;
      this._imageUrl = apiUserModel.avatar!.contains('https') ? apiUserModel.avatar : "${HelperClass.avatarIp}${apiUserModel.avatar}";

      _hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap = await firestore.collection('users').doc(_uid).get();
    if (snap.exists) {
      print('User Exists');
      return true;
    } else {
      print('new user');
      return false;
    }
  }

  Future<bool> checkApiUserExists() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // String? email = sp.getString('email');
    List response = [];
    List<UserModel> dummyList = [];
    bool userId = false;
    try {
      await _userServices
          .getUsers('users')
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            response.forEach((element) {
              dummyList.add(UserModel.fromJson(element));
            });
          });
      dummyList.forEach((element) {
        if (element.email == _email) {
          userId = true;
        }
      });
    } catch (e) {
      userId = false;
      print(e.toString());
    }
    return userId;
  }

  Future<bool> saveToFirebase() async {
    // final DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(_uid);
    // var userData = {
    //   'name': _name,
    //   'email': _email,
    //   'uid': _uid,
    //   'image url': _imageUrl,
    //   'timestamp': timestamp,
    //   'loved items': [],
    //   'bookmarked items': [],
    //   'state': _state,
    //   'district': _district
    // };
    // await ref.set(userData);
    var id = Uuid();
    var v4 = id.v4();
    bool success = false;
    var userData = {
      "api_key": "$apiKey",
      // "id": "11",
      "username": _name,
      "slug": _name!.replaceAll(' ', '-').toLowerCase(),
      "email": _email,
      "email_status": "1",
      "token": v4,
      "password": null,
      "role": "user",
      "user_type": _userType,
      "google_id": _userType == 'google' ? _idToken : null,
      "facebook_id": _userType == 'facebook' ? _idToken : null,
      "vk_id": null,
      "avatar": _imageUrl,
      "status": "1",
      "about_me": null,
      "facebook_url": null,
      "twitter_url": null,
      "instagram_url": null,
      "pinterest_url": null,
      "linkedin_url": null,
      "vk_url": null,
      "telegram_url": null,
      "youtube_url": null,
      "last_seen": DateTime.now().toString(),
      "show_email_on_profile": "1",
      "show_rss_feeds": "1",
      "reward_system_enabled": "0",
      "balance": "0",
      "total_pageviews": "0",
      "created_at": DateTime.now().toString(),
    };
    // await _userServices.createUser('users', userData).then((value) {
    //   if (value.statusCode == 200) {
    //     Map mapRes = jsonDecode(value.body);
    //     if (mapRes['status'] == true) {
    //       success = true;
    //       Fluttertoast.showToast(msg: mapRes['message']);
    //     } else {
    //       success = false;
    //       Fluttertoast.showToast(msg: mapRes['message']);
    //     }
    //   } else {
    //     success = false;
    //     print(value);
    //   }
    // });
    return success;
  }

  Future saveUserToApi() async {}
  Future getTimestamp() async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    timestamp = _timestamp;
  }

  Future saveDataToSP() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setString('name', _name!);
    await sp.setString('email', _email!);
    await sp.setStringList('district', _district ?? []);
    await sp.setString('state', _state ?? '');
    await sp.setString('uid', _uid ?? '');
    await sp.setString('image_url', _imageUrl!);
    await sp.setString('uid', _uid!);
    await sp.setString('sign_in_provider', _signInProvider!);

    //handle user registration here
  }

  Future getDataFromSp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _name = sp.getString('name');
    _state = sp.getString('state');
    _district = sp.getStringList('district');

    _email = sp.getString('email');
    _imageUrl = sp.getString('image_url');
    _uid = sp.getString('uid');
    _signInProvider = sp.getString('sign_in_provider');
    notifyListeners();
  }

  Future getUserDatafromFirebase(uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((DocumentSnapshot snap) {
      this._uid = snap['uid'];
      this._name = snap['name'];
      this._email = snap['email'];
      this._imageUrl = snap['image url'];
      this._state = snap['state'] ?? '';
      this._district = snap['district'].cast<String>();

      print(_name);
    });
    notifyListeners();
  }

  Future getUserFromApi(email) async {
    List response = [];
    List<UserModel> dummyList = [];
    // String userId = '';
    UserModel? apiUserModel;
    try {
      await _userServices
          .getUsers('users')
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            response.forEach((element) {
              dummyList.add(UserModel.fromJson(element));
            });
          });
      dummyList.forEach((element) {
        if (element.email == email) {
          apiUserModel = element;
        }
      });
      this._uid = apiUserModel!.id;
      this._name = apiUserModel!.userName;
      this._email = apiUserModel!.email;
      this._imageUrl = apiUserModel!.avatar!.contains('https') ? apiUserModel!.avatar : "https://onlinehunt.in/news/${apiUserModel!.avatar}";
      // Fluttertoast.showToast(msg: '${this._imageUrl}');
    } catch (e) {
      print(e.toString());
    }
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }

  Future userSignout() async {
    if (_signInProvider == 'apple') {
      await _firebaseAuth.signOut();
    } else if (_signInProvider == 'facebook') {
      await _firebaseAuth.signOut();
      await _fbAuth.logOut();
    } else if (_signInProvider == 'email') {
      await _firebaseAuth.signOut();
    } else {
      await _firebaseAuth.signOut();
      await _googlSignIn.signOut();
    }
  }

  Future afterUserSignOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await userSignout().then((_) async {
      await clearAllData(preferences.getString('language')!, preferences.getString('state')!, preferences.getStringList('district')!);
      _isSignedIn = false;
      _guestUser = false;
      notifyListeners();
    });
  }

  Future setGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', true);
    _guestUser = true;
    notifyListeners();
  }

  void checkGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _guestUser = sp.getBool('guest_user') ?? false;
    notifyListeners();
  }

  Future clearAllData(String language, String state, List<String> district) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear().whenComplete(() {
      sp.setString('language', language);
      sp.setString('state', state);
      sp.setStringList('district', district);
    });
  }

  Future guestSignout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', false);
    _guestUser = false;
    notifyListeners();
  }

  Future updateUserProfile(String newName, String newImageUrl, String state, List<String> districts) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    FirebaseFirestore.instance.collection('users').doc(_uid).update({'name': newName, 'image url': newImageUrl, 'state': state, 'district': districts});

    sp.setString('name', newName);
    sp.setString('image_url', newImageUrl);

    sp.setString('state', state);
    sp.setStringList('district', districts);
    _name = newName;
    _imageUrl = newImageUrl;
    _state = state;
    _district = districts;
    notifyListeners();
  }

  Future updateUserLocationData(String state, List<String> districts) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    FirebaseFirestore.instance.collection('users').doc(_uid).update({'state': state, 'district': districts});

    sp.setString('state', state);
    sp.setStringList('district', districts);
    _state = state;
    _district = districts;
    notifyListeners();
  }

  Future<int> getTotalUsersCount() async {
    final String fieldName = 'count';
    final DocumentReference ref = firestore.collection('item_count').doc('users_count');
    DocumentSnapshot snap = await ref.get();
    if (snap.exists == true) {
      int itemCount = snap[fieldName] ?? 0;
      return itemCount;
    } else {
      await ref.set({fieldName: 0});
      return 0;
    }
  }

  Future increaseUserCount() async {
    await getTotalUsersCount().then((int documentCount) async {
      await firestore.collection('item_count').doc('users_count').update({'count': documentCount + 1});
    });
  }
}
