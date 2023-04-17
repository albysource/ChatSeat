import 'package:flutter/material.dart';
import 'package:onionchatflutter/constants.dart';

class AudioMessage extends StatefulWidget {
  final String sendType;
  final String url;
  final String time;

  const AudioMessage({
    Key? key,
    required this.sendType,
    required this.url,
    required this.time,
  }) : super(key: key);

  @override
  _AudioMessageState createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  bool isPlaying = false;

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
                  print('download and play audio');
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
                  child: IntrinsicWidth(
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            iconSize: 40,
                            color: Colors.white,
                            icon: Icon(Icons.fast_rewind_rounded)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isPlaying = !isPlaying;
                            });
                          },
                          iconSize: 40,
                          color: Colors.white,
                          icon: (isPlaying)
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow_rounded),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Text(
                            // widget.url.split('/').last,
                            "audio file name here",
                            softWrap: true,
                            style: const TextStyle(
                              fontFamily: FontFamily_main,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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
                  print('download and play audio');
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
                  child: IntrinsicWidth(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "Filename here",
                            style: const TextStyle(
                              fontFamily: FontFamily_main,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff484848),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        IconButton(
                            onPressed: () {},
                            iconSize: 40,
                            color: Colors.black,
                            icon: Icon(Icons.fast_rewind_rounded)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isPlaying = !isPlaying;
                              });
                            },
                            iconSize: 40,
                            color: Colors.black,
                            icon: (isPlaying)
                                ? Icon(Icons.pause)
                                : Icon(Icons.play_arrow_rounded)),
                      ],
                    ),
                  ),
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
            height: 20,
          )
        ],
      );
    }
  }
}
