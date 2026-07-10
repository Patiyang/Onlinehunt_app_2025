import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/shims/dart_ui_real.dart';

class CustomCacheImage extends StatefulWidget {
  final String? imageUrl;
  final String? videoUrl;
  final String? avatarUrl;
  final String? contentType;
  final double radius;
  final bool? circularShape;
  final String? mediaType;
  const CustomCacheImage({
    Key? key,
    required this.imageUrl,
    required this.radius,
    this.circularShape,
    this.contentType,
    this.mediaType,
    this.avatarUrl,
    this.videoUrl,
  }) : super(key: key);

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
        bottomLeft: Radius.circular(widget.circularShape == false && widget.videoUrl!.isEmpty ? 0 : widget.radius),
        bottomRight: Radius.circular(widget.circularShape == false&& widget.videoUrl!.isEmpty  ? 0 : widget.radius),
      ),
      child: widget.contentType == 'video' && widget.videoUrl!.contains('youtube')
          ? CachedNetworkImage(
              imageUrl: getYoutubeThumbnail(widget.videoUrl!),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: widget.contentType == 'article'
                    ? CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: widget.avatarUrl!,
                        errorWidget: (context, url, error) => Center(child: Text('image not found'.tr(), style: TextStyle())),
                      )
                    : Icon(Icons.error),
              ),
            )
          // Image.network(getYoutubeThumbnail(widget.videoUrl!), fit: BoxFit.cover, height: MediaQuery.of(context).size.height)
          :widget.contentType == 'video' && widget.videoUrl!.contains('youtube')?Container(): CachedNetworkImage(
              imageUrl: widget.imageUrl!,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget: (context, url, error) => Container(
                color: Theme.of(context).primaryColorDark.withAlpha(50),
                child: widget.contentType == 'article'
                    ? CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: widget.avatarUrl!,
                        errorWidget: (context, url, error) => Center(child: Text('image not found'.tr(), style: TextStyle())),
                      )
                    : Icon(Icons.error),
              ),
            ),
    );
  }

  String getYoutubeThumbnail(String videoUrl) {
    final Uri? uri = Uri.tryParse(videoUrl);
    if (uri == null) {
      return '';
    }

    return 'https://img.youtube.com/vi/${uri.queryParameters['v']}/0.jpg';
  }
}
