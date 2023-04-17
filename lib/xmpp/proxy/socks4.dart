import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:onionchatflutter/xmpp/proxy/broadcasting_socket.dart';

import '../../util/connection_helper.dart';
import '../../viewmodel/login_view_model.dart';

Future<Socket> connectSocks4(
    {required final String proxyHost,
      required final int proxyPort,
      required final Uri uri}) async {
  Socket socket =
  BroadcastingSocket(await Socket.connect(proxyHost, proxyPort));
  socket.setOption(SocketOption.tcpNoDelay, true);

  final port = uri.port;
  var uriPortBytes = [(port >> 8) & 0xFF, port & 0xFF];
  var uriAuthorityAscii = ascii.encode(uri.authority);

  socket.add([
    0x04,
    0x01,
    ...uriPortBytes,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    ...uriAuthorityAscii,
    0x00,
  ]);
  Completer<void> completer = Completer();

  StreamSubscription? subscription;
  subscription = socket.listen((event) async {
    if (event.length == 8 && event[0] == 0x00 && event[1] == 0x5A) {
      print('Connection open');
      if (uri.scheme == 'https') {
        socket = BroadcastingSocket(await SecureSocket.secure(
          (socket as BroadcastingSocket).backingSocket,
          host: uri.authority,
        ));
      }
      await subscription?.cancel();
      completer.complete(null);
    }
  });
  await completer.future.timeout(Duration(seconds: 3));
  return socket;
}

void main() async {
  final socket = await connectSocks4(proxyHost: "localhost", proxyPort:  9150, uri: Uri.http("79.110.52.158:5222", "/"));
  print(socket.remoteAddress);
}
