import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_hunt_news/blocs/bottomNavBar_bloc.dart';
import 'package:online_hunt_news/blocs/tab_index_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/pages/home.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/services/userServices.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/sign_in_bloc.dart';
import '../utils/snacbar.dart';

class EditProfile extends StatefulWidget {
  final String? name;
  final String? imageUrl;
  final String? state;
  final String? district;
  // final String? oldDistric
  EditProfile({Key? key, required this.name, required this.imageUrl, this.state, this.district}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? name;
  String? imageUrl;
  String? state;
  List<String>? district;

  File? imageFile;
  String? fileName;
  bool loading = false;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var fnameCtrl = TextEditingController();
  var lnameCtrl = TextEditingController();

  var bioCtrl = TextEditingController();

  List<String> states = [];
  List<dynamic> districts = [];
  String selectedState = '';
  String selectedDistricts = '';

  @override
  void initState() {
    final sb = context.read<SignInBloc>();
    super.initState();
    fnameCtrl.text = sb.userModel.first_name!;
    lnameCtrl.text = sb.userModel.last_name!;

    // selectedState = state ?? '';
    // selectedDistrict = district ?? '';
    getStates();
    // getDistricts();
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (val, t) async {
        // print('poppp${t}');
        // Navigator.pop(context,selectedDistricts);
        // nextScreenReplace(context, HomePage());
        // context.read<TabIndexBloc>().setTabIndex(0);
        // context.read<BottomNavBloc>().currentIndex = 0;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(title: Text('edit profile').tr()),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              InkWell(
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: (imageFile == null ? CachedNetworkImageProvider(sb.imageUrl!) : FileImage(imageFile!)) as ImageProvider<Object>,
                  child: Container(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.edit, size: 30, color: Colors.black),
                    ),
                  ),
                ),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  // UserServices().getProfile().then((val) {
                  //   print(jsonDecode(val.body));
                  //   // print(val.request);
                  //   // print(prefs.getString('auth_token'));
                  // });
                  // print(' dcdc');
                  // pickImage();
                },
              ),
              SizedBox(height: 50),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('enter fname'.tr()),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        alignLabelWithHint: true,
                      ),
                      controller: fnameCtrl,
                      validator: (value) {
                        if (value!.length == 0) return "empty fname".tr();
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('enter lname'.tr()),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        alignLabelWithHint: true,
                      ),
                      controller: lnameCtrl,
                      validator: (value) {
                        if (value!.length == 0) return "empty lname".tr();
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('bio'.tr()),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        alignLabelWithHint: true,
                      ),
                      controller: bioCtrl,
                      maxLines: 5,
                      // validator: (value) {
                      //   if (value!.length == 0) return "Bio can't be empty";
                      //   return null;
                      // },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     selectedDistricts.isEmpty
              //         ? SizedBox.shrink()
              //         : Row(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               Text('news district:'.tr()),
              //               SizedBox(width: 10),
              //               Container(
              //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Theme.of(context).cardColor),
              //                 padding: EdgeInsets.symmetric(vertical: 28, horizontal: 10),
              //                 child: Center(
              //                   child: Text(
              //                     selectedDistricts,
              //                     textAlign: TextAlign.center,
              //                     style: TextStyle(color: Config().appColor, fontSize: 16, fontWeight: FontWeight.bold),
              //                   ).tr(),
              //                 ),
              //               ),
              //             ],
              //           ),
              //     SizedBox(width: 10),

              //     MaterialButton(
              //       color: Theme.of(context).primaryColor,
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
              //       onPressed: () async {
              //         var value = await showDistrictSheet(selectedDistricts);
              //         if (value != null) {
              //           selectedDistricts = value;
              //           setState(() {});
              //         }
              //       },
              //       child: Text(selectedDistricts.isNotEmpty ? 'change'.tr() : 'choose district'.tr()),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 10),
              // // Expanded(

              // // ),
              // SizedBox(height: 10),

              // Spacer(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 45,
          margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ButtonStyle(
              // backgroundColor: WidgetStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
              textStyle: WidgetStateProperty.resolveWith((states) => TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color)),
            ),
            child: loading == true
                ? Center(child: Loading(color: Theme.of(context).iconTheme.color))
                : Text(
                    'update profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyMedium!.color),
                  ).tr(),
            onPressed: () async {
              handleUpdateData();
              // await UserServices().updateProfile(avatar: sb.imageUrl!, firstName: fnameCtrl.text, lastName: lnameCtrl.text, bio: bioCtrl.text).then((val) {
              //   print(val.body);
              // });
            },
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    final _imagePicker = ImagePicker();
    var imagepicked = await _imagePicker.pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    if (imagepicked != null) {
      setState(() {
        imageFile = File(imagepicked.path);
        fileName = (imageFile!.path);
      });
    } else {
      print('No image selected!');
    }
  }

  Future uploadPicture() async {
    final SignInBloc sb = context.read<SignInBloc>();

    Reference storageReference = FirebaseStorage.instance.ref().child('Profile Pictures/${sb.uid}');
    UploadTask uploadTask = storageReference.putFile(imageFile!);

    await uploadTask.whenComplete(() async {
      var _url = await storageReference.getDownloadURL();
      var _imageUrl = _url.toString();
      setState(() {
        imageUrl = _imageUrl;
      });
    });
  }

  handleUpdateData() async {
    final sb = context.read<SignInBloc>();
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openSnacbar(scaffoldKey, 'no internet'.tr());
      } else {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          setState(() => loading = true);

          imageFile == null
              ? await sb.updateProfile(sb.userModel.image!, fnameCtrl.text, lnameCtrl.text, bioCtrl.text, selectedDistricts).then((value) {
                  // openSnacbar(scaffoldKey, 'updated successfully'.tr());
                  setState(() => loading = false);
                })
              : await uploadPicture().then(
                  (value) => sb.updateUserProfile('${fnameCtrl.text} ${lnameCtrl.text}', imageUrl!, selectedState, selectedDistricts).then((_) {
                    openSnacbar(scaffoldKey, 'updated successfully'.tr());
                    setState(() => loading = false);
                  }),
                );
        }
      }
    });
  }

  getStates() async {
    final sb = context.read<SignInBloc>();
    bioCtrl.text = sb.userModel.about_me!;
    String data = await DefaultAssetBundle.of(context).loadString(Config.citiesAndDistricts);
    final jsonResult = jsonDecode(data);
    // print(jsonResult);
    for (int i = 0; i < jsonResult['states'].length; i++) {
      states.add(jsonResult['states'][i]['state']);
    }
    // Fluttertoast.showToast(msg: 'Already present $state!');
    selectedState = 'Karnataka';
    selectedDistricts = sb.district ?? '';
    if (selectedState.isNotEmpty) {
      getDistricts();
    } else {
      setState(() {});
    }
  }

  getDistricts() async {
    districts = [];
    String data = await DefaultAssetBundle.of(context).loadString(Config.citiesAndDistricts);
    final jsonResult = jsonDecode(data);
    // print(jsonResult['states'][0]);
    districts = jsonResult['states'][states.indexOf(selectedState)]['districts'];
    setState(() {});
    print(districts);
  }

  showDistrictSheet(String initialDist) {
    String tempDistrict = initialDist;
    return showModalBottomSheet(
      isScrollControlled: false,
      enableDrag: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
                  onPressed: () {
                    Navigator.pop(context, tempDistrict);
                  },
                  child: Text('done'.tr()),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 70),
                    itemCount: districts.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      var district = districts[index];
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(9),
                          splashColor: Config().appColor,
                          onTap: () {
                            if (selectedDistricts.contains(district)) {
                              Fluttertoast.showToast(msg: 'Already present');
                            } else {
                              tempDistrict = district;
                              setState(() {});
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: tempDistrict == district ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Text(
                                district,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: tempDistrict == district ? Colors.white : Config().appColor, fontSize: 16, fontWeight: FontWeight.bold),
                              ).tr(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
