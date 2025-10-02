import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
import 'package:online_hunt_news/blocs/theme_bloc.dart';
import 'package:online_hunt_news/models/custom_color.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/utils/app_name.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:online_hunt_news/widgets/language.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/general_settings_model.dart';
import '../services/general_settings_sservices.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    final List titles = [
      // 'bookmarks',
      'language',
      'about us',
      'privacy policy',
      'contact us',
      'facebook page',
      // 'youtube channel',
      // 'twitter'
    ];

    final List icons = [
      // Feather.bookmark,
      Feather.globe,
      Feather.info,
      Feather.lock,
      Feather.mail,
      Feather.facebook,
      // Feather.youtube,
      // Feather.twitter
    ];

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                alignment: Alignment.center,
                //color: context.watch<ThemeBloc>().darkTheme == false ? CustomColor().drawerHeaderColorLight : CustomColor().drawerHeaderColorDark,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppName(fontSize: 25.0),
                    Text('Version: ${sb.appVersion}', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
            Container(
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 30),
                itemCount: titles.length,
                shrinkWrap: true,
                separatorBuilder: (ctx, idx) => Divider(height: 0),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(titles[index], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)).tr(),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: context.watch<ThemeBloc>().darkTheme == false
                          ? CustomColor().drawerHeaderColorLight
                          : CustomColor().drawerHeaderColorDark,
                      child: Icon(icons[index], color: Colors.grey[600]),
                    ),
                    onTap: () async {
                      //
                      // if (index == 0) {
                      //   Navigator.pop(context);
                      //   nextScreen(context, BookmarkPage());
                      // } else

                      if (index == 1) {
                        Navigator.pop(context);
                        nextScreen(context, LanguagePopup());
                      } else if (index == 2) {
                        // AppService().openLinkWithCustomTab(context, Config().ourWebsiteUrl);
                        await GeneralSettingsServices().getSettings().then((val) {
                          shoAboutBtSheet(val);
                        });
                      } else if (index == 3) {
                        // Navigator.pop(context);
                        await GeneralSettingsServices().getSettings().then((val) {
                          AppService().openLinkWithCustomTab(context, val.privacyPolicy!);
                        });
                      } else if (index == 4) {
                        // AppService().openEmailSupport();
                        await GeneralSettingsServices().getSettings().then((val) {
                          showContactBottomSheet(val);
                        });
                      } else if (index == 5) {
                        GeneralSettingsServices().getSettings().then((value) => AppService().openLink(context, value.facebookUrl!));
                        // AppService().openLink(context, Config.facebookPageUrl);
                      }
                    },
                  );
                },
              ),
            ),
            // context.watch<AdsBloc>().bannerAdEnabled == false ? Container() : BannerAdAdmob() //admob
          ],
        ),
      ),
    );
  }

  showContactBottomSheet(SettingsModel settingsModel) {
    return showModalBottomSheet(
      isScrollControlled: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 9),
              children: [
                Text(
                  'contact us',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  textAlign: TextAlign.center,
                ).tr(),
                SizedBox(height: 15),
                ListTile(
                  onTap: () => AppService().openPhoneNumber(settingsModel.contactPhone!),
                  leading: Icon(Icons.call),
                  title: Text(settingsModel.contactPhone!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
                ListTile(
                  onTap: () => AppService().openEmailSupport(settingsModel.contactEmail!),
                  leading: Icon(Icons.alternate_email_rounded),
                  title: Text('${settingsModel.contactEmail!}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  shoAboutBtSheet(SettingsModel settingsModel) {
    return showModalBottomSheet(
      isScrollControlled: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 9),
              children: [
                Text(
                  'about us',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  textAlign: TextAlign.center,
                ).tr(),
                SizedBox(height: 15),
                Text(
                  settingsModel.aboutFooter!,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  textAlign: TextAlign.center,
                ).tr(),
              ],
            );
          },
        );
      },
    );
  }

  showPrivacyBtSheet(SettingsModel settingsModel) {
    return showModalBottomSheet(
      isScrollControlled: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 9),
              children: [
                Text(
                  'privacy policy',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  textAlign: TextAlign.center,
                ).tr(),
                SizedBox(height: 15),
                Text(
                  settingsModel.aboutFooter!,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  textAlign: TextAlign.center,
                ).tr(),
              ],
            );
          },
        );
      },
    );
  }
}
