import 'dart:async';
import 'package:onionchatflutter/xmpp/Connection.dart';
import 'logger/Log.dart';

class ReconnectionManager {
  static const TAG = 'ReconnectionManager';

  Connection _connection;
  bool isActive = false;
  int initialTimeout = 1000;
  int totalReconnections = 3;
  int timeOutInMs;
  int counter = 0;
  Timer? timer;

  ReconnectionManager(this._connection): initialTimeout = _connection.account.reconnectionTimeout, totalReconnections = _connection.account.totalReconnections, timeOutInMs = _connection.account.reconnectionTimeout {
    _connection.connectionStateStream.listen(connectionStateHandler);
  }

  void connectionStateHandler(XmppConnectionState state) {
    if (state == XmppConnectionState.ForcefullyClosed) {
      Log.d(TAG, 'Connection forcefully closed!'); //connection lost
      handleReconnection();
    } else if (state == XmppConnectionState.SocketOpening) {
      //do nothing
    } else if (state != XmppConnectionState.Reconnecting) {
      isActive = false;
      timeOutInMs = initialTimeout;
      counter = 0;
      if (timer != null) {
        timer?.cancel();
        timer = null;
      }
    }
  }

  void handleReconnection() {
    if (timer != null) {
      timer?.cancel();
    }
    if (counter < totalReconnections) {
      timer = Timer(Duration(milliseconds: timeOutInMs), _connection.reconnect);
      timeOutInMs += timeOutInMs;
      Log.d(TAG, 'TimeOut is: $timeOutInMs reconnection counter $counter');
      counter++;
    } else {
      _connection.close();
    }
  }
}
