import 'dart:async';
import 'dart:ffi';

import 'package:either_dart/either.dart';
import 'package:onionchatflutter/xmpp/elements/XmppAttribute.dart';
import 'package:onionchatflutter/xmpp/elements/stanzas/IqStanza.dart';
import 'package:onionchatflutter/xmpp/xmpp_stone.dart';
import 'package:tuple/tuple.dart';

class RegistrationManager {
  static Map<Connection, RegistrationManager> instances =
      <Connection, RegistrationManager>{};

  static RegistrationManager getInstance(Connection connection) {
    var manager = instances[connection];
    if (manager == null) {
      manager = RegistrationManager(connection);
      instances[connection] = manager;
    }

    return manager;
  }

  final Connection _connection;

  final Map<String, Tuple2<IqStanza, Completer<RegistrationInfo>>>
      _unrespondedRegistrationInfoStanzas =
      <String, Tuple2<IqStanza, Completer<RegistrationInfo>>>{};
  final Map<String, Tuple2<IqStanza, Completer<Either<RegistrationError, Void?>>>>
      _unrespondedRegistrationRequestStanzas =
      <String, Tuple2<IqStanza, Completer<Either<RegistrationError, Void?>>>>{};

  RegistrationManager(this._connection) {
    _connection.connectionStateStream.listen(_connectionStateProcessor);
    _connection.inStanzasStream.listen(_processStanza);
  }

  Future<Either<RegistrationError, Void?>> createAccount(
      {required final String username, required final String password}) {
    var completer = Completer<Either<RegistrationError, Void?>>();
    var iqStanza = IqStanza(AbstractStanza.getRandomId(), IqStanzaType.SET);
    iqStanza.fromJid = _connection.fullJid;
    final registrationInfo = RegistrationInfo(
        attributes: {"username": username, "password": password});
    iqStanza.addChild(registrationInfo.toXmppElement());
    _unrespondedRegistrationRequestStanzas[iqStanza.id ?? ''] = Tuple2(iqStanza, completer);
    _connection.writeStanza(iqStanza);
    return completer.future;
  }

  Future<RegistrationInfo> getRegistrationInfo() {
    var completer = Completer<RegistrationInfo>();
    var iqStanza = IqStanza(AbstractStanza.getRandomId(), IqStanzaType.GET);
    final registrationInfo = RegistrationInfo();
    iqStanza.addChild(registrationInfo.toXmppElement());
    _unrespondedRegistrationInfoStanzas[iqStanza.id ?? ''] = Tuple2(iqStanza, completer);
    _connection.writeStanza(iqStanza);
    return completer.future;
  }

  void _connectionStateProcessor(XmppConnectionState event) {}

  void _processStanza(final AbstractStanza stanza) {
    _handleRegistrationInfoStanza(stanza);
    _handleRegistrationRequestStanza(stanza);
  }

  void _handleRegistrationInfoStanza(final AbstractStanza stanza) {
    if (stanza is! IqStanza) return;
    var requestStanza = _unrespondedRegistrationInfoStanzas[stanza.id];
    if (requestStanza == null) return;
    _unrespondedRegistrationInfoStanzas.remove(stanza.id);
    final String? instructionsElement = stanza.getChild("instructions")?.textValue;
    final remainingChildren = stanza.children.where((element) => element?.name != "instructions").whereType<XmppElement>().toList();
    final Map<String, String> attributes = { for (var e in remainingChildren) if (e.name != null ) e.name! : e.textValue ?? "" };
    attributes["TYPE"] = stanza.type.name;
    final RegistrationInfo info = RegistrationInfo(instructions: instructionsElement, attributes: attributes);
    requestStanza.item2.complete(info);
  }

  void _handleRegistrationRequestStanza(final AbstractStanza stanza) {
    if (stanza is! IqStanza) return;
    var requestStanza = _unrespondedRegistrationRequestStanzas[stanza.id];
    if (requestStanza == null) return;
    _unrespondedRegistrationRequestStanzas.remove(stanza.id);
    if (stanza.type == IqStanzaType.RESULT) {
      requestStanza.item2.complete(const Right(null));
    } else if ([IqStanzaType.ERROR, IqStanzaType.INVALID, IqStanzaType.TIMEOUT].contains(stanza.type)) {
      final errorElement = stanza.getChild("error");
      final int errorCode = int.tryParse(errorElement?.getAttribute("code")?.value ?? '') ?? 400;
      final String errorDescription = errorElement?.children.whereType<XmppElement>().map((e) => e.name).join(", ") ?? "Error: ${stanza.type}";
      requestStanza.item2.complete(Left(RegistrationError(errorCode, errorDescription)));
    }
  }
}

class RegistrationInfo {
  final String? instructions;
  final Map<String, String>? attributes;

  RegistrationInfo({this.instructions, this.attributes});

  XmppElement toXmppElement() {
    var registrationElement = XmppElement();
    registrationElement.name = 'query';
    registrationElement
        .addAttribute(XmppAttribute('xmlns', 'jabber:iq:register'));
    if (instructions != null) {
      final instructionsElement = XmppElement();
      instructionsElement.name = "instructions";
      instructionsElement.textValue = instructions;
      registrationElement.addChild(instructionsElement);
    }
    attributes?.forEach((key, value) {
      final attrElement = XmppElement();
      attrElement.name = key;
      attrElement.textValue = value;
      registrationElement.addChild(attrElement);
    });
    return registrationElement;
  }
}

class RegistrationError {
  final int code;
  final String name;

  RegistrationError(this.code, this.name);
}
