import 'dart:convert';
import 'dart:io';

import 'package:onionchatflutter/xmpp/data/Jid.dart';
import 'package:onionchatflutter/xmpp/proxy/socks4.dart';
import 'package:onionchatflutter/xmpp/proxy/socks5.dart' as local_sock;
import 'package:socks5/socks5.dart';

class XmppAccountSettings {
  Proxy proxy;
  String name;
  String username;
  String domain;
  String resource;
  String password;
  String? host;
  int port;
  int totalReconnections = 3;
  int reconnectionTimeout = 1000;
  bool ackEnabled = true;

  XmppAccountSettings(this.name, this.username, this.domain, this.password, this.port, {this.host, this.resource = '', this.proxy = noProxy} );

  Jid get fullJid => Jid(username, domain, resource);

  static XmppAccountSettings fromJid(String jid, String password, {Proxy proxy = noProxy}) {
    var fullJid = Jid.fromFullJid(jid);
    return XmppAccountSettings(jid, fullJid.local ?? '', fullJid.domain ?? '', password, 5222, proxy: proxy);
  }
}

const noProxy = _PassthroughProxy();

abstract class Proxy {
  final ProxyType type;

  const Proxy({this.type = ProxyType.NONE});

  Future<Socket> createProxySocket(final String connectionHost, final int connectionPort);
}

class _PassthroughProxy extends Proxy {
  const _PassthroughProxy() : super(type: ProxyType.NONE);

  @override
  Future<Socket> createProxySocket(String connectionHost, int connectionPort) {
    return Socket.connect(connectionHost, connectionPort);
  }
}

class Socks5Proxy extends Proxy {
  final String host;
  final int port;
  final String? username;
  final String? password;
  Socks5Proxy({required this.host, required this.port, this.username, this.password}) : super(type: ProxyType.SOCKS5);

  @override
  Future<Socket> createProxySocket(final String connectionHost, final int connectionPort) async {
    final socket = await Socket.connect(connectionHost, connectionPort);
    final sock = await RawSocket.connect(host, port);
    final proxy = SOCKSSocket(sock);
    await proxy.connect("$connectionHost:$connectionPort");
    return socket;
  }
}

class Socks4Proxy extends Proxy {
  final String host;
  final int port;
  final String? username;
  final String? password;
  Socks4Proxy({required this.host, required this.port, this.username, this.password}) : super(type: ProxyType.SOCKS4);

  @override
  Future<Socket> createProxySocket(String connectionHost, int connectionPort) async {
    final uri = Uri.http("$connectionHost:$connectionPort", '/');
    String authority = "$connectionHost:$connectionPort";
    return await connectSocks4(proxyHost: host, proxyPort: port, uri: uri);
  }
}

enum ProxyType {
  NONE,
  SOCKS4,
  SOCKS5,
}
