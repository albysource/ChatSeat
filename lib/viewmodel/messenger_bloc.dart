import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onionchatflutter/model/chat_message.dart';
import 'package:onionchatflutter/viewmodel/messenger_service.dart';

class MessengerBloc extends Bloc<MessengerEvent, MessengerState> {
  final Messenger _messenger;
  final String _channelId;

  MessengerBloc(this._messenger, this._channelId)
      : super(LoadingMessengerState()) {
    on<MessengerInitEvent>(onInit);
    on<MessageReceiveEvent>(onMessageReceive);
    on<MessageFetchEvent>(onMessageFetch);
    on<MessageSendEvent>(onMessageSend);
    _messenger.incomingMessages.listen((msg) {
      add(MessageReceiveEvent(msg));
    });
  }

  FutureOr<void> onInit(
      final MessengerInitEvent event, Emitter<MessengerState> emit) async {
    emit(LoadingMessengerState());
    final List<Message> msg = await _messenger.fetchMessages(_channelId, 0, 20);
    emit(LoadedMessengerState(msg, false));
  }

  FutureOr<void> onMessageReceive(
      final MessageReceiveEvent event, Emitter<MessengerState> emit) async {
    final capturedState = state;
    if (capturedState is! LoadedMessengerState) {
      return;
    }
    capturedState.messages.add(event.message);
    emit(LoadedMessengerState(capturedState.messages, capturedState.completedLoading));
  }

  FutureOr<void> onMessageSend(
      final MessageSendEvent event, Emitter<MessengerState> emit) async {
    final capturedState = state;
    if (capturedState is! LoadedMessengerState) {
      return;
    }
    final Message msg = await _messenger.sendMessage(event.message);
    capturedState.messages.add(msg);
    emit(LoadedMessengerState(capturedState.messages, capturedState.completedLoading));
  }

  FutureOr<void> onMessageFetch(
      final MessageFetchEvent event, Emitter<MessengerState> emit) async {
    final capturedState = state;
    if (capturedState is! LoadedMessengerState) {
      return;
    }
    final List<Message> msg = await _messenger.fetchMessages(
        _channelId, capturedState.messages.length, 10);
    capturedState.messages.insertAll(0, msg);
    emit(LoadedMessengerState(capturedState.messages, msg.isEmpty));
  }
}

abstract class MessengerState {}

class LoadingMessengerState extends MessengerState {}

class ErrorMessengerState extends MessengerState {}

class LoadedMessengerState extends MessengerState {
  final List<Message> messages;
  final bool completedLoading;

  LoadedMessengerState(this.messages, this.completedLoading);
}

abstract class MessengerEvent {}


class MessageSendEvent extends MessengerEvent {
  final Message message;

  MessageSendEvent(this.message);
}

class MessageReceiveEvent extends MessengerEvent {
  final Message message;

  MessageReceiveEvent(this.message);
}

class MessageFetchEvent extends MessengerEvent {}

class MessengerInitEvent extends MessengerEvent {}

class MessengerAddEvent extends MessengerEvent {}
