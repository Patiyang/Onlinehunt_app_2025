import 'package:shared_preferences/shared_preferences.dart';

const apiKey = '53b7a9e4-2489-4314240c0889-fa93-433d';

Future<int> returnCategoryId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.getString('language') == 'English') {
    return 1;
  } else if (preferences.getString('language') == 'Kannada') {
    return 2;
  } else {
    return 0;
  }
}
