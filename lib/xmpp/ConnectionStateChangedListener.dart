import 'package:onionchatflutter/xmpp/Connection.dart';

abstract class ConnectionStateChangedListener {
  void onConnectionStateChanged(XmppConnectionState state);
}
