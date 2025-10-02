import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/shims/dart_ui_real.dart';


class CustomCacheImage extends StatefulWidget {
  final String? imageUrl;
  final String? avatarUrl;
  final String? contentType;
  final double radius;
  final bool? circularShape;
  final String? mediaType;
  const CustomCacheImage({Key? key, required this.imageUrl, required this.radius, this.circularShape, this.contentType, this.mediaType, this.avatarUrl})
    : super(key: key);

  @override
  State<CustomCacheImage> createState() => _CustomCacheImageState();
}

class _CustomCacheImageState extends State<CustomCacheImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(widget.radius),
        topRight: Radius.circular(widget.radius),
        bottomLeft: Radius.circular(widget.circularShape == false ? 0 : widget.radius),
        bottomRight: Radius.circular(widget.circularShape == false ? 0 : widget.radius),
      ),
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl!,
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height,
        placeholder: (context, url) => Container(color: Colors.grey[300]),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: widget.contentType == 'articlje'? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.avatarUrl!,
                            errorWidget: (context, url, error) => Center(child: Text('image not found'.tr(), style: TextStyle())),
                          )

              : Icon(Icons.error),
        ),
      ),
    );
  }
}
