import 'dart:async';

import 'package:onionchatflutter/xmpp/Connection.dart';
import 'package:onionchatflutter/xmpp/data/Jid.dart';
import 'package:onionchatflutter/xmpp/elements/XmppAttribute.dart';
import 'package:onionchatflutter/xmpp/elements/XmppElement.dart';
import 'package:onionchatflutter/xmpp/elements/nonzas/Nonza.dart';
import 'package:onionchatflutter/xmpp/elements/stanzas/AbstractStanza.dart';
import 'package:onionchatflutter/xmpp/elements/stanzas/IqStanza.dart';
import 'package:onionchatflutter/xmpp/features/Negotiator.dart';
import '../elements/nonzas/Nonza.dart';

class BindingResourceConnectionNegotiator extends Negotiator {
  Connection _connection;
  StreamSubscription<AbstractStanza>? subscription;
  static const String BIND_NAME = 'bind';
  static const String BIND_ATTRIBUTE = 'urn:ietf:params:xml:ns:xmpp-bind';

  BindingResourceConnectionNegotiator(this._connection) {
    priorityLevel = 100;
    expectedName = 'BindingResourceConnectionNegotiator';
  }
  @override
  List<Nonza> match(List<Nonza?> requests) {
    var nonza = requests.firstWhere((request) => request?.name == BIND_NAME, orElse: () => null);
    return nonza != null ? [nonza] : [];
  }

  @override
  void negotiate(List<Nonza?> nonzas) {
    if (match(nonzas).isNotEmpty) {
      state = NegotiatorState.NEGOTIATING;
      subscription = _connection.inStanzasStream.listen(parseStanza);
      sendBindRequestStanza(_connection.account.resource);
    }
  }

  void parseStanza(AbstractStanza stanza) {
    if (stanza is IqStanza) {
      var element = stanza.getChild(BIND_NAME);
      var jidValue = element?.getChild('jid')?.textValue;
      if (jidValue != null) {
        var jid = Jid.fromFullJid(jidValue);
        _connection.fullJidRetrieved(jid);
        state = NegotiatorState.DONE;
        subscription?.cancel();
      }
    }
  }

  void sendBindRequestStanza(String resource) {
    var stanza = IqStanza(AbstractStanza.getRandomId(), IqStanzaType.SET);
    var bindElement = XmppElement();
    bindElement.name = BIND_NAME;
    var resourceElement = XmppElement();
    resourceElement.name = 'resource';
    resourceElement.textValue = resource;
    bindElement.addChild(resourceElement);
    var attribute = XmppAttribute('xmlns', BIND_ATTRIBUTE);
    bindElement.addAttribute(attribute);
    stanza.addChild(bindElement);
    _connection.writeStanza(stanza);
  }
}
