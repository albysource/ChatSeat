import 'package:onionchatflutter/repository/channels_table.dart'
    as channels_table;

class ChatChannel {
  final String name;
  final String avatarFilePath;
  int lastViewed;
  String? lastMessage;
  int? unreadCount;

  ChatChannel(
      {required this.name,
      required this.avatarFilePath,
      required this.lastViewed,
      this.lastMessage,
      this.unreadCount});

  factory ChatChannel.fromViewMap(final Map<String, Object?> map) {
    return ChatChannel(
      name: map[channels_table.colName] as String,
      avatarFilePath: map[channels_table.colAvatarFilePath] as String,
      lastViewed: map[channels_table.colLastViewedTimeStamp] as int,
      lastMessage: map[channels_table.vColLastMessage] as String?,
      unreadCount: map[channels_table.vColUnreadCount] as int?,
    );
  }

  Map<String, Object?> toTableMap() {
    return {
        channels_table.colName : name,
        channels_table.colAvatarFilePath : avatarFilePath,
        channels_table.colLastViewedTimeStamp : lastViewed
    };
  }
}
