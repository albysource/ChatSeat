import 'package:onionchatflutter/xmpp/xmpp_stone.dart' as xmpp;

import '../xmpp/account/XmppAccountSettings.dart';

const domain = 'dedf54xrpkdkekxc36ky4kofo6yq5gdndevh3mrpjlvdmcafsfsw2mqd.onion';
const port = 5222;
const resource = 'OnionChat';
const host = '79.110.52.158';

xmpp.XmppAccountSettings createAccountSettings({String username = "", String password = ""}) => xmpp.XmppAccountSettings(
  "$username@$domain",
  username,
  domain,
  password,
  port,
  proxy: Socks4Proxy(host: "localhost", port: 9050),
  resource: resource,
  host: host,
);

extension ConnectionStateHelper on xmpp.Connection {
  Future<xmpp.XmppConnectionState> awaitState(final List<xmpp.XmppConnectionState> states) {
    return connectionStateStream
        .where(states.contains)
        .first;
  }
}

extension JidTransformer on String {
  xmpp.Jid toJid() {
    return xmpp.Jid(this, domain, resource);
  }
}


class ConnectionError {
  final xmpp.XmppConnectionState state;
  final String message;
  ConnectionError(this.state, this.message);
}