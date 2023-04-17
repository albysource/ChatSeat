import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:onionchatflutter/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class ImageMessage extends StatefulWidget {
  final String sendType;
  final String url;
  final String time;

  const ImageMessage(
      {Key? key, required this.sendType, required this.url, required this.time})
      : super(key: key);

  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  final Dio dio = Dio();

  bool loading = false;

  double progress = 0;

  Future<bool> saveP(String url, String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/IcarusApp";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(url, saveFile.path,
            onReceiveProgress: (value1, value2) {
          setState(() {
            progress = value1 / value2;
          });
        });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  downloadFile() async {
    setState(() {
      loading = true;
      progress = 0;
    });
    bool downloaded = await saveP(
        "https://9to5mac.com/wp-content/uploads/sites/6/2021/09/Apple-TV.png",
        "apple.png");
    if (downloaded) {
      print("File Downloaded");
    } else {
      print("Problem Downloading File Check the network mf..");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sendType == 'sent') {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 13),
              decoration: BoxDecoration(
                gradient: messageBoxGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return FocusImage(
                      url: widget.url,
                    );
                  }));
                  // print('download and view image');
                  downloadFile;
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xff822FAF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Image.network(widget.url),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.time,
              style: messageTimeStyle,
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      );
    } else {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 13),
              decoration: const BoxDecoration(
                color: Color(0xffD9D6D6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return FocusImage(
                      url: widget.url,
                    );
                  }));
                  // print('download and view image');
                  downloadFile;
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xffB6B3B3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Image.network(widget.url),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.time,
              style: messageTimeStyle,
            ),
          ),
          const SizedBox(
            height: 21,
          )
        ],
      );
    }
  }
}

class FocusImage extends StatelessWidget {
  final String url;
  const FocusImage({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      child: PhotoView(
        imageProvider: NetworkImage(url),
      ),
    ));
  }
}
