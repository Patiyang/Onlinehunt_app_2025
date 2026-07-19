import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  DynamicLinkService._();

  static final instance = DynamicLinkService._();

  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? subscription;

  final StreamController<Uri> _controller = StreamController<Uri>.broadcast();

  Stream<Uri> get linkStream => _controller.stream;

  Uri? _pendingUri;
  Uri? get pendingUri => _pendingUri;

  Future<void> initialize() async {
    // Handle cold start
    _pendingUri = await _appLinks.getInitialLink();

    // Handle links while app is running
    subscription ??= _appLinks.uriLinkStream.listen(
      (uri) {
        _pendingUri = uri;
        _controller.add(uri);
      },
      onError: (e) {
        debugPrint('Deep link error: $e');
      },
    );
  }

  void clearPendingUri() {
    _pendingUri = null;
  }

  void dispose() {
    subscription?.cancel();
    _controller.close();
  }
}
