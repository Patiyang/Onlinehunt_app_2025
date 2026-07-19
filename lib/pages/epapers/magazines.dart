import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Magazines extends StatefulWidget {
  const Magazines({super.key});

  @override
  State<Magazines> createState() => _MagazinesState();
}

class _MagazinesState extends State<Magazines> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text('magazines').tr(),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}