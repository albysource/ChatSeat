import 'dart:async';

import 'package:intl/intl.dart';
import 'package:onionchatflutter/model/chat_channel.dart';
import 'package:onionchatflutter/model/chat_channel.dart' as cc;
import 'package:onionchatflutter/model/chat_message.dart' as cm;
import 'package:onionchatflutter/repository/channel_repository.dart';
import 'package:onionchatflutter/repository/message_repository.dart';
import 'package:onionchatflutter/util/connection_helper.dart';
import 'package:onionchatflutter/xmpp/Connection.dart';
import 'package:onionchatflutter/xmpp/elements/stanzas/MessageStanza.dart';
import 'package:onionchatflutter/xmpp/xmpp_stone.dart';

final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");

abstract class Messenger {
  VCardManager get vCardManager;

  String? activeChannelId;

  Stream<cm.Message> get incomingMessages;

  Stream<cm.Message> get outgoingMessages;

  Stream<cc.ChatChannel> get channelCreations;

  Stream<cc.ChatChannel> get channelUpdates;

  String get username;

  Future<cm.Message> sendMessage(cm.Message message);

  Future<List<cm.Message>> fetchMessages(
      String channelId, int offset, int limit);

  Future<List<cc.ChatChannel>> fetchChannels(int offset, int limit);

  Future<cc.ChatChannel> createChannel(String channelId);

  Future<cc.ChatChannel?> updateLastSeen(String channelId);

  Future<void> logout();

  void dispose();
}

class XmppMessenger extends Messenger {
  final MessageRepository _messageRepository;
  final ChannelRepository _channelRepository;
  final VCardManager _vCardManager;
  final Connection connection;
  final StreamSubscription _stanzaSubscription;
  final StreamController<cm.Message> _incomingMessagesController;
  final StreamController<cm.Message> _outgoingMessagesController;

  final StreamController<cc.ChatChannel> _channelUpdationStreamController;
  final StreamController<cc.ChatChannel> _channelCreationStreamController;

  XmppMessenger(
      this._messageRepository,
      this._incomingMessagesController,
      this._outgoingMessagesController,
      this.connection,
      this._channelRepository,
      this._vCardManager,
      this._channelUpdationStreamController,
      this._channelCreationStreamController)
      : _stanzaSubscription = connection.inStanzasStream
            .where((abstractStanza) => abstractStanza is MessageStanza)
            .map((stanza) => stanza as MessageStanza)
            .where((event) =>
                (event.type == MessageStanzaType.CHAT || event.type == MessageStanzaType.NORMAL) &&
                event.fromJid != event.toJid)
            .map((stanza) {
          final fileExtension = stanza.getChild("onion_msg_type");
          final delayExtension = stanza.getChild("delay");
          final stampAttribute = delayExtension?.getAttribute("stamp");
          final timeStamp = stampAttribute == null
              ? DateTime.now()
              : dateFormat.parse(stampAttribute.value);

          final channelName = stanza.fromJid?.local ?? "Unknown";
          final cm.Message message;
          if (fileExtension == null) {
            message = cm.TextMessage(
                from: stanza.fromJid?.local ?? "Unknown",
                channelName: channelName,
                timestamp: timeStamp.millisecondsSinceEpoch,
                message: stanza.body ?? "");
          } else {
            message = cm.DownloadableMessage(
                type: cm.migrateFromAndroidNaming(
                    fileExtension.getAttribute("Type")?.value ?? ""),
                from: stanza.fromJid?.local ?? "Unknown",
                channelName: channelName,
                timestamp: timeStamp.millisecondsSinceEpoch,
                url: fileExtension.getAttribute("Url")?.value ?? "",
                name: fileExtension.getAttribute("Name")?.value ?? "",
                size: int.parse(
                    fileExtension.getAttribute("Size")?.value ?? "0"));
          }
          return message;
        }).listen((msg) async {
          _channelRepository.getChannel(msg.channelName).then((channel) async {
            if (channel != null) {
              return;
            }
            final newChannel = ChatChannel(
                name: msg.from,
                avatarFilePath: "Assets/Icons/avatar.png",
                lastViewed: 0);
            final created = await _channelRepository.insert(newChannel);
            _channelCreationStreamController.add(created);
          });
          _incomingMessagesController.add(await _messageRepository.insert(msg));
        }) {}

  @override
  Stream<cm.Message> get incomingMessages =>
      _incomingMessagesController.stream.asBroadcastStream();

  @override
  Stream<cm.Message> get outgoingMessages =>
      _outgoingMessagesController.stream.asBroadcastStream();

  @override
  Future<cm.Message> sendMessage(cm.Message message) async {
    final insertedMessage = await _messageRepository.insert(message);
    _outgoingMessagesController.add(insertedMessage);
    if (insertedMessage is cm.TextMessage) {
      MessageHandler.getInstance(connection)
          .sendMessage(message.channelName.toJid(), insertedMessage.message);
    }
    return insertedMessage;
  }

  @override
  Future<List<cm.Message>> fetchMessages(
      String channelId, int offset, int limit) async {
    final List<cm.Message> messages =
        await _messageRepository.getMessagesFromChannel(
            channelId: channelId, offset: offset, limit: limit);
    return messages;
  }

  @override
  Future<List<cc.ChatChannel>> fetchChannels(int offset, int limit) async {
    final channels = await _channelRepository.fetchChannels(offset, limit);
    return channels;
  }

  @override
  Future<cc.ChatChannel> createChannel(String channelId) async {
    final newChannel = ChatChannel(
        name: channelId,
        avatarFilePath: "Assets/Icons/avatar.png",
        lastViewed: 0);
    final created = await _channelRepository.insert(newChannel);
    _channelCreationStreamController.add(created);
    return created;
  }

  @override
  void dispose() {
    _stanzaSubscription.cancel();
    _incomingMessagesController.close();
    _outgoingMessagesController.close();
    _channelUpdationStreamController.close();
    _channelCreationStreamController.close();
  }

  @override
  Stream<ChatChannel> get channelCreations =>
      _channelCreationStreamController.stream.asBroadcastStream();

  @override
  String get username => connection.fullJid.local ?? "Unknown";

  @override
  Future<ChatChannel?> updateLastSeen(String channelId) async {
    final channel = await _channelRepository.getChannel(channelId);
    if (channel == null) return null;
    channel.lastViewed = DateTime.now().millisecondsSinceEpoch;
    _channelUpdationStreamController.add(channel);
    await _channelRepository.update(channel);
    return channel;
  }

  @override
  Stream<ChatChannel> get channelUpdates =>
      _channelUpdationStreamController.stream.asBroadcastStream();

  @override
  VCardManager get vCardManager => _vCardManager;

  @override
  Future<void> logout() async {
    connection.close();
  }
}
