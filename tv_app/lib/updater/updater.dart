import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../model/update.dart';

Future<String> download(String url, String filename) async {
  String dir = (await getTemporaryDirectory()).path;
  File file = File('$dir/$filename');
  if (await file.exists()) return file.path;
  await file.create(recursive: true);
  var response =
      await http.get(Uri.parse(url)).timeout(const Duration(seconds: 60));

  if (response.statusCode == 200) {
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }
  throw 'Download $url failed';
}

bool isVersionGreaterThan(String newVersion, String currentVersion) {
  List<String> currentV = currentVersion.split(".");
  List<String> newV = newVersion.split(".");
  bool a = false;
  for (var i = 0; i <= 2; i++) {
    a = int.parse(newV[i]) > int.parse(currentV[i]);
    if (int.parse(newV[i]) != int.parse(currentV[i])) break;
  }
  return a;
}

Future<String?> hasNewVersion() async {
  const url = 'https://swiftit.net/robinhood.json';
  final response = await http.get(Uri.parse(url));
  final object = json.decode(response.body) as Map<String, dynamic>;
  final update = Update.fromJson(object);
  final packageInfo = await PackageInfo.fromPlatform();
  if (isVersionGreaterThan(update.version, packageInfo.version)) {
    return update.url;
  } else {
    return null;
  }
}

void checkAndUpdate(BuildContext context) {
  hasNewVersion().then((url) => {
        if (url != null)
          {
            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text('Software Update'),
                    content:
                        const Text("There's a new version of the app. Update?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            download(url, 'rh.apk').then((String path) {
                              OpenFile.open(path);
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'))
                    ],
                  );
                })
          }
      });
}
