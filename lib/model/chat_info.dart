import 'package:flutter/cupertino.dart';

class ChatInfo {
  final String name;
  final String latestMessage;
  final String imageUrl;
  final int unreadMessageCounter;

  ChatInfo({
    required this.name,
    required this.latestMessage,
    required this.imageUrl,
    required this.unreadMessageCounter,
  });
}

class ChatCardsinfo with ChangeNotifier {
  final List<ChatInfo> _chatsInfo = [
    ChatInfo(
      name: 'Albin_alex',
      latestMessage: 'Hello bro how are you',
      imageUrl: 'Assets/Test_images/albin.jpg',
      unreadMessageCounter: 3,
    ),
    ChatInfo(
      name: 'Pranav_r',
      latestMessage: 'Finished the work 👍',
      imageUrl: 'Assets/Test_images/icarus.jpg',
      unreadMessageCounter: 0,
    ),
    ChatInfo(
      name: 'Mr_dharan_singh',
      latestMessage: 'Bro are u coming for playing fortnite',
      imageUrl: 'Assets/Test_images/dharan.jpg',
      unreadMessageCounter: 2,
    ),
    ChatInfo(
      name: 'Shyamkrishnan_S',
      latestMessage: 'I am not here da',
      imageUrl: 'Assets/Test_images/shyam.jpg',
      unreadMessageCounter: 1,
    ),
    ChatInfo(
      name: 'Akil_MSI',
      latestMessage: 'I am doing gud 👍👍. How are u bro ?',
      imageUrl: 'Assets/Test_images/Msi.jpg',
      unreadMessageCounter: 5,
    ),
    ChatInfo(
      name: 'Jeff_Bijos',
      latestMessage: 'Did u recieve the mail I sent ?',
      imageUrl: 'Assets/Test_images/vshnv.png',
      unreadMessageCounter: 0,
    ),
    ChatInfo(
      name: 'Johny_Noel',
      latestMessage: '😂🤣😂🤣',
      imageUrl: 'Assets/Test_images/noel.jpg',
      unreadMessageCounter: 1,
    ),
    ChatInfo(
      name: 'Icarus',
      latestMessage: 'Can u sent the assignments ?',
      imageUrl: 'Assets/Test_images/icarus.jpg',
      unreadMessageCounter: 0,
    ),
    ChatInfo(
      name: 'Mr_venom',
      latestMessage: 'Happy Birthday bro 🎉🎉🎉',
      imageUrl: 'Assets/Test_images/albin.jpg',
      unreadMessageCounter: 0,
    ),
    ChatInfo(
      name: 'Albin_alex',
      latestMessage: 'Hello bro how are you',
      imageUrl: 'Assets/Test_images/albin.jpg',
      unreadMessageCounter: 3,
    ),
    ChatInfo(
      name: 'Pranav_r',
      latestMessage: 'Finished the work 👍',
      imageUrl: 'Assets/Test_images/icarus.jpg',
      unreadMessageCounter: 0,
    ),
    ChatInfo(
      name: 'Mr_dharan_singh',
      latestMessage: 'Bro are u coming for playing fortnite',
      imageUrl: 'Assets/Test_images/dharan.jpg',
      unreadMessageCounter: 2,
    ),
  ];

  List<ChatInfo> get chatInfo {
    return [..._chatsInfo];
  }
}
