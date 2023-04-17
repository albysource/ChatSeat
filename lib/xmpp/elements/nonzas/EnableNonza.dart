import 'package:onionchatflutter/xmpp/elements/XmppAttribute.dart';
import 'package:onionchatflutter/xmpp/elements/nonzas/Nonza.dart';

class EnableNonza extends Nonza {
  static String NAME = 'enable';
  static String XMLNS = 'urn:xmpp:sm:3';

  static bool match(Nonza nonza) =>
      (nonza.name == NAME && nonza.getAttribute('xmlns')?.value == XMLNS);

  EnableNonza(bool resume) {
    name = NAME;
    addAttribute(XmppAttribute('xmlns', 'urn:xmpp:sm:3'));
    addAttribute(XmppAttribute('resume', resume.toString()));
  }
}
