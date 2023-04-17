import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:onionchatflutter/util/connection_helper.dart';
import 'package:onionchatflutter/xmpp/xmpp_stone.dart' as xmpp;

class LoginViewModel {
  Future<Either<ConnectionError, xmpp.Connection>> login(final String username, final String password) async {
    final xmpp.XmppAccountSettings accountSettings = createAccountSettings(username: username, password: password);
    final xmpp.Connection connection = xmpp.Connection(accountSettings);
    connection.connect();
    final xmpp.XmppConnectionState terminalState = await connection.awaitState(const [
      xmpp.XmppConnectionState.Closed,
      xmpp.XmppConnectionState.ForcefullyClosed,
      xmpp.XmppConnectionState.AuthenticationFailure,
      xmpp.XmppConnectionState.Authenticated,
    ]);
    return Either.condLazy(
        terminalState == xmpp.XmppConnectionState.Authenticated,
        () {
          if (connection.isOpened()) connection.close();
          return ConnectionError(terminalState, connection.errorMessage ?? "");
        },
        () => connection);
  }
}