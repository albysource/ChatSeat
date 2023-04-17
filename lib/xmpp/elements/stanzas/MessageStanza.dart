import 'package:onionchatflutter/xmpp/elements/XmppAttribute.dart';
import 'package:onionchatflutter/xmpp/elements/XmppElement.dart';
import 'package:onionchatflutter/xmpp/elements/stanzas/AbstractStanza.dart';

class MessageStanza extends AbstractStanza {
  MessageStanzaType? type;

  MessageStanza(id, this.type) {
    name = 'message';
    this.id = id;
    addAttribute(
        XmppAttribute('type', type.toString().split('.').last.toLowerCase()));
  }

  String? get body => children
      .firstWhere((child) => (child?.name == 'body' && child?.attributes.isEmpty == true),
          orElse: () => null)
      ?.textValue;

  set body(String? value) {
    var element = XmppElement();
    element.name = 'body';
    element.textValue = value;
    addChild(element);
  }

  String? get subject => children
      .firstWhere((child) => (child?.name == 'subject'), orElse: () => null)
      ?.textValue;

  set subject(String? value) {
    var element = XmppElement();
    element.name = 'subject';
    element.textValue = value;
    addChild(element);
  }

  String? get thread => children
      .firstWhere((child) => (child?.name == 'thread'), orElse: () => null)
      ?.textValue;

  set thread(String? value) {
    var element = XmppElement();
    element.name = 'thread';
    element.textValue = value;
    addChild(element);
  }
}

enum MessageStanzaType { CHAT, ERROR, GROUPCHAT, HEADLINE, NORMAL, UNKOWN }
