import 'package:onionchatflutter/xmpp/roster/Buddy.dart';

abstract class RosterListener {
  void onRosterListChanged(List<Buddy> roster);
}
