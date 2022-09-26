import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HiddenWebView extends StatefulWidget {
  const HiddenWebView({Key? key}) : super(key: key);

  @override
  State<HiddenWebView> createState() => _HiddenWebViewState();
}

class _HiddenWebViewState extends State<HiddenWebView> {
  @override
  Widget build(BuildContext context) {
    var webview = InAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse(
              "https://motchill.com/xem-phim/sieu-thoi-khong-lang-man-tap-1-10577_125395.html")),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(useShouldOverrideUrlLoading: true),
      ),
      onLoadStop: (controller, url) async {
        print("onLoadStop: ${url?.host}");

        var result = await controller.evaluateJavascript(source: """
          // \$('video').map(function() { return \$(this).attr('playlist'); }).toArray();
          // setInterval(function() {            
            // var playlsit = jwplayer().playlistItem().length;
            // window.flutter_inappwebview.callHandler('handlerName', 'great', key, token);
            // for(var b in window) { 
            //   if(window.hasOwnProperty(b)) window.flutter_inappwebview.callHandler('handlerName', b); 
            // }
            // window.flutter_inappwebview.callHandler('handlerName', next_video);
            // window.flutter_inappwebview.callHandler('handlerName', filmId);
            // window.flutter_inappwebview.callHandler('handlerName', vId);
            // window.flutter_inappwebview.callHandler('handlerName', slug);
            // window.flutter_inappwebview.callHandler('handlerName', keygen);
            // window.flutter_inappwebview.callHandler('handlerName', decodeLink);
          // }, 5000);
          jwplayer().getDuration()
        """);
        print("XXXXX: $result");
      },
      onLoadError: (_, __, ___, ____) {
        print("onLoadError");
      },
      onLoadHttpError: (_, __, ___, ____) {
        print("onLoadError");
      },
      onWebViewCreated: ((controller) {
        controller.addJavaScriptHandler(
            handlerName: "handlerName",
            callback: ((args) {
              print(args);
            }));
      }),
    );
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: webview,
    );
  }
}
