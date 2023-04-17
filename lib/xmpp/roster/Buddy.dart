import 'package:onionchatflutter/xmpp/data/Jid.dart';

class Buddy {
  SubscriptionType? subscriptionType;

  String? name;

  Jid? accountJid;

  Jid _jid;

  Jid get jid => _jid;

  Buddy(this._jid);

  @override
  String toString() {
    return _jid.fullJid ?? '';
  }

  static SubscriptionType? typeFromString(String typeString) {
    switch (typeString) {
      case 'none':
        return SubscriptionType.NONE;
        break;
      case 'to':
        return SubscriptionType.TO;
        break;
      case 'from':
        return SubscriptionType.FROM;
        break;
      case 'both':
        return SubscriptionType.BOTH;
        break;
    }
    return null;
  }
}

enum SubscriptionType { NONE, TO, FROM, BOTH }
