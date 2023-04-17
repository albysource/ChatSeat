import 'package:onionchatflutter/xmpp/elements/stanzas/AbstractStanza.dart';

abstract class StanzaProcessor {
  void processStanza(AbstractStanza stanza);
}
