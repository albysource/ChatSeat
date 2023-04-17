import 'package:onionchatflutter/xmpp/data/Jid.dart';

abstract class MessageApi {
  void sendMessage(Jid to, String text);
}
