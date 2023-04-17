import 'dart:ffi';

import 'package:either_dart/either.dart';
import 'package:onionchatflutter/xmpp/features/sasl/NonAuthenticatingSaslAuthenticationFeature.dart';
import 'package:onionchatflutter/xmpp/registration_manager.dart';

import '../util/connection_helper.dart';
import 'package:onionchatflutter/xmpp/xmpp_stone.dart' as xmpp;


class RegistrationViewModel {
  Future<Either<ConnectionError, Either<RegistrationError, Void?>>> register(
      final String username, final String password) async {
    final xmpp.XmppAccountSettings accountSettings = createAccountSettings();
    final xmpp.Connection connection = xmpp.Connection(accountSettings,
        authenticationFeature: (c, p) =>
            NonAuthenticatingSaslAuthenticationFeature(c));
    connection.connect();
    final xmpp.XmppConnectionState terminalState = await connection.awaitState(
        const [
          xmpp.XmppConnectionState.Closed,
          xmpp.XmppConnectionState.ForcefullyClosed,
          xmpp.XmppConnectionState.SaslNegotiated,
        ]);
    if (terminalState != xmpp.XmppConnectionState.SaslNegotiated) {
      if (connection.isOpened()) connection.close();
      return Left(ConnectionError(terminalState, connection.errorMessage ?? ""));
    }
    final RegistrationManager registrationManager = RegistrationManager.getInstance(connection);
    final result = await registrationManager.createAccount(username: username, password: password);
    if (connection.isOpened()) connection.close();
    return Right(result);
  }
}
