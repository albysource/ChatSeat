import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Messages {
  final String type;
  final String sendType;
  final String message;
  final String time;
  final String attachmentUrl;

  Messages({
    required this.type,
    required this.sendType,
    required this.message,
    required this.time,
    required this.attachmentUrl,
  });
}

class ChatMessage with ChangeNotifier {
  final List<Messages> _SpoofMessages = [
    Messages(
      type: 'normal',
      sendType: 'recieve',
      message: 'How are u bro?',
      time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
      attachmentUrl: '',
    ),
    Messages(
      type: 'normal',
      sendType: 'sent',
      message: 'I am doing gud. How was the test bro?',
      time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
      attachmentUrl: '',
    ),
    Messages(
      type: 'normal',
      sendType: 'recieve',
      message:
          'The test was kinda gud 👍👍.Can u sent the assignment that was given yesterday ?',
      time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
      attachmentUrl: '',
    ),
    Messages(
      type: 'normal',
      sendType: 'sent',
      message: 'Ya bro sure, just wait a second.',
      time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
      attachmentUrl: '',
    ),
    Messages(
      type: 'attachment',
      sendType: 'sent',
      message: '',
      time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
      attachmentUrl: "Assets/Test_images/dharan.jpg",
    ),
    Messages(
      type: 'normal',
      sendType: 'recieve',
      message:
          'Thanks a lot bro. By the way how was yesterdays class. I couldnt attend due to some personal reasons',
      time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
      attachmentUrl: '',
    ),
    Messages(
      type: 'normal',
      sendType: 'sent',
      message: 'It was good bro. There were not much important topics.',
      time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
      attachmentUrl: '',
    ),
    Messages(
      type: 'normal',
      sendType: 'sent',
      message: 'No worries',
      time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
      attachmentUrl: '',
    ),
    Messages(
      type: 'attachment',
      sendType: 'recieve',
      message: '',
      time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
      attachmentUrl: "Assets/Test_images/albin.jpg",
    ),
  ];

  List<Messages> get SpoofMessages {
    return [..._SpoofMessages];
  }

  void sentMessage(Messages message) {
    _SpoofMessages.add(message);
    notifyListeners();
  }
}
