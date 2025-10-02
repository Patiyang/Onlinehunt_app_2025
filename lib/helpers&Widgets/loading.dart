import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? height;
  final double? size;
  final Color? spinkitColor;
  final Color? textColor;
  final Widget? spinkit;

  const Loading({Key? key, this.text, this.color, this.height, this.size, this.spinkitColor, this.textColor, this.spinkit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          spinkit ?? SpinKitCircle(color: spinkitColor ?? Theme.of(context).primaryColor, size: size ?? 20),
          text != null ? SizedBox(height: 10) : SizedBox.shrink(),
          text != null
              ? Text(text ?? '', style: TextStyle(letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.titleMedium!.fontSize, color: textColor ?? Theme.of(context).primaryColor),)
              : SizedBox.shrink()
        ],
      ),
    );
  }
}