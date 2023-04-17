import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class BroadcastingSocket extends Socket {
  Stream<Uint8List> _broadcastStream;
  Socket backingSocket;
  @override
  Encoding encoding;

  BroadcastingSocket(this.backingSocket): encoding = backingSocket.encoding, _broadcastStream = backingSocket.asBroadcastStream();

  @override
  void add(List<int> data) {
    backingSocket.add(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    backingSocket.addError(error, stackTrace);
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    return backingSocket.addStream(stream);
  }

  @override
  InternetAddress get address => backingSocket.address;

  @override
  Future<bool> any(bool Function(Uint8List element) test) {
    return backingSocket.any(test);
  }

  @override
  Stream<Uint8List> asBroadcastStream({void Function(StreamSubscription<Uint8List> subscription)? onListen, void Function(StreamSubscription<Uint8List> subscription)? onCancel}) {
    return backingSocket.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(Uint8List event) convert) {
    return backingSocket.asyncExpand(convert);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(Uint8List event) convert) {
    return backingSocket.asyncMap(convert);
  }

  @override
  Stream<R> cast<R>() {
    return backingSocket.cast<R>();
  }

  @override
  Future close() {
    return backingSocket.close();
  }

  @override
  Future<bool> contains(Object? needle) {
    return backingSocket.contains(needle);
  }

  @override
  void destroy() {
    backingSocket.destroy();
  }

  @override
  Stream<Uint8List> distinct([bool Function(Uint8List previous, Uint8List next)? equals]) {
    return backingSocket.distinct(equals);
  }

  @override
  Future get done => backingSocket.done;

  @override
  Future<E> drain<E>([E? futureValue]) {
    return backingSocket.drain(futureValue);
  }

  @override
  Future<Uint8List> elementAt(int index) {
    return backingSocket.elementAt(index);
  }

  @override
  Future<bool> every(bool Function(Uint8List element) test) {
    return backingSocket.every(test);
  }

  @override
  Stream<S> expand<S>(Iterable<S> Function(Uint8List element) convert) {
    return backingSocket.expand(convert);
  }

  @override
  Future<Uint8List> get first => backingSocket.first;

  @override
  Future<Uint8List> firstWhere(bool Function(Uint8List element) test, {Uint8List Function()? orElse}) {
    return backingSocket.firstWhere(test, orElse: orElse);
  }

  @override
  Future flush() {
    return backingSocket.flush();
  }

  @override
  Future<S> fold<S>(S initialValue, S Function(S previous, Uint8List element) combine) {
    return backingSocket.fold(initialValue, combine);
  }

  @override
  Future forEach(void Function(Uint8List element) action) {
    return backingSocket.forEach(action);
  }

  @override
  Uint8List getRawOption(RawSocketOption option) {
    return backingSocket.getRawOption(option);
  }

  @override
  Stream<Uint8List> handleError(Function onError, {bool Function(dynamic error)? test}) {
    return backingSocket.handleError(onError, test: test);
  }

  @override
  bool get isBroadcast => backingSocket.isBroadcast;

  @override
  Future<bool> get isEmpty => backingSocket.isEmpty;

  @override
  Future<String> join([String separator = ""]) {
    return backingSocket.join(separator);
  }

  @override
  Future<Uint8List> get last =>  backingSocket.last;

  @override
  Future<Uint8List> lastWhere(bool Function(Uint8List element) test, {Uint8List Function()? orElse}) {
    return backingSocket.lastWhere(test, orElse: orElse);
  }

  @override
  Future<int> get length => backingSocket.length;

  @override
  StreamSubscription<Uint8List> listen(void Function(Uint8List event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _broadcastStream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  Future<Uint8List> get single => backingSocket.single;

  @override
  Future<Uint8List> singleWhere(bool Function(Uint8List element) test, {Uint8List Function()? orElse}) {
    return backingSocket.singleWhere(test, orElse: orElse);
  }

  @override
  Stream<Uint8List> skip(int count) {
    return backingSocket.skip(count);
  }

  @override
  Stream<Uint8List> skipWhile(bool Function(Uint8List element) test) {
    return backingSocket.skipWhile(test);
  }

  @override
  Stream<Uint8List> take(int count) {
    return backingSocket.take(count);
  }


  @override
  Stream<Uint8List> takeWhile(bool Function(Uint8List element) test) {
    return backingSocket.takeWhile(test);
  }

  @override
  Stream<S> map<S>(S Function(Uint8List event) convert) {
    return  backingSocket.map<S>(convert);
  }

  @override
  Future pipe(StreamConsumer<Uint8List> streamConsumer) {
    return backingSocket.pipe(streamConsumer);
  }

  @override
  int get port => backingSocket.port;

  @override
  Future<Uint8List> reduce(Uint8List Function(Uint8List previous, Uint8List element) combine) {
    return backingSocket.reduce(combine);
  }

  @override
  InternetAddress get remoteAddress => backingSocket.remoteAddress;

  @override
  int get remotePort => backingSocket.remotePort;

  @override
  bool setOption(SocketOption option, bool enabled) {
    return backingSocket.setOption(option, enabled);
  }

  @override
  void setRawOption(RawSocketOption option) {
    backingSocket.setRawOption(option);
  }

  @override
  Stream<Uint8List> timeout(Duration timeLimit, {void Function(EventSink<Uint8List> sink)? onTimeout}) {
    return backingSocket.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<List<Uint8List>> toList() {
    return backingSocket.toList();
  }

  @override
  Future<Set<Uint8List>> toSet() {
    return backingSocket.toSet();
  }

  @override
  Stream<S> transform<S>(StreamTransformer<Uint8List, S> streamTransformer) {
    return backingSocket.transform(streamTransformer);
  }

  @override
  Stream<Uint8List> where(bool Function(Uint8List event) test) {
    return backingSocket.where(test);
  }

  @override
  void write(Object? object) {
    backingSocket.write(object);
  }

  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    backingSocket.writeAll(objects, separator);
  }

  @override
  void writeCharCode(int charCode) {
    backingSocket.writeCharCode(charCode);
  }

  @override
  void writeln([Object? object = ""]) {
    backingSocket.writeln(object);
  }

  Future<RawSecureSocket> _detachRaw() {
    return (backingSocket as dynamic).detachRaw();
  }
}