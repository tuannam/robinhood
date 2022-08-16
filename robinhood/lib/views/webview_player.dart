import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewWidget extends StatelessWidget {
  final String url;

  WebViewWidget({Key? key, required this.url}) : super(key: key);
  final _options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(url)),
                initialOptions: _options),
            //IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow))
          ],
        ),
      ),
    );
  }
}
