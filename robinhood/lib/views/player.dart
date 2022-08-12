import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  void a(WebViewController clt) {}
  Widget build(BuildContext context) {
    Future<void> _loadHtmlFromAssets() async {
      String html = '''
          <!DOCTYPE html><html>
          <head>
            <title></title>
            <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
            <script src="https://cdn.jwplayer.com/libraries/2vQP28Pg.js"></script>
          </head>
          <body>
          <div id="player">
            <video autoplay width="100%" height="100%">
              <source src=""https://scontent.cdninstagram.com/v/t39.25447-2/10000000_184809143966974_3194651430808768154_n.mp4?_nc_cat=103&vs=4f48442111651c2a&_nc_vs=HBksFQAYJEdJQ1dtQURfbkdBN0ZhZ0FBSnJPak9LTXJsVXNibWRqQUFBRhUAAsgBABUAGCRHSUNXbUFDaUJiNWx0TlVDQUY0ZTBfRmdFREl6YnJGcUFBQUYVAgLIAQBLBogScHJvZ3Jlc3NpdmVfcmVjaXBlATENc3Vic2FtcGxlX2ZwcwAQdm1hZl9lbmFibGVfbnN1YgAgbWVhc3VyZV9vcmlnaW5hbF9yZXNvbHV0aW9uX3NzaW0AKGNvbXB1dGVfc3NpbV9vbmx5X2F0X29yaWdpbmFsX3Jlc29sdXRpb24AEWRpc2FibGVfcG9zdF9wdnFzABUAJQAcAAAmwPzWuYfh8gEVAigCQzMYC3Z0c19wcmV2aWV3HBdAs2rmZmZmZhg0ZGFzaF9pNGxpdGViYXNpY19wYXNzdGhyb3VnaGFsaWduZWRfaHEyX2ZyYWdfMl92aWRlbxIAGBh2aWRlb3MudnRzLmNhbGxiYWNrLnByb2Q4ElZJREVPX1ZJRVdfUkVRVUVTVBsKiBVvZW1fdGFyZ2V0X2VuY29kZV90YWcGb2VwX2hkE29lbV9yZXF1ZXN0X3RpbWVfbXMBMAxvZW1fY2ZnX3J1bGUHdW5tdXRlZBNvZW1fcm9pX3JlYWNoX2NvdW50ATARb2VtX2lzX2V4cGVyaW1lbnQADG9lbV92aWRlb19pZBAxMjc3NjkxNjE2MTAyNTQyEm9lbV92aWRlb19hc3NldF9pZA83NDkyMDQyNzk2Njc4MDYVb2VtX3ZpZGVvX3Jlc291cmNlX2lkDzUzMzgzMTA3NTE1OTg0MBxvZW1fc291cmNlX3ZpZGVvX2VuY29kaW5nX2lkDzQ4MDI2NzgwNzI0NzE0Nw52dHNfcmVxdWVzdF9pZAAlAhwAJcQBGweIAXMENDUxMwJjZAoyMDIyLTA4LTA2A3JjYgEwA2FwcAVWaWRlbwJjdBlDT05UQUlORURfUE9TVF9BVFRBQ0hNRU5UE29yaWdpbmFsX2R1cmF0aW9uX3MINDk3MC45MzQCdHMVcHJvZ3Jlc3NpdmVfZW5jb2RpbmdzAA%3D%3D&ccb=1-7&_nc_sid=41a7d5&efg=eyJ2ZW5jb2RlX3RhZyI6Im9lcF9oZCJ9&_nc_ohc=y7wB63BT20UAX8yR9Qf&_nc_ht=scontent-hel3-1.xx&edm=APRAPSkEAAAA&oh=00_AT9aSTmVcQQhwIzlzwEkSWzgkRFbJq8EvNzVHyCcyqaH0A&oe=62F988CB&_nc_rid=092589850490356" 
              type="video/mp4">
            </video>
          </div>
          // <script>
          //   jwplayer("player").setup({ 
          //           "playlist": [{
          //               "file": "https://cdn2.p2pstreaming.tw/bigv2st2hls/2021/newlist/2022/07/21/003/TRAM-VUN-HUONG-PHAI-1_new.mp4/playlist.m3u8?wmsAuthSign=c2VydmVyX3RpbWU9OC8xMi8yMDIyIDE6MDI6MzcgUE0maGFzaF92YWx1ZT02cmowVHM1QlVHcXVxZ2ExMVNDTFh3PT0mdmFsaWRtaW51dGVzPTE4MCZpZD00OWJmMDQwODRhZjQ0MmY3YjdjNjMyNDM4MTg3YzRmNw=="
          //           }]
          //       }); 
          // </script>
          </body>
          </html>
          ''';
      final String contentBase64 =
          base64Encode(const Utf8Encoder().convert(html));
      await _controller?.loadUrl('data:text/html;base64,$contentBase64');
    }

    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        body: WebView(
            initialUrl: 'about:blank',
            userAgent:
                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
              _loadHtmlFromAssets();
            }),
      ),
    );
  }
}
