import 'package:flutter/material.dart';

import 'package:online_hunt_news/blocs/featured_bloc.dart';
import 'package:online_hunt_news/blocs/popular_articles_bloc.dart';
import 'package:online_hunt_news/blocs/recent_articles_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:online_hunt_news/models/theme_model.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/home.dart';

class LanguagePopup extends StatefulWidget {
  const LanguagePopup({Key? key}) : super(key: key);

  @override
  _LanguagePopupState createState() => _LanguagePopupState();
}

class _LanguagePopupState extends State<LanguagePopup> {
  List<String> categoryList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('select language').tr()),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: Config().languages.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemList(Config().languages[index], index);
        },
      ),
    );
  }

  Widget _itemList(d, index) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.language),
          title: Text(d.toString().toLowerCase().tr()),
          onTap: () async {
            await refresh()
                .whenComplete(() async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if (d == 'English') {
                    context.setLocale(Locale('en'));
                    prefs.setString('language', 'English');
                    ThemeModel().myValue = 'Manrope';
                  } else if (d == 'Kannada') {
                    context.setLocale(Locale('kn'));
                    prefs.setString('language', 'Kannada');
                    ThemeModel().myValue = 'NotoSerif';
                  } else if (d == 'Hindi') {
                    context.setLocale(Locale('hi'));
                    prefs.setString('language', 'Hindi');
                    ThemeModel().myValue = 'Karma';
                  }
                })
                .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage())));
            // await getCategories();
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage()), (route) => true);
          },
        ),
        Divider(height: 3, color: Colors.grey[400]),
      ],
    );
  }

  Future refresh() async {
    context.read<FeaturedBloc>().onRefresh(mounted);
    context.read<PopularBloc>().onRefresh(mounted);
    context.read<RecentBloc>().onRefresh(mounted);
    getCategories();
  }

  Future getCategories() async {
    // context.read<CategoryTab1Bloc>().onRefresh(mounted, Config().initialCategories[0]);
    // context.read<CategoryTab2Bloc>().onRefresh(mounted, Config().initialCategories[1]);
    // context.read<CategoryTab3Bloc>().onRefresh(mounted, Config().initialCategories[2]);
    // context.read<CategoryTab4Bloc>().onRefresh(mounted, Config().initialCategories[3]);
    // context.read<CategoryTab5Bloc>().onRefresh(mounted, Config().initialCategories[4]);
    // context.read<CategoryTab6Bloc>().onRefresh(mounted, Config().initialCategories[5]);
    // context.read<CategoryTab7Bloc>().onRefresh(mounted, Config().initialCategories[6]);
    // context.read<CategoryTab8Bloc>().onRefresh(mounted, Config().initialCategories[7]);
    // context.read<CategoryTab9Bloc>().onRefresh(mounted, Config().initialCategories[8]);
    // context.read<CategoryTab10Bloc>().onRefresh(mounted, Config().initialCategories[9]);
    // context.read<CategoryTab11Bloc>().onRefresh(mounted, Config().initialCategories[10]);
    // context.read<CategoryTab12Bloc>().onRefresh(mounted, Config().initialCategories[11]);
  }
}
