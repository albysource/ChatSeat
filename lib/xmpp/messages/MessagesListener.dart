import 'package:onionchatflutter/xmpp/elements/stanzas/MessageStanza.dart';

abstract class MessagesListener {
  void onNewMessage(MessageStanza message);
}
