import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:online_hunt_news/blocs/notification_bloc.dart';
import 'package:online_hunt_news/blocs/theme_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/general_settings_model.dart';
import 'package:online_hunt_news/pages/aricleUploads/allArticles.dart';
import 'package:online_hunt_news/pages/bookmarks.dart';
import 'package:online_hunt_news/pages/edit_profile.dart';
import 'package:online_hunt_news/pages/welcome.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:provider/provider.dart';
// import 'package:webfeed/domain/rss_feed.dart';
import '../blocs/sign_in_bloc.dart';
import '../config/config.dart';
import '../utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  ScrollController? controller;
  SettingsModel? settingsModel;
  openAboutDialog() {
    final sb = context.read<SignInBloc>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AboutDialog(
          applicationName: Config().appName,
          applicationIcon: Image(image: AssetImage(Config().splashIcon), height: 30, width: 30),
          applicationVersion: sb.appVersion,
        );
      },
    );
  }

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller!.position.pixels == controller!.position.maxScrollExtent) {
      print('reached bottom');
      // context.read<CategoriesBloc>().setLoading(true);
      // context.read<CategoriesBloc>().categoriesStream(mounted);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sb = context.watch<SignInBloc>();
    return Scaffold(
      appBar: AppBar(title: Text('profile').tr(), centerTitle: false,automaticallyImplyLeading: false,),
      body: ListView(
        controller: controller,
        padding: EdgeInsets.fromLTRB(15, 20, 20, 50),
        children: [
          sb.guestUser == true ? GuestUserUI() : UserUI(),
          Text("general settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)).tr(),
          SizedBox(height: 15),
          ListTile(
            title: Text('bookmarks').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(5)),
              child: Icon(Feather.bookmark, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20),
            onTap: () => nextScreen(context, BookmarkPage()),
          ),
          Divider(height: 3),
          ListTile(
            title: Text('dark mode').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(5)),
              child: Icon(LineIcons.sun, size: 22, color: Colors.white),
            ),
            trailing: Switch(
              activeThumbColor: Theme.of(context).primaryColor,
              value: context.watch<ThemeBloc>().darkTheme!,
              onChanged: (bool) {
                context.read<ThemeBloc>().toggleTheme();
              },
            ),
          ),
          Divider(height: 3),
          ListTile(
            title: Text('get notifications').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(color: Colors.deepPurpleAccent, borderRadius: BorderRadius.circular(5)),
              child: Icon(LineIcons.bell, size: 22, color: Colors.white),
            ),
            trailing: Switch(
              activeThumbColor: Theme.of(context).primaryColor,
              value: context.watch<NotificationBloc>().subscribed!,
              onChanged: (bool) {
                context.read<NotificationBloc>().fcmSubscribe(bool);
              },
            ),
          ),
          Divider(height: 3),
          ListTile(
            title: Text('contact us').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
              child: Icon(Feather.mail, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20),
            onTap: () async {
              showContactBottomSheet(SettingsModel(
                contactEmail: Config.emailSupport,
                contactPhone: Config.phoneSupport,
              ));
              // await GeneralSettingsServices().getSettings().then((val) {
                
              // });
            },
          ),
          // Divider(height: 3),
          // ListTile(
          //   title: Text('language').tr(),
          //   leading: Container(
          //     height: 30,
          //     width: 30,
          //     decoration: BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.circular(5)),
          //     child: Icon(Feather.globe, size: 20, color: Colors.white),
          //   ),
          //   trailing: Icon(Feather.chevron_right, size: 20),
          //   onTap: () async {
          //     var popped = await Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePopup()));

          //     if (popped == true) {
          //       print(popped);
          //       setState(() {});
          //     }
          //   },
          // ),
          // Divider(height: 3),
          // ListTile(
          //   title: Text('rate this app').tr(),
          //   leading: Container(
          //     height: 30,
          //     width: 30,
          //     decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(5)),
          //     child: Icon(Feather.star, size: 20, color: Colors.white),
          //   ),
          //   trailing: Icon(Feather.chevron_right, size: 20),
          //   onTap: () async => AppService().launchAppReview(context),
          // ),
          Divider(height: 3),
          ListTile(
            title: Text('licence').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(color: Colors.purpleAccent, borderRadius: BorderRadius.circular(5)),
              child: Icon(Feather.paperclip, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20),
            onTap: () => openAboutDialog(),
          ),
          Divider(height: 3),
          // ListTile(
          //   title: Text('privacy policy').tr(),
          //   leading: Container(
          //     height: 30,
          //     width: 30,
          //     decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(5)),
          //     child: Icon(Feather.lock, size: 20, color: Colors.white),
          //   ),
          //   trailing: Icon(Feather.chevron_right, size: 20),
          //   onTap: () async => AppService().openLinkWithCustomTab(context, '${HelperClass.avatarIp}'),
          // ),
          // Divider(height: 3),
          ListTile(
            title: Text('about us').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
              child: Icon(Feather.info, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20),
            onTap: () async => AppService().openLinkWithCustomTab(context, '${HelperClass.avatarIp}'),
          ),
          SizedBox(height: 10),
          Text('visit', textAlign: TextAlign.center).tr(),
          GestureDetector(
            onTap: () => AppService().openLinkWithCustomTab(context, '${HelperClass.avatarIp}'),
            child: Text(
              'https://onlinehunt.in/',
              style: TextStyle(color: Config().appColor, decoration: TextDecoration.underline, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Text('for more news', textAlign: TextAlign.center).tr(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

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
}

class GuestUserUI extends StatelessWidget {
  const GuestUserUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('login').tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.user, size: 20, color: Colors.white),
          ),
          trailing: Icon(Feather.chevron_right, size: 20),
          onTap: () => nextScreenPopup(context, WelcomePage(tag: 'popup')),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class UserUI extends StatelessWidget {
  const UserUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return Column(
      children: [
        Container(
          height: 200,
          child: Column(
            children: [
              CircleAvatar(radius: 60, backgroundColor: Colors.grey[300], backgroundImage: CachedNetworkImageProvider(sb.imageUrl!)),
              SizedBox(height: 15),
              Text(sb.name!, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        ListTile(
          title: Text(sb.email!),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.mail, size: 20, color: Colors.white),
          ),
        ),
        Divider(height: 3),
        ListTile(
          title: Text('edit profile').tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(color: Colors.purpleAccent, borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.edit_3, size: 20, color: Colors.white),
          ),
          trailing: Icon(Feather.chevron_right, size: 20),
          onTap: () => nextScreen(context, EditProfile(name: sb.name, imageUrl: sb.imageUrl, state: sb.state, district: sb.district)),
        ),
        Divider(height: 3),
        ListTile(
          title: Text('my uploads').tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(color: Config().appColor, borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.upload, size: 20, color: Colors.white),
          ),
          trailing: Icon(Feather.chevron_right, size: 20),
          onTap: () => nextScreen(context, AllArticles()),
        ),
        Divider(height: 3),
        ListTile(
          title: Text('logout').tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.log_out, size: 20, color: Colors.white),
          ),
          trailing: Icon(Feather.chevron_right, size: 20),
          onTap: () => openLogoutDialog(context),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  // rssTest() async {
  //   final client = IOClient(HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true));

  //   // RSS feed
  //   var response = await client.get(Uri.parse('https://newsics.com/feed/'));
  //   var channel = RssFeed.parse(response.body);

  //   // final res = await http.get(
  //   //   Uri.parse(channel.items!.first.link!),
  //   //   headers: {"Accept": "application/json"},
  //   // );
  //   // print(res.body);
  //   try {
  //     var data = await MetadataFetch.extract('https://newsics.com/news/karnataka/3-year-old-baby-raped-in-shimogga/92183/');
  //     print(data!.image);
  //   } catch (e) {
  //     print(e.toString());
  //   }

  //   print(channel.items!.first.link);
  // }

  void openLogoutDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('logout title').tr(),
          actions: [
            TextButton(child: Text('no').tr(), onPressed: () => Navigator.pop(context)),
            TextButton(
              child: Text('yes').tr(),
              onPressed: () async {
                await context.read<SignInBloc>().userSignout().then((value) => context.read<SignInBloc>().afterUserSignOut()).then((value) {
                  Navigator.pop(context);
                  if (context.read<ThemeBloc>().darkTheme == true) {
                    context.read<ThemeBloc>().toggleTheme();
                  }
                  nextScreenCloseOthers(context, WelcomePage());
                });
              },
            ),
          ],
        );
      },
    );
  }
}
