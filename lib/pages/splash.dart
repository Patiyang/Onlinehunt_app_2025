import 'dart:async';

import 'package:flutter/material.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/pages/welcome.dart';
import 'package:online_hunt_news/services/dynamic_link_services.dart';
import 'package:provider/provider.dart';
import '../blocs/sign_in_bloc.dart';
import '../utils/next_screen.dart';
import 'home.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final uri = DynamicLinkService.instance.pendingUri;
  @override
  void initState() {
    // checkLink();
    afterSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Image.asset(Config().splashIcon,height: 120, width: 120, fit: BoxFit.contain),
        // child: Image(image: AssetImage(Config().splashIcon), height: 120, width: 120, fit: BoxFit.contain),
      ),
    );
  }

  afterSplash() {
    final SignInBloc sb = context.read<SignInBloc>();
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      sb.isSignedIn == true || sb.guestUser == true ? gotoHomePage() : gotoSignInPage();
    });
  }

  gotoHomePage() {
    final SignInBloc sb = context.read<SignInBloc>();
    if (sb.isSignedIn == true) {
      sb.getDataFromSp();
    }
    nextScreenReplace(context, HomePage(initialDeepLink: uri,));
  }

  gotoSignInPage() {
    nextScreenReplace(context, WelcomePage());
  }
}
