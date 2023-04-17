import 'package:onionchatflutter/repository/messages_table.dart' as messages_table;



abstract class Message {
  int? id;
  final MessageType type;
  final String from;
  final String channelName;
  final int timestamp;

  Message(this.id, this.type, this.from, this.channelName, this.timestamp);

  Map<String, Object> toMap();

  static Message fromMap(final Map<String, Object?> map) {
    switch(MessageType.values[map[messages_table.colType] as int]) {
      case MessageType.TEXT:
        return TextMessage(
            id: map[messages_table.colId] as int?,
            from: map[messages_table.colFrom] as String,
            timestamp: map[messages_table.colTimestamp] as int,
            message: map[messages_table.colBody] as String,
            channelName: map[messages_table.colChannelName] as String
        );
      default:
        return DownloadableMessage(
            id: map[messages_table.colId] as int?,
            type: MessageType.values[map[messages_table.colType] as int? ?? 0],
            from: map[messages_table.colFrom] as String,
            channelName: map[messages_table.colChannelName] as String,
            timestamp: map[messages_table.colTimestamp] as int,
            size: map[messages_table.colFileSize] as int,
            url: map[messages_table.colUrl] as String,
            name: map[messages_table.colFileName] as String,
        );
    }
  }
}

enum MessageType {
  TEXT,
  FILE,
  IMAGE,
  AUDIO
}

MessageType migrateFromAndroidNaming(final String androidName) {
  switch (androidName) {
    case "IMAGE":
      return MessageType.IMAGE;
    case "AUDIO":
      return MessageType.AUDIO;
    case "FILE":
      return MessageType.FILE;
    default:
      return  MessageType.TEXT;
  }
}

String migrateToAndroidNaming(final MessageType type) {
  switch (type) {
    case MessageType.IMAGE:
      return "IMAGE";
    case MessageType.AUDIO:
      return "AUDIO";
    case MessageType.FILE:
      return "FILE";
    default:
      return  "TEXT";
  }
}


class TextMessage extends Message {
  final String message;

  TextMessage(
      {int? id,
      required String from,
      required String channelName,
      required int timestamp,
      required this.message})
      : super(id, MessageType.TEXT, from, channelName, timestamp);
  @override
  Map<String, Object> toMap() {
    final capturedId = id;
    return {
      if (capturedId != null) messages_table.colId : capturedId,
      messages_table.colType : type.index,
      messages_table.colFrom : from,
      messages_table.colChannelName : channelName,
      messages_table.colTimestamp : timestamp,
      messages_table.colBody : message,
    };
  }
}

class DownloadableMessage extends Message {
  final String url;
  final String name;
  final int size;

  String? _localPath;

  String? get localPath => _localPath;

  bool get isDownloaded => _localPath != null;

  DownloadableMessage(
      {int? id,
      required MessageType type,
      required String from,
      required String channelName,
      required int timestamp,
      required this.url,
      required this.name,
      required this.size,
      String? localPath})
      : _localPath = localPath,
        super(id, type, from, channelName, timestamp);

  Future<bool> tryDownload() async {
    return true;
  }

  @override
  Map<String, Object> toMap() {
    final capturedId = id;
    final capturedLocalPath = id;
    return {
      if (capturedId != null) messages_table.colId : capturedId,
      messages_table.colType : type.index,
      messages_table.colFrom : from,
      messages_table.colChannelName : channelName,
      messages_table.colTimestamp : timestamp,
      messages_table.colUrl : url,
      messages_table.colFileName : name,
      messages_table.colFileSize : size,
      if (capturedLocalPath != null) messages_table.colLocalPath : capturedLocalPath
    };
  }
}
