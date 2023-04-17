import 'package:onionchatflutter/xmpp/Connection.dart';
import 'package:onionchatflutter/xmpp/elements/nonzas/Nonza.dart';
import 'package:onionchatflutter/xmpp/features/sasl/SaslAuthenticationFeature.dart';

class NonAuthenticatingSaslAuthenticationFeature extends SaslAuthenticationFeature {
  NonAuthenticatingSaslAuthenticationFeature(final Connection connection) : super(connection, "");
  @override
  void negotiate(List<Nonza?> nonzas) {
    if (nonzas != null || nonzas.isNotEmpty) {
      connection.saslNegotiated();
    }
  }
}