import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Periodicals extends StatefulWidget {
  const Periodicals({super.key});

  @override
  State<Periodicals> createState() => _PeriodicalsState();
}

class _PeriodicalsState extends State<Periodicals> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text('periodicals').tr(),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}