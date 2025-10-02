import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/sign_in_bloc.dart';
import '../utils/snacbar.dart';

class EditProfile extends StatefulWidget {
  final String? name;
  final String? imageUrl;
  final String? state;
  final List<String>? district;

  EditProfile({Key? key, required this.name, required this.imageUrl, this.state, this.district}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState(this.name, this.imageUrl, this.state, this.district);
}

class _EditProfileState extends State<EditProfile> {
  _EditProfileState(this.name, this.imageUrl, this.state, this.district);

  String? name;
  String? imageUrl;
  String? state;
  List<String>? district;

  File? imageFile;
  String? fileName;
  bool loading = false;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var nameCtrl = TextEditingController();
  List<String> states = [];
  List<dynamic> districts = [];
  String selectedState = '';
  List<String> selectedDistricts = [];
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
              ? await sb.updateUserProfile(nameCtrl.text, imageUrl!, selectedState, selectedDistricts).then((value) {
                  openSnacbar(scaffoldKey, 'updated successfully'.tr());
                  setState(() => loading = false);
                })
              : await uploadPicture().then(
                  (value) => sb.updateUserProfile(nameCtrl.text, imageUrl!, selectedState, selectedDistricts).then((_) {
                    openSnacbar(scaffoldKey, 'updated successfully'.tr());
                    setState(() => loading = false);
                  }),
                );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    nameCtrl.text = name!;
    // selectedState = state ?? '';
    // selectedDistrict = district ?? '';
    getStates();
    // getDistricts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text('edit profile').tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            InkWell(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey[300],
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey[800]!),
                    color: Colors.grey[500],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: (imageFile == null ? CachedNetworkImageProvider(imageUrl!) : FileImage(imageFile!)) as ImageProvider<Object>,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.edit, size: 30, color: Colors.black),
                  ),
                ),
              ),
              onTap: () {
                pickImage();
              },
            ),
            SizedBox(height: 50),
            Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(hintText: 'enter new name'.tr()),
                controller: nameCtrl,
                validator: (value) {
                  if (value!.length == 0) return "Name can't be empty";
                  return null;
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'set location data below'.tr(),
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  hint: Text('select state'.tr()),
                  value: selectedState.isNotEmpty ? selectedState : null,
                  onChanged: (String? val) {
                    setState(() {
                      selectedState = val ?? '';
                      // selectedDistrict = '';
                    });
                    getDistricts();
                  },
                  items: states.map((state) => DropdownMenuItem(child: Text(state).tr(), value: state)).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 10),
            selectedDistricts.isEmpty
                ? Text('no districts specified yet'.tr().toUpperCase())
                : Container(
                    height: 40,
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      scrollDirection: Axis.horizontal,
                      children: selectedDistricts
                          .map(
                            (singleDistrict) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).cardColor),
                                child: Row(
                                  children: [
                                    Text(singleDistrict, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)).tr(),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        selectedDistricts.remove(singleDistrict);
                                        setState(() {});
                                      },
                                      child: Icon(Icons.cancel),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
            SizedBox(height: 10),
            Text('choose district'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 50),
                itemCount: districts.length,
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
                          selectedDistricts.add(district);
                          setState(() {});
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Theme.of(context).cardColor),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Text(
                            district,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Config().appColor, fontSize: 16, fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                  textStyle: WidgetStateProperty.resolveWith((states) => TextStyle(color: Colors.white)),
                ),
                child: loading == true
                    ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white))
                    : Text('update profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)).tr(),
                onPressed: () {
                  handleUpdateData();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getStates() async {
    String data = await DefaultAssetBundle.of(context).loadString(Config.citiesAndDistricts);
    final jsonResult = jsonDecode(data);
    print(jsonResult);
    for (int i = 0; i < jsonResult['states'].length; i++) {
      states.add(jsonResult['states'][i]['state']);
    }
    selectedState = state!;
    selectedDistricts = district!.cast<String>();
    if (selectedState != '') {
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
    setState(() {
      districts = jsonResult['states'][states.indexOf(selectedState)]['districts'];
    });
  }
}
