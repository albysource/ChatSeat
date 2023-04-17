import 'package:flutter/material.dart';
import 'package:onionchatflutter/constants.dart';

class Normal_message extends StatelessWidget {
  final String message;
  final String time;
  final String sendType;
  const Normal_message(
      {Key? key,
      required this.sendType,
      required this.message,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sendType == 'sent') {
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
              child: Text(
                message,
                style: const TextStyle(
                    fontFamily: FontFamily_main,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              time,
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
              child: Text(
                message,
                style: const TextStyle(
                    fontFamily: FontFamily_main,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Color(0xff484848)),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              time,
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
