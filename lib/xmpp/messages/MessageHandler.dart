import 'package:onionchatflutter/xmpp/Connection.dart';
import 'package:onionchatflutter/xmpp/data/Jid.dart';
import 'package:onionchatflutter/xmpp/elements/stanzas/AbstractStanza.dart';
import 'package:onionchatflutter/xmpp/elements/stanzas/MessageStanza.dart';
import 'package:onionchatflutter/xmpp/messages/MessageApi.dart';

class MessageHandler implements MessageApi {
  static Map<Connection, MessageHandler> instances =
      <Connection, MessageHandler>{};

  Stream<MessageStanza> get messagesStream {
    return _connection.inStanzasStream
        .where((abstractStanza) => abstractStanza is MessageStanza)
        .map((stanza) => stanza as MessageStanza);
  }

  static MessageHandler getInstance(Connection connection) {
    var manager = instances[connection];
    if (manager == null) {
      manager = MessageHandler(connection);
      instances[connection] = manager;
    }

    return manager;
  }

  final Connection _connection;

  MessageHandler(this._connection);

  @override
  void sendMessage(Jid to, String text) {
    _sendMessageStanza(to, text);
  }

  void _sendMessageStanza(Jid jid, String text) {
    var stanza =
        MessageStanza(AbstractStanza.getRandomId(), MessageStanzaType.CHAT);
    stanza.toJid = jid;
    stanza.fromJid = _connection.fullJid;
    stanza.body = text;
    _connection.writeStanza(stanza);
  }
}
